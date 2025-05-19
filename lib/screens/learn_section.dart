import 'package:flutter/material.dart';
import '../data/filipino_words_structured.dart';
import '../data/grammar_data.dart';
import '../user_state.dart';
import 'word_details_page.dart';
import '../services/progress_service.dart';
import 'dart:async';
import 'baybayin_page.dart';

class LearnSection extends StatefulWidget {
  final String language;

  const LearnSection({
    super.key,
    required this.language,
  });

  @override
  State<LearnSection> createState() => _LearnSectionState();
}

class _LearnSectionState extends State<LearnSection> with SingleTickerProviderStateMixin {  late TabController _tabController;
  Timer? _dbListener;
  Map<String, List<String>> _wordsByPartOfSpeech = {};
  List<Map<String, dynamic>> _grammarLessons = [];

  // Localized text getters
  String get _learnTitle =>
      widget.language == 'Filipino' ? 'MGA ARALIN' : 'LEARNING';

  String get _wordsTabTitle =>
      widget.language == 'Filipino' ? 'MGA SALITA' : 'WORDS';
      
  String get _grammarTabTitle =>
      widget.language == 'Filipino' ? 'GRAMATIKA' : 'GRAMMAR';
      
  String get _baybayinTabTitle =>
      widget.language == 'Filipino' ? 'BAYBAYIN' : 'BAYBAYIN';
      
  String get _partsOfSpeechTitle =>
      widget.language == 'Filipino' ? 'Bahagi ng Pananalita' : 'Parts of Speech';
      
  String get _noWordsText =>
      widget.language == 'Filipino' ? 'Walang mga salita' : 'No words available';
      
  String get _viewAllText =>
      widget.language == 'Filipino' ? 'Tingnan Lahat' : 'View All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
    
    // Load progress if user is logged in
    if (UserState.instance.isLoggedIn) {
      _loadProgress();
      _setupRealtimeProgressListener();
    }

    // Listen for login state changes
    UserState.instance.loginState.listen((isLoggedIn) {
      if (isLoggedIn && mounted) {
        _loadProgress();
        _setupRealtimeProgressListener();
      } else if (!isLoggedIn && _dbListener != null) {
        _dbListener?.cancel();
        _dbListener = null;
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _dbListener?.cancel();
    super.dispose();
  }

  void _loadData() {
    _loadWordsByPartOfSpeech();
    _loadGrammarLessons();
  }

  void _loadWordsByPartOfSpeech() {
    // Initialize an empty map instead of predefined categories
    _wordsByPartOfSpeech = {};
    
    // Get all parts of speech from our structured data
    List<String> allPartsOfSpeech = FilipinoWordsStructured.getAllPartsOfSpeech();
    
    // Log the total number of words available
    int totalWords = FilipinoWordsStructured.words.length;
    debugPrint('Total words in FilipinoWordsStructured: $totalWords');
    debugPrint('Parts of speech found: ${allPartsOfSpeech.join(", ")}');
    
    // Group words by part of speech
    for (var partOfSpeech in allPartsOfSpeech) {
      List<String> words = FilipinoWordsStructured.getWordsByPartOfSpeech(partOfSpeech);
      if (words.isNotEmpty) {
        _wordsByPartOfSpeech[partOfSpeech] = words;
        debugPrint('Part of speech: $partOfSpeech, Words count: ${words.length}');
      }
    }
    
    // Remove empty categories
    _wordsByPartOfSpeech.removeWhere((key, value) => value.isEmpty);
    
    // Log the total words loaded into all categories
    int loadedWords = _wordsByPartOfSpeech.values.fold(0, (sum, list) => sum + list.length);
    debugPrint('Total words loaded into categories: $loadedWords');
  }

  void _loadGrammarLessons() {
    _grammarLessons = GrammarData.getCategories().map((category) {
      return {
        'id': category['id'],
        'title': widget.language == 'Filipino' ? category['titleFil'] : category['title'],
        'description': widget.language == 'Filipino' 
            ? category['descriptionFil'] 
            : category['description'],
        'rules': GrammarData.getRulesByCategory(category['id']),
        'progress': 0.0,
        'completed': false,
      };
    }).toList();
  }  void _loadProgress() async {
    // Load progress for grammar lessons from Firestore
    if (!UserState.instance.isLoggedIn) return;
    
    try {
      final progressData = await ProgressService.instance.getLessonProgress(UserState.instance.uid);
      
      setState(() {
        // Update grammar lessons progress
        for (var lesson in _grammarLessons) {
          final lessonId = lesson['id'];
          final grammarKey = 'grammar_$lessonId';
          
          // Check if there's data for this specific lesson
          if (progressData.containsKey(grammarKey) && 
              progressData[grammarKey] is Map &&
              progressData[grammarKey].containsKey('progress')) {
            
            final lessonProgress = (progressData[grammarKey]['progress'] as num).toDouble();
            lesson['progress'] = lessonProgress;
            lesson['completed'] = lessonProgress >= 1.0;
          } else {
            // Default to no progress
            lesson['progress'] = 0.0;
            lesson['completed'] = false;
          }
        }
      });
      
      debugPrint('Grammar lessons progress loaded successfully');
    } catch (e) {
      debugPrint('Error loading progress: $e');
    }
  }

  void _setupRealtimeProgressListener() {
    // Set up a timer to refresh progress data periodically
    _dbListener = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (mounted && UserState.instance.isLoggedIn) {
        _loadProgress();
      }
    });
  }
  void _navigateToWordDetails(String word) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WordDetailsPage(
          word: word,
          language: widget.language,
        ),
      ),
    );
  }
  void _navigateToGrammarLesson(Map<String, dynamic> lesson) {
    // Update progress for this lesson - when viewing a lesson, increment progress by 20%
    if (UserState.instance.isLoggedIn) {
      final lessonId = lesson['id'];
      final currentProgress = lesson['progress'] as double;
      
      // Only update if not already completed
      if (currentProgress < 1.0) {
        // Increment by 20% but don't exceed 100%
        final newProgress = (currentProgress + 0.2).clamp(0.0, 1.0);
        
        // Update Firestore through the progress service
        ProgressService.instance.updateGrammarLessonProgress(
          lessonId: lessonId,
          progress: newProgress,
        ).then((success) {
          if (success) {
            // Update the local state
            setState(() {
              lesson['progress'] = newProgress;
              lesson['completed'] = newProgress >= 1.0;
            });
          }
        });
      }
    }
    
    // Show the grammar lesson dialog
    showDialog(
      context: context,
      builder: (context) => GrammarLessonDialog(
        lesson: lesson,
        language: widget.language,
        onLessonCompleted: (lessonId) {
          // This callback will be called when the user marks a lesson as completed
          _markLessonAsCompleted(lessonId);
        },
      ),
    );
  }
  
  void _markLessonAsCompleted(String lessonId) {
    if (!UserState.instance.isLoggedIn) return;
    
    // Find the lesson
    final lesson = _grammarLessons.firstWhere((l) => l['id'] == lessonId, orElse: () => {});
    if (lesson.isEmpty) return;
    
    // Mark as completed (100%)
    ProgressService.instance.updateGrammarLessonProgress(
      lessonId: lessonId,
      progress: 1.0,
    ).then((success) {
      if (success) {
        setState(() {
          lesson['progress'] = 1.0;
          lesson['completed'] = true;
        });
      }
    });
  }

  void _navigateToBaybayin() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BaybayinPage(
          language: widget.language,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_learnTitle),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: _wordsTabTitle),
            Tab(text: _grammarTabTitle),
            Tab(text: _baybayinTabTitle),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildWordsTab(),
          _buildGrammarTab(),
          _buildBaybayinTab(),
        ],
      ),
    );
  }
  Widget _buildWordsTab() {
    if (_wordsByPartOfSpeech.isEmpty) {
      return Center(
        child: Text(_noWordsText, style: TextStyle(fontSize: 18)),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          // Parts of Speech Title
          Text(
            _partsOfSpeechTitle,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          
          // Parts of Speech Cards
          ..._wordsByPartOfSpeech.entries.map((entry) {
            final partOfSpeech = entry.key;
            final words = entry.value;
            
            // Get description text for this part of speech
            final description = FilipinoWordsStructured.partsOfSpeechDescriptions[partOfSpeech] ?? '';
            
            // Display name based on language
            String displayName;
            switch (partOfSpeech) {
              case 'pangngalan':
                displayName = widget.language == 'Filipino' ? 'Pangngalan' : 'Nouns';
                break;
              case 'panghalip':
                displayName = widget.language == 'Filipino' ? 'Panghalip' : 'Pronouns';
                break;
              case 'pandiwa':
                displayName = widget.language == 'Filipino' ? 'Pandiwa' : 'Verbs';
                break;
              case 'pang-uri':
                displayName = widget.language == 'Filipino' ? 'Pang-uri' : 'Adjectives';
                break;
              case 'pang-abay':
                displayName = widget.language == 'Filipino' ? 'Pang-abay' : 'Adverbs';
                break;
              case 'pang-ukol':
                displayName = widget.language == 'Filipino' ? 'Pang-ukol' : 'Prepositions';
                break;
              case 'pangatnig':
                displayName = widget.language == 'Filipino' ? 'Pangatnig' : 'Conjunctions';
                break;
              case 'pandamdam':
                displayName = widget.language == 'Filipino' ? 'Pandamdam' : 'Interjections';
                break;
              default:
                displayName = partOfSpeech;
            }
            
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Theme.of(context).primaryColor,
                    width: double.infinity,
                    child: Text(
                      displayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          description,
                          style: const TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Display the first 5 words
                        ...words.take(5).map((word) => 
                          ListTile(
                            title: Text(word),
                            subtitle: Text(
                              FilipinoWordsStructured.words[word]?['englishDefinitions']?.first ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () => _navigateToWordDetails(word),
                          )
                        ).toList(),
                        
                        // View all button if more than 5 words
                        if (words.length > 5)
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                // Show all words in this part of speech
                                showDialog(
                                  context: context,
                                  builder: (context) => WordListDialog(
                                    title: displayName,
                                    words: words,
                                    onWordTap: _navigateToWordDetails,
                                    language: widget.language,
                                  ),
                                );
                              },
                              child: Text(_viewAllText + ' (${words.length})'),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
  Widget _buildGrammarTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          // Grammar Categories
          ..._grammarLessons.map((lesson) => 
            Card(
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 2,
              child: InkWell(
                onTap: () => _navigateToGrammarLesson(lesson),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: Theme.of(context).primaryColor,
                      width: double.infinity,
                      child: Text(
                        lesson['title'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lesson['description'],
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 12),
                          LinearProgressIndicator(
                            value: lesson['progress'],
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              lesson['completed'] ? Colors.green : Theme.of(context).primaryColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${(lesson['progress'] * 100).toStringAsFixed(0)}% ${widget.language == 'Filipino' ? 'Nakumpleto' : 'Completed'}',
                            style: TextStyle(
                              color: lesson['completed'] ? Colors.green : Theme.of(context).primaryColor,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ).toList(),
        ],
      ),
    );
  }
  Widget _buildBaybayinTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          // Baybayin Content
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 2,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Theme.of(context).primaryColor,
                  width: double.infinity,
                  child: Text(
                    widget.language == 'Filipino' ? 'Panimula sa Baybayin' : 'Introduction to Baybayin',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.language == 'Filipino'
                            ? 'Ang Baybayin ay isang sinaunang sistema ng pagsulat na ginamit ng mga Tagalog bago dumating ang mga Kastila. Ang salitang "baybayin" ay tumutukoy sa alpabeto, na bawat karakter ay kumakatawan sa isang pantig.'
                            : 'Baybayin is an ancient Philippine script that was used primarily by the Tagalog people before the Spanish colonization. The word "baybayin" refers to the alphabet, with each character representing a syllable.',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _navigateToBaybayin,
                        child: Text(widget.language == 'Filipino' 
                            ? 'Magpatuloy sa Aralin ng Baybayin' 
                            : 'Continue to Baybayin Lesson'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Baybayin Samples
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 2,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Theme.of(context).primaryColor,
                  width: double.infinity,
                  child: Text(
                    widget.language == 'Filipino' ? 'Mga Halimbawa ng Baybayin' : 'Baybayin Samples',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Display a few Baybayin character samples
                      ...FilipinoWordsStructured.baybayinCharacters.entries.take(5).map((entry) => 
                        ListTile(
                          title: Text('${entry.key} = ${entry.value}'),
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Center(
                              child: Text(
                                entry.value,
                                style: const TextStyle(fontSize: 24),
                              ),
                            ),
                          ),
                        ),
                      ).toList(),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _navigateToBaybayin,
                        child: Text(widget.language == 'Filipino' 
                            ? 'Tingnan Lahat ng mga Karakter' 
                            : 'View All Characters'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Baybayin Words
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 2,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Theme.of(context).primaryColor,
                  width: double.infinity,
                  child: Text(
                    widget.language == 'Filipino' ? 'Mga Salita sa Baybayin' : 'Words in Baybayin',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Display a few words with their Baybayin equivalent
                      ...FilipinoWordsStructured.baybayinWords.entries.take(5).map((entry) => 
                        ListTile(
                          title: Text(entry.key),
                          subtitle: Text(entry.value, style: const TextStyle(fontSize: 20)),
                        ),
                      ).toList(),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _navigateToBaybayin,
                        child: Text(widget.language == 'Filipino' 
                            ? 'Tingnan Lahat ng mga Salita' 
                            : 'View All Words'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Dialog to show all words in a part of speech
class WordListDialog extends StatelessWidget {
  final String title;
  final List<String> words;
  final Function(String) onWordTap;
  final String language;

  const WordListDialog({
    super.key,
    required this.title,
    required this.words,
    required this.onWordTap,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: words.length,
                itemBuilder: (context, index) {
                  final word = words[index];
                  return ListTile(
                    title: Text(word),
                    subtitle: Text(
                      FilipinoWordsStructured.words[word]?['englishDefinitions']?.first ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      onWordTap(word);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(language == 'Filipino' ? 'Isara' : 'Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Dialog to show grammar lesson details
class GrammarLessonDialog extends StatelessWidget {
  final Map<String, dynamic> lesson;
  final String language;
  final Function(String)? onLessonCompleted;

  const GrammarLessonDialog({
    super.key,
    required this.lesson,
    required this.language,
    this.onLessonCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final rules = lesson['rules'] as List<dynamic>;
    
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lesson['title'],
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              lesson['description'],
              style: const TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: rules.length,
                itemBuilder: (context, index) {
                  final rule = rules[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            language == 'Filipino' ? rule['titleFil'] : rule['title'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            language == 'Filipino' ? rule['explanationFil'] : rule['explanation'],
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Examples:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...((rule['examples'] ?? []) as List<dynamic>).map((example) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (example['filipino'] != null)
                                    Text(
                                      example['filipino'],
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  if (example['english'] != null)
                                    Text(
                                      example['english'],
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!lesson['completed'] && onLessonCompleted != null)
                  ElevatedButton(
                    onPressed: () {
                      onLessonCompleted!(lesson['id']);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: Text(
                      language == 'Filipino' ? 'Markahan Bilang Tapos' : 'Mark as Completed',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(language == 'Filipino' ? 'Isara' : 'Close'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

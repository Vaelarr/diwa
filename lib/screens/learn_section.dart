import 'package:flutter/material.dart';
import '../main.dart';
import '../data/filipino_words_data.dart';
import '../user_state.dart';
import 'word_details_page.dart';
import '../services/progress_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';

class LearnSection extends StatefulWidget {
  final String language;

  const LearnSection({
    super.key,
    required this.language,
  });

  @override
  State<LearnSection> createState() => _LearnSectionState();
}

class _LearnSectionState extends State<LearnSection> {  List<Map<String, dynamic>> _lessons = [];
  int _currentLevel = 1;
  bool _isLoadingProgress = false;
  Timer? _dbListener;

  // Localized text getters
  String get _learnTitle =>
      widget.language == 'Filipino' ? 'MGA ARALIN' : 'LESSONS';

  String get _beginnerTitle =>
      widget.language == 'Filipino' ? 'Nagsisimula' : 'Beginner';

  String get _intermediateTitle =>
      widget.language == 'Filipino' ? 'Panggitnang Antas' : 'Intermediate';

  String get _advancedTitle =>
      widget.language == 'Filipino' ? 'Advanced' : 'Advanced';

  String get _comingSoonText =>
      widget.language == 'Filipino' ? 'Malapit nang Dumating' : 'Coming Soon';

  String get _lessonsCompletedText =>
      widget.language == 'Filipino' ? 'Mga Natapós na Aralin' : 'Lessons Completed';

  String get _startLessonText =>
      widget.language == 'Filipino' ? 'Simulan ang Aralin' : 'Start Lesson';

  String get _continueText =>
      widget.language == 'Filipino' ? 'Magpatuloy' : 'Continue';

  String get _completedText =>
      widget.language == 'Filipino' ? 'Natapos' : 'Completed';

  String get _lockedText =>
      widget.language == 'Filipino' ? 'Naka-lock' : 'Locked';

  String get _unlockHintText =>
      widget.language == 'Filipino'
          ? 'Kumpletuhin ang mga naunang aralin upang i-unlock ito'
          : 'Complete previous lessons to unlock';

  @override
  void initState() {
    super.initState();
    _loadLessons();

    // Load progress from Firebase if user is logged in
    if (UserState.instance.isLoggedIn) {
      _loadProgressFromFirebase();
      _setupRealtimeProgressListener();
    }

    // Listen for login state changes
    UserState.instance.loginState.listen((isLoggedIn) {
      if (isLoggedIn && mounted) {
        _loadProgressFromFirebase();
        _setupRealtimeProgressListener();
      } else if (!isLoggedIn && _dbListener != null) {
        _dbListener?.cancel();
        _dbListener = null;
      }
    });
  }

  @override
  void dispose() {
    // Clean up the database listener when the widget is removed
    _dbListener?.cancel();
    super.dispose();
  }

  void _loadLessons() {
    // Simplified approach that directly uses categories from FilipinoWordsData
    final lessonsData = <Map<String, dynamic>>[];

    // Get all categories from FilipinoWordsData
    final allCategories = FilipinoWordsData.getAllCategories();
    final valueCategories = allCategories.where((cat) =>
        ['character traits', 'values', 'social values', 'virtues'].contains(cat)).toList();
    final emotionCategories = allCategories.where((cat) =>
        ['emotions', 'feelings', 'psychological states'].contains(cat)).toList();
    final conceptCategories = allCategories.where((cat) =>
        ['abstract concepts', 'social terms', 'relational concepts'].contains(cat)).toList();

    // Helper function to add lesson only if it has words
    void addLessonIfHasWords(Map<String, dynamic> lesson) {
      final wordsList = lesson['words'] as List;
      if (wordsList.isNotEmpty) {
        lessonsData.add(lesson);
      }
    }

    // LEVEL 1: Beginner lessons with easy words
    final easyWords = FilipinoWordsData.getWordsByDifficulty('easy');
    if (easyWords.isNotEmpty) {
      addLessonIfHasWords({
        'id': 1,
        'title': widget.language == 'Filipino' ? 'Pangunahing Bokabularyo' : 'Basic Vocabulary',
        'description': widget.language == 'Filipino'
            ? 'Matuto ng mga pangunahing salita sa Filipino'
            : 'Learn essential Filipino words',
        'level': 1,
        'completed': true,
        'progress': 1.0,
        'duration': '15 min',
        'icon': Icons.book,
        'color': Colors.green,
        'words': easyWords.take(10).toList(),
      });
    }

    // Add Values lesson if category has words
    if (valueCategories.isNotEmpty) {
      final valueWords = FilipinoWordsData.getWordsByCategory(valueCategories[0]);
      if (valueWords.isNotEmpty) {
        addLessonIfHasWords({
          'id': 2,
          'title': widget.language == 'Filipino' ? 'Mga Katangiang Filipino' : 'Filipino Values',
          'description': widget.language == 'Filipino'
              ? 'Mga salitang nagpapakita ng mga katangiang Filipino'
              : 'Words that showcase Filipino values',
          'level': 1,
          'completed': false,
          'progress': 0.3,
          'duration': '20 min',
          'icon': Icons.emoji_people,
          'color': Colors.blue,
          'words': valueWords.take(6).toList(),
        });
      }
    }

    // Add Emotions lesson if category has words
    if (emotionCategories.isNotEmpty) {
      final emotionWords = FilipinoWordsData.getWordsByCategory(emotionCategories[0]);
      if (emotionWords.isNotEmpty) {
        addLessonIfHasWords({
          'id': 3,
          'title': widget.language == 'Filipino' ? 'Mga Emosyon' : 'Emotions',
          'description': widget.language == 'Filipino'
              ? 'Salitang nagpapahayag ng damdamin'
              : 'Words expressing feelings',
          'level': 1,
          'completed': false,
          'progress': 0.0,
          'duration': '25 min',
          'icon': Icons.emoji_emotions,
          'color': Colors.orange,
          'words': emotionWords.take(5).toList(),
        });
      }
    }

    // LEVEL 2: Intermediate lessons - only add if we have matching words
    if (valueCategories.length > 1) {
      final socialValueWords = FilipinoWordsData.getWordsByCategory(valueCategories[1]);
      if (socialValueWords.isNotEmpty) {
        addLessonIfHasWords({
          'id': 4,
          'title': widget.language == 'Filipino' ? 'Mga Kaugaliang Panlipunan' : 'Social Values',
          'description': widget.language == 'Filipino'
              ? 'Salitang may kinalaman sa pakikitungo sa lipunan'
              : 'Words related to social interactions',
          'level': 2,
          'completed': false,
          'progress': 0.0,
          'duration': '30 min',
          'icon': Icons.groups,
          'color': Colors.purple,
          'words': socialValueWords.take(5).toList(),
        });
      }
    }

    // Add intermediate emotions lesson with medium difficulty words
    final mediumWords = FilipinoWordsData.getWordsByDifficulty('medium')
        .where((word) => FilipinoWordsData.words[word]?['category']?.contains('emotions') ?? false)
        .toList();

    if (mediumWords.isNotEmpty) {
      addLessonIfHasWords({
        'id': 5,
        'title': widget.language == 'Filipino' ? 'Malalim na Damdamin' : 'Deep Emotions',
        'description': widget.language == 'Filipino'
            ? 'Pag-unawa sa mga salitang nagpapahayag ng malalim na damdamin'
            : 'Understanding words that express deep emotions',
        'level': 2,
        'completed': false,
        'progress': 0.0,
        'duration': '35 min',
        'icon': Icons.psychology,
        'color': Colors.indigo,
        'words': mediumWords.take(5).toList(),
      });
    }

    // LEVEL 3: Advanced lessons - only if we have concepts
    if (conceptCategories.isNotEmpty) {
      final conceptWords = FilipinoWordsData.getWordsByCategory(conceptCategories[0]);
      if (conceptWords.isNotEmpty) {
        addLessonIfHasWords({
          'id': 6,
          'title': widget.language == 'Filipino' ? 'Abstraktong Konsepto' : 'Abstract Concepts',
          'description': widget.language == 'Filipino'
              ? 'Mga salitang nagpapahayag ng malalim na kaisipan'
              : 'Words expressing deep concepts',
          'level': 3,
          'completed': false,
          'progress': 0.0,
          'duration': '40 min',
          'icon': Icons.auto_awesome,
          'color': Colors.red,
          'words': conceptWords.take(5).toList(),
        });
      }
    }

    // Hard difficulty words for advanced vocabulary
    final hardWords = FilipinoWordsData.getWordsByDifficulty('hard');
    if (hardWords.isNotEmpty) {
      addLessonIfHasWords({
        'id': 7,
        'title': widget.language == 'Filipino' ? 'Malalim na Bokabularyo' : 'Advanced Vocabulary',
        'description': widget.language == 'Filipino'
            ? 'Mga hindi karaniwang salitang Filipino'
            : 'Uncommon Filipino words',
        'level': 3,
        'completed': false,
        'progress': 0.0,
        'duration': '45 min',
        'icon': Icons.menu_book,
        'color': Colors.teal,
        'words': hardWords.take(5).toList(),
      });
    }

    setState(() {
      _lessons = lessonsData;
    });
  }  // New method to load progress from SharedPreferences
  Future<void> _loadProgressFromFirebase() async {
    if (!UserState.instance.isLoggedIn || _lessons.isEmpty) return;

    setState(() {
      _isLoadingProgress = true;
    });

    try {
      final allProgress = await ProgressService.instance.getAllLessonProgress();

      if (allProgress.isNotEmpty && mounted) {
        setState(() {
          for (var lesson in _lessons) {
            final lessonId = lesson['id'].toString();
            if (allProgress.containsKey(lessonId)) {
              final lessonProgress = allProgress[lessonId];
              lesson['progress'] = lessonProgress['progress'] ?? 0.0;
              lesson['completed'] = lessonProgress['completed'] ?? false;
            }
          }
        });
      }
    } catch (e) {
      debugPrint('Error loading lesson progress: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingProgress = false;
        });
      }
    }
  }
    // Set up periodic refresh for lesson progress updates
  void _setupRealtimeProgressListener() {
    if (!UserState.instance.isLoggedIn || _lessons.isEmpty) return;
    
    // Cancel any existing listener
    _dbListener?.cancel();
    
    // Set up a timer to refresh progress data periodically
    _dbListener = Timer.periodic(const Duration(seconds: 30), (_) {
      if (!mounted) return;
      _loadProgressFromLocalStorage();
    });
  }
  
  // Load progress from SharedPreferences
  Future<void> _loadProgressFromLocalStorage() async {
    if (!UserState.instance.isLoggedIn || _lessons.isEmpty) return;

    setState(() {
      _isLoadingProgress = true;
    });

    try {
      final allProgress = await ProgressService.instance.getAllLessonProgress();

      if (allProgress.isNotEmpty && mounted) {
        setState(() {
          for (var lesson in _lessons) {
            final lessonId = lesson['id'].toString();
            if (allProgress.containsKey(lessonId)) {
              final lessonProgress = allProgress[lessonId];
              lesson['progress'] = lessonProgress['progress'] ?? 0.0;
              lesson['completed'] = lessonProgress['completed'] ?? false;
            }
          }
        });
      }
    } catch (e) {
      debugPrint('Error loading lesson progress: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingProgress = false;
        });
      }
    }
  }

  void _openLesson(Map<String, dynamic> lesson) {
    // Simplified dialog that focuses on words from FilipinoWordsData
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          lesson['title'],
          style: const TextStyle(color: Colors.brown, fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Description
              Text(
                lesson['description'],
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),

              // Word list with simple formatting
              if ((lesson['words'] as List).isNotEmpty) ...[
                Text(
                  widget.language == 'Filipino' ? 'Mga Salita:' : 'Words:',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                // Simple word list
                ...lesson['words'].map<Widget>((word) {
                  final wordData = FilipinoWordsData.words[word];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: InkWell(
                      onTap: () => _navigateToWordDetails(word),
                      child: Row(
                        children: [
                          const Icon(Icons.text_fields, size: 16, color: Colors.brown),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  word,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    decoration: TextDecoration.underline,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (wordData != null)
                                  Text(
                                    wordData['translations']['english'],
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text(widget.language == 'Filipino' ? 'Pag-aralan' : 'Study Words'),
            onPressed: () {
              // Only update progress if user is logged in
              if (UserState.instance.isLoggedIn) {
                _updateLessonProgress(lesson, 0.3, false);
              }
              Navigator.pop(context);

              // Navigate to first word
              if ((lesson['words'] as List).isNotEmpty) {
                _navigateToWordDetails(lesson['words'][0]);
              }
            },
          ),
          if (UserState.instance.isLoggedIn && lesson['progress'] > 0)
            TextButton.icon(
              icon: Icon(
                (lesson['completed'] as bool) ? Icons.check_circle : Icons.check_circle_outline,
                color: Colors.green,
              ),
              label: Text(
                (lesson['completed'] as bool)
                    ? (widget.language == 'Filipino' ? 'Tapos na' : 'Completed')
                    : (widget.language == 'Filipino' ? 'Markahan bilang Tapos' : 'Mark as Complete'),
              ),
              onPressed: () {
                _updateLessonProgress(lesson, 1.0, true);
                Navigator.pop(context);
              },
            ),
          TextButton(
            child: Text(widget.language == 'Filipino' ? 'Isara' : 'Close'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color(0xFFF8F4E1),
      ),
    );
  }

  // Update this method to save progress to Firebase
  void _updateLessonProgress(Map<String, dynamic> lesson, double progress, bool completed) async {
    if (!UserState.instance.isLoggedIn) return;

    try {
      // Update local state
      setState(() {
        final index = _lessons.indexWhere((l) => l['id'] == lesson['id']);
        if (index != -1) {
          _lessons[index]['progress'] = progress;
          _lessons[index]['completed'] = completed;
        }
      });

      // Save to Firebase
      await ProgressService.instance.saveLessonProgress(
        lessonId: lesson['id'].toString(),
        progress: progress,
        completed: completed,
      );
    } catch (e) {
      debugPrint('Error updating lesson progress: $e');
    }
  }

  void _navigateToWordDetails(String word) {
    Navigator.pop(context);

    if (FilipinoWordsData.words.containsKey(word)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WordDetailsPage(
            word: word,
            language: widget.language,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Word details not available for "$word"'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveUtil.isTablet(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F4E1),
      appBar: AppBar(
        title: Text(
          'DIWA',
          style: TextStyle(
            color: Colors.brown,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.brown),
          onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Simple header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              _learnTitle,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Simple level tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildSimpleTab(1, _beginnerTitle),
                _buildSimpleTab(2, _intermediateTitle),
                _buildSimpleTab(3, _advancedTitle),
              ],
            ),
          ),

          // Completion status if logged in
          if (UserState.instance.isLoggedIn)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "$_lessonsCompletedText: ${_lessons.where((l) => l['completed']).length}/${_lessons.length}",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),

          // Lessons list
          Expanded(
            child: _buildSimpleLessonsList(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: widget.language == 'Filipino' ? 'Tahanan' : 'Home',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.videogame_asset),
            label: widget.language == 'Filipino' ? 'Laro' : 'Games',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: widget.language == 'Filipino' ? 'Profile' : 'Profile',
          ),
        ],
        selectedItemColor: Colors.brown,
        unselectedItemColor: Colors.brown.withOpacity(0.6),
        backgroundColor: Colors.white,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/games');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/profile');
          }
        },
      ),
    );
  }

  Widget _buildSimpleTab(int level, String title) {
    final isSelected = _currentLevel == level;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentLevel = level;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? Colors.brown : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.brown : Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildSimpleLessonsList() {
    final filteredLessons = _lessons.where((lesson) => lesson['level'] == _currentLevel).toList();

    if (filteredLessons.isEmpty) {
      return Center(
        child: Text(
          _comingSoonText,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.brown.withOpacity(0.7),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredLessons.length,
      itemBuilder: (context, index) {
        final lesson = filteredLessons[index];
        return _buildSimpleLessonCard(lesson);
      },
    );
  }

  Widget _buildSimpleLessonCard(Map<String, dynamic> lesson) {
    final bool isCompleted = lesson['completed'] as bool;
    final double progress = lesson['progress'] as double;
    final Color lessonColor = lesson['color'] as Color;
    final List<String> wordList = lesson['words'] as List<String>;

    // Reset progress display for non-logged-in users
    final bool showProgress = UserState.instance.isLoggedIn && progress > 0;
    final bool showCompleted = UserState.instance.isLoggedIn && isCompleted;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _openLesson(lesson),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title row with icon
              Row(
                children: [
                  Icon(lesson['icon'] as IconData, color: lessonColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      lesson['title'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (showCompleted)
                    const Icon(Icons.check_circle, color: Colors.green, size: 16)
                ],
              ),

              // Description
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  lesson['description'] as String,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ),

              // Preview of words (show first 3)
              if (wordList.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Wrap(
                    spacing: 8,
                    children: wordList.take(3).map((word) => Chip(
                      label: Text(word, style: const TextStyle(fontSize: 12)),
                      backgroundColor: lessonColor.withOpacity(0.2),
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    )).toList(),
                  ),
                ),

              // Duration & progress indicator
              Row(
                children: [
                  Text(
                    lesson['duration'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                  const Spacer(),
                  if (showProgress && !isCompleted)
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 12,
                        color: lessonColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),

              // Add onPressed handler to mark lessons as complete
              if (UserState.instance.isLoggedIn && lesson['progress'] > 0)
                TextButton.icon(
                  icon: Icon(
                    (lesson['completed'] as bool) ? Icons.check_circle : Icons.check_circle_outline,
                    color: Colors.green,
                  ),
                  label: Text(
                    (lesson['completed'] as bool)
                        ? (widget.language == 'Filipino' ? 'Tapos na' : 'Completed')
                        : (widget.language == 'Filipino' ? 'Markahan bilang Tapos' : 'Mark as Complete'),
                  ),
                  onPressed: () {
                    _updateLessonProgress(lesson, 1.0, true);
                  },
                ),

              // Simple progress bar - only show if logged in
              if (showProgress)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(lessonColor),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../main.dart'; // Import for ResponsiveUtil
import '../data/filipino_words_structured.dart'; // Import the centralized data
import '../user_state.dart'; // Import for checking login status

class WordDetailsPage extends StatefulWidget {
  final String word;
  final String language;
  final VoidCallback? onBackPressed;
  
  const WordDetailsPage({
    super.key,
    required this.word,
    required this.language,
    this.onBackPressed,
  });

  @override
  State<WordDetailsPage> createState() => _WordDetailsPageState();
}

class _WordDetailsPageState extends State<WordDetailsPage> {
  bool _isWordSaved = false;
  
  @override
  void initState() {
    super.initState();
    // Check if word is saved
    _checkIfWordSaved();
    
    // Track word viewing for progress analytics
    _trackWordViewed();
    
    // Show login reminder when page is opened if user is not logged in
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!UserState.instance.isLoggedIn) {
        _showLoginPrompt();
      }
    });
  }
  
  // Track that a word was viewed for progress metrics
  Future<void> _trackWordViewed() async {
    if (UserState.instance.isLoggedIn) {
      // Update learning progress when a word is viewed
      await UserState.instance.updateLearningProgress(pointsEarned: 1);
    }
  }
  
  Future<void> _checkIfWordSaved() async {
    if (UserState.instance.isLoggedIn) {
      final isSaved = await UserState.instance.isWordSaved(widget.word);
      if (mounted) {
        setState(() {
          _isWordSaved = isSaved;
        });
      }
    }
  }
  
  // Localized text getters
  String get _loginReminderText => 
    widget.language == 'Filipino' 
        ? 'Mag-login upang masave ang iyong progress' 
        : 'Log in to save your progress';
        
  String get _loginButtonText => 
    widget.language == 'Filipino' ? 'Mag-login' : 'Log In';
    
  String get _saveWordText => 
    widget.language == 'Filipino' ? 'I-save ang salitang ito' : 'Save this word';
    
  String get _removeWordText => 
    widget.language == 'Filipino' ? 'Alisin sa mga naka-save' : 'Remove from saved';
    
  String get _examplesText => 
    widget.language == 'Filipino' ? 'Mga Halimbawa' : 'Examples';

  String get _examplesTranslationText => 
    widget.language == 'Filipino' ? 'Pagsasalin ng mga Halimbawa' : 'Examples Translation';
    
  String get _synonymsText => 
    widget.language == 'Filipino' ? 'Mga Kasingkahulugan' : 'Synonyms';
    
  String get _antonymsText => 
    widget.language == 'Filipino' ? 'Mga Kasalungat' : 'Antonyms';
    
  String get _relatedWordsText => 
    widget.language == 'Filipino' ? 'Kaugnay na mga Salita' : 'Related Words';
    
  String get _partOfSpeechText => 
    widget.language == 'Filipino' ? 'Bahagi ng Pananalita' : 'Part of Speech';
    
  String get _pronunciationText => 
    widget.language == 'Filipino' ? 'Pagbigkas' : 'Pronunciation';
    
  String get _tagalogDefinitionText => 
    widget.language == 'Filipino' ? 'Kahulugan sa Filipino' : 'Filipino Definition';
    
  String get _englishDefinitionText => 
    widget.language == 'Filipino' ? 'Kahulugan sa Ingles' : 'English Definition';
    
  String get _categoryText => 
    widget.language == 'Filipino' ? 'Kategorya' : 'Category';
    
  String get _difficultyText => 
    widget.language == 'Filipino' ? 'Antas ng Kahirapan' : 'Difficulty Level';

  @override
  Widget build(BuildContext context) {
    final wordData = FilipinoWordsStructured.words[widget.word];
    final isTablet = ResponsiveUtil.isTablet(context);
    
    if (wordData == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Word not found'),
          backgroundColor: Colors.brown,
        ),
        body: const Center(
          child: Text('The requested word was not found in our dictionary.'),
        ),
      );
    }
    
    // Map difficulty levels to user-friendly display text
    String getDifficultyText(String difficulty) {
      switch (difficulty) {
        case 'easy':
          return widget.language == 'Filipino' ? 'Madali' : 'Easy';
        case 'medium':
          return widget.language == 'Filipino' ? 'Katamtaman' : 'Medium';
        case 'hard':
          return widget.language == 'Filipino' ? 'Mahirap' : 'Hard';
        default:
          return widget.language == 'Filipino' ? 'Hindi tinukoy' : 'Not specified';
      }
    }
    
    // Map parts of speech to more descriptive text
    String getPartOfSpeechText(String partOfSpeech) {
      switch (partOfSpeech) {
        case 'pangngalan':
          return widget.language == 'Filipino' ? 'Pangngalan (Noun)' : 'Noun';
        case 'panghalip':
          return widget.language == 'Filipino' ? 'Panghalip (Pronoun)' : 'Pronoun';
        case 'pandiwa':
          return widget.language == 'Filipino' ? 'Pandiwa (Verb)' : 'Verb';
        case 'pang-uri':
          return widget.language == 'Filipino' ? 'Pang-uri (Adjective)' : 'Adjective';
        case 'pang-abay':
          return widget.language == 'Filipino' ? 'Pang-abay (Adverb)' : 'Adverb';
        case 'pang-ukol':
          return widget.language == 'Filipino' ? 'Pang-ukol (Preposition)' : 'Preposition';
        case 'pangatnig':
          return widget.language == 'Filipino' ? 'Pangatnig (Conjunction)' : 'Conjunction';
        case 'pandamdam':
          return widget.language == 'Filipino' ? 'Pandamdam (Interjection)' : 'Interjection';
        default:
          return partOfSpeech;
      }
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.brown.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Text('D',
                style: TextStyle(
                  color: Colors.brown,
                  fontSize: isTablet ? 32 : 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text('DIWA',
              style: TextStyle(
                color: Colors.brown,
                fontSize: isTablet ? 32 : 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.brown.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.arrow_back, color: Colors.brown),
          ),
          onPressed: () {
            if (widget.onBackPressed != null) {
              widget.onBackPressed!();
            } else if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).pushReplacementNamed('/dictionary');
            }
          },
        ),
        actions: [
          // Show login button if not logged in
          if (!UserState.instance.isLoggedIn)
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.person, color: Colors.blue),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              tooltip: _loginReminderText,
            ),
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _isWordSaved 
                    ? Colors.red.withOpacity(0.1) 
                    : Colors.brown.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _isWordSaved ? Icons.bookmark : Icons.bookmark_border,
                color: _isWordSaved ? Colors.red : Colors.brown,
              ),
            ),
            onPressed: () async {
              if (!UserState.instance.isLoggedIn) {
                _showLoginPrompt();
                return;
              }
              
              // Toggle the saved state and update the database
              setState(() {
                _isWordSaved = !_isWordSaved;
              });
                if (_isWordSaved) {
                // Save word and update achievements
                await UserState.instance.saveWord(widget.word);
                await UserState.instance.updateLearningProgress(pointsEarned: 2);
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Word saved!'),
                    duration: const Duration(seconds: 2),
                    backgroundColor: Colors.brown,
                  ),
                );
              } else {
                await UserState.instance.removeSavedWord(widget.word);
                // No points deduction for removing words
                await UserState.instance.updateLearningProgress();
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Word removed'),
                    duration: const Duration(seconds: 2),
                    backgroundColor: Colors.brown,
                  ),
                );
              }
            },
            tooltip: _isWordSaved ? _removeWordText : _saveWordText,
          ),
          const SizedBox(width: 8),
        ],
        centerTitle: true,
        toolbarHeight: isTablet ? 90 : 70,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Word header with main info
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.brown.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Word title with first letter highlighted
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.brown.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          widget.word[0].toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                            color: Colors.brown,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.word,
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.brown,
                              ),
                            ),
                            if (wordData.containsKey('partOfSpeech'))
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.brown.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  getPartOfSpeechText(wordData['partOfSpeech']),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.brown[700],
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const Divider(height: 32, thickness: 1),
                  
                  // Pronunciation
                  if (wordData.containsKey('pronunciation') && wordData['pronunciation'] != null)
                    _buildDetailSection(
                      _pronunciationText,
                      Icons.record_voice_over,
                      wordData['pronunciation'],
                    ),
                  
                  if (wordData.containsKey('pronunciation') && wordData['pronunciation'] != null)
                    const SizedBox(height: 16),
                    
                  // Part of Speech details
                  if (wordData.containsKey('partOfSpeech') && wordData['partOfSpeech'] != null)
                    _buildDetailSection(
                      _partOfSpeechText,
                      Icons.category,
                      getPartOfSpeechText(wordData['partOfSpeech']),
                    ),
                    
                  if (wordData.containsKey('partOfSpeech') && wordData['partOfSpeech'] != null)
                    const SizedBox(height: 16),
                    
                  // Tagalog Definitions
                  if (wordData.containsKey('tagalogDefinitions') && 
                      wordData['tagalogDefinitions'] != null &&
                      (wordData['tagalogDefinitions'] as List).isNotEmpty)
                    _buildListDetailSection(
                      _tagalogDefinitionText,
                      Icons.description,
                      wordData['tagalogDefinitions'] as List,
                    ),
                  
                  if (wordData.containsKey('tagalogDefinitions') && 
                      wordData['tagalogDefinitions'] != null &&
                      (wordData['tagalogDefinitions'] as List).isNotEmpty)
                    const SizedBox(height: 16),
                  
                  // English Definitions
                  if (wordData.containsKey('englishDefinitions') && 
                      wordData['englishDefinitions'] != null &&
                      (wordData['englishDefinitions'] as List).isNotEmpty)
                    _buildListDetailSection(
                      _englishDefinitionText,
                      Icons.translate,
                      wordData['englishDefinitions'] as List,
                    ),
                    
                  if (wordData.containsKey('englishDefinitions') && 
                      wordData['englishDefinitions'] != null &&
                      (wordData['englishDefinitions'] as List).isNotEmpty)
                    const SizedBox(height: 16),
                    
                  // Category
                  if (wordData.containsKey('category') && 
                      wordData['category'] != null &&
                      (wordData['category'] as List).isNotEmpty)
                    _buildDetailSection(
                      _categoryText,
                      Icons.folder,
                      (wordData['category'] as List).join(', '),
                    ),
                
                  if (wordData.containsKey('category') && 
                      wordData['category'] != null &&
                      (wordData['category'] as List).isNotEmpty)
                    const SizedBox(height: 16),
                    
                  // Difficulty
                  if (wordData.containsKey('difficulty') && wordData['difficulty'] != null)
                    _buildDetailSection(
                      _difficultyText,
                      Icons.bar_chart,
                      getDifficultyText(wordData['difficulty']),
                    ),
                    
                ],
              ),
            ),
            
            // Examples
            if (wordData.containsKey('examples') && 
                wordData['examples'] != null &&
                (wordData['examples'] as List).isNotEmpty)
              _buildExamplesCard(
                wordData['examples'] as List, 
                wordData.containsKey('examplesTranslation') ? wordData['examplesTranslation'] as List? : null
              ),
              
            // Synonyms
            if (wordData.containsKey('synonyms') && 
                wordData['synonyms'] != null &&
                (wordData['synonyms'] as List).isNotEmpty)
              _buildWordChipsCard(_synonymsText, wordData['synonyms'] as List, Colors.green),
              
            // Translations
            if (wordData.containsKey('translations') && 
                wordData['translations'] != null &&
                (wordData['translations'] as Map).isNotEmpty)
              _buildTranslationsCard(wordData['translations'] as Map),
              
            const SizedBox(height: 32),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFF8F4E1),
    );
  }
  
  Widget _buildDetailSection(String title, IconData icon, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.brown),
            const SizedBox(width: 6),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 22),
          child: Text(
            content,
            style: TextStyle(
              fontSize: 16,
              color: Colors.brown[800],
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildListDetailSection(String title, IconData icon, List contentList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.brown),
            const SizedBox(width: 6),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: contentList.map<Widget>((item) => 
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                    Expanded(
                      child: Text(
                        item,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.brown[800],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ).toList(),
          ),
        ),
      ],
    );
  }
  
  Widget _buildExamplesCard(List examples, List? translations) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.format_quote, size: 16, color: Colors.brown),
              const SizedBox(width: 6),
              Text(
                _examplesText,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...List.generate(examples.length, (index) {
            final example = examples[index];
            final translation = translations != null && index < translations.length 
                ? translations[index] 
                : null;
                
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Filipino example
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.brown.withOpacity(0.05),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(8),
                        topRight: const Radius.circular(8),
                        bottomLeft: translation != null ? Radius.zero : const Radius.circular(8),
                        bottomRight: translation != null ? Radius.zero : const Radius.circular(8),
                      ),
                      border: Border.all(
                        color: Colors.brown.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      example,
                      style: TextStyle(
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                        color: Colors.brown[800],
                      ),
                    ),
                  ),
                  
                  // English translation if available
                  if (translation != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.brown.withOpacity(0.02),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                        border: Border(
                          bottom: BorderSide(color: Colors.brown.withOpacity(0.1), width: 1),
                          left: BorderSide(color: Colors.brown.withOpacity(0.1), width: 1),
                          right: BorderSide(color: Colors.brown.withOpacity(0.1), width: 1),
                        ),
                      ),
                      child: Text(
                        translation,
                        style: TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          color: Colors.brown[600],
                        ),
                      ),
                    ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
  
  Widget _buildWordChipsCard(String title, List words, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.label, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: words.map((word) => InkWell(
              onTap: () {
                if (FilipinoWordsStructured.words.containsKey(word)) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WordDetailsPage(
                        word: word,
                        language: widget.language,
                        onBackPressed: widget.onBackPressed,
                      ),
                    ),
                  );
                }
              },
              child: Chip(
                label: Text(
                  word,
                  style: TextStyle(
                    color: color.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                backgroundColor: color.withOpacity(0.1),
                side: BorderSide(color: color.withOpacity(0.3)),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTranslationsCard(Map translations) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.translate, size: 16, color: Colors.blue),
              const SizedBox(width: 6),
              Text(
                widget.language == 'Filipino' ? 'Mga Pagsasalin' : 'Translations',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...translations.entries.map((entry) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    entry.key.toString(),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    entry.value.toString(),
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }
  
  void _showLoginPrompt() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_loginReminderText),
        action: SnackBarAction(
          label: _loginButtonText,
          onPressed: () {
            Navigator.pushNamed(context, '/login');
          },
        ),
        duration: const Duration(seconds: 5),
        backgroundColor: Colors.brown,
      ),
    );
  }
}

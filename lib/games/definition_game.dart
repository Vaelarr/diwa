import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import '../main.dart'; // Import for ResponsiveUtil
import '../data/filipino_words_structured.dart'; // Import the centralized data
import '../user_state.dart';
import '../services/score_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DefinitionGame extends StatefulWidget {
  final String language;
  
  const DefinitionGame({
    Key? key,
    required this.language,
  }) : super(key: key);

  @override
  State<DefinitionGame> createState() => _DefinitionGameState();
}

class _DefinitionGameState extends State<DefinitionGame> with SingleTickerProviderStateMixin {
  int _score = 0;
  int _questionIndex = 0;
  bool _gameOver = false;
  String? _selectedAnswer;
  bool _answerChecked = false;
  final int _totalQuestions = 5;
  Timer? _timer;
  int _timeLeft = 20; // seconds for each question
  bool _isAnimating = false;
  late AnimationController _animController;
  
  late List<Map<String, dynamic>> _questions;
  
  @override
  void initState() {
    super.initState();
    _initializeQuestions();
    
    // Initialize animation controller for UI elements
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    _animController.dispose();
    super.dispose();
  }
  
  void _initializeQuestions() {
    try {
      // Get words from the central data source - using multiple difficulty levels
      List<String> wordPool = [];
      wordPool.addAll(FilipinoWordsStructured.getWordsByDifficulty('easy'));
      wordPool.addAll(FilipinoWordsStructured.getWordsByDifficulty('medium'));
      
      if (wordPool.isEmpty) {
        throw Exception('No words found in the data source');
      }
      
      // Shuffle words to get random selections
      wordPool.shuffle();
      
      final translations = <String, String>{};
      
      // Create questions based on centralized data
      _questions = [];
      
      for (var word in wordPool) {
        // Verify word exists in the data
        if (!FilipinoWordsStructured.words.containsKey(word)) {
          continue; // Skip if word not found
        }
        
        final wordData = FilipinoWordsStructured.words[word]!;
        
        // Verify translations exist
        if (wordData['translations'] == null || 
            !(wordData['translations'] is Map) || 
            !wordData['translations'].containsKey('english')) {
          continue; // Skip if translation structure is invalid
        }
        
        // Get English translation
        final englishTranslation = (wordData['translations']['english'] as String).split(',')[0].trim();
        translations[word] = englishTranslation;
        
        // Get appropriate definition based on language setting
        String definition;
        if (widget.language == 'Filipino') {
          // Try to get Tagalog definition
          if (wordData['tagalogDefinitions'] != null && 
              (wordData['tagalogDefinitions'] as List).isNotEmpty) {
            definition = wordData['tagalogDefinitions'][0];
          } else {
            // Use English definition as fallback but translated
            definition = wordData['englishDefinitions'] != null && 
                        (wordData['englishDefinitions'] as List).isNotEmpty 
                        ? _translateDefinition(wordData['englishDefinitions'][0], 'en', 'tl') 
                        : 'Walang depinisyon';
          }
        } else {
          // English definition
          definition = wordData['englishDefinitions'] != null && 
                      (wordData['englishDefinitions'] as List).isNotEmpty 
                      ? wordData['englishDefinitions'][0] 
                      : 'No definition available';
        }
        
        // Add to our questions list
        _questions.add({
          'word': word,
          'definition': definition,
          'choices': _generateChoices(englishTranslation, translations),
          'correctAnswer': englishTranslation,
        });
        
        // Once we have enough questions, we can stop
        if (_questions.length >= _totalQuestions * 2) {
          break; // Collect more than needed so we can shuffle and use a subset
        }
      }
      
      // Ensure we have at least the minimum required questions
      if (_questions.length < _totalQuestions) {
        throw Exception('Not enough valid words found for the game');
      }
      
      // Shuffle and limit to total questions
      _questions.shuffle();
      if (_questions.length > _totalQuestions) {
        _questions = _questions.sublist(0, _totalQuestions);
      }
      
      // Start the timer
      _startTimer();
      
    } catch (e) {
      // Handle errors by creating a fallback question set
      print('Error initializing questions: $e');
      _createFallbackQuestions();
      _startTimer();
    }
  }
  
  // Simple mock translation function - in a real app, you might use a translation API
  // This is just for fallback when a Tagalog definition is not available
  String _translateDefinition(String text, String fromLang, String toLang) {
    // In a real app, this would call a translation API
    // For now, we'll just return the original text
    return text;
  }
  
  void _startTimer() {
    // Cancel any existing timer
    _timer?.cancel();
    
    _timeLeft = 20; // Reset timer
    
    // Create a new timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        // Time's up, treat as wrong answer
        _checkAnswer("");
      }
    });
  }
  
  void _createFallbackQuestions() {
    // Create fallback questions using words from the data if possible
    _questions = [];
    
    final fallbackWordPairs = [
      {'word': 'Bahay', 'translation': 'House', 'definition_tl': 'Lugar na tinitirahan ng mga tao', 'definition_en': 'A place where people live'},
      {'word': 'Tubig', 'translation': 'Water', 'definition_tl': 'Likidong inumin na walang kulay at lasa', 'definition_en': 'A colorless, tasteless liquid'},
      {'word': 'Araw', 'translation': 'Sun', 'definition_tl': 'Bituing nagbibigay ng init at liwanag sa Earth', 'definition_en': 'The star that provides heat and light to Earth'},
      {'word': 'Puno', 'translation': 'Tree', 'definition_tl': 'Halamang mataas na may katawan at mga sanga', 'definition_en': 'A tall plant with a trunk and branches'},
      {'word': 'Ibon', 'translation': 'Bird', 'definition_tl': 'Hayop na may pakpak at balahibo', 'definition_en': 'A warm-blooded animal with wings and feathers'},
    ];
    
    for (var pair in fallbackWordPairs) {
      final definition = widget.language == 'Filipino' ? pair['definition_tl'] : pair['definition_en'];
      final choices = _generateFallbackChoices(pair['translation'] as String, fallbackWordPairs);
      
      _questions.add({
        'word': pair['word'],
        'definition': definition,
        'choices': choices,
        'correctAnswer': pair['translation'],
      });
    }
    
    // Shuffle the questions
    _questions.shuffle();
  }
  
  List<String> _generateFallbackChoices(String correctAnswer, List<Map<String, dynamic>> wordPairs) {
    final choices = <String>[correctAnswer];
    final allTranslations = wordPairs.map((pair) => pair['translation'] as String).toList();
    
    // Ensure we don't have duplicate choices
    while (choices.length < 4 && choices.length < allTranslations.length) {
      final random = Random().nextInt(allTranslations.length);
      final randomChoice = allTranslations[random];
      
      if (!choices.contains(randomChoice)) {
        choices.add(randomChoice);
      }
    }
    
    // Shuffle choices to randomize position
    choices.shuffle();
    return choices;
  }
  
  // Generate multiple choices including the correct answer
  List<String> _generateChoices(String correctAnswer, Map<String, String> allTranslations) {
    final choices = <String>[correctAnswer];
    final allValues = allTranslations.values.toList();
    
    // Ensure we don't have duplicate choices
    while (choices.length < 4 && choices.length < allValues.length) {
      final random = Random().nextInt(allValues.length);
      final randomChoice = allValues[random];
      
      if (!choices.contains(randomChoice)) {
        choices.add(randomChoice);
      }
    }
    
    // If we still don't have enough choices, add some predefined common words
    final commonEnglishWords = ['Love', 'Time', 'Person', 'Year', 'Way', 'Day', 'Thing', 'Man', 'World', 'Life'];
    
    while (choices.length < 4) {
      final random = Random().nextInt(commonEnglishWords.length);
      final randomChoice = commonEnglishWords[random];
      
      if (!choices.contains(randomChoice)) {
        choices.add(randomChoice);
      }
    }
    
    // Shuffle choices to randomize position
    choices.shuffle();
    return choices;
  }
  
  void _checkAnswer(String answer) {
    // Prevent multiple submissions
    if (_isAnimating) return;
    
    // Stop the timer
    _timer?.cancel();
    
    final currentQuestion = _questions[_questionIndex];
    final correctAnswer = currentQuestion['correctAnswer'];
    
    setState(() {
      _selectedAnswer = answer;
      _answerChecked = true;
      _isAnimating = true;
      
      if (answer == correctAnswer) {
        _score += 10 + _timeLeft; // Add points with time bonus
      }
    });
    
    // Move to next question after a delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _isAnimating = false;
          
          if (_questionIndex < _totalQuestions - 1) {
            _questionIndex++;
            _selectedAnswer = null;
            _answerChecked = false;
            _startTimer();
          } else {
            _gameOver = true;
          }
        });
      }
    });
  }
  
  void _restartGame() {
    setState(() {
      _score = 0;
      _questionIndex = 0;
      _gameOver = false;
      _selectedAnswer = null;
      _answerChecked = false;
      _questions.shuffle();
    });
    _startTimer();
  }
  
  void _endGame() {
    // Logic to handle end of game, like showing scores, etc.
    setState(() {
      _gameOver = true;
    });
    
    // Award points based on final score
    if (UserState.instance.isLoggedIn) {
      final ScoreService scoreService = ScoreService();
      scoreService.updateScore('Definition Game', _score, pointsToAward: _score * 2);
      
      // Award achievement points if score is above threshold
      if (_score >= 10) {
        scoreService.awardAchievementPoints('definition_master', 25);
      }
    }
  }
  
  String get _gameTitle => widget.language == 'Filipino' ? 'Laro ng Depinisyon' : 'Definition Game';
  String get _scoreText => widget.language == 'Filipino' ? 'Iskor' : 'Score';
  String get _questionText => widget.language == 'Filipino' ? 'Tanong' : 'Question';
  String get _correctText => widget.language == 'Filipino' ? 'Tama!' : 'Correct!';
  String get _incorrectText => widget.language == 'Filipino' ? 'Mali!' : 'Incorrect!';
  String get _gameOverText => widget.language == 'Filipino' ? 'Tapos na ang Laro!' : 'Game Over!';
  String get _finalScoreText => widget.language == 'Filipino' ? 'Pinal na Iskor' : 'Final Score';
  String get _playAgainText => widget.language == 'Filipino' ? 'Maglaro Ulit' : 'Play Again';
  String get _instructionsText => widget.language == 'Filipino'
      ? 'Piliin ang tamang salin sa Ingles ng salitang Tagalog base sa depinisyon:'
      : 'Select the correct English translation of the Tagalog word based on the definition:';
  String get _timeText => widget.language == 'Filipino' ? 'Oras' : 'Time';

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveUtil.isTablet(context);
    
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
              child: Text(
                'D',
                style: TextStyle(
                  color: Colors.brown,
                  fontSize: isTablet ? 32 : 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'DIWA',
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
        centerTitle: true,
        toolbarHeight: isTablet ? 90 : 70,
      ),
      backgroundColor: const Color(0xFFF8F4E1),
      body: SafeArea(
        child: _gameOver ? _buildGameOverScreen() : _buildQuestionScreen(),
      ),
    );
  }
  
  Widget _buildQuestionScreen() {
    final isTablet = ResponsiveUtil.isTablet(context);
    final padding = isTablet ? 16.0 : 12.0;
    final currentQuestion = _questions[_questionIndex];
    
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height - 
                     (MediaQuery.of(context).padding.top + 
                      MediaQuery.of(context).padding.bottom + 
                      (isTablet ? 90.0 : 70.0)), // AppBar height
        ),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            children: [
              // Game info bar with improved styling
              Card(
                elevation: 3,
                shadowColor: Colors.brown.withOpacity(0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.star, color: Colors.amber, size: 18),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '$_scoreText: $_score',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.quiz, color: Colors.green, size: 18),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '$_questionText ${_questionIndex + 1}/$_totalQuestions',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              // Timer with improved styling
              const SizedBox(height: 10),
              Card(
                elevation: 2,
                shadowColor: Colors.brown.withOpacity(0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      AnimatedBuilder(
                        animation: _animController,
                        builder: (context, child) {
                          return Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.brown.withOpacity(0.1 + 0.05 * _animController.value),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.timer, color: Colors.brown, size: 18),
                          );
                        }
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '$_timeText: $_timeLeft',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Instructions with enhanced styling
              const SizedBox(height: 10),
              Card(
                elevation: 2,
                shadowColor: Colors.brown.withOpacity(0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Text(
                    _instructionsText,
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.brown[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              
              // Word card with improved styling
              const SizedBox(height: 10),
              Card(
                elevation: 4,
                shadowColor: Colors.brown.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: EdgeInsets.all(isTablet ? 24 : 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.brown.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      TweenAnimationBuilder(
                        tween: Tween<double>(begin: 0.95, end: 1.0),
                        duration: const Duration(seconds: 1),
                        curve: Curves.elasticOut,
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            child: Text(
                              currentQuestion['word'],
                              style: TextStyle(
                                fontSize: isTablet ? 36 : 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.brown[800],
                                height: 1.3,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.brown.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          currentQuestion['definition'],
                          style: TextStyle(
                            fontSize: isTablet ? 18 : 16,
                            color: Colors.brown[700],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Options using GridView for consistent layout
              const SizedBox(height: 10),
              GridView.count(
                crossAxisCount: 2,
                childAspectRatio: isTablet ? 2.2 : 1.8,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(
                  currentQuestion['choices'].length,
                  (index) {
                    final choice = currentQuestion['choices'][index];
                    final bool isSelected = _selectedAnswer == choice;
                    final bool isCorrect = choice == currentQuestion['correctAnswer'];
                    
                    return Card(
                      elevation: 3,
                      shadowColor: Colors.brown.withOpacity(0.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _answerChecked 
                                ? (isCorrect 
                                    ? Colors.green 
                                    : (isSelected ? Colors.red : Colors.transparent))
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: InkWell(
                          onTap: _answerChecked 
                              ? null 
                              : () => _checkAnswer(choice),
                          borderRadius: BorderRadius.circular(12),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  choice,
                                  style: TextStyle(
                                    fontSize: isTablet ? 22 : 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.brown[700],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    );
                    },
                ),
              ),
              
              // Feedback display with improved styling
              if (_answerChecked)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: _selectedAnswer == currentQuestion['correctAnswer']
                        ? Colors.green.shade50
                        : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: (_selectedAnswer == currentQuestion['correctAnswer']
                            ? Colors.green 
                            : Colors.red).withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    border: Border.all(
                      color: _selectedAnswer == currentQuestion['correctAnswer']
                          ? Colors.green.withOpacity(0.3)
                          : Colors.red.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _selectedAnswer == currentQuestion['correctAnswer']
                            ? Icons.check_circle
                            : Icons.cancel,
                        color: _selectedAnswer == currentQuestion['correctAnswer']
                            ? Colors.green
                            : Colors.red,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          _selectedAnswer == currentQuestion['correctAnswer']
                              ? _correctText
                              : '$_incorrectText ${currentQuestion['correctAnswer']}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: _selectedAnswer == currentQuestion['correctAnswer']
                                ? Colors.green[700]
                                : Colors.red[700],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                
              // Add padding at the bottom to ensure nothing gets cut off
              SizedBox(height: MediaQuery.of(context).padding.bottom + 10),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildGameOverScreen() {
    final isTablet = ResponsiveUtil.isTablet(context);
    
    return Center(
      child: Card(
        elevation: 6,
        shadowColor: Colors.brown.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: EdgeInsets.all(isTablet ? 24 : 16),
        child: Padding(
          padding: EdgeInsets.all(isTablet ? 28 : 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0.6, end: 1.0),
                duration: const Duration(seconds: 1),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.brown.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.emoji_events,
                        size: 80,
                        color: Colors.amber,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Text(
                _gameOverText,
                style: TextStyle(
                  fontSize: isTablet ? 32 : 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.brown.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '$_finalScoreText: $_score/$_totalQuestions',
                  style: TextStyle(
                    fontSize: isTablet ? 24 : 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown[700],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.replay),
                label: Text(
                  _playAgainText,
                  style: TextStyle(
                    fontSize: isTablet ? 18 : 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: _restartGame,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 40 : 32,
                    vertical: isTablet ? 20 : 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

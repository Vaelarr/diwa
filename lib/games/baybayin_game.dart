import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import '../main.dart'; // Import for ResponsiveUtil
import '../data/filipino_words_structured.dart'; // Import the centralized data
import '../user_state.dart';
import '../services/score_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum GameMode {
  baybayinToFilipino,  // Guess Filipino word from Baybayin
  filipinoToBaybayin,  // Guess Baybayin symbol from Filipino
}

class BaybayinGame extends StatefulWidget {
  final String language;
  
  const BaybayinGame({
    Key? key,
    required this.language,
  }) : super(key: key);

  @override
  State<BaybayinGame> createState() => _BaybayinGameState();
}

class _BaybayinGameState extends State<BaybayinGame> with SingleTickerProviderStateMixin {
  int _score = 0;
  int _level = 1;
  int _lives = 3;
  int _correctAnswers = 0;
  bool _gameOver = false;
  bool _levelComplete = false;
  GameMode _gameMode = GameMode.baybayinToFilipino;
  late String _currentQuestion;
  late String _correctAnswer;
  List<String> _options = [];
  Timer? _timer;
  int _timeLeft = 20; // seconds for each question
  bool _isAnimating = false;
  late AnimationController _animController;
  String? _selectedAnswer; // Add this variable to track selected answer
  bool _answerChecked = false; // Add this variable to track if answer was checked
  
  // Use centralized data for the game
  final Map<String, String> _baybayinToFilipino = FilipinoWordsStructured.baybayinCharacters;
  final Map<String, String> _wordsWithBaybayin = FilipinoWordsStructured.baybayinWords;
  
  // Cache localized text
  late final String _gameTitle;
  late final String _scoreText;
  late final String _levelText;
  late final String _livesText;
  late final String _timeText;
  late final String _gameOverText;
  late final String _levelCompleteText;
  late final String _finalScoreText;
  late final String _correctText;
  late final String _incorrectText;
  late final String _nextLevelText;
  late final String _playAgainText;
  late final String _switchToText;
  late final String _baybayinToFilipinoMode;
  late final String _filipinoToBaybayinMode;
  late final String _guessFilipinoBaybayinInstructionText;
  late final String _guessBaybayinFilipinoInstructionText;
  
  @override
  void initState() {
    super.initState();
    _initializeTexts();
    _startLevel();
    
    // Initialize animation controller for UI elements
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }
  
  void _initializeTexts() {
    // Initialize texts based on language
    _gameTitle = widget.language == 'Filipino' ? 'Hulaan ang Baybayin' : 'Guess the Baybayin';
    _scoreText = widget.language == 'Filipino' ? 'Iskor' : 'Score';
    _levelText = widget.language == 'Filipino' ? 'Antas' : 'Level';
    _livesText = widget.language == 'Filipino' ? 'Buhay' : 'Lives';
    _timeText = widget.language == 'Filipino' ? 'Oras' : 'Time';
    _gameOverText = widget.language == 'Filipino' ? 'Tapos na ang Laro!' : 'Game Over!';
    _levelCompleteText = widget.language == 'Filipino' ? 'Natapos ang Antas!' : 'Level Complete!';
    _finalScoreText = widget.language == 'Filipino' ? 'Pinal na Iskor' : 'Final Score';
    _correctText = widget.language == 'Filipino' ? 'Tama!' : 'Correct!';
    _incorrectText = widget.language == 'Filipino' ? 'Mali!' : 'Incorrect!';
    _nextLevelText = widget.language == 'Filipino' ? 'Susunod na Antas' : 'Next Level';
    _playAgainText = widget.language == 'Filipino' ? 'Maglaro Ulit' : 'Play Again';
    _switchToText = widget.language == 'Filipino' ? 'Lumipat sa' : 'Switch to';
    _baybayinToFilipinoMode = widget.language == 'Filipino' 
        ? 'Mode: Baybayin → Filipino' 
        : 'Mode: Baybayin → Filipino';
    _filipinoToBaybayinMode = widget.language == 'Filipino' 
        ? 'Mode: Filipino → Baybayin' 
        : 'Mode: Filipino → Baybayin';
    _guessFilipinoBaybayinInstructionText = widget.language == 'Filipino'
        ? 'Ano ang katumbas ng salitang ito sa Baybayin?'
        : 'What is the Baybayin equivalent of this word?';
    _guessBaybayinFilipinoInstructionText = widget.language == 'Filipino'
        ? 'Ano ang katumbas ng simbolong ito sa Filipino?'
        : 'What is the Filipino equivalent of this symbol?';
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    _animController.dispose();
    super.dispose();
  }
  
  void _startLevel() {
    _correctAnswers = 0;
    _levelComplete = false;
    _generateNewQuestion();
    _startTimer();
  }
  
  void _generateNewQuestion() {
    final random = Random();
    
    if (_gameMode == GameMode.baybayinToFilipino) {
      // Select a random Baybayin character for simple levels (1-2)
      if (_level <= 2) {
        final characters = _baybayinToFilipino.keys.toList();
        _currentQuestion = characters[random.nextInt(characters.length)];
        _correctAnswer = _baybayinToFilipino[_currentQuestion]!;
        
        // Generate options
        final allAnswers = _baybayinToFilipino.values.toList();
        _options = [_correctAnswer];
        
        // Add 3 more random unique options
        while (_options.length < 4) {
          final option = allAnswers[random.nextInt(allAnswers.length)];
          if (!_options.contains(option)) {
            _options.add(option);
          }
        }
      } 
      // Use words for higher levels (3+)
      else {
        final words = _wordsWithBaybayin.keys.toList();
        _currentQuestion = words[random.nextInt(words.length)];
        _correctAnswer = _wordsWithBaybayin[_currentQuestion]!;
        
        // Generate options
        final allAnswers = _wordsWithBaybayin.values.toList();
        _options = [_correctAnswer];
        
        // Add 3 more random unique options
        while (_options.length < 4) {
          final option = allAnswers[random.nextInt(allAnswers.length)];
          if (!_options.contains(option)) {
            _options.add(option);
          }
        }
      }
    } else {
      // Filipino to Baybayin mode
      // Use characters for simple levels (1-2)
      if (_level <= 2) {
        final entries = _baybayinToFilipino.entries.toList();
        final selectedEntry = entries[random.nextInt(entries.length)];
        _currentQuestion = selectedEntry.value;
        _correctAnswer = selectedEntry.key;
        
        // Generate options
        final allAnswers = _baybayinToFilipino.keys.toList();
        _options = [_correctAnswer];
        
        // Add 3 more random unique options
        while (_options.length < 4) {
          final option = allAnswers[random.nextInt(allAnswers.length)];
          if (!_options.contains(option)) {
            _options.add(option);
          }
        }
      }
      // Use words for higher levels (3+)
      else {
        final entries = _wordsWithBaybayin.entries.toList();
        final selectedEntry = entries[random.nextInt(entries.length)];
        _currentQuestion = selectedEntry.value;
        _correctAnswer = selectedEntry.key;
        
        // Generate options
        final allAnswers = _wordsWithBaybayin.keys.toList();
        _options = [_correctAnswer];
        
        // Add 3 more random unique options
        while (_options.length < 4) {
          final option = allAnswers[random.nextInt(allAnswers.length)];
          if (!_options.contains(option)) {
            _options.add(option);
          }
        }
      }
    }
    
    // Shuffle options
    _options.shuffle();
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
        _handleAnswer('');
      }
    });
  }
  
  void _handleAnswer(String answer) {
    // Prevent multiple submissions
    if (_isAnimating) return;
    
    // Stop the timer
    _timer?.cancel();
    
    final bool isCorrect = answer == _correctAnswer;
    
    setState(() {
      _isAnimating = true;
      _selectedAnswer = answer; // Store the selected answer
      _answerChecked = true; // Mark that answer was checked
      
      if (isCorrect) {
        // Add points for correct answer (with bonus for faster answers)
        _score += (10 * _level) + _timeLeft;
        _correctAnswers++;
        
        // Check if level is complete (5 correct answers per level)
        if (_correctAnswers >= 5) {
          _levelComplete = true;
          _level++;
        }
      } else {
        // Only decrease lives for incorrect answers (and only when answer is not empty)
        if (answer.isNotEmpty) {
          _lives--;
          if (_lives <= 0) {
            _gameOver = true;
          }
        } else {
          // Time's up - also decrease lives
          _lives--;
          if (_lives <= 0) {
            _gameOver = true;
          }
        }
      }
    });
    
    // Delay to show the result
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _isAnimating = false;
          _answerChecked = false; // Reset answer checked state
          _selectedAnswer = null; // Reset selected answer
          
          if (!_gameOver && !_levelComplete) {
            _generateNewQuestion();
            _startTimer();
          }
        });
      }
    });
  }
  
  void _restartGame() {
    setState(() {
      _score = 0;
      _level = 1;
      _lives = 3;
      _correctAnswers = 0;
      _gameOver = false;
      _levelComplete = false;
      _timeLeft = 20;
    });
    
    _startLevel();
  }
  
  void _proceedToNextLevel() {
    setState(() {
      _levelComplete = false;
      _correctAnswers = 0;
      _timeLeft = 20;
    });
    
    _startLevel();
  }
  
  void _switchGameMode() {
    setState(() {
      if (_gameMode == GameMode.baybayinToFilipino) {
        _gameMode = GameMode.filipinoToBaybayin;
      } else {
        _gameMode = GameMode.baybayinToFilipino;
      }
      _restartGame();
    });
  }
  
  // Award points when handling correct answers - implemented in _handleAnswer method

  // At the end of game
  void _endGame() {
    // ...existing code...
    
    // Save score to Firebase and award bonus points
    if (UserState.instance.isLoggedIn) {
      final ScoreService scoreService = ScoreService();
      scoreService.updateScore('Baybayin Game', _score, pointsToAward: _score * 2);
      
      // Award achievement points if score is above threshold
      if (_score >= 15) {
        scoreService.awardAchievementPoints('baybayin_master', 35);
      }
    }
    
    // ...existing code...
  }
  
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
        actions: [
          // Mode switch button with improved styling
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.swap_horiz, color: Colors.white, size: 20),
              label: Text(
                _switchToText,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              onPressed: _switchGameMode,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                foregroundColor: Colors.white,
                elevation: 2,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF8F4E1),
      body: SafeArea(
        child: _gameOver 
            ? _buildGameOverScreen() 
            : _levelComplete 
                ? _buildLevelCompleteScreen() 
                : _buildGameScreen(),
      ),
    );
  }
  
  Widget _buildGameScreen() {
    final isTablet = ResponsiveUtil.isTablet(context);
    final padding = isTablet ? 16.0 : 12.0;
    
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
              // Game info bar with improved styling - more compact
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
                            child: const Icon(Icons.trending_up, color: Colors.green, size: 18),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '$_levelText: $_level',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: List.generate(
                          3,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            child: Icon(
                              Icons.favorite,
                              color: index < _lives 
                                  ? Colors.red 
                                  : Colors.grey.withOpacity(0.3),
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Timer and game mode with improved styling - reduced spacing
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Card(
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
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Card(
                      elevation: 2,
                      shadowColor: Colors.brown.withOpacity(0.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          _gameMode == GameMode.baybayinToFilipino
                              ? _baybayinToFilipinoMode
                              : _filipinoToBaybayinMode,
                          style: TextStyle(
                            color: Colors.brown[700],
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              // Instructions with enhanced styling - more compact
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
                    _gameMode == GameMode.baybayinToFilipino
                        ? _guessBaybayinFilipinoInstructionText
                        : _guessFilipinoBaybayinInstructionText,
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.brown[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              
              // Current question with improved card styling - more compact
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
                  child: TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0.95, end: 1.0),
                    duration: const Duration(seconds: 1),
                    curve: Curves.elasticOut,
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Text(
                          _currentQuestion,
                          style: TextStyle(
                            fontSize: isTablet ? 36 : 28, // Reduced size further
                            fontWeight: FontWeight.bold,
                            color: Colors.brown[800],
                            height: 1.3,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),
                ),
              ),
              
              // Options - Changed from fixed height to GridView with automatic sizing
              const SizedBox(height: 10),
              GridView.count(
                crossAxisCount: 2,
                childAspectRatio: isTablet ? 2.2 : 1.8,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                shrinkWrap: true, // Important for SingleChildScrollView
                physics: const NeverScrollableScrollPhysics(), // Disable scrolling for this grid
                children: List.generate(
                  _options.length,
                  (index) => Card(
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
                          color: _isAnimating 
                              ? (_options[index] == _correctAnswer 
                                  ? Colors.green 
                                  : Colors.transparent)
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: InkWell(
                        onTap: _isAnimating 
                            ? null 
                            : () => _handleAnswer(_options[index]),
                        borderRadius: BorderRadius.circular(12),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                _options[index],
                                style: TextStyle(
                                  fontSize: isTablet ? 22 : 16, // Reduced size
                                  fontWeight: FontWeight.bold,
                                  color: Colors.brown[700],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              // Feedback display with improved styling
              if (_answerChecked)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: _selectedAnswer == _correctAnswer
                        ? Colors.green.shade50
                        : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: (_selectedAnswer == _correctAnswer
                            ? Colors.green 
                            : Colors.red).withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    border: Border.all(
                      color: _selectedAnswer == _correctAnswer
                          ? Colors.green.withOpacity(0.3)
                          : Colors.red.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _selectedAnswer == _correctAnswer
                            ? Icons.check_circle
                            : Icons.cancel,
                        color: _selectedAnswer == _correctAnswer
                            ? Colors.green
                            : Colors.red,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          _selectedAnswer == _correctAnswer
                              ? _correctText
                              : '$_incorrectText $_correctAnswer',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: _selectedAnswer == _correctAnswer
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
  
  Widget _buildLevelCompleteScreen() {
    final isTablet = ResponsiveUtil.isTablet(context);
    
    return Center(
      child: Card(
        elevation: 6, // Reduced from 8
        shadowColor: Colors.amber.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Reduced from 24
        ),
        margin: EdgeInsets.all(isTablet ? 24 : 16), // Reduced for phones
        child: Padding(
          padding: EdgeInsets.all(isTablet ? 28 : 20), // Reduced from 32
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
                        color: Colors.amber.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.emoji_events,
                        size: 80,
                        color: Colors.amber,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20), // Reduced from 24
              Text(
                _levelCompleteText,
                style: TextStyle(
                  fontSize: isTablet ? 32 : 24, // Reduced from 36/28
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
              const SizedBox(height: 12), // Reduced from 16
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.brown.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '$_levelText ${_level - 1} $_finalScoreText: $_score',
                  style: TextStyle(
                    fontSize: isTablet ? 24 : 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown[700],
                  ),
                ),
              ),
              const SizedBox(height: 24), // Reduced from 32
              ElevatedButton.icon(
                icon: const Icon(Icons.arrow_forward),
                label: Text(
                  _nextLevelText,
                  style: TextStyle(
                    fontSize: isTablet ? 18 : 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: _proceedToNextLevel,
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
  
  Widget _buildGameOverScreen() {
    final isTablet = ResponsiveUtil.isTablet(context);
    
    return Center(
      child: Card(
        elevation: 6, // Reduced from 8
        shadowColor: Colors.brown.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Reduced from 24
        ),
        margin: EdgeInsets.all(isTablet ? 24 : 16), // Reduced for phones
        child: Padding(
          padding: EdgeInsets.all(isTablet ? 28 : 20), // Reduced from 32
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
                        Icons.sentiment_dissatisfied,
                        size: 80,
                        color: Colors.brown[600],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20), // Reduced from 24
              Text(
                _gameOverText,
                style: TextStyle(
                  fontSize: isTablet ? 32 : 24, // Reduced from 36/28
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
              const SizedBox(height: 12), // Reduced from 16
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.brown.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      '$_finalScoreText: $_score',
                      style: TextStyle(
                        fontSize: isTablet ? 24 : 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown[700],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$_levelText: $_level',
                      style: TextStyle(
                        fontSize: isTablet ? 20 : 16,
                        color: Colors.brown[600],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24), // Reduced from 32
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.replay),
                    label: Text(
                      _playAgainText,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: _restartGame,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 3,
                    ),
                  ),
                  const SizedBox(width: 16),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.swap_horiz),
                    label: Text(_switchToText),
                    onPressed: _switchGameMode,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.brown,
                      side: const BorderSide(color: Colors.brown),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
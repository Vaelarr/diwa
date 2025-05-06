import 'package:flutter/material.dart';
import 'dart:math';
import '../data/filipino_words_data.dart'; // Import the centralized data
import '../user_state.dart'; // Import UserState instead of auth service
import '../services/score_service.dart'; // Import score service

class WordGuessGame extends StatefulWidget {
  final String language;
  
  const WordGuessGame({
    Key? key,
    required this.language,
  }) : super(key: key);

  @override
  State<WordGuessGame> createState() => _WordGuessGameState();
}

class _WordGuessGameState extends State<WordGuessGame> {
  int _score = 0;
  int _lives = 3;
  bool _gameOver = false;
  late String _currentWord;
  late String _currentWordUppercase; // Add this to store uppercase version
  final List<String> _guessedLetters = [];
  
  // Use centralized data instead of hardcoded values
  late final List<String> _tagalogWords;
  late final Map<String, String> _meanings;
  
  // List of alphabet letters for the keyboard (using static for performance)
  static const List<String> _alphabet = [
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
    'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
  ];
  
  // Cache localized text to avoid recomputing on every rebuild
  late final String _gameTitle;
  late final String _scoreText;
  late final String _livesText;
  late final String _meaningText;
  late final String _gameOverText;
  late final String _finalScoreText;
  late final String _playAgainText;
  late final String _guessText;
  late final String _theWordWasText;
  
  @override
  void initState() {
    super.initState();
    // Initialize localized text once
    _gameTitle = widget.language == 'Filipino' ? 'Anong Salita?' : 'Guess the Word';
    _scoreText = widget.language == 'Filipino' ? 'Iskor' : 'Score';
    _livesText = widget.language == 'Filipino' ? 'Buhay' : 'Lives';
    _meaningText = widget.language == 'Filipino' ? 'Kahulugan' : 'Meaning';
    _gameOverText = widget.language == 'Filipino' ? 'Tapos na ang Laro!' : 'Game Over!';
    _finalScoreText = widget.language == 'Filipino' ? 'Pinal na Iskor' : 'Final Score';
    _playAgainText = widget.language == 'Filipino' ? 'Maglaro Ulit' : 'Play Again';
    _guessText = widget.language == 'Filipino' ? 'Hulaan ang Salita:' : 'Guess the Word:';
    _theWordWasText = widget.language == 'Filipino' ? 'Ang salita ay:' : 'The word was:';
    
    // Initialize game data from centralized source
    _initializeGameData();
    _startNewRound();
  }
  
  void _initializeGameData() {
    // Get words from easy and medium difficulty
    final easyWords = FilipinoWordsData.getWordsByDifficulty('easy');
    final mediumWords = FilipinoWordsData.getWordsByDifficulty('medium');
    
    _tagalogWords = [...easyWords, ...mediumWords];
    
    // Create meanings map
    _meanings = {};
    for (var word in _tagalogWords) {
      final translation = FilipinoWordsData.words[word]!['translations']['english'];
      _meanings[word] = translation;
    }
  }
  
  void _startNewRound() {
    // Select a random word
    final random = Random();
    _currentWord = _tagalogWords[random.nextInt(_tagalogWords.length)];
    _currentWordUppercase = _currentWord.toUpperCase(); // Store uppercase version
    _guessedLetters.clear();
  }
  
  void _guessLetter(String letter) {
    if (_guessedLetters.contains(letter) || _gameOver) {
      return;
    }
    
    setState(() {
      _guessedLetters.add(letter);
      
      if (!_currentWordUppercase.contains(letter)) { // Use uppercase version for comparison
        _lives--;
        if (_lives <= 0) {
          _gameOver = true;
        }
      } else {
        // Check if the word is complete
        bool wordComplete = true;
        for (int i = 0; i < _currentWord.length; i++) {
          if (!_guessedLetters.contains(_currentWord[i].toUpperCase())) { // Convert to uppercase for comparison
            wordComplete = false;
            break;
          }
        }
        
        if (wordComplete) {
          _score++;
          
          // Delay before starting a new round
          Future.delayed(const Duration(milliseconds: 1000), () {
            if (mounted) {
              setState(() {
                _startNewRound();
              });
            }
          });
        }
      }
    });
  }
  
  void _restartGame() {
    setState(() {
      _score = 0;
      _lives = 3;
      _gameOver = false;
      _startNewRound();
    });
  }
  
  // New method to save score when game is over
  Future<void> _saveScore() async {
    try {
      final userId = UserState.instance.uid; // Get user ID directly from UserState
      
      if (userId.isNotEmpty) {
        final scoreService = ScoreService();
        await scoreService.saveScore(
          userId: userId,
          game: 'word_guess',
          score: _score,
        );
      }
    } catch (e) {
      debugPrint('Error saving score: $e');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    // Use const widgets where possible
    return Scaffold(
      appBar: AppBar(
        title: Text(_gameTitle),
        backgroundColor: Colors.brown,
      ),
      backgroundColor: const Color(0xFFF8F4E1),
      body: _gameOver ? _buildGameOverScreen() : _buildGameScreen(),
    );
  }
  
  Widget _buildGameScreen() {
    // Use const for container dimensions
    const double letterBoxSize = 40.0;
    const double letterSpacing = 4.0;
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Score and Lives (using Row.children directly for better performance)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$_scoreText: $_score',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
              Row(
                children: List.generate(
                  3,
                  (index) => Icon(
                    Icons.favorite,
                    color: index < _lives ? Colors.red : Colors.grey,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Word meaning (cached for performance)
          Text(
            '$_meaningText: ${_meanings[_currentWord] ?? "Unknown"}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.brown,
            ),
          ),
          const SizedBox(height: 8),
          
          // Instruction text (const to prevent rebuilds)
          Text(
            _guessText,
            style: const TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          
          // Word to guess - optimize with a FittedBox for responsive sizing
          FittedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _currentWord.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: letterSpacing),
                  width: letterBoxSize,
                  height: letterBoxSize,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.brown, width: 2),
                    borderRadius: BorderRadius.circular(8.0),
                    color: _guessedLetters.contains(_currentWord[index].toUpperCase()) // Convert to uppercase for comparison
                        ? Colors.brown.withOpacity(0.2)
                        : Colors.white,
                  ),
                  alignment: Alignment.center,
                  child: _guessedLetters.contains(_currentWord[index].toUpperCase()) // Convert to uppercase for comparison
                      ? Text(
                          _currentWord[index],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown,
                          ),
                        )
                      : null,
                ),
              ),
            ),
          ),
          const SizedBox(height: 48),
          
          // Keyboard - using Expanded with flexible sizing
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Calculate optimal grid size based on available space
                final double availableWidth = constraints.maxWidth;
                final int crossAxisCount = availableWidth > 360 ? 7 : 6;
                
                return GridView.builder(
                  physics: const NeverScrollableScrollPhysics(), // Prevent scrolling for performance
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: 1,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  itemCount: _alphabet.length,
                  itemBuilder: (context, index) {
                    final letter = _alphabet[index];
                    final bool isGuessed = _guessedLetters.contains(letter);
                    final bool isCorrect = _currentWordUppercase.contains(letter); // Use uppercase version for comparison
                    
                    return ElevatedButton(
                      onPressed: isGuessed ? null : () => _guessLetter(letter),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        backgroundColor: isGuessed
                            ? (isCorrect ? Colors.green[100] : Colors.red[100])
                            : Colors.white,
                        foregroundColor: Colors.brown,
                        disabledForegroundColor: isCorrect
                            ? Colors.green[800]
                            : Colors.red[800],
                      ),
                      child: Text(
                        letter,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                );
              }
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildGameOverScreen() {
    // Save score when showing game over screen
    if (_gameOver) {
      _saveScore();
    }
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _lives <= 0 ? Icons.mood_bad : Icons.emoji_events,
            size: 100,
            color: _lives <= 0 ? Colors.red : Colors.amber,
          ),
          const SizedBox(height: 24),
          Text(
            _gameOverText,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.brown,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '$_finalScoreText: $_score',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (_lives <= 0) ...[
            const SizedBox(height: 16),
            Text(
              '$_theWordWasText $_currentWord',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
          ],
          const SizedBox(height: 32),
          ElevatedButton.icon(
            icon: const Icon(Icons.replay),
            label: Text(_playAgainText),
            onPressed: _restartGame,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

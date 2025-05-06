import 'package:flutter/material.dart';
import 'dart:math';
import '../main.dart'; // Import for ResponsiveUtil
import '../data/filipino_words_data.dart'; // Import the centralized data

class QuizGame extends StatefulWidget {
  final String language;
  
  const QuizGame({
    Key? key,
    required this.language,
  }) : super(key: key);

  @override
  State<QuizGame> createState() => _QuizGameState();
}

class _QuizGameState extends State<QuizGame> {
  int _score = 0;
  int _questionIndex = 0;
  bool _gameOver = false;
  int? _selectedAnswerIndex;
  bool _answerChecked = false;
  final int _totalQuestions = 5;
  
  late List<Map<String, dynamic>> _questions;

  // Cache localized text strings
  late final String _gameTitle;
  late final String _scoreText;
  late final String _questionText;
  late final String _correctText;
  late final String _incorrectText;
  late final String _gameOverText;
  late final String _finalScoreText;
  late final String _playAgainText;
  
  @override
  void initState() {
    super.initState();
    
    // Initialize text values once
    _gameTitle = widget.language == 'Filipino' ? 'Palaro ng Pagsusulit' : 'Quiz Game';
    _scoreText = widget.language == 'Filipino' ? 'Iskor' : 'Score';
    _questionText = widget.language == 'Filipino' ? 'Tanong' : 'Question';
    _correctText = widget.language == 'Filipino' ? 'Tama!' : 'Correct!';
    _incorrectText = widget.language == 'Filipino' ? 'Mali!' : 'Incorrect!';
    _gameOverText = widget.language == 'Filipino' ? 'Tapos na ang Palaro!' : 'Game Over!';
    _finalScoreText = widget.language == 'Filipino' ? 'Pinal na Iskor' : 'Final Score';
    _playAgainText = widget.language == 'Filipino' ? 'Maglaro Ulit' : 'Play Again';
    
    _initializeQuestions();
    _questions.shuffle();
    _questions = _questions.take(_totalQuestions).toList();
  }
  
  void _initializeQuestions() {
    _questions = [
      {
        'question': widget.language == 'Filipino'
            ? 'Anong pambansang wika ng Pilipinas?'
            : 'What is the national language of the Philippines?',
        'options': ['English', 'Spanish', 'Filipino', 'Bisaya'],
        'correctAnswerIndex': 2,
      },
      {
        'question': widget.language == 'Filipino'
            ? 'Anong tawag sa orihinal na pagsulat ng mga Pilipino?'
            : 'What is the name of the original writing system of the Philippines?',
        'options': ['Baybayin', 'Alibata', 'Abakada', 'Kaligrapiya'],
        'correctAnswerIndex': 0,
      },
      {
        'question': widget.language == 'Filipino'
            ? 'Ilan ang titik sa makabagong alpabetong Filipino?'
            : 'How many letters are in the modern Filipino alphabet?',
        'options': ['20', '24', '28', '26'],
        'correctAnswerIndex': 2,
      },
      {
        'question': widget.language == 'Filipino'
            ? 'Sino ang kilalang "Ama ng Wikang Pambansa"?'
            : 'Who is known as the "Father of the National Language"?',
        'options': ['Jose Rizal', 'Andres Bonifacio', 'Manuel L. Quezon', 'Lope K. Santos'],
        'correctAnswerIndex': 3,
      },
      {
        'question': widget.language == 'Filipino'
            ? 'Kailan ipinagdiriwang ang Buwan ng Wika?'
            : 'When is the Language Month celebrated?',
        'options': ['January', 'August', 'October', 'June'],
        'correctAnswerIndex': 1,
      },
      {
        'question': widget.language == 'Filipino'
            ? 'Alin sa mga sumusunod ang HINDI kasalukuyang titik sa makabagong alpabetong Filipino?'
            : 'Which of the following is NOT a current letter in the modern Filipino alphabet?',
        'options': ['Ñ', 'C', 'RR', 'LL'],
        'correctAnswerIndex': 3,
      },
      {
        'question': widget.language == 'Filipino'
            ? 'Ano ang tawag sa paraan ng pagbibigay-diin sa pantig sa Filipino?'
            : 'What is the term for the way of emphasizing syllables in Filipino?',
        'options': ['Intonasyon', 'Diin', 'Tono', 'Ritmo'],
        'correctAnswerIndex': 1,
      },
      {
        'question': widget.language == 'Filipino'
            ? 'Aling wika ang may malaking impluwensya sa Filipino?'
            : 'Which language has a major influence on Filipino?',
        'options': ['Chinese', 'Arabic', 'Spanish', 'Japanese'],
        'correctAnswerIndex': 2,
      },
    ];

    // Add one question based on parts of speech from central data
    final partsOfSpeech = FilipinoWordsData.getAllPartOfSpeech();
    if (partsOfSpeech.contains('pangngalan')) {
      _questions.add({
        'question': widget.language == 'Filipino'
            ? 'Alin sa mga sumusunod ay "pangngalan" sa Ingles?'
            : 'Which of the following is "pangngalan" in English?',
        'options': ['Verb', 'Noun', 'Adjective', 'Adverb'],
        'correctAnswerIndex': 1,
      });
    }
  }
  
  void _checkAnswer(int answerIndex) {
    if (_answerChecked) return;
    
    final correctAnswerIndex = _questions[_questionIndex]['correctAnswerIndex'];
    setState(() {
      _selectedAnswerIndex = answerIndex;
      _answerChecked = true;
      
      if (answerIndex == correctAnswerIndex) {
        _score++;
      }
    });
    
    // Move to next question after a delay
    Future.delayed(const Duration(seconds: 1), () {
      if (_questionIndex < _totalQuestions - 1) {
        setState(() {
          _questionIndex++;
          _selectedAnswerIndex = null;
          _answerChecked = false;
        });
      } else {
        setState(() {
          _gameOver = true;
        });
      }
    });
  }
  
  void _restartGame() {
    setState(() {
      _score = 0;
      _questionIndex = 0;
      _gameOver = false;
      _selectedAnswerIndex = null;
      _answerChecked = false;
      
      // Re-initialize questions
      _initializeQuestions();
      _questions.shuffle();
      _questions = _questions.take(_totalQuestions).toList();
    });
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
          // Game type info badge
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: Chip(
              label: Text(
                _gameTitle,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isTablet ? 14 : 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: Colors.brown,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF8F4E1),
      body: _gameOver ? _buildGameOverScreen() : _buildQuestionScreen(),
    );
  }
  
  Widget _buildQuestionScreen() {
    final currentQuestion = _questions[_questionIndex];
    final isTablet = ResponsiveUtil.isTablet(context);
    final padding = ResponsiveUtil.getResponsivePadding(context: context);
    
    // Use RepaintBoundary to prevent unnecessary repaints
    return RepaintBoundary(
      child: Padding(
        padding: padding,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isTablet ? 600.0 : double.infinity,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 4,
                  shadowColor: Colors.brown.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.brown.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.emoji_events,
                                color: Colors.brown,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '$_scoreText: $_score',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.brown,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.brown.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.question_answer,
                                color: Colors.brown,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '$_questionText ${_questionIndex + 1}/$_totalQuestions',
                              style: const TextStyle(
                                fontSize: 18,
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
                
                const SizedBox(height: 24),
                
                // Question card with improved styling
                Card(
                  elevation: 4.0,
                  shadowColor: Colors.brown.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.brown.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.lightbulb_outline,
                                color: Colors.brown,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                currentQuestion['question'],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.brown,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Answer options with improved styling
                ...List.generate(
                  (currentQuestion['options'] as List).length,
                  (index) {
                    final bool isSelected = _selectedAnswerIndex == index;
                    final bool isCorrect = index == currentQuestion['correctAnswerIndex'];
                    
                    Color cardColor = Colors.white;
                    Color textColor = Colors.brown;
                    IconData? iconData;
                    
                    if (_answerChecked) {
                      if (isCorrect) {
                        cardColor = Colors.green.shade50;
                        textColor = Colors.green.shade800;
                        iconData = Icons.check_circle_outline;
                      } else if (isSelected) {
                        cardColor = Colors.red.shade50;
                        textColor = Colors.red.shade800;
                        iconData = Icons.cancel_outlined;
                      }
                    }
                    
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Card(
                        color: cardColor,
                        elevation: 2,
                        shadowColor: Colors.brown.withOpacity(0.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: _answerChecked && (isSelected || isCorrect)
                                ? (isCorrect ? Colors.green.shade200 : Colors.red.shade200)
                                : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: InkWell(
                          onTap: _answerChecked ? null : () => _checkAnswer(index),
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: Colors.brown.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Center(
                                    child: _answerChecked && (isSelected || isCorrect)
                                        ? Icon(
                                            iconData,
                                            color: textColor,
                                            size: 18,
                                          )
                                        : Text(
                                            String.fromCharCode(65 + index), // A, B, C, D
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: textColor,
                                            ),
                                          ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    currentQuestion['options'][index],
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: textColor,
                                      fontWeight: isSelected || (isCorrect && _answerChecked)
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                
                // Feedback message with improved styling
                if (_answerChecked)
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    margin: const EdgeInsets.only(top: 16.0),
                    decoration: BoxDecoration(
                      color: _selectedAnswerIndex == currentQuestion['correctAnswerIndex']
                          ? Colors.green.shade50
                          : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(
                        color: _selectedAnswerIndex == currentQuestion['correctAnswerIndex']
                            ? Colors.green.shade200
                            : Colors.red.shade200,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _selectedAnswerIndex == currentQuestion['correctAnswerIndex']
                                ? Colors.green.shade100
                                : Colors.red.shade100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            _selectedAnswerIndex == currentQuestion['correctAnswerIndex']
                                ? Icons.check_circle
                                : Icons.cancel,
                            color: _selectedAnswerIndex == currentQuestion['correctAnswerIndex']
                                ? Colors.green.shade800
                                : Colors.red.shade800,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _selectedAnswerIndex == currentQuestion['correctAnswerIndex']
                                ? _correctText
                                : '$_incorrectText ${currentQuestion['options'][currentQuestion['correctAnswerIndex']]}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: _selectedAnswerIndex == currentQuestion['correctAnswerIndex']
                                  ? Colors.green.shade800
                                  : Colors.red.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildGameOverScreen() {
    final percentage = (_score / _totalQuestions) * 100;
    final isTablet = ResponsiveUtil.isTablet(context);
    
    return Padding(
      padding: EdgeInsets.all(isTablet ? 32.0 : 24.0),
      child: Center(
        child: Card(
          elevation: 8,
          shadowColor: Colors.brown.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.emoji_events,
                    size: 80,
                    color: Colors.amber,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                Text(
                  _gameOverText,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.brown.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.brown.withOpacity(0.2),
                    ),
                  ),
                  child: Text(
                    '$_finalScoreText: $_score/$_totalQuestions',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: percentage >= 80
                        ? Colors.green.shade50
                        : percentage >= 60
                            ? Colors.amber.shade50
                            : Colors.red.shade50,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: percentage >= 80
                          ? Colors.green.shade200
                          : percentage >= 60
                              ? Colors.amber.shade200
                              : Colors.red.shade200,
                      width: 3,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${percentage.round()}%',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: percentage >= 80
                            ? Colors.green.shade700
                            : percentage >= 60
                                ? Colors.amber.shade700
                                : Colors.red.shade700,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                ElevatedButton.icon(
                  icon: const Icon(Icons.replay),
                  label: Text(_playAgainText),
                  onPressed: _restartGame,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../main.dart'; // Import for ResponsiveUtil
import '../data/filipino_words_data.dart'; // Import the centralized data
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
    
    // Show login reminder when page is opened if user is not logged in
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!UserState.instance.isLoggedIn) {
        _showLoginPrompt();
      }
    });
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
    
  String get _synonymsText => 
    widget.language == 'Filipino' ? 'Mga Kasingkahulugan' : 'Synonyms';
    
  String get _antonymsText => 
    widget.language == 'Filipino' ? 'Mga Kasalungat' : 'Antonyms';
    
  String get _relatedWordsText => 
    widget.language == 'Filipino' ? 'Kaugnay na mga Salita' : 'Related Words';
    
  String get _partOfSpeechText => 
    widget.language == 'Filipino' ? 'Bahagi ng Pananalita' : 'Part of Speech';
    
  String get _originText => 
    widget.language == 'Filipino' ? 'Pinagmulan' : 'Origin';
    
  String get _meaningText => 
    widget.language == 'Filipino' ? 'Kahulugan' : 'Meaning';
    
  String get _translationText => 
    widget.language == 'Filipino' ? 'Salin sa Ingles' : 'English Translation';
    
  String get _regionText => 
    widget.language == 'Filipino' ? 'Rehiyon' : 'Region';

  @override
  Widget build(BuildContext context) {
    final wordData = FilipinoWordsData.words[widget.word];
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
                await UserState.instance.saveWord(widget.word);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Word saved!'),
                    duration: const Duration(seconds: 2),
                    backgroundColor: Colors.brown,
                  ),
                );
              } else {
                await UserState.instance.removeSavedWord(widget.word);
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
                                  wordData['partOfSpeech'],
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
                  
                  // Meaning in Filipino
                  _buildDetailSection(
                    _meaningText,
                    Icons.description,
                    wordData['meaning'] ?? "No meaning available",
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Translation in English
                  _buildDetailSection(
                    _translationText,
                    Icons.translate,
                    wordData['translations']?['english'] ?? "No translation available",
                  ),
                  
                  // Origin if available
                  if (wordData.containsKey('origin') && wordData['origin'] != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        _buildDetailSection(
                          _originText,
                          Icons.history,
                          wordData['origin'],
                        ),
                      ],
                    ),
                    
                  // Region if available
                  if (wordData.containsKey('region') && wordData['region'] != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        _buildDetailSection(
                          _regionText,
                          Icons.place,
                          wordData['region'],
                        ),
                      ],
                    ),
                ],
              ),
            ),
            
            // Examples
            if (wordData.containsKey('examples') && 
                wordData['examples'] != null &&
                (wordData['examples'] as List).isNotEmpty)
              _buildExamplesCard(wordData['examples'] as List),
              
            // Synonyms
            if (wordData.containsKey('synonyms') && 
                wordData['synonyms'] != null &&
                (wordData['synonyms'] as List).isNotEmpty)
              _buildWordChipsCard(_synonymsText, wordData['synonyms'] as List, Colors.green),
              
            // Antonyms
            if (wordData.containsKey('antonyms') && 
                wordData['antonyms'] != null &&
                (wordData['antonyms'] as List).isNotEmpty)
              _buildWordChipsCard(_antonymsText, wordData['antonyms'] as List, Colors.red),
              
            // Related words
            if (wordData.containsKey('related') && 
                wordData['related'] != null &&
                (wordData['related'] as List).isNotEmpty)
              _buildWordChipsCard(_relatedWordsText, wordData['related'] as List, Colors.blue),
              
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
  
  Widget _buildExamplesCard(List examples) {
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
          ...examples.map((example) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.brown.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
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
          )).toList(),
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
                if (FilipinoWordsData.words.containsKey(word)) {
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

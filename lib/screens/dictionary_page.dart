import 'package:flutter/material.dart';
import '../main.dart'; // Import for ResponsiveUtil
import '../data/filipino_words_structured.dart'; // Import the centralized data
import 'word_details_page.dart'; // Import the new word details page
import '../user_state.dart'; // Import for checking login status

class DictionaryPage extends StatefulWidget {
  final String language;

  const DictionaryPage({
    super.key,
    required this.language,
  });

  @override
  State<DictionaryPage> createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearching = false;
  late AnimationController _animController;

  // Use the centralized data source
  final Map<String, Map<String, dynamic>> _dictionary = FilipinoWordsStructured.words;

  // Localized text getters
  String get _dictionaryTitle =>
      widget.language == 'Filipino' ? 'Diksyunaryong Filipino' : 'Filipino Dictionary';

  String get _searchHint =>
      widget.language == 'Filipino' ? 'Maghanap ng salita...' : 'Search for a word...';

  String get _resultsFor =>
      widget.language == 'Filipino' ? 'Mga resulta para sa' : 'Results for';

  String get _wordsList =>
      widget.language == 'Filipino' ? 'Mga Salitang Filipino' : 'Filipino Words';

  // Login reminder text
  String get _loginReminderText =>
      widget.language == 'Filipino'
          ? 'Mag-login upang masave ang iyong progress'
          : 'Log in to save your progress';

  // Login button text
  String get _loginButtonText =>
      widget.language == 'Filipino' ? 'Mag-login' : 'Log In';

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    
    // Show login reminder when page is opened if user is not logged in
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!UserState.instance.isLoggedIn) {
        _showLoginPrompt();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animController.dispose();
    super.dispose();
  }

  List<String> _getFilteredWords() {
    if (_searchQuery.isEmpty) {
      return _dictionary.keys.toList();
    }

    return _dictionary.keys
        .where((word) => word.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredWords = _getFilteredWords();
    final isTablet = ResponsiveUtil.isTablet(context);
    final padding = ResponsiveUtil.getResponsivePadding(context: context);

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: _searchHint,
                  hintStyle: TextStyle(color: Colors.brown.withOpacity(0.7)),
                  border: InputBorder.none,
                  prefixIcon: const Icon(Icons.search, color: Colors.brown),
                ),
                style: const TextStyle(color: Colors.brown),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              )
            : Row(
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
                color: Colors.brown.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _isSearching ? Icons.cancel : Icons.search,
                color: Colors.brown,
              ),
            ),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _isSearching = false;
                  _searchQuery = '';
                  _searchController.clear();
                } else {
                  _isSearching = true;
                }
              });
            },
          ),
          const SizedBox(width: 8),
        ],
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
            // Handle back navigation safely
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              // If can't pop (e.g., if this was directly opened), go to home
              Navigator.of(context).pushReplacementNamed('/home');
            }
          },
        ),
        centerTitle: true,
        toolbarHeight: isTablet ? 90 : 70,
      ),
      body: Column(
        children: [
          // Dictionary header
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0.95, end: 1.0),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutQuad,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.brown.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.brown.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    _isSearching && _searchQuery.isNotEmpty
                        ? '$_resultsFor: "$_searchQuery"'
                        : _dictionaryTitle.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                      letterSpacing: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          ),

          // Results count
          if (_searchQuery.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.brown.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.format_list_numbered, size: 16, color: Colors.brown),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${filteredWords.length} ${widget.language == 'Filipino' ? 'mga resulta' : 'results'}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.brown[600],
                    ),
                  ),
                ],
              ),
            ),

          // Word list
          Expanded(
            child: filteredWords.isEmpty
                ? _buildEmptyState()
                : _buildWordsList(filteredWords),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF8F4E1),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.brown.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search_off,
              size: 60,
              color: Colors.brown.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            widget.language == 'Filipino'
                ? 'Walang nahanap na salita'
                : 'No words found',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.brown,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.language == 'Filipino'
                ? 'Subukan ang ibang mga keyword'
                : 'Try different keywords',
            style: TextStyle(
              fontSize: 16,
              color: Colors.brown[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWordsList(List<String> filteredWords) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: ListView.builder(
        key: ValueKey<int>(filteredWords.length),
        itemCount: filteredWords.length,
        padding: const EdgeInsets.only(bottom: 16),
        itemBuilder: (context, index) {
          final word = filteredWords[index];

          // Staggered animation effect
          return TweenAnimationBuilder(
            key: ValueKey<String>(word),
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 300 + (index % 5) * 100),
            builder: (context, value, child) {
              return Transform.scale(
                scale: 0.8 + (0.2 * value),
                child: Opacity(
                  opacity: value,
                  child: child,
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              elevation: 2,
              shadowColor: Colors.brown.withOpacity(0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: () => _navigateToWordDetails(word),
                borderRadius: BorderRadius.circular(12),
                splashColor: Colors.brown.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.brown.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          word[0].toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
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
                              word,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.brown,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _dictionary[word]!['translations']['english'],
                              style: TextStyle(
                                color: Colors.brown[600],
                                fontStyle: FontStyle.italic,
                                fontSize: 14,
                              ),
                            ),
                            if (_dictionary[word]!.containsKey('partOfSpeech'))
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.brown.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    _dictionary[word]!['partOfSpeech'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.brown[700],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Colors.brown),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _navigateToWordDetails(String word) {
    // No need to show login prompt here, as it will be shown in the WordDetailsPage when it's initialized
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WordDetailsPage(
          word: word,
          language: widget.language,
          // Make sure WordDetailsPage can navigate back to this page
          onBackPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => DictionaryPage(language: widget.language),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  // Show login prompt similar to LearnSection
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

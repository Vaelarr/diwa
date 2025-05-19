import 'package:flutter/material.dart';
import 'dart:async'; // For debouncing
import '../main.dart'; // Import for ResponsiveUtil
import '../data/filipino_words_structured.dart'; // Import the centralized data

class BaybayinPage extends StatefulWidget {
  final String language;

  const BaybayinPage({
    Key? key,
    required this.language,
  }) : super(key: key);

  @override
  State<BaybayinPage> createState() => _BaybayinPageState();
}

class _BaybayinPageState extends State<BaybayinPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  String _inputText = '';
  String _translatedText = '';
  Timer? _debounceTimer;
  bool _isTranslating = false;

  // Cached texts
  late final String _baybayinTitle;
  late final String _learnTabTitle;
  late final String _practiceTabTitle;
  late final String _translateTabTitle;
  late final String _previousButtonText;
  late final String _nextButtonText;
  late final String _examplesText;
  late final String _inputHintText;
  late final String _translateButtonText;
  late final String _latinText;
  late final String _translatedTextWillAppearHere;

  // Use centralized data
  final Map<String, String> _baybayinChars = FilipinoWordsStructured.baybayinCharacters;
  
  // Expanded lessons with more content
  static final _lessons = [
    {
      'title': 'Introduction to Baybayin',
      'description': 'Learn about the history and basics of the Baybayin writing system.',
      'content': 'Baybayin is an ancient Philippine script that was used primarily by the Tagalog people before the Spanish colonization. The word "baybayin" refers to the alphabet, with each character representing a syllable. This writing system was widely used for personal communication, literature, and religious practices.',
      'icon': Icons.history,
      'color': Colors.brown,
    },
    {
      'title': 'Vowels in Baybayin',
      'description': 'Learn how vowels are represented in the Baybayin script.',
      'content': 'Baybayin has three basic vowel characters:\n\n• ᜀ (A)\n• ᜁ (E/I)\n• ᜂ (O/U)\n\nThese vowels form the foundation of the Baybayin writing system and are essential for proper pronunciation and reading.',
      'icon': Icons.text_fields,
      'color': Colors.green,
    },
  ];

  // Generate character samples from centralized data with improved structure
  List<Map<String, dynamic>> get _characterSamples {
    final List<Map<String, dynamic>> samples = [];
    final characters = FilipinoWordsStructured.baybayinCharacters;
    
    // Add vowels
    samples.add({
      'character': characters['a']!,
      'latin': 'A',
      'examples': ['ama (father)', 'araw (sun)'],
      'color': Colors.brown,
    });
    
    samples.add({
      'character': characters['e/i']!,
      'latin': 'E/I',
      'examples': ['ina (mother)', 'isda (fish)'],
      'color': Colors.brown,
    });
    
    samples.add({
      'character': characters['o/u']!,
      'latin': 'O/U',
      'examples': ['ulo (head)', 'uso (trend)'],
      'color': Colors.brown,
    });
    
    // Add consonants
    samples.add({
      'character': characters['ba']!,
      'latin': 'BA',
      'examples': ['bata (child)', 'bahay (house)'],
      'color': Colors.brown,
    });
    
    samples.add({
      'character': characters['ka']!,
      'latin': 'KA',
      'examples': ['kamay (hand)', 'kalabaw (carabao)'],
      'color': Colors.brown,
    });
    
    samples.add({
      'character': characters['da']!,
      'latin': 'DA',
      'examples': ['daan (road)', 'daliri (finger)'],
      'color': Colors.brown,
    });
    
    samples.add({
      'character': characters['ga']!,
      'latin': 'GA',
      'examples': ['gabi (night)', 'gatas (milk)'],
      'color': Colors.brown,
    });
    
    samples.add({
      'character': characters['ha']!,
      'latin': 'HA',
      'examples': ['halaman (plant)', 'hangin (wind)'],
      'color': Colors.brown,
    });
    
    samples.add({
      'character': characters['la']!,
      'latin': 'LA',
      'examples': ['labi (lip)', 'langit (sky)'],
      'color': Colors.brown,
    });
    
    samples.add({
      'character': characters['ma']!,
      'latin': 'MA',
      'examples': ['mata (eye)', 'mahal (love/expensive)'],
      'color': Colors.brown,
    });
    
    samples.add({
      'character': characters['na']!,
      'latin': 'NA',
      'examples': ['naiintindihan (understand)', 'nanay (mom)'],
      'color': Colors.brown,
    });
    
    samples.add({
      'character': characters['nga']!,
      'latin': 'NGA',
      'examples': ['ngalan (name)', 'ngiti (smile)'],
      'color': Colors.brown,
    });
    
    samples.add({
      'character': characters['pa']!,
      'latin': 'PA',
      'examples': ['paa (foot)', 'puso (heart)'],
      'color': Colors.brown,
    });
    
    samples.add({
      'character': characters['sa']!,
      'latin': 'SA',
      'examples': ['saya (happiness)', 'salita (word)'],
      'color': Colors.brown,
    });
    
    samples.add({
      'character': characters['ta']!,
      'latin': 'TA',
      'examples': ['tao (person)', 'tatay (father)'],
      'color': Colors.brown,
    });
    
    samples.add({
      'character': characters['wa']!,
      'latin': 'WA',
      'examples': ['walis (broom)', 'wala (none)'],
      'color': Colors.brown,
    });
    
    samples.add({
      'character': characters['ya']!,
      'latin': 'YA',
      'examples': ['yakap (embrace)', 'yaman (wealth)'],
      'color': Colors.brown,
    });
    
    return samples;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initializeTexts();
  }

  void _initializeTexts() {
    // Initialize texts once
    _baybayinTitle = widget.language == 'Filipino' ? 'Baybayin' : 'Baybayin Script';
    _learnTabTitle = widget.language == 'Filipino' ? 'Matuto' : 'Learn';
    _practiceTabTitle = widget.language == 'Filipino' ? 'Magsanay' : 'Practice';
    _translateTabTitle = widget.language == 'Filipino' ? 'Isalin' : 'Translate';
    _previousButtonText = widget.language == 'Filipino' ? 'Nauna' : 'Previous';
    _nextButtonText = widget.language == 'Filipino' ? 'Susunod' : 'Next';
    _examplesText = widget.language == 'Filipino' ? 'Mga Halimbawa' : 'Examples';
    _inputHintText = widget.language == 'Filipino' ? 'Mag-type ng text dito...' : 'Type text here...';
    _translateButtonText = widget.language == 'Filipino' ? 'Isalin sa Baybayin' : 'Translate to Baybayin';
    _latinText = widget.language == 'Filipino' ? 'Latin' : 'Latin';
    _translatedTextWillAppearHere = widget.language == 'Filipino' 
        ? 'Ang isinalin na text ay ipapakita dito' 
        : 'Translated text will appear here';
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  // Debounced translation to avoid excessive rebuilds
  void _debouncedTranslate(String text) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _translateText(text);
    });
  }

  // Simplified translation method
  void _translateText(String input) {
    if (_isTranslating) return;
    
    setState(() {
      _isTranslating = true;
      _inputText = input; // Add this line to save the current input
    });
    
    // Use Future to avoid blocking the UI
    Future.microtask(() {
      try {
        input = input.toLowerCase();
        String result = '';

        // Simplified translation algorithm
        for (int i = 0; i < input.length; i++) {
          if (i < input.length - 1) {
            String pair = input.substring(i, i + 2);
            if (_baybayinChars.containsKey(pair)) {
              result += _baybayinChars[pair]!;
              i++;
              continue;
            }
          }

          String char = input[i];
          if (_baybayinChars.containsKey(char)) {
            result += _baybayinChars[char]!;
          } else if (char == ' ') {
            result += ' ';
          }
        }

        // Update UI on next frame
        if (mounted) {
          setState(() {
            _translatedText = result;
            _isTranslating = false;
          });
        }
      } catch (e) {
        // Silently handle errors
        if (mounted) {
          setState(() {
            _isTranslating = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final primaryColor = Theme.of(context).primaryColor;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(_baybayinTitle, 
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isTablet ? 24 : 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.brown,
        elevation: 2,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: _learnTabTitle),
            Tab(text: _practiceTabTitle),
            Tab(text: _translateTabTitle),
          ],
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
        ),
      ),
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildLearnTab(context),
            _buildPracticeTab(context),
            _buildTranslateTab(context),
          ],
        ),
      ),
    );
  }
  
  // Tab builders with improved UI
  Widget _buildLearnTab(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final padding = isTablet ? 20.0 : 16.0;
    
    return ListView.builder(
      padding: EdgeInsets.all(padding),
      itemCount: _lessons.length,
      itemBuilder: (context, index) {
        final lesson = _lessons[index];
        return Card(
          elevation: 2,
          margin: EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsets.all(isTablet ? 20 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.brown.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        lesson['icon'] as IconData,
                        color: Colors.brown,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        lesson['title'] as String,
                        style: TextStyle(
                          fontSize: isTablet ? 20 : 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown[700],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  lesson['description'] as String,
                  style: TextStyle(
                    fontSize: isTablet ? 16 : 14,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(isTablet ? 18 : 14),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.grey[200]!,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    lesson['content'] as String,
                    style: TextStyle(
                      fontSize: isTablet ? 16 : 14,
                      color: Colors.grey[800],
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPracticeTab(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final padding = isTablet ? 20.0 : 16.0;
    final crossAxisCount = isTablet ? (screenWidth > 900 ? 4 : 3) : 2;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(padding, padding, padding, padding/2),
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.symmetric(vertical: 4),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: isTablet ? 14 : 10,
                horizontal: isTablet ? 16 : 12,
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.brown.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.info_outline,
                      color: Colors.brown,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.language == 'Filipino' 
                          ? 'I-tap ang bawat titik para makita ang detalye'
                          : 'Tap each character to see details',
                      style: TextStyle(
                        fontSize: isTablet ? 16 : 14,
                        color: Colors.brown[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.all(padding),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: isTablet ? 0.9 : 0.8,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: _characterSamples.length,
            itemBuilder: (context, index) {
              final character = _characterSamples[index];
              
              return LayoutBuilder(
                builder: (context, constraints) {
                  return Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: InkWell(
                      onTap: () {
                        _showCharacterDetails(context, character);
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: constraints.maxHeight * 0.12),
                            color: Colors.brown,
                            width: double.infinity,
                            child: Center(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  character['character'] as String,
                                  style: TextStyle(
                                    fontSize: isTablet ? 36 : 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$_latinText: ${character['latin']}',
                                    style: TextStyle(
                                      fontSize: isTablet ? 16 : 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.brown[700],
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Spacer(),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: TextButton(
                                      onPressed: () {
                                        _showCharacterDetails(context, character);
                                      },
                                      style: TextButton.styleFrom(
                                        minimumSize: Size(0, 0),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: isTablet ? 12 : 8, 
                                          vertical: isTablet ? 6 : 4
                                        ),
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Text(
                                        widget.language == 'Filipino' ? 'Tingnan' : 'View',
                                        style: TextStyle(
                                          color: Colors.brown,
                                          fontWeight: FontWeight.bold,
                                          fontSize: isTablet ? 14 : 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              );
            },
          ),
        ),
      ],
    );
  }
  
  void _showCharacterDetails(BuildContext context, Map<String, dynamic> character) {
    final examples = character['examples'] as List<String>;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: screenHeight * 0.7,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 5,
                margin: const EdgeInsets.only(top: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(isTablet ? 24.0 : 20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: isTablet ? 120 : 100,
                      height: isTablet ? 120 : 100,
                      decoration: BoxDecoration(
                        color: Colors.brown,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          character['character'] as String,
                          style: TextStyle(
                            fontSize: isTablet ? 70 : 60,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${character['latin']}',
                      style: TextStyle(
                        fontSize: isTablet ? 32 : 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown[700],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.brown,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                      child: Text(
                        widget.language == 'Filipino' ? 'Mga Halimbawa' : 'Examples',
                        style: TextStyle(
                          fontSize: isTablet ? 18 : 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                        border: Border.all(
                          color: Colors.grey[200]!,
                        ),
                      ),
                      child: Column(
                        children: examples.map((example) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.arrow_right, color: Colors.brown),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  example,
                                  style: TextStyle(
                                    fontSize: isTablet ? 18 : 16,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )).toList(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.brown.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.info_outline,
                                color: Colors.brown,
                                size: isTablet ? 20 : 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                widget.language == 'Filipino' 
                                    ? 'Sa Baybayin, ang mga katinig ay likas na may kasunod na "a"'
                                    : 'In Baybayin, consonants inherently have an "a" sound',
                                style: TextStyle(
                                  fontSize: isTablet ? 14 : 13,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.brown,
                        ),
                        child: Text(
                          widget.language == 'Filipino' ? 'Isara' : 'Close',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
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
    );
  }

  Widget _buildTranslateTab(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final padding = isTablet ? 20.0 : 16.0;
    
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.all(isTablet ? 20 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.brown.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.translate,
                          color: Colors.brown,
                          size: isTablet ? 22 : 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _translateTabTitle,
                        style: TextStyle(
                          fontSize: isTablet ? 20 : 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown[700],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isTablet ? 16 : 12),
                  TextField(
                    decoration: InputDecoration(
                      hintText: _inputHintText,
                      filled: true,
                      fillColor: Colors.grey[50],
                      contentPadding: EdgeInsets.symmetric(
                        vertical: isTablet ? 16 : 14,
                        horizontal: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.grey[300]!,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.grey[300]!,
                        ),
                      ),
                      prefixIcon: const Icon(Icons.text_fields),
                    ),
                    style: TextStyle(fontSize: isTablet ? 16 : 14),
                    onChanged: (value) {
                      _debouncedTranslate(value);
                    },
                  ),
                  SizedBox(height: isTablet ? 16 : 14),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () {
                        _translateText(_inputText);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        foregroundColor: Colors.white,
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 20 : 16,
                          vertical: isTablet ? 12 : 10,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.autorenew, size: isTablet ? 20 : 18),
                          SizedBox(width: isTablet ? 8 : 6),
                          Text(
                            _translateButtonText,
                            style: TextStyle(fontSize: isTablet ? 16 : 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: isTablet ? 20 : 16),
          Expanded(
            child: Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(isTablet ? 20 : 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_translatedText.isEmpty)
                          Icon(
                            Icons.text_snippet_outlined,
                            size: isTablet ? 48 : 40,
                            color: Colors.grey[400],
                          ),
                        SizedBox(height: isTablet ? 16 : 12),
                        Text(
                          _translatedText.isNotEmpty
                              ? _translatedText
                              : _translatedTextWillAppearHere,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: _translatedText.isNotEmpty
                                ? (isTablet ? 28 : 24)
                                : (isTablet ? 18 : 16),
                            color: _translatedText.isNotEmpty
                              ? Colors.brown[700]
                              : Colors.grey[500],
                            fontWeight: _translatedText.isNotEmpty
                                ? FontWeight.bold
                                : FontWeight.normal,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

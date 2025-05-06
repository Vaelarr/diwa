import 'package:flutter/material.dart';
import 'dart:async'; // For debouncing
import '../main.dart'; // Import for ResponsiveUtil
import '../data/filipino_words_data.dart'; // Import the centralized data

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
  final Map<String, String> _baybayinChars = FilipinoWordsData.baybayinCharacters;
  
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
    final characters = FilipinoWordsData.baybayinCharacters;
    
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
    _baybayinTitle = widget.language == 'Filipino' ? 'Baybayin' : 'Baybayin';
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
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(_baybayinTitle, 
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isTablet ? 26 : 22,
          ),
        ),
        backgroundColor: Colors.brown,
        elevation: 4,
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
      backgroundColor: const Color(0xFFF8F4E1),
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
    final padding = isTablet ? 24.0 : 16.0;
    
    return ListView.builder(
      padding: EdgeInsets.all(padding),
      itemCount: _lessons.length,
      itemBuilder: (context, index) {
        final lesson = _lessons[index];
        return Card(
          elevation: 4,
          shadowColor: Colors.brown.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          margin: EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.brown.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
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
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  lesson['description'] as String,
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    lesson['content'] as String,
                    style: TextStyle(
                      fontSize: 16,
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
    final padding = isTablet ? 24.0 : 16.0;
    final crossAxisCount = isTablet ? 3 : 2;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(padding, padding, padding, 12),
          child: Card(
            elevation: 3,
            shadowColor: Colors.brown.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.brown.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
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
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.brown,
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
              childAspectRatio: 0.8,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: _characterSamples.length,
            itemBuilder: (context, index) {
              final character = _characterSamples[index];
              
              return Card(
                elevation: 4,
                shadowColor: Colors.brown.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: InkWell(
                  onTap: () {
                    _showCharacterDetails(context, character);
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.brown.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              character['character'] as String,
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.brown,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.brown.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '$_latinText: ${character['latin']}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.language == 'Filipino' ? 'Mga Halimbawa' : 'Examples',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.brown.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.brown.withOpacity(0.2),
                            ),
                          ),
                          child: Text(
                            widget.language == 'Filipino' ? 'Tingnan' : 'View',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.brown,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
  
  void _showCharacterDetails(BuildContext context, Map<String, dynamic> character) {
    final examples = character['examples'] as List<String>;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
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
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.brown.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        character['character'] as String,
                        style: const TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${character['latin']}',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    widget.language == 'Filipino' ? 'Mga Halimbawa' : 'Examples',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.brown.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.brown.withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      children: examples.map((example) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            const Icon(Icons.arrow_right, color: Colors.brown),
                            const SizedBox(width: 8),
                            Text(
                              example,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                      )).toList(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    widget.language == 'Filipino' 
                        ? 'Paalala: Sa Baybayin, ang mga katinig (consonants) ay likas na may kasunod na "a"'
                        : 'Note: In Baybayin, consonants inherently have an "a" sound',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTranslateTab(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final padding = isTablet ? 24.0 : 16.0;
    
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            elevation: 4,
            shadowColor: Colors.brown.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                          Icons.translate,
                          color: Colors.brown,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _translateTabTitle,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      hintText: _inputHintText,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey.withOpacity(0.3),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey.withOpacity(0.3),
                        ),
                      ),
                      prefixIcon: const Icon(Icons.text_fields),
                    ),
                    onChanged: (value) {
                      _debouncedTranslate(value);
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _translateText(_inputText);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.autorenew),
                        const SizedBox(width: 8),
                        Text(_translateButtonText),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Card(
              elevation: 4,
              shadowColor: Colors.brown.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_translatedText.isEmpty)
                      Icon(
                        Icons.text_snippet_outlined,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        _translatedText.isNotEmpty
                            ? _translatedText
                            : _translatedTextWillAppearHere,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          color: _translatedText.isNotEmpty
                              ? Colors.brown
                              : Colors.grey[500],
                          fontWeight: _translatedText.isNotEmpty
                              ? FontWeight.bold
                              : FontWeight.normal,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

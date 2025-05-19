import 'package:flutter/material.dart';
import '../data/filipino_words_structured.dart';
import '../user_state.dart';
import 'word_details_page.dart';
import 'learn_section.dart';

class HomeSection extends StatefulWidget {
  final String language;

  const HomeSection({
    super.key,
    required this.language,
  });

  @override
  State<HomeSection> createState() => _HomeSectionState();
}

class _HomeSectionState extends State<HomeSection> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late PageController _pageController;
  List<String> _featuredWords = [];
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 0,
      viewportFraction: 0.9, // This gives a nice peek of the next card
    );
    _loadFeaturedWords();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _loadFeaturedWords() {
    try {
      final allWords = FilipinoWordsStructured.words.keys.toList();
      print('Total words available: ${allWords.length}');

      if (allWords.isEmpty) {
        setState(() => _featuredWords = []);
        print('Warning: No words found in the dictionary');
        return;
      }

      final randomizedWords = List<String>.from(allWords);
      randomizedWords.shuffle();

      final completeWords = randomizedWords.where((word) {
        final wordData = FilipinoWordsStructured.words[word];
        return wordData != null &&
               wordData.containsKey('translations') &&
               wordData['translations'] is Map &&
               (wordData['translations'] as Map).containsKey('english') &&
               (wordData['translations'] as Map)['english'] != null;
      }).toList();

      print('Complete words found: ${completeWords.length}');

      setState(() {
        if (completeWords.isNotEmpty) {
          _featuredWords = completeWords.take(3).toList();
          if (_featuredWords.length < 3 && allWords.length >= 3) {
            final remainingWordsNeeded = 3 - _featuredWords.length;
            final additionalWords = randomizedWords
                .where((word) => !_featuredWords.contains(word))
                .take(remainingWordsNeeded)
                .toList();
            _featuredWords.addAll(additionalWords);
          }
        } else {
          _featuredWords = randomizedWords.take(3).toList();
        }
      });

      print('Featured words selected: $_featuredWords');
    } catch (e) {
      print('Error loading featured words: $e');
      setState(() => _featuredWords = []);
    }
  }

  String get _welcomeText => widget.language == 'English'
      ? 'Welcome to'
      : 'Maligayang pagdating sa';

  String get _taglineText => widget.language == 'English'
      ? 'Your guide to learning Filipino'
      : 'Ang iyong gabay sa pag-aaral ng Filipino';

  String get _featuredWordsText => widget.language == 'English'
      ? 'Featured Words'
      : 'Mga Salitang Pantangi';

  String get _exploreText => widget.language == 'English'
      ? 'Explore DIWA'
      : 'Siyasatin ang DIWA';

  String get _learnSectionText => widget.language == 'English'
      ? 'Lessons'
      : 'Mga Aralin';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final padding = isTablet
        ? const EdgeInsets.all(24.0)
        : const EdgeInsets.all(16.0);

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
        toolbarHeight: isTablet ? 90 : 70,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: const Color(0xFFF8F4E1),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeBanner(isTablet),

              const SizedBox(height: 24),

              _buildFeaturedWordsSection(isTablet),

              const SizedBox(height: 24),

              AnimatedBuilder(
                animation: _animController,
                builder: (context, child) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.brown.withOpacity(0.05 + 0.05 * _animController.value),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      _exploreText,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                        letterSpacing: 0.5,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              _buildMainSectionsGrid(isTablet),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildWelcomeBanner(bool isTablet) {
    return Card(
      elevation: 5,
      shadowColor: Colors.brown.withOpacity(0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.brown.shade800,
              Colors.brown.shade700,
              Colors.brown.shade600,
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.brown.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _welcomeText,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: isTablet ? 22 : 18,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0.9, end: 1.0),
                  duration: const Duration(seconds: 1),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Text(
                        'DIWA',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isTablet ? 36 : 30,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    );
                  },
                ),
                if (UserState.instance.isLoggedIn && UserState.instance.userFullName.isNotEmpty) ...[
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      ', ${UserState.instance.userFullName.split(' ')[0]}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isTablet ? 32 : 26,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _taglineText,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: isTablet ? 16 : 14,
                fontWeight: FontWeight.w400,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedWordsSection(bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.brown.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.brown.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star, color: Colors.brown, size: 20),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  _featuredWordsText,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                    letterSpacing: 0.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (_featuredWords.isEmpty) 
          const Center(
            child: Column(
              children: [
                CircularProgressIndicator(color: Colors.brown),
                SizedBox(height: 10),
                Text(
                  'Loading words...',
                  style: TextStyle(color: Colors.brown),
                ),
              ],
            ),
          )
        else
          SizedBox(
            height: 180,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _featuredWords.length,
              physics: const BouncingScrollPhysics(), // Provides better swipe feel
              pageSnapping: true,
              onPageChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              itemBuilder: (context, index) {
                if (index >= _featuredWords.length) return Container();
                final word = _featuredWords[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: _selectedIndex == index ? 1.0 : 0.7,
                    child: _buildFeaturedWordCard(word, isTablet),
                  ),
                );
              },
            ),
          ),
        const SizedBox(height: 16),
        if (_featuredWords.isNotEmpty)
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _featuredWords.length,
                (index) => GestureDetector(
                  onTap: () {
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: _selectedIndex == index ? 24 : 8,
                    decoration: BoxDecoration(
                      color: _selectedIndex == index
                          ? Colors.brown
                          : Colors.brown.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: _selectedIndex == index ? [
                        BoxShadow(
                          color: Colors.brown.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ] : null,
                    ),
                  ),
                ),
              ),
            ),
          ),
        if (_featuredWords.length > 1)
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                widget.language == 'English' 
                    ? 'Swipe to see more' 
                    : 'Mag-swipe para makita ang iba pa',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFeaturedWordCard(String word, bool isTablet) {
    final wordData = FilipinoWordsStructured.words[word];
    if (wordData == null) {
      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Center(
          child: Text(
            'Word data not available',
            style: TextStyle(color: Colors.grey[700]),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }

    final translations = wordData['translations'] as Map<String, dynamic>? ?? {};
    final english = translations['english'] as String? ?? 'Translation not available';

    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WordDetailsPage(
                  word: word,
                  language: widget.language,
                ),
              ),
            );
          },
          child: Card(
            elevation: 4,
            shadowColor: Colors.brown.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.brown.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.brown.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          word.isNotEmpty ? word[0].toUpperCase() : '',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          word,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    english,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        widget.language == 'English' ? 'Learn more' : 'Matuto pa',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.brown[600],
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward,
                        size: 14,
                        color: Colors.brown[600],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMainSectionsGrid(bool isTablet) {
    return Card(
      elevation: 4,
      shadowColor: Colors.green.withOpacity(0.3),
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
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.school,
                    color: Colors.green,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    _learnSectionText,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              widget.language == 'English' 
                  ? 'Start learning Filipino through interactive lessons' 
                  : 'Simulan ang pag-aaral ng Filipino sa pamamagitan ng mga interactive na aralin',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LearnSection(
                        language: widget.language,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.school),
                label: Text(
                  widget.language == 'English' ? 'Go to Lessons' : 'Pumunta sa mga Aralin',
                  overflow: TextOverflow.ellipsis,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.videogame_asset_outlined),
            activeIcon: Icon(Icons.videogame_asset),
            label: 'Games',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.brown,
        unselectedItemColor: Colors.brown.withOpacity(0.6),
        backgroundColor: Colors.white,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushReplacementNamed(context, '/games');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/profile');
          }
        },
      ),
    );
  }
}

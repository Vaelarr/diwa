import 'package:diwa/user_state.dart';
import 'package:flutter/material.dart';
import '../games/game_manager.dart';
import '../main.dart'; // Import for ResponsiveUtil

class GamesSection extends StatefulWidget {
  final String language;
  
  const GamesSection({
    super.key,
    required this.language,
  });

  @override
  State<GamesSection> createState() => _GamesSectionState();
}

class _GamesSectionState extends State<GamesSection> {
  bool _isLoading = true;
  bool _isAuthenticated = false;
  String? _userName;
  String? _userFullName;
  
  @override
  void initState() {
    super.initState();
    _checkAuthentication();
    
    // Listen for auth state changes using UserState
    UserState.instance.authStateChanges.listen((_) {
      if (mounted) {
        _checkAuthentication();
      }
    });
    
    // Also listen to UserState login state changes
    UserState.instance.loginState.listen((isLoggedIn) {
      if (mounted) {
        _checkAuthentication();
      }
    });
  }
  
  Future<void> _checkAuthentication() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _isAuthenticated = UserState.instance.isLoggedIn;
      
      if (_isAuthenticated) {
        _userFullName = await UserState.instance.getCurrentUserName();
        _userName = _userFullName?.split(' ').first; // Get first name only
        
        // If name is still null, try to get it directly from UserState
        if (_userFullName == null || _userFullName!.isEmpty) {
          _userFullName = UserState.instance.userFullName;
          _userName = _userFullName?.split(' ').first;
        }
      }
    } catch (e) {
      debugPrint('Error checking authentication: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  String get _gamesTitle => widget.language == 'Filipino' ? 'MGA LARO' : 'GAMES';
  String get _playText => widget.language == 'Filipino' ? 'MAGLARO' : 'PLAY';  String get _loginRequiredText => widget.language == 'Filipino' 
      ? 'Kailangan mag-login upang makapaglaro' 
      : 'Login Required to Play Games';
  String get _loginDescriptionText => widget.language == 'Filipino'
      ? 'Mangyaring mag-login o gumawa ng isang account upang ma-access ang mga laro.'
      : 'Please log in or create an account to access games.';
  String get _loginButtonText => widget.language == 'Filipino' ? 'Mag-login' : 'Login';
  String _getLocalizedGameName(String englishName) {
    if (widget.language != 'Filipino') return englishName;
    
    switch (englishName) {
      case 'Definition Game': return 'Depinisyon';
      case 'Baybayin Game': return 'Laro ng Baybayin';
      default: return englishName;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final crossAxisCount = isTablet ? 2 : 1;
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
        ),        toolbarHeight: isTablet ? 90 : 70,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: _isLoading 
          ? _buildLoadingView() 
          : _isAuthenticated 
              ? _buildGamesGridView(isTablet, crossAxisCount, padding)
              : _buildLoginView(isTablet),
      backgroundColor: const Color(0xFFF8F4E1),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }
  
  Widget _buildLoadingView() {
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.brown,
      ),
    );
  }
  
  Widget _buildLoginView(bool isTablet) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lock,
            size: 80,
            color: Colors.brown.withOpacity(0.7),
          ),
          const SizedBox(height: 24),
          Text(
            _loginRequiredText,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.brown,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            _loginDescriptionText,
            style: TextStyle(
              fontSize: 16,
              color: Colors.brown[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            icon: const Icon(Icons.login),
            label: Text(
              _loginButtonText,
              style: const TextStyle(fontSize: 16),
            ),
            onPressed: () => _navigateToLogin(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown,
              foregroundColor: Colors.white,
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
    );
  }
  
  Widget _buildGamesGridView(bool isTablet, int crossAxisCount, EdgeInsets padding) {
    return Center(
      child: Column(
        children: [          const SizedBox(height: 16),
          // Enhanced header with shadow and animation
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0.95, end: 1.0),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutQuad,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
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
                    _playText, 
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                      letterSpacing: 1.2,
                    ),
                    textAlign: TextAlign.center
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),          Expanded(
            child: Padding(
              padding: padding,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isTablet ? 800.0 : double.infinity,
                ),
                child: GridView.count(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.3,
                  padding: const EdgeInsets.only(bottom: 24.0),
                  children: [
                    _buildGameCard(context, 'Definition Game', Icons.extension),
                    _buildGameCard(context, 'Baybayin Game', Icons.translate),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Builder(
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),          child: BottomNavigationBar(
            currentIndex: 1,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home_outlined),
                activeIcon: const Icon(Icons.home),
                label: widget.language == 'Filipino' ? 'Tahanan' : 'Home',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.videogame_asset_outlined),
                activeIcon: const Icon(Icons.videogame_asset),
                label: widget.language == 'Filipino' ? 'Laro' : 'Games',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.person_outline),
                activeIcon: const Icon(Icons.person),
                label: widget.language == 'Filipino' ? 'Propayl' : 'Profile',
              ),
            ],
            selectedItemColor: Colors.brown,
            unselectedItemColor: Colors.brown.withOpacity(0.6),
            backgroundColor: Colors.white,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            onTap: (index) {
              if (index == 0) {
                Navigator.pushReplacementNamed(context, '/home');
              } else if (index == 2) {
                Navigator.pushReplacementNamed(context, '/profile');
              }
            },
          ),
        );
      },
    );
  }  // Navigation to login/signup screens
  void _navigateToLogin(BuildContext context) {
    Navigator.pushNamed(context, '/login').then((_) {
      _checkAuthentication();
    });
  }
  
  // Kept for potential future use
  // ignore: unused_element
  Future<void> _logout() async {
    try {
      await UserState.instance.logout();
      
      setState(() {
        _isAuthenticated = false;
        _userName = null;
        _userFullName = null;
      });
    } catch (e) {
      debugPrint('Error during logout: $e');
    }
  }

  // Enhanced game card with hover effect that uses GameManager instead of directly launching games
  Widget _buildGameCard(BuildContext context, String title, IconData icon) {
    final localizedTitle = _getLocalizedGameName(title);
    
    return Card(
      elevation: 4.0,
      shadowColor: Colors.brown.withOpacity(0.3),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: () {
          // Launch the game through GameManager with game type parameter
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GameManager(
                language: widget.language,
                initialGameType: title,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Enhanced icon container with animation
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0.9, end: 1.0),
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutQuad,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.brown.withOpacity(0.1),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.brown.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(icon, size: 40.0, color: Colors.brown),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16.0),
              Text(
                localizedTitle, 
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                )
              ),
              const SizedBox(height: 8.0),
              Text(
                widget.language == 'Filipino' ? 'Pindutin para maglaro' : 'Tap to play',
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.brown.withOpacity(0.7),
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../user_state.dart';
import '../services/score_service.dart';
import '../services/progress_service.dart'; // Add this import
import '../main.dart';
import 'definition_game.dart';
import 'baybayin_game.dart';

class GameManager extends StatefulWidget {
  final String language;
  final String? initialGameType; // Add parameter to open a specific game
  
  const GameManager({
    Key? key,
    required this.language,
    this.initialGameType,
  }) : super(key: key);

  @override
  State<GameManager> createState() => _GameManagerState();
}

class _GameManagerState extends State<GameManager> {
  bool _isLoading = true;
  bool _isLoadingProgress = false; // Add this field
  bool _isAuthenticated = false;
  String? _userName;
  ScoreService scoreService = ScoreService();
  Map<String, dynamic> _gameProgressData = {}; // Add this field

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
    
    // Listen to authentication state changes
    UserState.instance.loginState.listen((_) {
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
      // Check if user is logged in using UserState
      _isAuthenticated = UserState.instance.isLoggedIn;
      
      if (_isAuthenticated) {
        // Get user name for display
        _userName = await UserState.instance.getCurrentUserName();
        
        // If name is still null, try to get directly from UserState
        if (_userName == null || _userName!.isEmpty) {
          _userName = UserState.instance.userFullName;
        }
        
        // Load game progress from Firebase
        await _loadGameProgress();
        
        // If there's an initial game type specified, navigate directly to that game
        if (widget.initialGameType != null && mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _navigateToGame(context, _getGameBuilder(widget.initialGameType!));
          });
        }
      }
    } catch (e) {
      debugPrint('Error checking authentication: $e');
      _isAuthenticated = false;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  // New method to load game progress from Firebase
  Future<void> _loadGameProgress() async {
    if (!UserState.instance.isLoggedIn) return;
    
    setState(() {
      _isLoadingProgress = true;
    });
    
    try {
      final progress = await ProgressService.instance.getAllGameProgress();
      if (mounted) {
        setState(() {
          _gameProgressData = progress;
        });
      }
    } catch (e) {
      debugPrint('Error loading game progress: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingProgress = false;
        });
      }
    }
  }
  
  // Method to get progress for a specific game
  double _getGameProgress(String gameType) {
    if (!UserState.instance.isLoggedIn || _gameProgressData.isEmpty) {
      return 0.0;
    }
    
    if (_gameProgressData.containsKey(gameType)) {
      final gameData = _gameProgressData[gameType];
      if (gameData is Map && gameData.containsKey('progress')) {
        return (gameData['progress'] as num).toDouble();
      }
    }
    
    return 0.0;
  }
  
  // Method to get high score for a specific game
  int _getGameHighScore(String gameType) {
    if (!UserState.instance.isLoggedIn || _gameProgressData.isEmpty) {
      return 0;
    }
    
    if (_gameProgressData.containsKey(gameType)) {
      final gameData = _gameProgressData[gameType];
      if (gameData is Map && gameData.containsKey('highScore')) {
        return gameData['highScore'] as int;
      }
    }
    
    return 0;
  }
  
  // Helper to get the appropriate game builder based on the game type
  Widget Function() _getGameBuilder(String gameType) {
    switch (gameType) {
      case 'Definition Game':
        return () => DefinitionGame(language: widget.language);
      case 'Baybayin Game':
        return () => BaybayinGame(language: widget.language);
      default:
        // Return a default game or throw an exception
        return () => DefinitionGame(language: widget.language); // Use Definition Game as default
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveUtil.isTablet(context);

    // Show loading indicator while checking auth status
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8F4E1),
        body: const Center(
          child: CircularProgressIndicator(color: Colors.brown),
        ),
      );
    }

    // If we have an initial game type, bypass the game selection and go straight to the game
    if (widget.initialGameType != null && _isAuthenticated) {
      return _navigateToGame(context, _getGameBuilder(widget.initialGameType!));
    }

    // Show login screen if not authenticated
    if (!_isAuthenticated) {
      return _buildLoginPrompt();
    }

    // Show game selection screen when authenticated
    return _buildGameSelectionScreen(isTablet);
  }

  // Fix this method to properly navigate to the game and return a Widget
  Widget _navigateToGame(BuildContext context, Widget Function() gameBuilder) {
    return gameBuilder();  // Directly return the game widget instead of using Navigator
  }

  Scaffold _buildLoginPrompt() {
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
              child: const Text(
                'D',
                style: TextStyle(
                  color: Colors.brown,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'DIWA',
              style: TextStyle(
                color: Colors.brown,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFF8F4E1),
      body: Center(
        child: Padding(
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
                widget.language == 'Filipino' 
                    ? 'Kailangan mag-login upang makapaglaro' 
                    : 'Login Required to Play Games',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                widget.language == 'Filipino'
                    ? 'Mangyaring mag-login o gumawa ng isang account upang ma-access ang mga laro.'
                    : 'Please log in or create an account to access games.',
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
                  widget.language == 'Filipino' ? 'Mag-login' : 'Login',
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
              const SizedBox(height: 16),
              TextButton.icon(
                icon: const Icon(Icons.person_add_outlined),
                label: Text(
                  widget.language == 'Filipino' ? 'Gumawa ng Account' : 'Create Account',
                ),
                onPressed: () => _navigateToSignup(context),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.brown,
                ),
              ),
              const SizedBox(height: 32),
              OutlinedButton.icon(
                icon: const Icon(Icons.arrow_back),
                label: Text(
                  widget.language == 'Filipino' ? 'Bumalik' : 'Go Back',
                ),
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.brown,
                  side: const BorderSide(color: Colors.brown),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
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
    );
  }

  Scaffold _buildGameSelectionScreen(bool isTablet) {
    // Define game options with progress data from Firebase
    final gameOptions = [
      {
        'title': widget.language == 'Filipino' ? 'Laro ng Depinisyon' : 'Definition Game',
        'icon': Icons.menu_book,
        'color': Colors.purple,
        'route': () => DefinitionGame(language: widget.language),
        'description': widget.language == 'Filipino'
            ? 'Piliin ang tamang salin batay sa depinisyon.'
            : 'Choose the correct translation based on the definition.',
        'progress': _getGameProgress('Definition Game'),
        'highScore': _getGameHighScore('Definition Game'),
      },
      {
        'title': widget.language == 'Filipino' ? 'Hulaan ang Baybayin' : 'Baybayin Game',
        'icon': Icons.translate,
        'color': Colors.orange,
        'route': () => BaybayinGame(language: widget.language),
        'description': widget.language == 'Filipino'
            ? 'Pag-aralan at subukan ang iyong kaalaman sa baybayin.'
            : 'Learn and test your knowledge of the baybayin writing system.',
        'progress': _getGameProgress('Baybayin Game'),
        'highScore': _getGameHighScore('Baybayin Game'),
      },
      {
        'title': widget.language == 'Filipino' ? 'Mga Aralin' : 'Lessons',
        'icon': Icons.school,
        'color': Colors.green,
        'route': () => Navigator.pushNamed(context, '/lessons', arguments: {'language': widget.language}),
        'description': widget.language == 'Filipino'
            ? 'Pag-aralan ang mga pangunahing konsepto ng wikang Filipino.'
            : 'Learn the fundamental concepts of the Filipino language.',
        'progress': 0.0, // Default progress
        'highScore': 0, // Default high score
      },
    ];

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
          // Profile button showing user is logged in
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: IconButton(
              icon: const Icon(Icons.account_circle, color: Colors.brown),
              onPressed: () => _showUserProfileDialog(context),
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF8F4E1),
      body: SafeArea(
        child: _isLoadingProgress
            ? const Center(child: CircularProgressIndicator(color: Colors.brown))
            : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(isTablet ? 24.0 : 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome section
                      Card(
                        elevation: 2,
                        shadowColor: Colors.brown.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.brown.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.gamepad,
                                  color: Colors.brown,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.language == 'Filipino'
                                          ? 'Kamusta, $_userName!'
                                          : 'Hello, $_userName!',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.brown,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      widget.language == 'Filipino'
                                          ? 'Piliin ang isang laro para magsimula!'
                                          : 'Choose a game to start playing!',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.brown[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Games title header
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0, bottom: 12.0),
                        child: Text(
                          widget.language == 'Filipino' ? 'MGA LARO' : 'GAMES',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      
                      // Game options grid with progress from Firebase
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isTablet ? 2 : 1,
                          childAspectRatio: isTablet ? 1.5 : 1.3,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: gameOptions.length,
                        itemBuilder: (context, index) {
                          final game = gameOptions[index];
                          return _buildGameCard(
                            title: game['title'] as String,
                            icon: game['icon'] as IconData,
                            color: game['color'] as Color,
                            description: game['description'] as String,
                            progress: game['progress'] as double,
                            highScore: game['highScore'] as int,
                            onTap: () => _navigateToGame(context, game['route'] as Widget Function()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildGameCard({
    required String title,
    required IconData icon,
    required Color color,
    required String description,
    required double progress,
    required int highScore,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3,
      shadowColor: color.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.brown.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.brown,
                      size: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.brown[600],
                ),
              ),
              const SizedBox(height: 12),
              
              // High score display
              if (highScore > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.emoji_events, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.language == 'Filipino' ? 'Pinakamataas: ' : 'High Score: '}$highScore',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown[700],
                        ),
                      ),
                    ],
                  ),
                ),
              
              const Spacer(),
              
              // Progress section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.language == 'Filipino' ? 'Pag-unlad' : 'Progress',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.brown[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${(progress * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.brown[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: color.withOpacity(0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    minHeight: 6,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToLogin(BuildContext context) {
    // Navigate to login page
    // After successful login, return to this screen which will re-check authentication
    Navigator.pushNamed(context, '/login').then((_) {
      _checkAuthentication();
    });
  }

  void _navigateToSignup(BuildContext context) {
    // Navigate to sign up page
    // After successful signup, return to this screen which will re-check authentication
    Navigator.pushNamed(context, '/signup').then((_) {
      _checkAuthentication();
    });
  }

  Future<void> _showUserProfileDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            widget.language == 'Filipino' ? 'Profile' : 'Profile',
            style: const TextStyle(
              color: Colors.brown,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundColor: Colors.brown.withOpacity(0.2),
                radius: 40,
                child: const Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.brown,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _userName ?? 'User',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              TextButton.icon(
                icon: const Icon(Icons.logout),
                label: Text(widget.language == 'Filipino' ? 'Mag-logout' : 'Logout'),
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  _logout();
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text(widget.language == 'Filipino' ? 'Isara' : 'Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout() async {
    try {
      await UserState.instance.logout();
      
      // Re-check authentication status after logout
      _checkAuthentication();
    } catch (e) {
      debugPrint('Error during logout: $e');
    }
  }
}

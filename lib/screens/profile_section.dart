import 'package:flutter/material.dart';
import '../user_state.dart';
import '../main.dart'; // Import ResponsiveUtil
import '../data/filipino_words_structured.dart'; // Import the centralized data
import 'word_details_page.dart'; // Import for WordDetailsPage
import 'login.dart'; // Add this import for LoginPage

class ProfileSection extends StatefulWidget {
  final Function(ThemeData) updateTheme;
  final Function(String) updateLanguage;
  final String language;
  final Function(double)? updateFontSize; // Add new callback for font size

  const ProfileSection({
    super.key,
    required this.updateTheme,
    required this.updateLanguage,
    required this.language,
    this.updateFontSize,
  });

  @override
  State<ProfileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {
  String _selectedTheme = 'Default';
  bool _notificationsEnabled = true; // Keeping this variable to avoid breaking existing code
  String _selectedLanguage = 'English';
  String _tempSelectedLanguage = 'English'; // Temporary variable for language selection
  double _fontSize = 16.0;
  
  // Keeping achievement-related state variables but removing unused ones
  int _achievements = 0;
  int _totalPoints = 0;

  // Add language change listener reference
  late VoidCallback _languageChangeListener;

  // Add a field to track language changes and force updates
  bool _forceRebuild = false;
  
  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.language;
    _tempSelectedLanguage = widget.language; // Initialize temp language

    // Initialize font size from UserState
    _loadFontSizePreference();
    
    // Load achievement data from UserState - with delay to ensure it loads after auth state is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAchievementData();
    });

    // Set up listener for language changes from UserState
    _languageChangeListener = () {
      final userLanguage = UserState.instance.preferredLanguage;
      if (mounted && userLanguage != _selectedLanguage) {
        setState(() {
          _selectedLanguage = userLanguage;
        });
        widget.updateLanguage(userLanguage);
      }
    };

    // Register the listener with UserState
    UserState.instance.addLanguageChangeListener(_languageChangeListener);

    // Initialize language from UserState on load
    _syncLanguageWithUserState();
  }
  
  // Load achievement data from UserState
  Future<void> _loadAchievementData() async {
    if (!UserState.instance.isLoggedIn) return;
    
    try {
      // Use the new consolidated method to refresh all metrics at once
      final metrics = await UserState.instance.refreshAllProgressMetrics();
      
      if (mounted) {
        setState(() {
          _achievements = metrics['achievements']!;
          _totalPoints = metrics['totalPoints']!;
        });
        
        // Debug print to verify data
        debugPrint('Achievement Data Loaded: Achievements=$_achievements, Points=$_totalPoints');
      }
    } catch (e) {
      debugPrint('Error loading achievement data: $e');
      // Show error message if in debug mode
      assert(() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Debug: Error loading achievements: $e')),
        );
        return true;
      }());
    }
  }
  
  @override
  void dispose() {
    // Clean up by removing the listener when widget is disposed
    UserState.instance.removeLanguageChangeListener(_languageChangeListener);
    super.dispose();
  }  // Override didUpdateWidget to handle language changes from parent
  @override
  void didUpdateWidget(ProfileSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.language != widget.language) {
      setState(() {
        _selectedLanguage = widget.language;
        _tempSelectedLanguage = widget.language;
      });
    }
    
    // When widget updates, refresh the achievement data if user is logged in
    if (UserState.instance.isLoggedIn) {
      _loadAchievementData();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Refresh achievement data whenever we navigate back to this screen
    if (UserState.instance.isLoggedIn) {
      _loadAchievementData();
    }
  }

  // Sync language with UserState
  Future<void> _syncLanguageWithUserState() async {
    final userLanguage = UserState.instance.preferredLanguage;
    if (userLanguage != widget.language) {
      setState(() {
        _selectedLanguage = userLanguage;
      });
      widget.updateLanguage(userLanguage);
    }
  }

  // Load font size preference
  Future<void> _loadFontSizePreference() async {
    try {
      final savedFontSize = await UserState.instance.getFontSizePreference();
      if (savedFontSize != null && mounted) {
        setState(() {
          _fontSize = savedFontSize;
        });
      }
    } catch (e) {
      debugPrint('Error loading font size preference: $e');
    }
  }

  // Add method to save font size preference
  Future<void> _saveFontSizePreference(double size) async {
    try {
      await UserState.instance.setFontSizePreference(size);
    } catch (e) {
      debugPrint('Error saving font size preference: $e');
    }
  }

  // Localized text with getters for performance
  String get _profileTitle =>
      widget.language == 'Filipino' ? 'Profile Ko' : 'My Profile';
  String get _notLoggedInText =>
      widget.language == 'Filipino' ? 'Hindi Naka-login' : 'Not Logged In';
  String get _pleaseLoginText => widget.language == 'Filipino'
      ? 'Mangyaring mag-login para ma-access ang iyong profile'
      : 'Please login to access your profile';
  String get _loginButtonText =>
      widget.language == 'Filipino' ? 'Mag-login' : 'Login';
  String get _createAccountText =>
      widget.language == 'Filipino' ? 'Gumawa ng account' : 'Create an account';
  String get _appPreferencesText =>
      widget.language == 'Filipino' ? 'Mga Setting ng App' : 'App Preferences';
  String get _themeText =>
      widget.language == 'Filipino' ? 'Tema ng App' : 'App Theme';
  String get _languageText =>
      widget.language == 'Filipino' ? 'Wika' : 'Language';
  String get _fontSizeText =>
      widget.language == 'Filipino' ? 'Laki ng Font' : 'Font Size';
  String get _logoutText =>
      widget.language == 'Filipino' ? 'Mag-logout' : 'Logout';
  String get _confirmLogoutTitle =>
      widget.language == 'Filipino' ? 'Kumpirmahin ang Pag-logout' : 'Confirm Logout';
  String get _confirmLogoutMessage => widget.language == 'Filipino'
      ? 'Sigurado ka bang gusto mong mag-logout?'
      : 'Are you sure you want to logout?';
  String get _cancelText =>
      widget.language == 'Filipino' ? 'Kanselahin' : 'Cancel';  String get _profileSettingsText =>
      widget.language == 'Filipino' ? 'PROFILE' : 'PROFILE';@override  Widget build(BuildContext context) {
    // Reset force rebuild flag
    _forceRebuild = false;

    final isTablet = ResponsiveUtil.isTablet(context);
    final padding = ResponsiveUtil.getResponsivePadding(context: context);
    
    // Don't reload achievement data on every build - this can cause infinite loops
    // Only load on specific lifecycle events (initState, didChangeDependencies)

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
        automaticallyImplyLeading: false,
        toolbarHeight: isTablet ? 90 : 70,
      ),
      backgroundColor: const Color(0xFFF8F4E1),
      body: Column(
        children: [
          // Profile header text with improved styling
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
              _profileSettingsText,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
                letterSpacing: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Main content
          Expanded(
            child: UserState.instance.isLoggedIn
                ? _buildLoggedInView(isTablet, padding)
                : _buildNotLoggedInView(),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
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
        currentIndex: 2,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home),
            label: widget.language == 'Filipino' ? 'Tahanan' : 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.videogame_asset_outlined),
            activeIcon: const Icon(Icons.videogame_asset),
            label: widget.language == 'Filipino' ? 'Laro' : 'Games',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: const Icon(Icons.person),
            label: widget.language == 'Filipino' ? 'Profile' : 'Profile',
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
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/games');
          }
        },
      ),
    );
  }

  Widget _buildNotLoggedInView() {
    final isTablet = ResponsiveUtil.isTablet(context);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Card(
          elevation: 4,
          shadowColor: Colors.brown.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isTablet ? 500.0 : double.infinity,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Enhanced profile icon with animation
                  TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0.8, end: 1.0),
                    duration: const Duration(seconds: 1),
                    curve: Curves.elasticOut,
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Container(
                          width: 120,
                          height: 120, 
                          decoration: BoxDecoration(
                            color: Colors.brown.withOpacity(0.8),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.brown.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.account_circle,
                            size: 70,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Text(
                    _notLoggedInText,
                    style: TextStyle(
                      fontSize: isTablet ? 26 : 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _pleaseLoginText,
                    style: TextStyle(
                      fontSize: isTablet ? 16 : 14,
                      color: Colors.brown[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  
                  // Improved login button
                  ElevatedButton.icon(
                    icon: const Icon(Icons.login),
                    label: Text(
                      _loginButtonText,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),                    onPressed: () async {
                      // Navigate to login page
                      await Navigator.pushNamed(context, '/login');
                      
                      // Refresh achievement data when returned from login screen
                      if (UserState.instance.isLoggedIn) {
                        _loadAchievementData();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton.icon(
                    icon: const Icon(Icons.person_add_outlined),
                    label: Text(
                      _createAccountText,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),                    onPressed: () async {
                      // Navigate to create account page
                      await Navigator.pushNamed(context, '/create_account');
                      
                      // Refresh achievement data when returned from create account screen
                      if (UserState.instance.isLoggedIn) {
                        _loadAchievementData();
                      }
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.brown,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Future<void> _handleLogout() async {
    final shouldLogout = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(_confirmLogoutTitle),
            content: Text(_confirmLogoutMessage),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(_cancelText),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.brown,
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  foregroundColor: Colors.white,
                ),
                child: Text(_logoutText),
              ),
            ],
          ),
        ) ??
        false;

    if (shouldLogout) {
      // Show loading indicator for logout
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(color: Colors.brown),
        ),
      );
      
      // Reset achievement data in UI before actual logout
      if (mounted) {
        setState(() {
          _achievements = 0;
          _totalPoints = 0;
        });
      }
      
      // Perform logout
      await UserState.instance.logout();

      // Wait briefly to simulate processing
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Update app language to English (default after logout)
      setState(() {
        _selectedLanguage = 'English';
      });
      widget.updateLanguage('English');

      if (!mounted) return;
      Navigator.pop(context); // Dismiss loading indicator
      
      // Navigate to login page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(language: '',),
        ),
      );
    }
  }
  Widget _buildLoggedInView(bool isTablet, EdgeInsets padding) {

    return ListView(
      padding: padding,
      children: [
        Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isTablet ? 800.0 : double.infinity,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // User profile card with enhanced styling
                Card(
                  elevation: 4,
                  shadowColor: Colors.brown.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        // Profile picture with subtle animation
                        TweenAnimationBuilder(
                          tween: Tween<double>(begin: 0.9, end: 1.0),
                          duration: const Duration(seconds: 1),
                          curve: Curves.elasticOut,
                          builder: (context, value, child) {
                            return Transform.scale(
                              scale: value,
                              child: Container(
                                width: 110,
                                height: 110,
                                decoration: BoxDecoration(
                                  color: Colors.brown.withOpacity(0.8),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.brown.withOpacity(0.3),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Icon(Icons.person,
                                    size: 60, color: Colors.white),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        Text(
                          UserState.instance.userFullName.isNotEmpty
                              ? UserState.instance.userFullName
                              : 'User Name',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                            UserState.instance.userEmail.isEmpty
                                ? 'user@example.com'
                                : UserState.instance.userEmail,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.brown[600],
                            )),
                        const SizedBox(height: 20),
                        OutlinedButton.icon(
                          icon: const Icon(Icons.edit),
                          label: Text(widget.language == 'Filipino'
                              ? 'I-edit ang Profile'
                              : 'Edit Profile'),
                          onPressed: () {
                            _showEditProfileDialog();
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.brown,
                            side: const BorderSide(color: Colors.brown),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),                const SizedBox(height: 24),
                
                // Add saved words section
                _buildSavedWordsSection(isTablet),

                const SizedBox(height: 24),

                // Enhanced app preferences section header
                Container(
                  margin: const EdgeInsets.only(left: 4, bottom: 12),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.brown.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.brown.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.settings_outlined,
                          color: Colors.brown,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _appPreferencesText,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),

                // Enhanced preferences card
                Card(
                  elevation: 4,
                  shadowColor: Colors.brown.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Colors.white,
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(_themeText,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(_selectedTheme),
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.brown.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.color_lens_outlined,
                              color: Colors.brown),
                        ),
                        trailing: Icon(Icons.chevron_right,
                            color: Colors.brown.withOpacity(0.7)),
                        onTap: () => _showThemeDialog(),
                      ),
                      Divider(
                          height: 1,
                          indent: 70,
                          endIndent: 20,
                          color: Colors.brown.withOpacity(0.1)),
                      ListTile(
                        title: Text(_languageText,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(_selectedLanguage),
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.language_outlined,
                              color: Colors.blue),
                        ),
                        trailing: Icon(Icons.chevron_right,
                            color: Colors.brown.withOpacity(0.7)),
                        onTap: () => _showLanguageDialog(),
                      ),
                      Divider(
                          height: 1,
                          indent: 70,
                          endIndent: 20,
                          color: Colors.brown.withOpacity(0.1)),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.purple.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(Icons.text_fields_outlined,
                                      color: Colors.purple),
                                ),
                                const SizedBox(width: 16),
                                Text(_fontSizeText,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                const Spacer(),
                                // Add a preview text that shows current size
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.purple.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${_fontSize.toStringAsFixed(1)}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.purple,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                const Text('A', style: TextStyle(fontSize: 12)),
                                Expanded(
                                  child: SliderTheme(
                                    data: SliderThemeData(
                                      activeTrackColor: Colors.purple,
                                      inactiveTrackColor:
                                          Colors.purple.withOpacity(0.2),
                                      thumbColor: Colors.purple,
                                      overlayColor:
                                          Colors.purple.withOpacity(0.2),
                                      thumbShape:
                                          const RoundSliderThumbShape(
                                              enabledThumbRadius: 10),
                                      overlayShape:
                                          const RoundSliderOverlayShape(
                                              overlayRadius: 20),
                                    ),
                                    child: Slider(
                                      value: _fontSize,
                                      min: 12.0,
                                      max: 24.0,
                                      divisions: 12, // More precise control
                                      label: _fontSize.toStringAsFixed(1),
                                      onChanged: (value) {
                                        setState(() {
                                          _fontSize = value;
                                        });
                                      },
                                      onChangeEnd: (value) {
                                        // Apply font size change when user stops sliding
                                        _saveFontSizePreference(value);

                                        // Update app-wide font size if callback exists
                                        if (widget.updateFontSize != null) {
                                          widget.updateFontSize!(value);
                                        }

                                        // Show visual feedback
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              widget.language == 'Filipino'
                                                  ? 'Laki ng font na-update sa ${value.toStringAsFixed(1)}'
                                                  : 'Font size updated to ${value.toStringAsFixed(1)}',
                                            ),
                                            backgroundColor: Colors.purple,
                                            duration:
                                                const Duration(seconds: 1),
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                const Text('A', style: TextStyle(fontSize: 24)),
                              ],
                            ),
                            // Preview text section with current font size
                            Container(
                              margin: const EdgeInsets.only(top: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.purple.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: Colors.purple.withOpacity(0.2)),
                              ),
                              child: Text(
                                widget.language == 'Filipino'
                                    ? 'Halimbawa ng sukat ng text'
                                    : 'Example text size',
                                style: TextStyle(fontSize: _fontSize),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Improved logout button
                ElevatedButton.icon(
                  icon: const Icon(Icons.logout),
                  label: Text(
                    _logoutText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: _handleLogout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 2,
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Enhanced stat card with subtle animations

  void _showThemeDialog() {
    final isTablet = ResponsiveUtil.isTablet(context);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            widget.language == 'Filipino' ? 'Pumili ng Tema' : 'Select Theme',
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.brown),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isTablet ? 400 : 300,
              maxHeight: 200, // Reduced height since we have fewer options
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildThemeOption('Default', Colors.brown),
                  _buildThemeOption('Dark', Colors.grey[800]!),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: Colors.brown,
              ),
              child: Text(widget.language == 'Filipino' ? 'Kanselahin' : 'Cancel'),
            ),
          ],
        );
      },
    );
  }
  
  void _showLanguageDialog() {
    final isTablet = ResponsiveUtil.isTablet(context);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter dialogSetState) {
            return AlertDialog(
              title: Text(
                widget.language == 'Filipino' ? 'Pumili ng Wika' : 'Select Language',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.brown),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              content: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isTablet ? 400 : 300,
                  maxHeight: 200,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildLanguageOption('English', dialogSetState),
                      _buildLanguageOption('Filipino', dialogSetState),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.brown,
                  ),
                  child: Text(widget.language == 'Filipino' ? 'Kanselahin' : 'Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => _confirmLanguageChange(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(widget.language == 'Filipino' ? 'Kumpirmahin' : 'Confirm'),
                ),
              ],
            );
          }
        );
      },
    );
  }

  Widget _buildThemeOption(String name, Color color) {
    return Card(
      elevation: 0,
      color: _selectedTheme == name ? color.withOpacity(0.1) : null,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: _selectedTheme == name ? color : Colors.transparent,
          width: 2,
        ),
      ),
      child: ListTile(
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        title: Text(
          name,
          style: TextStyle(
            fontWeight: _selectedTheme == name ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        trailing: _selectedTheme == name ? Icon(Icons.check_circle, color: color) : null,
        onTap: () {
          setState(() {
            _selectedTheme = name;
          });

          ThemeData newTheme;
          switch (name) {
            case 'Dark':
              newTheme = ThemeData.dark().copyWith(
                primaryColor: Colors.grey[800],
                textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'Montserrat'),
              );
              break;
            default: // Default theme
              newTheme = ThemeData(
                primarySwatch: Colors.brown,
                scaffoldBackgroundColor: const Color(0xFFF8F4E1),
                textTheme: ThemeData().textTheme.apply(fontFamily: 'Montserrat'),
              );
          }

          widget.updateTheme(newTheme);
          Navigator.pop(context);
        },
      )
    );
  }

  Future<void> _confirmLanguageChange(BuildContext context) async {
    if (_tempSelectedLanguage != _selectedLanguage) {
      // Close dialog first
      Navigator.pop(context);
      
      // Save preference immediately (don't wait for completion)
      UserState.instance.setLanguagePreference(_tempSelectedLanguage);
      
      // Update local state and app language for instant UI change
      setState(() {
        _selectedLanguage = _tempSelectedLanguage;
      });
      
      // Update app-level language
      widget.updateLanguage(_selectedLanguage);
      
      // Force a rebuild of the entire widget for full language refresh
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          // This creates a new instance of the current page
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) => ProfileSection(
                updateTheme: widget.updateTheme,
                updateLanguage: widget.updateLanguage,
                language: _selectedLanguage,
                updateFontSize: widget.updateFontSize,
              ),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
          
          // Show success message after navigation
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_selectedLanguage == 'Filipino'
                  ? 'Matagumpay na binago ang wika sa Filipino'
                  : 'Language successfully changed to English'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      });
    } else {
      Navigator.pop(context);
    }
  }

  Widget _buildLanguageOption(String language, Function dialogSetState) {
    return Card(
      elevation: 0,
      color: _tempSelectedLanguage == language ? Colors.brown.withOpacity(0.1) : null,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: _tempSelectedLanguage == language ? Colors.brown : Colors.transparent,
          width: 2,
        ),
      ),
      child: ListTile(
        leading: Container(
          width: 36,
          height: 36,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.brown.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: language == 'English'
              ? const Text('EN', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown))
              : const Text('FI', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown)),
        ),
        title: Text(language),
        trailing: _tempSelectedLanguage == language ? const Icon(Icons.check_circle, color: Colors.brown) : null,
        onTap: () {
          // Update temporary selection in dialog
          dialogSetState(() {
            _tempSelectedLanguage = language;
          });
        },
      ),
    );
  }

  // String for saved words section
  String get _savedWordsText =>
      widget.language == 'Filipino' ? 'Mga Na-save na Salita' : 'Saved Words';
        String get _noSavedWordsText =>
      widget.language == 'Filipino' ? 'Wala ka pang na-save na salita' : 'You haven\'t saved any words yet';

  // New method to fetch and display saved words
  Widget _buildSavedWordsSection(bool isTablet) {
    return FutureBuilder<List<String>>(
      future: UserState.instance.getSavedWords(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(color: Colors.brown),
            ),
          );
        }
        
        final savedWords = snapshot.data ?? [];
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header
            Container(
              margin: const EdgeInsets.only(left: 4, bottom: 12, top: 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.brown.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.brown.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.bookmark,
                      color: Colors.brown,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _savedWordsText,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            
            // Display saved words or message if none
            Card(
              elevation: 4,
              shadowColor: Colors.brown.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: savedWords.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.bookmark_border,
                                size: 48,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _noSavedWordsText,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                    : GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isTablet ? 3 : 2,
                          childAspectRatio: 2.5,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: savedWords.length,
                        itemBuilder: (context, index) {
                          final word = savedWords[index];
                          final wordData = FilipinoWordsStructured.words[word];
                          
                          return Card(
                            elevation: 2,
                            color: Colors.brown.withOpacity(0.05),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: Colors.brown.withOpacity(0.1),
                              ),
                            ),
                            child: InkWell(                              onTap: () {
                                if (FilipinoWordsStructured.words.containsKey(word)) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WordDetailsPage(
                                        word: word,
                                        language: widget.language,
                                      ),
                                    ),
                                  );
                                }
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      word,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.brown,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    if (wordData != null)
                                      Text(
                                        wordData['translations']?['english'] ?? '',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                          fontStyle: FontStyle.italic,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Add this method to the _ProfileSectionState class
  void _showEditProfileDialog() {
    final TextEditingController nameController = TextEditingController(text: UserState.instance.userFullName);
    final isTablet = ResponsiveUtil.isTablet(context);
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            widget.language == 'Filipino' ? 'I-edit ang Profile' : 'Edit Profile',
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.brown),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: SizedBox(
            width: isTablet ? 400 : 300,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.brown.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: widget.language == 'Filipino' ? 'Pangalan' : 'Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Email field (disabled, just for display)
                  TextField(
                    enabled: false,
                    controller: TextEditingController(text: UserState.instance.userEmail),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.email_outlined),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: Colors.brown,
              ),
              child: Text(widget.language == 'Filipino' ? 'Kanselahin' : 'Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final newName = nameController.text.trim();
                if (newName.isNotEmpty) {
                  // Show loading indicator
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => const Center(
                      child: CircularProgressIndicator(color: Colors.brown),
                    ),
                  );
                  
                  // Update user name in UserState using the new method
                  final success = await UserState.instance.updateUserProfile(name: newName);
                  
                  // Dismiss loading indicator
                  if (mounted) {
                    Navigator.pop(context);
                    
                    // Trigger UI refresh
                    setState(() {});
                    
                    // Show success or error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(success 
                          ? (widget.language == 'Filipino'
                              ? 'Na-update ang profile!'
                              : 'Profile updated successfully!')
                          : (widget.language == 'Filipino'
                              ? 'Hindi ma-update ang profile. Pakisubukang muli.'
                              : 'Failed to update profile. Please try again.')),
                        backgroundColor: success ? Colors.green : Colors.red,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                } else {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(widget.language == 'Filipino'
                          ? 'Ang pangalan ay hindi maaaring walang laman.'
                          : 'Name cannot be empty.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                foregroundColor: Colors.white,
              ),
              child: Text(widget.language == 'Filipino' ? 'I-save' : 'Save'),
            ),
          ],
        );
      },
    );
  }
}

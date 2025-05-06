import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'screens/learn_section.dart';
import 'screens/login.dart';
import 'screens/games_section.dart';
import 'screens/profile_section.dart';
import 'screens/create_account.dart';
import 'screens/new_home_section.dart';
import 'user_state.dart';
import 'widgets/language_selection_dialog.dart';
import 'widgets/screen_size_error.dart';
import 'utils/diagnostics.dart';
import 'splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'services/connectivity_service.dart';

final Map<double, double> _fontSizeFactorCache = {
  320: 0.8,  // Small mobile
  360: 0.9,  // Normal mobile
  400: 1.0,  // Default
  600: 1.1,  // Small tablet
  768: 1.2,  // Tablet
  1024: 1.3, // Large tablet
};

bool isTablet(double width) => width >= 600;

class ResponsiveUtil {

  static double getScaledFontSize({
    BuildContext? context, 
    double? width,
    required double fontSize
  }) {
    // Calculate appropriate width value
    final double effectiveWidth = width ?? 
      (context != null ? MediaQuery.of(context).size.width : 400);
    
    double factor = 1.0;
    // Find the closest width in the cache
    for (var entry in _fontSizeFactorCache.entries) {
      if (effectiveWidth <= entry.key) {
        factor = entry.value;
        break;
      }
    }
    
    return factor * fontSize;
  }
  
  static EdgeInsets getResponsivePadding({
    BuildContext? context, 
    double? width
  }) {
    // Calculate appropriate width value
    final double effectiveWidth = width ?? 
      (context != null ? MediaQuery.of(context).size.width : 400);
      
    return effectiveWidth > 600 
        ? const EdgeInsets.all(24.0) 
        : const EdgeInsets.all(12.0);
  }
  
  static int getGridCount({
    BuildContext? context, 
    double? width
  }) {
    // Calculate appropriate width value
    final double effectiveWidth = width ?? 
      (context != null ? MediaQuery.of(context).size.width : 400);
      
    if (effectiveWidth > 900) return 3; // Large tablet
    if (effectiveWidth > 600) return 2; // Small tablet
    return 1; // Phone
  }
  
  // For backward compatibility
  static int getGridCrossAxisCount(BuildContext context) {
    return getGridCount(context: context);
  }
  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width > 600;
  }
}

// Minimum screen dimensions (in logical pixels)
const double MIN_SCREEN_WIDTH = 320.0;
const double MIN_SCREEN_HEIGHT = 480.0;

// Initialize Firebase with better error handling and multi-platform support
Future<bool> _initializeFirebase() async {
  try {
    DiagnosticsService.log('Firebase', 'Initializing Firebase');
    
    // Check for internet connectivity first
    final hasConnection = await ConnectivityService.hasInternetConnection();
    if (!hasConnection) {
      DiagnosticsService.logError('Firebase', 'No internet connection detected');
      return false;
    }
    
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    // Initialize Crashlytics (except on web where it's not supported)
    if (!kIsWeb) {
      FlutterError.onError = (errorDetails) {
        FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      };
      
      // Pass all uncaught asynchronous errors to Crashlytics
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
    }
    
    DiagnosticsService.log('Firebase', 'Firebase initialized successfully');
    return true;
  } catch (e, stackTrace) {
    DiagnosticsService.logError('Firebase', 'Failed to initialize Firebase: $e', stackTrace);
    return false;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  DiagnosticsService.log('App', 'Starting application');
  DiagnosticsService.log('Platform', 'Running on ${kIsWeb ? 'Web' : 'Mobile'}');

  bool firebaseInitialized = false;
  
  try {
    firebaseInitialized = await _initializeFirebase();
    if (!firebaseInitialized) {
      DiagnosticsService.log('Firebase', 'Firebase initialization failed or skipped');
    }
  } catch (e) {
    DiagnosticsService.logError('App', 'Error initializing app: $e');
  }
  
  // Run the app with error handling
  runApp(DiwaApp(firebaseInitialized: firebaseInitialized));
}

class DiwaApp extends StatefulWidget {
  final bool firebaseInitialized;
  
  const DiwaApp({
    super.key,
    this.firebaseInitialized = false,
  });

  @override
  State<DiwaApp> createState() => _DiwaAppState();
}

class _DiwaAppState extends State<DiwaApp> {
  late ThemeData _currentTheme;
  String _currentLanguage = 'English';
  bool _isInitialized = false;
  double _textScaleFactor = 1.0;
  
  @override
  void initState() {
    super.initState();
    _currentTheme = _getDefaultTheme();
    _currentLanguage = UserState.instance.preferredLanguage;
    
    // Initialize text scale factor from preferences
    _loadFontSizePreference();
    
    // Add listener to update language when UserState changes
    UserState.instance.addLanguageChangeListener(_updateLanguageFromUserState);
    
    // Don't try to show dialog here - it will be handled after build
  }
  
  // Load font size preference
  Future<void> _loadFontSizePreference() async {
    try {
      final savedFontSize = await UserState.instance.getFontSizePreference();
      if (savedFontSize != null && mounted) {
        setState(() {
          // Convert font size (12-24) to scale factor (0.8-1.6)
          _textScaleFactor = savedFontSize / 16.0;
        });
      }
    } catch (e) {
      debugPrint('Error loading font size preference: $e');
    }
  }
  
  void _completeInitialization() {
    if (!mounted) return;
    
    setState(() {
      _isInitialized = true;
    });
    
    // Don't show language dialog here - move to the post-frame callback
  }
  
  // Move the language dialog check to a post-frame callback
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Only run this once when initialized
    if (_isInitialized && UserState.instance.isFirstLaunch) {
      // Use a post-frame callback to ensure MaterialApp is fully initialized
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && UserState.instance.isFirstLaunch) {
          _showLanguageDialog();
        }
      });
    }
  }
  
  void _updateLanguageFromUserState() {
    setState(() {
      _currentLanguage = UserState.instance.preferredLanguage;
    });
  }
  
  @override
  void dispose() {
    UserState.instance.removeLanguageChangeListener(_updateLanguageFromUserState);
    super.dispose();
  }
  
  // Use a more robust theme structure with Light/Dark support
  ThemeData _getDefaultTheme() {
    return ThemeData(
      scaffoldBackgroundColor: const Color(0xFFF8F4E1),
      fontFamily: 'Montserrat',
      primarySwatch: Colors.brown,
      primaryColor: Colors.brown,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.brown,
        brightness: Brightness.light,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: Colors.brown,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: Colors.brown,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(color: Colors.brown),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.brown,
          foregroundColor: Colors.white,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.brown,
          side: const BorderSide(color: Colors.brown),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: Colors.brown,
        unselectedItemColor: Colors.brown,
      ),
    );
  }

  void updateTheme(ThemeData newTheme) {
    setState(() {
      _currentTheme = newTheme;
    });
    // Store theme preference if needed
    // UserState.setThemePreference will be implemented in the future
  }
  
  void updateLanguage(String language) {
    if (_currentLanguage == language) return;
    
    setState(() {
      _currentLanguage = language;
    });
    
    // Update the UserState language preference
    UserState.instance.setLanguagePreference(language);
  }
  
  void updateFontSize(double fontSize) {
    setState(() {
      // Convert font size (12-24) to scale factor (0.8-1.6)
      _textScaleFactor = fontSize / 16.0;
    });
  }
  
  void _showLanguageDialog() {
    if (!mounted) return;
    
    // Using BuildContext from the current widget tree that has MaterialLocalizations
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return LanguageSelectionDialog(
          onLanguageSelected: (selectedLanguage) {
            updateLanguage(selectedLanguage);
            // Mark first launch as completed
            UserState.instance.completeFirstLaunch();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diwa',
      debugShowCheckedModeBanner: false,
      theme: _currentTheme,
      // Add a builder to check screen size before displaying content
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        final width = mediaQuery.size.width;
        final height = mediaQuery.size.height;
        
        // Check if screen is too small
        if (width < MIN_SCREEN_WIDTH || height < MIN_SCREEN_HEIGHT) {
          return ScreenSizeError(
            minWidth: MIN_SCREEN_WIDTH,
            minHeight: MIN_SCREEN_HEIGHT,
            currentWidth: width,
            currentHeight: height,
            language: _currentLanguage,
          );
        }
        
        // Use MediaQuery to add padding for system UI and apply text scale factor
        return MediaQuery(
          data: mediaQuery.copyWith(
            textScaleFactor: _textScaleFactor,
          ),
          child: child!,
        );
      },
      home: !_isInitialized 
          ? SplashScreen(
              language: _currentLanguage,
              onInitializationComplete: _completeInitialization,
            )
          : HomeSection(language: _currentLanguage),
      // Use RouteFactory for more efficient routing
      onGenerateRoute: (settings) {
        // Skip splash screen in route generation to prevent navigation issues
        if (!_isInitialized && settings.name != '/') {
          return null;
        }
        
        Widget page;
        switch (settings.name) {
          case '/':
          case '/home':
            page = HomeSection(language: _currentLanguage);
            break;
          case '/learn':
            page = LearnSection(language: _currentLanguage);
            break;
          case '/games':
            page = GamesSection(language: _currentLanguage);
            break;
          case '/profile':
            page = ProfileSection(
              updateTheme: updateTheme,
              updateLanguage: updateLanguage,
              language: _currentLanguage,
              updateFontSize: updateFontSize,
            );
            break;
          case '/login':
            page = LoginPage(language: _currentLanguage);
            break;
          case '/create_account':
            page = CreateAccountScreen(language: _currentLanguage);
            break;
          default:
            page = HomeSection(language: _currentLanguage);
        }
        return MaterialPageRoute(builder: (context) => page);
      },
      initialRoute: _isInitialized ? '/home' : '/',
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'services/auth_service.dart';

class UserState {
  // Singleton instance
  static final UserState instance = UserState._internal();
  
  // Private constructor
  UserState._internal();
  
  // Private fields to store user state
  static bool _isLoggedIn = false;
  static String _uid = '';
  static String _userEmail = '';
  static String _userFullName = '';
  static String _languagePreference = 'English';
  static final AuthService _authService = AuthService();
  static bool _isFirstLaunch = true;
    // Achievement-related fields with default values of 0
  static int _achievements = 0;
  static int _totalPoints = 0;
  
  // Achievement flags to track which achievements have been unlocked
  static final Map<String, bool> _achievementFlags = {
    'points_100': false,
    'points_500': false,
    'saved_words_10': false,
  };
  
  // Add points tracking
  int _userPoints = 0;
  
  // Stream controllers for state changes
  static final StreamController<bool> _loginStateController = StreamController<bool>.broadcast();
  static final StreamController<String> _languageChangeController = StreamController<String>.broadcast();
  final _pointsStreamController = StreamController<int>.broadcast();
  
  // List of language change callbacks
  final List<VoidCallback> _languageChangeListeners = [];
  
  // Getters for user information
  bool get isLoggedIn => _isLoggedIn;
  String get uid => _uid;
  String get userEmail => _userEmail;
  String get userFullName => _userFullName;
  String get preferredLanguage => _languagePreference;
  bool get isFirstLaunch => _isFirstLaunch;
  
  // Getters for achievement data
  int get achievements => _achievements;
  int get totalPoints => _totalPoints;
  
  // Get current user points
  int get userPoints => _userPoints;
  
  // Stream to listen for login state changes
  Stream<bool> get loginState => _loginStateController.stream;
  
  // Stream to listen for auth state changes directly from Firebase
  Stream<User?> get authStateChanges => _authService.authStateChanges;
  
  // Stream to listen for points changes
  Stream<int> get pointsStream => _pointsStreamController.stream;
  
  // Initialize user state
  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      _uid = prefs.getString('uid') ?? '';
      _userEmail = prefs.getString('userEmail') ?? '';
      _userFullName = prefs.getString('userFullName') ?? '';
      _languagePreference = prefs.getString('languagePreference') ?? 'English';
      _isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
        // Initialize achievement data with user-specific keys
      final achievementsKey = getUserSpecificKey('achievements');
      final totalPointsKey = getUserSpecificKey('totalPoints');
      
      _achievements = prefs.getInt(achievementsKey) ?? 0;
      _totalPoints = prefs.getInt(totalPointsKey) ?? 0;
      
      // Load achievement flags
      if (_uid.isNotEmpty) {
        _achievementFlags['points_100'] = prefs.getBool('achievement_points_100_$_uid') ?? false;
        _achievementFlags['points_500'] = prefs.getBool('achievement_points_500_$_uid') ?? false;
        _achievementFlags['saved_words_10'] = prefs.getBool('achievement_saved_words_10_$_uid') ?? false;
      }
      
      // Verify with Firebase if user is really logged in
      final currentUser = _authService.currentUser;
      if (currentUser == null && _isLoggedIn) {
        // Firebase says user is logged out but our prefs say logged in
        // This could happen if token expired or user was logged out on another device
        await logout();
      } else if (currentUser != null && !_isLoggedIn) {
        // Firebase says user is logged in but our prefs say logged out
        // Update our prefs to match Firebase
        await setLoggedIn(true);
        await setUid(currentUser.uid);
        await setUserEmail(currentUser.email ?? '');
        await setUserFullName(currentUser.displayName ?? '');
      }
      
      // Initialize points
      await getUserPoints();
    } catch (e) {
      debugPrint('Error initializing UserState: $e');
      // Reset to default state on error
      _isLoggedIn = false;
      _uid = '';
      _userEmail = '';
      _userFullName = '';
    }
  }
  
  // Set login status
  Future<void> setLoggedIn(bool value) async {
    if (_isLoggedIn == value) return;
    
    _isLoggedIn = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', value);
    _loginStateController.add(value);
  }
  
  // Set user ID
  Future<void> setUid(String value) async {
    if (_uid == value) return;
    
    _uid = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', value);
  }
  
  // Set user email
  Future<void> setUserEmail(String value) async {
    _userEmail = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userEmail', value);
  }
  
  // Set user full name
  Future<void> setUserFullName(String value) async {
    _userFullName = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userFullName', value);
  }
  
  // Set language preference (instance method)
  Future<void> setLanguagePreference(String language) async {
    if (_languagePreference == language) return;
    
    _languagePreference = language;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languagePreference', language);
    _languageChangeController.add(language);
    
    // Notify all listeners
    for (final listener in _languageChangeListeners) {
      listener();
    }
  }
  
  // Add a language change listener
  void addLanguageChangeListener(VoidCallback callback) {
    _languageChangeListeners.add(callback);
  }
  
  // Remove a language change listener
  void removeLanguageChangeListener(VoidCallback callback) {
    _languageChangeListeners.remove(callback);
  }
  
  // Mark first launch as completed
  Future<void> completeFirstLaunch() async {
    if (!_isFirstLaunch) return;
    
    _isFirstLaunch = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstLaunch', false);
  }
  
  // Log out user
  Future<void> logout() async {
    try {
      await _authService.signOut();
      await setLoggedIn(false);
      await setUid('');
      await setUserEmail('');
      await setUserFullName('');
      
      // Reset achievements on logout
      await resetAchievements();
    } catch (e) {
      debugPrint('Error during logout: $e');
    }
  }
  
  // Reset all achievements to 0
  Future<void> resetAchievements() async {
    final prefs = await SharedPreferences.getInstance();
    _achievements = 0;
    _totalPoints = 0;
    
    final achievementsKey = getUserSpecificKey('achievements');
    final totalPointsKey = getUserSpecificKey('totalPoints');
    
    await prefs.setInt(achievementsKey, 0);
    await prefs.setInt(totalPointsKey, 0);
  }
  
  // Get current user name from Firebase (if available)
  Future<String?> getCurrentUserName() async {
    try {
      if (!_isLoggedIn || _uid.isEmpty) return null;
      
      final currentUser = _authService.currentUser;
      if (currentUser != null && currentUser.displayName != null && currentUser.displayName!.isNotEmpty) {
        return currentUser.displayName;
      }
      
      return _userFullName.isNotEmpty ? _userFullName : null;
    } catch (e) {
      debugPrint('Error getting current user name: $e');
      return null;
    }
  }
  
  // Get current user email from Firebase (refreshed)
  Future<String> getCurrentUserEmail() async {
    try {
      return await _authService.getCurrentUserEmail();
    } catch (e) {
      debugPrint('Error getting current user email: $e');
      return _userEmail;
    }
  }
  
  // Check if user exists (for signup validation)
  Future<bool> checkIfUserExists(String email) async {
    try {
      return await _authService.checkIfUserExists(email);
    } catch (e) {
      debugPrint('Error checking if user exists: $e');
      return false;
    }
  }
  
  // User registration
  Future<bool> register(String name, String email, String password) async {
    try {
      final user = await _authService.registerWithEmailAndPassword(
        email,
        password,
        userFullName,
      );
      
      if (user != null) {
        await setLoggedIn(true);
        await setUid(user.uid);
        await setUserEmail(user.email ?? '');
        await setUserFullName(name);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error during registration: $e');
      return false;
    }
  }
  
  // User login
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final user = await _authService.signInWithEmailAndPassword(
        email,
        password,
      );
      
      if (user != null) {
        await setLoggedIn(true);
        await setUid(user.uid);
        await setUserEmail(user.email ?? '');
        
        // Get display name if available
        final displayName = user.displayName;
        if (displayName != null && displayName.isNotEmpty) {
          await setUserFullName(displayName);
        } else {
          // Try to fetch user profile to get the display name if it's not immediately available
          try {
            await user.reload();
            final refreshedUser = _authService.currentUser;
            if (refreshedUser?.displayName != null && refreshedUser!.displayName!.isNotEmpty) {
              await setUserFullName(refreshedUser.displayName!);
            }
          } catch (e) {
            debugPrint('Error refreshing user data: $e');
          }
        }
        
        return {'success': true, 'message': 'Login successful'};
      }
      return {'success': false, 'message': 'Login failed. Please try again.'};
    } catch (e) {
      debugPrint('Error during login: $e');
      String errorMessage = 'An unexpected error occurred';
      
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'No user found with this email';
            break;
          case 'wrong-password':
            errorMessage = 'Wrong password provided';
            break;
          case 'invalid-email':
            errorMessage = 'The email address is not valid';
            break;
          case 'user-disabled':
            errorMessage = 'This user account has been disabled';
            break;
          case 'too-many-requests':
            errorMessage = 'Too many login attempts. Please try again later';
            break;
          case 'network-request-failed':
            errorMessage = 'Network error. Please check your connection';
            break;
        }
      }
      
      return {'success': false, 'message': errorMessage, 'error': e.toString()};
    }
  }
  
  // Get userId for storage purposes
  String get userId => _uid;
  
  // Helper method to generate user-specific storage keys
  String getUserSpecificKey(String baseKey) {
    if (_isLoggedIn && _uid.isNotEmpty) {
      return '${baseKey}_${_uid}';
    }
    return '${baseKey}_guest';
  }
  
  // Add achievement
  Future<void> unlockAchievement() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _achievements++;
      final userSpecificKey = getUserSpecificKey('achievements');
      await prefs.setInt(userSpecificKey, _achievements);
      
      // Add points for unlocking an achievement
      await addPoints(15);
    } catch (e) {
      debugPrint('Error adding achievement: $e');
    }
  }
  
  // Get achievements count
  Future<int> getAchievementsCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userSpecificKey = getUserSpecificKey('achievements');
      return prefs.getInt(userSpecificKey) ?? 0;
    } catch (e) {
      debugPrint('Error getting achievements count: $e');
      return 0;
    }
  }
  
  // Add points to total
  Future<void> addPoints(int points) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _totalPoints += points;
      final userSpecificKey = getUserSpecificKey('totalPoints');
      await prefs.setInt(userSpecificKey, _totalPoints);
      
      // Update user points in Firestore
      await setUserPoints(_totalPoints);
    } catch (e) {
      debugPrint('Error adding points: $e');
    }
  }
  
  // Set user points
  Future<void> setUserPoints(int points) async {
    if (!isLoggedIn) return;
    
    try {      final user = _authService.currentUser;
      if (user != null) {
        // Import and use FirebaseFirestore directly instead of through authService
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'points': points,
        });
        
        _userPoints = points;
        _pointsStreamController.add(_userPoints);
      }
    } catch (e) {
      debugPrint('Error setting user points: $e');
      rethrow;
    }
  }
    // Get current user points
  Future<int> getUserPoints() async {
    if (!isLoggedIn) return 0;
    
    try {
      final user = _authService.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        _userPoints = doc.data()?['points'] as int? ?? 0;
        _pointsStreamController.add(_userPoints);
        return _userPoints;
      }
    } catch (e) {
      debugPrint('Error getting user points: $e');
    }
    
    return 0;
  }
  
  // Get total points
  Future<int> getTotalPoints() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userSpecificKey = getUserSpecificKey('totalPoints');
      return prefs.getInt(userSpecificKey) ?? 0;
    } catch (e) {
      debugPrint('Error getting total points: $e');
      return 0;
    }
  }
  
  // Save a word to user's saved words
  Future<void> saveWord(String word) async {
    if (_uid.isEmpty) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> savedWords = prefs.getStringList('saved_words_$_uid') ?? [];
      if (!savedWords.contains(word)) {
        savedWords.add(word);
        await prefs.setStringList('saved_words_$_uid', savedWords);
      }
    } catch (e) {
      debugPrint('Error saving word: $e');
    }
  }
  
  // Remove a saved word
  Future<void> removeSavedWord(String word) async {
    if (_uid.isEmpty) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> savedWords = prefs.getStringList('saved_words_$_uid') ?? [];
      if (savedWords.contains(word)) {
        savedWords.remove(word);
        await prefs.setStringList('saved_words_$_uid', savedWords);
      }
    } catch (e) {
      debugPrint('Error removing saved word: $e');
    }
  }
  
  // Check if a word is saved
  Future<bool> isWordSaved(String word) async {
    if (_uid.isEmpty) return false;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> savedWords = prefs.getStringList('saved_words_$_uid') ?? [];
      return savedWords.contains(word);
    } catch (e) {
      debugPrint('Error checking if word is saved: $e');
      return false;
    }
  }
  
  // Get all saved words
  Future<List<String>> getSavedWords() async {
    if (_uid.isEmpty) return [];
    
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList('saved_words_$_uid') ?? [];
    } catch (e) {
      debugPrint('Error getting saved words: $e');
      return [];
    }
  }
  
  // Get saved words count
  Future<int> getSavedWordsCount() async {
    try {
      final words = await getSavedWords();
      return words.length;
    } catch (e) {
      debugPrint('Error getting saved words count: $e');
      return 0;
    }
  }
  
  // Set font size preference
  Future<void> setFontSizePreference(double fontSize) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSizePreference', fontSize);
  }
  
  // Get font size preference
  Future<double?> getFontSizePreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('fontSizePreference');
  }
  
  // Refresh all progress metrics at once - useful for profile page
  Future<Map<String, int>> refreshAllProgressMetrics() async {
    if (!_isLoggedIn) {
      return {
        'achievements': 0,
        'totalPoints': 0
      };
    }
    
    try {
      _achievements = await getAchievementsCount();
      _totalPoints = await getTotalPoints();
      
      return {
        'achievements': _achievements,
        'totalPoints': _totalPoints
      };
    } catch (e) {
      debugPrint('Error refreshing progress metrics: $e');
      return {
        'achievements': _achievements,
        'totalPoints': _totalPoints
      };
    }
  }
  
  // Update learning progress - a helper method to trigger after completing activities
  Future<void> updateLearningProgress({int pointsEarned = 0}) async {
    if (!_isLoggedIn) return;
    
    try {
      // Add points if provided
      if (pointsEarned > 0) {
        await addPoints(pointsEarned);
      }
      
      // Check for achievements based on current stats
      await checkForNewAchievements();
    } catch (e) {
      debugPrint('Error updating learning progress: $e');
    }
  }
  
  // Check for new achievements based on current stats
  Future<void> checkForNewAchievements() async {
    if (!_isLoggedIn) return;
    
    try {
      // Refresh counts
      _achievements = await getAchievementsCount();
      _totalPoints = await getTotalPoints();
        // Achievement for points earned milestones
      if (_totalPoints >= 100 && _achievementFlags['points_100'] == false) {
        await unlockAchievement();
        _achievementFlags['points_100'] = true;
        // Store achievement flag
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('achievement_points_100_$_uid', true);
      }
      
      if (_totalPoints >= 500 && _achievementFlags['points_500'] == false) {
        await unlockAchievement();
        _achievementFlags['points_500'] = true;
        // Store achievement flag
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('achievement_points_500_$_uid', true);      }
      
      // Achievement for saved words milestones
      int savedWordsCount = await getSavedWordsCount();
      if (savedWordsCount >= 10 && _achievementFlags['saved_words_10'] == false) {
        await unlockAchievement();
        _achievementFlags['saved_words_10'] = true;
        // Store achievement flag
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('achievement_saved_words_10_$_uid', true);
      }
      
      // Points-based achievements
      if (_totalPoints >= 100 && _achievements < 1) {
        await unlockAchievement();
      } else if (_totalPoints >= 500 && _achievements < 2) {
        await unlockAchievement();
      } else if (_totalPoints >= 1000 && _achievements < 3) {
        await unlockAchievement();
      }
    } catch (e) {
      debugPrint('Error checking for achievements: $e');
    }
  }  // Clean up resources when app is closed
  static void dispose() {
    _loginStateController.close();
    _languageChangeController.close();
    // The instance's _pointsStreamController needs to be closed by the instance
    instance._pointsStreamController.close();
  }

  // Update user profile
  Future<bool> updateUserProfile({String? name}) async {
    try {
      if (!isLoggedIn) return false;
      
      final user = _authService.currentUser;
      if (user == null) return false;
      
      // Update display name if provided
      if (name != null && name.isNotEmpty) {
        // Update in Firebase Auth
        await user.updateDisplayName(name);
        
        // Update in Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'displayName': name,
        });
        
        // Update local state
        await setUserFullName(name);
      }
      
      return true;
    } catch (e) {
      debugPrint('Error updating user profile: $e');
      return false;
    }
  }
}

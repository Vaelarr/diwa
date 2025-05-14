import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
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
  
  // New achievement-related fields with default values of 0
  static int _completedLessons = 0;
  static int _achievements = 0;
  static int _totalPoints = 0;
  static int _wordsLearned = 0;
  
  // Stream controllers for state changes
  static final StreamController<bool> _loginStateController = StreamController<bool>.broadcast();
  static final StreamController<String> _languageChangeController = StreamController<String>.broadcast();
  
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
  int get completedLessons => _completedLessons;
  int get achievements => _achievements;
  int get totalPoints => _totalPoints;
  int get wordsLearned => _wordsLearned;
  
  // Stream to listen for login state changes
  Stream<bool> get loginState => _loginStateController.stream;
  
  // Stream to listen for auth state changes directly from Firebase
  Stream<User?> get authStateChanges => _authService.authStateChanges;
  
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
      
      // Initialize achievement data
      _completedLessons = prefs.getInt('completedLessons') ?? 0;
      _achievements = prefs.getInt('achievements') ?? 0;
      _totalPoints = prefs.getInt('totalPoints') ?? 0;
      _wordsLearned = prefs.getInt('wordsLearned') ?? 0;
      
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
    _completedLessons = 0;
    _achievements = 0;
    _totalPoints = 0;
    _wordsLearned = 0;
    
    await prefs.setInt('completedLessons', 0);
    await prefs.setInt('achievements', 0);
    await prefs.setInt('totalPoints', 0);
    await prefs.setInt('wordsLearned', 0);
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
  
  // Check if user has completed a specific lesson
  Future<bool> hasCompletedLesson(String lessonId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('lesson_$lessonId') ?? false;
    } catch (e) {
      debugPrint('Error checking lesson completion: $e');
      return false;
    }
  }
  
  // Mark a lesson as completed
  Future<void> markLessonCompleted(String lessonId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('lesson_$lessonId', true);
      
      // Update completed lessons count
      _completedLessons++;
      await prefs.setInt('completedLessons', _completedLessons);
      
      // Add points for completing a lesson
      await addPoints(10);
    } catch (e) {
      debugPrint('Error marking lesson as completed: $e');
    }
  }
  
  // Get completedLessons count
  Future<int> getCompletedLessonsCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt('completedLessons') ?? 0;
    } catch (e) {
      debugPrint('Error getting completed lessons count: $e');
      return 0;
    }
  }
  
  // Add achievement
  Future<void> unlockAchievement() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _achievements++;
      await prefs.setInt('achievements', _achievements);
      
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
      return prefs.getInt('achievements') ?? 0;
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
      await prefs.setInt('totalPoints', _totalPoints);
    } catch (e) {
      debugPrint('Error adding points: $e');
    }
  }
  
  // Get total points
  Future<int> getTotalPoints() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt('totalPoints') ?? 0;
    } catch (e) {
      debugPrint('Error getting total points: $e');
      return 0;
    }
  }
  
  // Get words learned count
  Future<int> getWordsLearnedCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt('wordsLearned') ?? 0;
    } catch (e) {
      debugPrint('Error getting words learned count: $e');
      return 0;
    }
  }
  
  // Get list of completed lessons
  Future<List<String>> getCompletedLessons() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final allKeys = prefs.getKeys();
      return allKeys
          .where((key) => key.startsWith('lesson_'))
          .where((key) => prefs.getBool(key) == true)
          .map((key) => key.replaceFirst('lesson_', ''))
          .toList();
    } catch (e) {
      debugPrint('Error getting completed lessons: $e');
      return [];
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
        
        // Update words learned count
        _wordsLearned++;
        await prefs.setInt('wordsLearned', _wordsLearned);
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
  
  // Clean up resources when app is closed
  static void dispose() {
    _loginStateController.close();
    _languageChangeController.close();
  }
}

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
  Future<void> setLanguagePreference(String value) async {
    if (_languagePreference == value) return;
    
    _languagePreference = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languagePreference', value);
    
    // Notify listeners about language change
    _languageChangeController.add(value);
    
    // Call all registered callbacks
    for (var listener in _languageChangeListeners) {
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
    } catch (e) {
      debugPrint('Error during Firebase signOut: $e');
    }
    
    // Clear user data regardless of Firebase signout success
    await setLoggedIn(false);
    await setUid('');
    await setUserEmail('');
    await setUserFullName('');
    
    // Keep language preference when logging out
  }
  
  // Get current user name from Firebase (refreshed)
  Future<String> getCurrentUserName() async {
    try {
      return await _authService.getCurrentUserName();
    } catch (e) {
      debugPrint('Error getting current user name: $e');
      return _userFullName.isEmpty ? 'User' : _userFullName;
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
    } catch (e) {
      debugPrint('Error marking lesson as completed: $e');
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
  
  // Register new user with email and password
  Future<bool> register(String fullName, String email, String password) async {
    try {
      final user = await _authService.registerWithEmailAndPassword(
        email,
        password,
        fullName,
      );
      
      if (user != null) {
        await setLoggedIn(true);
        await setUid(user.uid);
        await setUserEmail(user.email ?? '');
        await setUserFullName(user.displayName ?? fullName);
        await setLanguagePreference('English'); // Default language preference
        
        debugPrint('User registered successfully: ${user.uid}');
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error during registration: $e');
      return false;
    }
  }
  
  // Check if a user with the given email already exists
  Future<bool> checkIfUserExists(String email) async {
    try {
      final methods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      return methods.isNotEmpty;
    } catch (e) {
      debugPrint('Error checking if user exists: $e');
      return false; // Assume user doesn't exist if we can't check
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

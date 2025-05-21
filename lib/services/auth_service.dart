import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/diagnostics.dart'; // Import for logging

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  
  // Get current user
  User? get currentUser => _auth.currentUser;
  
  // Get current user ID
  String get uid => _auth.currentUser?.uid ?? '';
  
  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  
  // Set persistence to LOCAL to ensure user stays logged in
  Future<void> setPersistence() async {
    try {
      // For web, use session persistence
      if (kIsWeb) {
        await _auth.setPersistence(Persistence.SESSION);
      }
      // For mobile, persistence is local by default
      // We're ensuring automatic re-login by storing credentials securely
      
    } catch (e) {
      debugPrint('Error setting persistence: $e');
    }
  }
  
  // Store user credentials securely for automatic re-login
  Future<void> storeUserCredentials(String email, String password) async {
    try {
      await _secureStorage.write(key: 'email', value: email);
      await _secureStorage.write(key: 'password', value: password);
      
      // Store login timestamp
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('last_login_timestamp', DateTime.now().toIso8601String());
    } catch (e) {
      debugPrint('Error storing credentials: $e');
    }
  }
  
  // Get stored credentials for automatic re-login
  Future<Map<String, String?>> getStoredCredentials() async {
    try {
      final email = await _secureStorage.read(key: 'email');
      final password = await _secureStorage.read(key: 'password');
      
      return {
        'email': email,
        'password': password,
      };
    } catch (e) {
      debugPrint('Error getting stored credentials: $e');
      return {
        'email': null,
        'password': null,
      };
    }
  }
  
  // Clear stored credentials on logout
  Future<void> clearStoredCredentials() async {
    try {
      await _secureStorage.delete(key: 'email');
      await _secureStorage.delete(key: 'password');
    } catch (e) {
      debugPrint('Error clearing stored credentials: $e');
    }
  }
  
  // Attempt automatic login with stored credentials
  Future<User?> attemptAutoLogin() async {
    try {
      final credentials = await getStoredCredentials();
      final email = credentials['email'];
      final password = credentials['password'];
      
      if (email != null && password != null) {
        final userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        
        return userCredential.user;
      }
    } catch (e) {
      debugPrint('Auto-login failed: $e');
      await clearStoredCredentials(); // Clear on failure
    }
    return null;
  }
  
  // Sign up with email and password
  Future<User?> registerWithEmailAndPassword(
    String email, 
    String password,
    String displayName,
  ) async {
    try {
      // Set persistence first
      await setPersistence();
      
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final user = userCredential.user;
      
      if (user != null) {
        // Update display name
        await user.updateDisplayName(displayName);
        
        // Create user document in Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'email': email,
          'displayName': displayName,
          'createdAt': FieldValue.serverTimestamp(),
          'points': 0,
        });
        
        // Store credentials for auto-login
        await storeUserCredentials(email, password);
      }
      
      return user;
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase Auth Exception: ${e.code} - ${e.message}');
      
      // Log the error
      DiagnosticsService.logError('Registration Error', e, StackTrace.current);
      
      // Provide specific error messages for user-friendly feedback
      String message = 'Registration failed';
      
      switch (e.code) {
        case 'email-already-in-use':
          message = 'An account already exists with this email';
          break;
        case 'invalid-email':
          message = 'The email address is invalid';
          break;
        case 'weak-password':
          message = 'The password is too weak';
          break;
        case 'operation-not-allowed':
          message = 'Account creation is not enabled';
          break;
        case 'network-request-failed':
          message = 'Network error. Please check your connection.';
          break;
      }
      
      throw Exception(message);
    } catch (e) {
      debugPrint('Unexpected error during registration: $e');
      DiagnosticsService.logError('Registration Error (Unknown)', e, StackTrace.current);
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }
  
  // Sign in with email and password
  Future<User?> signInWithEmailAndPassword(
    String email, 
    String password,
  ) async {
    try {
      debugPrint('Attempting to sign in user: $email');
      
      // Set persistence first
      await setPersistence();
      
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Store credentials for auto-login
      await storeUserCredentials(email, password);
      
      debugPrint('Sign in successful for: ${userCredential.user?.email}');
      
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase Auth Exception: ${e.code} - ${e.message}');
      
      // Log the error
      DiagnosticsService.logError('Sign In Error', e, StackTrace.current);
      
      // Rethrow with more specific message
      String message = 'Authentication failed';
      
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found with this email';
          break;
        case 'wrong-password':
          message = 'Incorrect password';
          break;
        case 'invalid-email':
          message = 'The email address is invalid';
          break;
        case 'user-disabled':
          message = 'This account has been disabled';
          break;
        case 'too-many-requests':
          message = 'Too many sign-in attempts. Please try again later.';
          break;
        case 'operation-not-allowed':
          message = 'Email/password sign-in is not enabled';
          break;
        case 'network-request-failed':
          message = 'Network error. Please check your connection.';
          break;
      }
      
      throw Exception(message);
    } catch (e) {
      debugPrint('Unexpected error during sign in: $e');
      DiagnosticsService.logError('Sign In Error (Unknown)', e, StackTrace.current);
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }
  
  // Sign out
  Future<void> signOut() async {
    try {
      debugPrint('Signing out user');
      await clearStoredCredentials();
      await _auth.signOut();
    } catch (e) {
      debugPrint('Error signing out: $e');
      DiagnosticsService.logError('Sign Out Error', e, StackTrace.current);
      throw Exception('Failed to sign out. Please try again.');
    }
  }

  // Check if a user with the given email already exists
  Future<bool> checkIfUserExists(String email) async {
    try {
      // Get sign-in methods for the email
      final methods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      // If there are sign-in methods available, the user exists
      return methods.isNotEmpty;
    } catch (e) {
      debugPrint('Error checking if user exists: $e');
      return false;
    }
  }

  // Get current user email
  Future<String> getCurrentUserEmail() async {
    final user = _auth.currentUser;
    if (user != null && user.email != null) {
      return user.email!;
    }
    return '';
  }
  
  // Password reset
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      debugPrint('Password reset error: ${e.code} - ${e.message}');
      
      String message = 'Failed to send password reset email';
      
      switch (e.code) {
        case 'invalid-email':
          message = 'The email address is invalid';
          break;
        case 'user-not-found':
          message = 'No user found with this email';
          break;
      }
      
      throw Exception(message);
    } catch (e) {
      debugPrint('Unexpected error during password reset: $e');
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }
}

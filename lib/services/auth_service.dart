import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../utils/diagnostics.dart'; // Import for logging

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Get current user
  User? get currentUser => _auth.currentUser;
  
  // Get current user ID
  String get uid => _auth.currentUser?.uid ?? '';
  
  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  
  // Sign in with email and password
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      debugPrint('Attempting to sign in user: $email');
      
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
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
  
  // Register with email and password
  Future<User?> registerWithEmailAndPassword(
    String email, 
    String password,
    String fullName
  ) async {
    try {
      debugPrint('Attempting to create user: $email');
      
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      debugPrint('User created successfully: ${userCredential.user?.email}');
      
      // Update display name
      await userCredential.user?.updateDisplayName(fullName);
      
      // Reload user to get the updated profile
      await userCredential.user?.reload();
      
      return _auth.currentUser;
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase Auth Exception: ${e.code} - ${e.message}');
      
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
  
  // Sign out
  Future<void> signOut() async {
    try {
      debugPrint('Signing out user');
      await _auth.signOut();
    } catch (e) {
      debugPrint('Error signing out: $e');
      DiagnosticsService.logError('Sign Out Error', e, StackTrace.current);
      throw Exception('Failed to sign out. Please try again.');
    }
  }

  // Get current user name
  Future<String> getCurrentUserName() async {
    try {
      User? user = _auth.currentUser;
      
      if (user != null) {
        if (user.displayName != null && user.displayName!.isNotEmpty) {
          return user.displayName!;
        }
        
        // If no display name, use email
        if (user.email != null && user.email!.isNotEmpty) {
          return user.email!.split('@')[0]; // Use part before @ as name
        }
      }
      
      return 'User';
    } catch (e) {
      debugPrint('Error getting user name: $e');
      return 'User';
    }
  }

  // Get current user email
  Future<String> getCurrentUserEmail() async {
    try {
      User? user = _auth.currentUser;
      return user?.email ?? '';
    } catch (e) {
      debugPrint('Error getting user email: $e');
      return '';
    }
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

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../user_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ScoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Key for SharedPreferences storage
  static const String _scoresKey = 'userScores';
  
  // For persistent user progress
  static const String _progressKey = 'gameProgress';
  
  // Save a score for a specific game
  Future<bool> saveScore({
    required String userId,
    required String game,
    required int score,
  }) async {
    try {
      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      
      // Get existing scores
      final Map<String, dynamic> allScores = await _getAllScores();
      
      // Initialize user scores if they don't exist
      if (!allScores.containsKey(userId)) {
        allScores[userId] = {};
      }
      
      // Initialize game scores if they don't exist
      if (!allScores[userId].containsKey(game)) {
        allScores[userId][game] = [];
      }
      
      // Add new score with timestamp
      final timestamp = DateTime.now().toIso8601String();
      allScores[userId][game].add({
        'score': score,
        'timestamp': timestamp,
      });
      
      // Save updated scores back to SharedPreferences
      await prefs.setString(_scoresKey, jsonEncode(allScores));
      
      // Update game progress in SharedPreferences
      await _saveGameProgress(game, score);
      
      // Award points based on score
      await UserState.instance.addPoints(score ~/ 10);
      
      return true;
    } catch (e) {
      print('Error saving score: $e');
      return false;
    }
  }
  
  // Save game progress to SharedPreferences
  Future<bool> _saveGameProgress(String gameType, int score) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = UserState.instance.uid;
      
      if (userId.isEmpty) {
        return false;
      }
      
      // Load existing progress data
      final String progressJson = prefs.getString(_progressKey) ?? '{}';
      final Map<String, dynamic> allProgress = json.decode(progressJson);
      
      // Initialize user progress if it doesn't exist
      if (!allProgress.containsKey(userId)) {
        allProgress[userId] = {};
      }
      
      // Initialize game progress if it doesn't exist
      if (!allProgress[userId].containsKey(gameType)) {
        allProgress[userId][gameType] = {};
      }
      
      // Get the current high score
      int currentHighScore = allProgress[userId][gameType]['highScore'] ?? 0;
      
      // Only update if new score is higher
      int highScore = score > currentHighScore ? score : currentHighScore;
      
      // Calculate completion percentage based on score (customize as needed)
      double completion = score / 100.0;
      if (completion > 1.0) completion = 1.0;
      
      // Update game progress
      allProgress[userId][gameType] = {
        'highScore': highScore,
        'lastPlayed': DateTime.now().toIso8601String(),
        'progress': completion,
      };
      
      // Save updated progress back to SharedPreferences
      await prefs.setString(_progressKey, jsonEncode(allProgress));
      
      // Check for achievements based on high score
      if (highScore >= 50) {
        await UserState.instance.checkForNewAchievements();
      }
      
      return true;
    } catch (e) {
      print('Error saving game progress: $e');
      return false;
    }
  }
  
  // Get all scores for a specific user and game
  Future<List<Map<String, dynamic>>> getUserGameScores({
    required String userId,
    required String game,
  }) async {
    try {
      // Get scores from SharedPreferences
      final Map<String, dynamic> allScores = await _getAllScores();
      
      if (allScores.containsKey(userId) && allScores[userId].containsKey(game)) {
        return List<Map<String, dynamic>>.from(allScores[userId][game]);
      }
      
      return [];
    } catch (e) {
      print('Error getting user game scores: $e');
      return [];
    }
  }
  
  // Get the highest score for a specific user and game
  Future<int> getUserHighScore({
    required String userId,
    required String game,
  }) async {
    try {
      // Get high score from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final String progressJson = prefs.getString(_progressKey) ?? '{}';
      final Map<String, dynamic> allProgress = json.decode(progressJson);
      
      if (allProgress.containsKey(userId) && 
          allProgress[userId].containsKey(game) &&
          allProgress[userId][game].containsKey('highScore')) {
        return allProgress[userId][game]['highScore'] as int;
      }
      
      // Fall back to calculating from scores
      final scores = await getUserGameScores(userId: userId, game: game);
      
      if (scores.isEmpty) {
        return 0;
      }
      
      // Find the highest score
      int highestScore = 0;
      for (var score in scores) {
        if (score['score'] > highestScore) {
          highestScore = score['score'];
        }
      }
      
      return highestScore;
    } catch (e) {
      print('Error getting user high score: $e');
      return 0;
    }
  }
  
  // Get all scores for all users
  Future<Map<String, dynamic>> _getAllScores() async {
    final prefs = await SharedPreferences.getInstance();
    final String scoresJson = prefs.getString(_scoresKey) ?? '{}';
    
    try {
      return jsonDecode(scoresJson);
    } catch (e) {
      print('Error decoding scores: $e');
      return {};
    }
  }
  
  // Get leaderboard for a specific game
  Future<List<Map<String, dynamic>>> getLeaderboard(String game) async {
    try {
      final List<Map<String, dynamic>> leaderboard = [];
      
      // Get from SharedPreferences
      final Map<String, dynamic> allScores = await _getAllScores();
      
      // Collect high scores for each user
      allScores.forEach((userId, gameScores) {
        if (gameScores.containsKey(game)) {
          int highestScore = 0;
          String latestTimestamp = '';
          
          for (var scoreData in gameScores[game]) {
            if (scoreData['score'] > highestScore) {
              highestScore = scoreData['score'];
              latestTimestamp = scoreData['timestamp'];
            }
          }
          
          leaderboard.add({
            'userId': userId,
            'score': highestScore,
            'timestamp': latestTimestamp,
          });
        }
      });
      
      // Sort by score (descending)
      leaderboard.sort((a, b) => b['score'].compareTo(a['score']));
      
      return leaderboard;
    } catch (e) {
      print('Error getting leaderboard: $e');
      return [];
    }
  }
  
  // Get game progress from SharedPreferences
  Future<Map<String, dynamic>> getGameProgress(String gameType) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = UserState.instance.uid;
      
      if (userId.isEmpty) {
        return {};
      }
      
      final String progressJson = prefs.getString(_progressKey) ?? '{}';
      final Map<String, dynamic> allProgress = json.decode(progressJson);
      
      if (allProgress.containsKey(userId) && allProgress[userId].containsKey(gameType)) {
        return Map<String, dynamic>.from(allProgress[userId][gameType]);
      }
      
      return {};
    } catch (e) {
      print('Error getting game progress: $e');
      return {};
    }
  }
  
  // Get progress for all games
  Future<Map<String, dynamic>> getAllGameProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = UserState.instance.uid;
      
      if (userId.isEmpty) {
        return {};
      }
      
      final String progressJson = prefs.getString(_progressKey) ?? '{}';
      final Map<String, dynamic> allProgress = json.decode(progressJson);
      
      if (allProgress.containsKey(userId)) {
        return Map<String, dynamic>.from(allProgress[userId]);
      }
      
      return {};
    } catch (e) {
      print('Error getting all game progress: $e');
      return {};
    }
  }
  
  // Update score and award points
  Future<void> updateScore(String gameType, int score, {int pointsToAward = 0}) async {
    final user = _auth.currentUser;
    if (user == null) return;
    
    try {
      // Get reference to user's game data
      final gameRef = _firestore.collection('users').doc(user.uid).collection('games').doc(gameType);
      
      // Get current high score
      final gameDoc = await gameRef.get();
      final currentHighScore = gameDoc.exists ? (gameDoc.data()?['highScore'] as int? ?? 0) : 0;
      
      // Only update if the new score is higher
      if (score > currentHighScore) {
        await gameRef.set({
          'highScore': score,
          'lastPlayed': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        
        // Award points if this is a new high score
        if (pointsToAward > 0) {
          await UserState.instance.addPoints(pointsToAward);
        }
      }
    } catch (e) {
      debugPrint('Error updating score: $e');
      rethrow;
    }
  }
  
  // Update progress and award points
  Future<void> updateProgress(String gameType, double progress, {int pointsToAward = 0}) async {
    final user = _auth.currentUser;
    if (user == null) return;
    
    try {
      // Get reference to user's game data
      final gameRef = _firestore.collection('users').doc(user.uid).collection('games').doc(gameType);
      
      // Get current progress
      final gameDoc = await gameRef.get();
      final currentProgress = gameDoc.exists ? (gameDoc.data()?['progress'] as num?)?.toDouble() ?? 0.0 : 0.0;
      
      // Only update if new progress is greater
      if (progress > currentProgress) {
        await gameRef.set({
          'progress': progress,
          'lastPlayed': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        
        // Award points proportional to progress increase
        if (pointsToAward > 0) {
          final progressDifference = progress - currentProgress;
          final pointsEarned = (progressDifference * pointsToAward).round();
          if (pointsEarned > 0) {
            await UserState.instance.addPoints(pointsEarned);
          }
        }
      }
    } catch (e) {
      debugPrint('Error updating progress: $e');
      rethrow;
    }
  }
  
  // New method to award points for completing game achievements
  Future<void> awardAchievementPoints(String achievementType, int pointsToAward) async {
    final user = _auth.currentUser;
    if (user == null) return;
    
    try {
      // Record achievement in firestore
      await _firestore.collection('users').doc(user.uid)
          .collection('achievements').doc(achievementType).set({
        'achieved': true,
        'timestamp': FieldValue.serverTimestamp(),
        'pointsAwarded': pointsToAward
      });
      
      // Add points to user's total
      await UserState.instance.addPoints(pointsToAward);
    } catch (e) {
      debugPrint('Error awarding achievement points: $e');
      rethrow;
    }
  }
}

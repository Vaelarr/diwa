import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../user_state.dart';

class ProgressService {
  // Singleton pattern
  static final ProgressService _instance = ProgressService._internal();
  static ProgressService get instance => _instance;
  
  // Keys for SharedPreferences storage
  static const String _lessonsKey = 'userLessons';
  static const String _gamesKey = 'userGames';
  
  // Private constructor
  ProgressService._internal();
    // Save lesson progress to SharedPreferences
  Future<bool> saveLessonProgress({
    required String lessonId,
    required double progress,
    required bool completed,
  }) async {
    try {
      final userId = UserState.instance.uid;
      if (userId.isEmpty) {
        debugPrint('Cannot save lesson progress: User not logged in');
        return false;
      }
      
      final prefs = await SharedPreferences.getInstance();
      final String lessonsJson = prefs.getString(_lessonsKey) ?? '{}';
      final Map<String, dynamic> allLessons = json.decode(lessonsJson);
      
      // Initialize user lessons if they don't exist
      if (!allLessons.containsKey(userId)) {
        allLessons[userId] = {};
      }
      
      // Save lesson data
      allLessons[userId][lessonId] = {
        'progress': progress,
        'completed': completed,
        'lastUpdated': DateTime.now().toIso8601String(),
      };
      
      // Save to SharedPreferences
      await prefs.setString(_lessonsKey, json.encode(allLessons));
      
      return true;
    } catch (e) {
      debugPrint('Error saving lesson progress: $e');
      return false;
    }
  }
    // Get lesson progress from SharedPreferences
  Future<Map<String, dynamic>> getLessonProgress(String lessonId) async {
    try {
      final userId = UserState.instance.uid;
      if (userId.isEmpty) {
        return {};
      }
      
      final prefs = await SharedPreferences.getInstance();
      final String lessonsJson = prefs.getString(_lessonsKey) ?? '{}';
      final Map<String, dynamic> allLessons = json.decode(lessonsJson);
      
      if (allLessons.containsKey(userId) && allLessons[userId].containsKey(lessonId)) {
        return Map<String, dynamic>.from(allLessons[userId][lessonId]);
      }
      
      return {};
    } catch (e) {
      debugPrint('Error getting lesson progress: $e');
      return {};
    }
  }
  
  // Get all lesson progress for the current user
  Future<Map<String, dynamic>> getAllLessonProgress() async {
    try {
      final userId = UserState.instance.uid;
      if (userId.isEmpty) {
        return {};
      }
      
      final prefs = await SharedPreferences.getInstance();
      final String lessonsJson = prefs.getString(_lessonsKey) ?? '{}';
      final Map<String, dynamic> allLessons = json.decode(lessonsJson);
      
      if (allLessons.containsKey(userId)) {
        return Map<String, dynamic>.from(allLessons[userId]);
      }
      
      return {};
    } catch (e) {
      debugPrint('Error getting all lesson progress: $e');
      return {};
    }
  }
    // Save game progress and scores to SharedPreferences
  Future<bool> saveGameProgress({
    required String gameType,
    required int score,
    int level = 1,
    double completion = 0.0,
  }) async {
    try {
      final userId = UserState.instance.uid;
      if (userId.isEmpty) {
        debugPrint('Cannot save game progress: User not logged in');
        return false;
      }
      
      final prefs = await SharedPreferences.getInstance();
      final String gamesJson = prefs.getString(_gamesKey) ?? '{}';
      final Map<String, dynamic> allGames = json.decode(gamesJson);
      
      // Initialize user games if they don't exist
      if (!allGames.containsKey(userId)) {
        allGames[userId] = {};
      }
      
      // Initialize game data if it doesn't exist
      if (!allGames[userId].containsKey(gameType)) {
        allGames[userId][gameType] = {
          'highScore': 0,
          'sessions': [],
        };
      }
      
      // Get current high score
      int currentHighScore = allGames[userId][gameType]['highScore'] ?? 0;
      
      // Only update high score if new score is higher
      final highScore = score > currentHighScore ? score : currentHighScore;
      
      // Get existing sessions
      List<Map<String, dynamic>> sessions = [];
      if (allGames[userId][gameType].containsKey('sessions')) {
        sessions = List<Map<String, dynamic>>.from(allGames[userId][gameType]['sessions']);
      }
      
      // Record the game session
      sessions.add({
        'score': score,
        'level': level,
        'timestamp': DateTime.now().toIso8601String(),
      });
      
      // Update game summary data
      allGames[userId][gameType] = {
        'highScore': highScore,
        'lastPlayed': DateTime.now().toIso8601String(),
        'progress': completion,
        'sessions': sessions,
      };
      
      // Save to SharedPreferences
      await prefs.setString(_gamesKey, json.encode(allGames));
      
      return true;
    } catch (e) {
      debugPrint('Error saving game progress: $e');
      return false;
    }
  }
    // Get game progress from SharedPreferences
  Future<Map<String, dynamic>> getGameProgress(String gameType) async {
    try {
      final userId = UserState.instance.uid;
      if (userId.isEmpty) {
        return {};
      }
      
      final prefs = await SharedPreferences.getInstance();
      final String gamesJson = prefs.getString(_gamesKey) ?? '{}';
      final Map<String, dynamic> allGames = json.decode(gamesJson);
      
      if (allGames.containsKey(userId) && allGames[userId].containsKey(gameType)) {
        return Map<String, dynamic>.from(allGames[userId][gameType]);
      }
      
      return {};
    } catch (e) {
      debugPrint('Error getting game progress: $e');
      return {};
    }
  }
  
  // Get progress for all games
  Future<Map<String, dynamic>> getAllGameProgress() async {
    try {
      final userId = UserState.instance.uid;
      if (userId.isEmpty) {
        return {};
      }
      
      final prefs = await SharedPreferences.getInstance();
      final String gamesJson = prefs.getString(_gamesKey) ?? '{}';
      final Map<String, dynamic> allGames = json.decode(gamesJson);
      
      if (allGames.containsKey(userId)) {
        return Map<String, dynamic>.from(allGames[userId]);
      }
      
      return {};
    } catch (e) {
      debugPrint('Error getting all game progress: $e');
      return {};
    }
  }
    // Get overall user progress (combination of lessons and games)
  Future<double> getOverallProgress() async {
    try {
      final lessonProgress = await getAllLessonProgress();
      final gameProgress = await getAllGameProgress();
      
      if (lessonProgress.isEmpty && gameProgress.isEmpty) {
        return 0.0;
      }
      
      double totalLessonProgress = 0.0;
      double totalGameProgress = 0.0;
      
      // Calculate average lesson progress
      if (lessonProgress.isNotEmpty) {
        lessonProgress.forEach((_, value) {
          if (value is Map && value.containsKey('progress')) {
            totalLessonProgress += (value['progress'] as num).toDouble();
          }
        });
        totalLessonProgress = totalLessonProgress / lessonProgress.length;
      }
      
      // Calculate average game progress
      if (gameProgress.isNotEmpty) {
        gameProgress.forEach((_, value) {
          if (value is Map && value.containsKey('progress')) {
            totalGameProgress += (value['progress'] as num).toDouble();
          }
        });
        totalGameProgress = totalGameProgress / gameProgress.length;
      }
      
      // Overall progress is average of lesson and game progress
      if (lessonProgress.isNotEmpty && gameProgress.isNotEmpty) {
        return (totalLessonProgress + totalGameProgress) / 2;
      } else if (lessonProgress.isNotEmpty) {
        return totalLessonProgress;
      } else {
        return totalGameProgress;
      }
    } catch (e) {
      debugPrint('Error calculating overall progress: $e');
      return 0.0;
    }
  }
}

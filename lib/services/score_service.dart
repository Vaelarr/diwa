import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ScoreService {
  // Key for SharedPreferences storage
  static const String _scoresKey = 'userScores';
  
  // Save a score for a specific game
  Future<bool> saveScore({
    required String userId,
    required String game,
    required int score,
  }) async {
    try {
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
      allScores[userId][game].add({
        'score': score,
        'timestamp': DateTime.now().toIso8601String(),
      });
      
      // Save updated scores back to SharedPreferences
      await prefs.setString(_scoresKey, jsonEncode(allScores));
      
      return true;
    } catch (e) {
      print('Error saving score: $e');
      return false;
    }
  }
  
  // Get all scores for a specific user and game
  Future<List<Map<String, dynamic>>> getUserGameScores({
    required String userId,
    required String game,
  }) async {
    try {
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
      final Map<String, dynamic> allScores = await _getAllScores();
      final List<Map<String, dynamic>> leaderboard = [];
      
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
}

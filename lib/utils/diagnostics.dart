import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DiagnosticsService {
  // Log general messages with timestamp and category
  static void log(String category, String message) {
    final timestamp = DateTime.now().toIso8601String();
    final logMessage = '[$timestamp] $category: $message';
    debugPrint(logMessage);
  }

  // Log errors with stack trace (when available)
  static void logError(String category, dynamic error, [StackTrace? stackTrace]) {
    final timestamp = DateTime.now().toIso8601String();
    final errorMessage = '[$timestamp] ERROR - $category: $error';
    debugPrint(errorMessage);
    
    if (stackTrace != null && kDebugMode) {
      debugPrint('Stack trace:');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  // Log network operations
  static void logNetwork(String operation, String endpoint, [dynamic details]) {
    if (!kDebugMode) return;
    
    final timestamp = DateTime.now().toIso8601String();
    final logMessage = '[$timestamp] NETWORK - $operation: $endpoint';
    debugPrint(logMessage);
    
    if (details != null) {
      debugPrint('Details: $details');
    }
  }

  // Test connectivity and provide detailed report
  static Future<Map<String, dynamic>> diagnoseCommunication(String endpoint) async {
    final results = <String, dynamic>{};
    final startTime = DateTime.now();
    
    try {
      debugPrint('Testing communication with: $endpoint');
      
      // Attempt to make a simple HTTP request
      final uri = Uri.parse(endpoint);
      final response = await httpHead(uri);
      
      results['success'] = response;
      results['latency'] = DateTime.now().difference(startTime).inMilliseconds;
      
    } catch (e) {
      results['success'] = false;
      results['error'] = e.toString();
    }
    
    debugPrint('Connection diagnostic results: $results');
    return results;
  }
  
  // Simple HTTP HEAD request
  static Future<bool> httpHead(Uri uri) async {
    try {
      // In a real implementation, use package:http or similar
      // For now, just simulate a request
      await Future.delayed(const Duration(milliseconds: 500));
      return true;
    } catch (e) {
      debugPrint('HTTP diagnostic request failed: $e');
      return false;
    }
  }
}

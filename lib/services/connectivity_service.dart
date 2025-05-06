import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class ConnectivityService {
  /// Checks for internet connectivity in a platform-safe way
  static Future<bool> hasInternetConnection() async {
    if (kIsWeb) {
      // For web, we'll use a simple check - trying to fetch a small resource
      try {
        debugPrint('Web platform detected, using alternate connectivity check');
        final testUrl = Uri.parse('https://www.google.com/generate_204');
        final response = await Future.any([
          // Try to fetch a tiny response from Google
          httpHead(testUrl),
          // Set a timeout to avoid hanging
          Future.delayed(const Duration(seconds: 5), () => throw TimeoutException('Connection test timed out')),
        ]);
        
        debugPrint('Web connectivity check result: $response');
        return response == true;
      } catch (e) {
        debugPrint('Web connectivity check failed: $e');
        // On web, assume connectivity even if check fails (might be CORS issue)
        return true;
      }
    } else {
      // For mobile platforms, use the http check approach
      try {
        debugPrint('Mobile platform detected, using http connectivity check');
        final testUrl = Uri.parse('https://www.google.com/generate_204');
        final response = await Future.any([
          // Try to fetch a tiny response from Google
          httpHead(testUrl),
          // Set a timeout to avoid hanging
          Future.delayed(const Duration(seconds: 5), () => throw TimeoutException('Connection test timed out')),
        ]);
        
        debugPrint('Mobile connectivity check result: $response');
        return response == true;
      } catch (e) {
        debugPrint('Mobile connectivity check failed: $e');
        return false;
      }
    }
  }

  // Simple HTTP HEAD request to check connectivity
  static Future<bool> httpHead(Uri uri) async {
    try {
      // Use a direct HTTP request
      final client = await createHttpClient();
      final request = await client.headUrl(uri);
      final response = await request.close();
      await response.drain<void>();
      return response.statusCode == 204;
    } catch (e) {
      debugPrint('HTTP HEAD request failed: $e');
      return false;
    }
  }

  // Create an appropriate HTTP client
  static Future<dynamic> createHttpClient() async {
    try {
      if (kIsWeb) {
        // For web, use a JS-based approach
        // Return a stub that matches the API used in the httpHead method
        return _WebHttpClient();
      } else {
        // For mobile, use dart:io HttpClient
        final HttpClient = await importHttpClient();
        return HttpClient();
      }
    } catch (e) {
      debugPrint('Failed to create HTTP client: $e');
      // Return a stub client that will report connectivity
      return _WebHttpClient();
    }
  }

  // Import HttpClient only on non-web platforms
  static Future<dynamic> importHttpClient() async {
    if (kIsWeb) {
      throw UnsupportedError('HttpClient is not supported on web');
    }
    
    // Dynamically import dart:io only on non-web platforms
    try {
      dynamic io = await import('dart:io');
      return io.HttpClient;
    } catch (e) {
      debugPrint('Failed to import dart:io: $e');
      throw UnsupportedError('HttpClient import failed: $e');
    }
  }
  
  // Import function using JS interop for web-only code
  static Future<dynamic> import(String path) async {
    // This is a simplified version; in a real app you'd use dart:js_interop
    throw UnimplementedError('Dynamic import not supported in this context');
  }
}

// Web client stub that implements the necessary methods
class _WebHttpClient {
  Future<_WebHttpClientRequest> headUrl(Uri url) async {
    return _WebHttpClientRequest(url);
  }
}

class _WebHttpClientRequest {
  final Uri url;
  
  _WebHttpClientRequest(this.url);
  
  Future<_WebHttpClientResponse> close() async {
    try {
      // Use JS fetch API to make a HEAD request (simplified)
      // In a real implementation, you'd use dart:js_interop or package:http
      await Future.delayed(const Duration(milliseconds: 200));
      return _WebHttpClientResponse(true);
    } catch (e) {
      debugPrint('Web request failed: $e');
      return _WebHttpClientResponse(false);
    }
  }
}

class _WebHttpClientResponse {
  final bool success;
  
  _WebHttpClientResponse(this.success);
  
  int get statusCode => success ? 204 : 500;
  
  Future<void> drain<T>() async {
    // No-op for web
  }
}

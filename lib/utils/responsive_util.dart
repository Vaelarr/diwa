import 'package:flutter/material.dart';

/// A utility class for responsive design with screen size constraints
class ScreenConstraints {
  /// Minimum app width in logical pixels
  static const double minWidth = 320.0;
  
  /// Minimum app height in logical pixels
  static const double minHeight = 480.0;
  
  /// Checks if the current screen size meets the minimum requirements
  static bool meetsMinimumSize(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return size.width >= minWidth && size.height >= minHeight;
  }
  
  /// Gets the dimensions message for the current screen
  static String getDimensionsMessage(BuildContext context, String language) {
    final size = MediaQuery.of(context).size;
    final width = size.width.toInt();
    final height = size.height.toInt();
    
    return language == 'Filipino'
      ? 'Kasalukuyang laki: ${width}x${height} pixels'
      : 'Current size: ${width}x${height} pixels';
  }
}

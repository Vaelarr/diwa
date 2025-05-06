import 'package:flutter/material.dart';

class ScreenSizeError extends StatelessWidget {
  final double minWidth;
  final double minHeight;
  final double currentWidth;
  final double currentHeight;
  final String language;
  
  const ScreenSizeError({
    Key? key,
    required this.minWidth,
    required this.minHeight,
    required this.currentWidth,
    required this.currentHeight,
    required this.language,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isFilipino = language == 'Filipino';
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8F4E1),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.brown,
                  size: 80,
                ),
                const SizedBox(height: 24),
                Text(
                  isFilipino ? 'Sukat ng Screen' : 'Screen Size',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  isFilipino
                      ? 'Ang laki ng iyong screen ay masyadong maliit para sa application na ito.'
                      : 'Your screen size is too small for this application.',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Text(
                  isFilipino
                      ? 'Kasalukuyang sukat: ${currentWidth.toInt()}x${currentHeight.toInt()} px'
                      : 'Current size: ${currentWidth.toInt()}x${currentHeight.toInt()} px',
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  isFilipino
                      ? 'Kinakailangang sukat: ${minWidth.toInt()}x${minHeight.toInt()} px'
                      : 'Minimum size: ${minWidth.toInt()}x${minHeight.toInt()} px',
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Text(
                  isFilipino
                      ? 'Subukan ang mas malaking device o i-rotate ang iyong device sa landscape mode.'
                      : 'Please try using a larger device or rotate your device to landscape mode.',
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.brown[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

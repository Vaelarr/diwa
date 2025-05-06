import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  final String language;
  final VoidCallback onInitializationComplete;

  const SplashScreen({
    Key? key,
    required this.language,
    required this.onInitializationComplete,
  }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Create animation controller
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Create animations
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.65, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.2, 0.8, curve: Curves.easeOutBack),
      ),
    );

    // Start animation
    _controller.forward();

    // Navigate to home after a delay
    Timer(const Duration(seconds: 3), () {
      widget.onInitializationComplete();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _opacityAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.auto_stories,
                        color: Colors.white,
                        size: 70,
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'DIWA',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      widget.language == 'Filipino' 
                          ? 'Pag-aaral sa pamamagitan ng paglalaro' 
                          : 'Learning through play',
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(height: 48),
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../theme.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeOut,
          builder: (context, v, child) => Opacity(
            opacity: v,
            child: Transform.scale(scale: 0.85 + 0.15 * v, child: child),
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.menu_book_rounded, size: 96, color: Colors.white),
              SizedBox(height: 16),
              Text(
                'StudyMate',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Better together.',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              SizedBox(height: 32),
              SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

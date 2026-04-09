import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color accentPurple = Color(0xFF7C3AED);
  static const Color backgroundBlack = Color(0xFF0F172A);
  static const Color glassWhite = Color(0x33FFFFFF);
  static const Color glassBorder = Color(0x4DFFFFFF);
  
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1E3A8A),
      Color(0xFF7C3AED),
    ],
  );

  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0F172A),
      Color(0xFF1E293B),
    ],
  );
}

class AppStyles {
  static const double borderRadius = 24.0;
  static const double blurSigma = 15.0;
}

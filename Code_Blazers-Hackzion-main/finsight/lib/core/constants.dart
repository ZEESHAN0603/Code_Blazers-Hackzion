import 'package:flutter/material.dart';

class AppColors {
  // Primary Palette
  static const Color navyDark = Color(0xFF0F172A);
  static const Color navyMedium = Color(0xFF1E293B);
  static const Color slateBg = Color(0xFFF1F5F9);
  static const Color cardWhite = Color(0xFFFFFFFF);
  
  // Accents
  static const Color accentBlue = Color(0xFF2563EB);
  static const Color accentGreen = Color(0xFF10B981);
  static const Color accentRose = Color(0xFFF43F5E);
  
  // Text
  static const Color textMain = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textLight = Color(0xFF94A3B8);

  static const LinearGradient navyGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1E293B),
      Color(0xFF0F172A),
    ],
  );

  static const LinearGradient accentBlueGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF3B82F6),
      Color(0xFF2563EB),
    ],
  );
}

class AppStyles {
  static const double borderRadius = 20.0;
  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: const Color(0xFF000000).withValues(alpha: 0.05),
      blurRadius: 15,
      offset: const Offset(0, 4),
    ),
  ];
  
  static List<BoxShadow> deepShadow = [
    BoxShadow(
      color: const Color(0xFF0F172A).withValues(alpha: 0.08),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];
}

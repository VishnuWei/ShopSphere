import 'package:flutter/material.dart';

abstract class AppColors {
  // Brand colors
  static const Color primary = Color(0xFF2368D8);
  static const Color primaryLight = Color(0xFF5F8EFF);
  static const Color primaryDark = Color(0xFF004E89);

  // Neutrals
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF0A0E27);
  static const Color grey50 = Color(0xFFFAFAFC);
  static const Color grey100 = Color(0xFFF3F4F6);
  static const Color grey200 = Color(0xFFE5E7EB);
  static const Color grey300 = Color(0xFFD1D5DB);
  static const Color grey400 = Color(0xFF9CA3AF);
  static const Color grey500 = Color(0xFF6B7280);
  static const Color grey600 = Color(0xFF4B5563);
  static const Color grey700 = Color(0xFF374151);
  static const Color grey800 = Color(0xFF1F2937);
  static const Color grey900 = Color(0xFF111827);

  // Semantic colors
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFFB923C);
  static const Color info = Color(0xFF3B82F6);

  // Surface colors
  static const Color surface = white;
  static const Color surfaceDark = Color(0xFF121212);
  static const Color surfaceVariant = grey50;
  static const Color surfaceVariantDark = Color(0xFF1E1E1E);

  // Overlay
  static const Color overlay = Color(0x00000000);
  static const Color overlayDark = Color(0x1F000000);

  // Shadows
  static Color shadowLight = Colors.black.withAlpha(12);
  static Color shadowMedium = Colors.black.withAlpha(24);
  static Color shadowDark = Colors.black.withAlpha(40);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryDark, primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

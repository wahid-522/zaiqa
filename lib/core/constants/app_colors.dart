import 'package:flutter/material.dart';

/// Zaiqa (ذائقہ) Design System Color Tokens.
/// Food-appropriate warm colors: Saffron Orange, Deep Spice Amber, Soft Cream, Warm Espresso.
class AppColors {
  AppColors._();

  // Primary & Accent Colors
  static const Color primary = Color(0xFFE65100);
  static const Color primaryDark = Color(0xFFC64200);
  static const Color primaryLight = Color(0xFFFFE0B2);
  static const Color accent = Color(0xFFFF8F00);
  static const Color secondary = Color(0xFFD84315);

  // Background & Surface Colors (Light Mode)
  static const Color backgroundLight = Color(0xFFFAF7F2); // Soft warm cream
  static const Color surfaceLight = Colors.white;
  static const Color cardLight = Colors.white;

  // Background & Surface Colors (Dark Mode)
  static const Color backgroundDark = Color(0xFF141110); // Warm dark chocolate
  static const Color surfaceDark = Color(0xFF1F1A18);
  static const Color cardDark = Color(0xFF28221F);

  // Neutral & Typography Colors
  static const Color textPrimaryLight = Color(0xFF2C221E); // Espresso dark text
  static const Color textSecondaryLight = Color(0xFF786C66); // Warm grey text
  static const Color textPrimaryDark = Color(0xFFF5EFEA);
  static const Color textSecondaryDark = Color(0xFFAAA09A);

  // Functional / Status Colors
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFF57F17);
  static const Color error = Color(0xFFD32F2F);
  static const Color info = Color(0xFF0288D1);

  // Star Rating & Badges
  static const Color starRating = Color(0xFFFFB300);
  static const Color vegGreen = Color(0xFF388E3C);
  static const Color nonVegRed = Color(0xFFD32F2F);

  // Borders & Dividers
  static const Color borderLight = Color(0xFFEFE8E1);
  static const Color borderDark = Color(0xFF3B332E);
}

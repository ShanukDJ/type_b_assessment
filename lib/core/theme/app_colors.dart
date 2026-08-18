import 'package:flutter/material.dart';

/// Design tokens derived from Figma specifications
class AppColors {
  AppColors._();

  // Primary Brand Colors
  static const Color primary1 = Color(0xFF41AC85);
  static const Color primary2 = Color(0xFF093726);

  // Surface & Neutrals
  static const Color white = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF6F7F9);
  static const Color secondary = Color(0xFF6C6C78);
  static const Color onSurface = Color(0xFF131317);
  static const Color line = Color(0xFFE5E5E5);
  static const Color inputFill = Color(0xFFF6F7F9);

  // Status & Feedback Colors
  static const Color critical = Color(0xFFEB5A5A);
  static const Color warning = Color(0xFFFABE3C);
  static const Color success = Color(0xFFA4D325);

  // Gradients
  static const LinearGradient loginHeaderGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF2C8C6B), Color(0xFF41AC85)],
  );

  static const LinearGradient featuredCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF389B77), Color(0xFF4DBB93)],
  );
}

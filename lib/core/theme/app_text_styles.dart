import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // Headings
  static TextStyle get headingLarge => GoogleFonts.lexendDeca(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.onSurface,
    letterSpacing: -0.5,
  );

  static TextStyle get headingMedium => GoogleFonts.lexendDeca(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.onSurface,
    letterSpacing: -0.3,
  );

  static TextStyle get headingSmall => GoogleFonts.lexendDeca(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.onSurface,
  );

  // Section Headers
  static TextStyle get sectionTitle => GoogleFonts.lexendDeca(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.onSurface,
  );

  static TextStyle get viewAll => GoogleFonts.lexendDeca(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.primary1,
  );

  // Body Text
  static TextStyle get bodyLarge => GoogleFonts.lexendDeca(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.onSurface,
    height: 1.5,
  );

  static TextStyle get bodyMedium => GoogleFonts.lexendDeca(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.secondary,
    height: 1.4,
  );

  static TextStyle get bodySmall => GoogleFonts.lexendDeca(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.secondary,
  );

  // Labels & Captions
  static TextStyle get labelMedium => GoogleFonts.lexendDeca(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.secondary,
  );

  static TextStyle get buttonText => GoogleFonts.lexendDeca(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  static TextStyle get buttonSecondaryText => GoogleFonts.lexendDeca(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurface,
  );

  static TextStyle get logoText => GoogleFonts.lexendDeca(
    fontSize: 26,
    fontWeight: FontWeight.w800,
    color: AppColors.white,
    letterSpacing: 0.5,
  );
}

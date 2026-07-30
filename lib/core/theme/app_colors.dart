import 'package:flutter/material.dart';

/// App Color Palette for AI Kids Academy
/// Modern Apple + Duolingo + Khan Kids inspired soft pastel palette
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF5E60CE);
  static const Color primaryDark = Color(0xFF4849B4);
  static const Color primaryLight = Color(0xFF7E80E7);
  
  static const Color secondary = Color(0xFF64DFDF);
  static const Color secondaryDark = Color(0xFF48B8B8);
  static const Color secondaryLight = Color(0xFF90F3F3);

  static const Color accent = Color(0xFF80FFDB);
  static const Color warning = Color(0xFFFFD166);
  static const Color success = Color(0xFF06D6A0);
  static const Color background = Color(0xFFF7F8FC);
  
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFFAFBFF);
  
  static const Color cardShadow = Color(0x145E60CE);
  static const Color softShadow = Color(0x0F000000);
  
  static const Color textPrimary = Color(0xFF2B2D42);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color textLight = Color(0xFFA0AAB2);
  
  static const Color borderLight = Color(0xFFE9ECEF);
  static const Color glassBorder = Color(0x40FFFFFF);
  static const Color glassFill = Color(0x99FFFFFF);

  // Additional Pastel Accents for Cards & Categories
  static const Color pastelPink = Color(0xFFFFB5A7);
  static const Color pastelPurple = Color(0xFFD8BBFF);
  static const Color pastelBlue = Color(0xFFBEE1E6);
  static const Color pastelYellow = Color(0xFFFDE2E4);
  static const Color pastelOrange = Color(0xFFFFCAD4);
  static const Color pastelGreen = Color(0xFFE2ECE9);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF5E60CE), Color(0xFF7E80E7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFF64DFDF), Color(0xFF80FFDB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warningGradient = LinearGradient(
    colors: [Color(0xFFFFD166), Color(0xFFFFE194)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Colors.white, Color(0xFFF8F9FF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

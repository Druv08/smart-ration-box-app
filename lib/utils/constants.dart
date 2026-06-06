import 'package:flutter/material.dart';

class AppConstants {
  AppConstants._();

  static const String appName = 'Smart Ration Box';
  static const String projectName = 'Smart Ration Box';

  // Legacy colors (kept for backward compatibility)
  static const Color primaryColor = Color(0xFF2E7D32); // green

  // Luxury dark theme colors
  static const Color darkBg = Color(0xFF0F0F0F);
  static const Color darkCharcoal = Color(0xFF1F1F1F);
  static const Color darkerCharcoal = Color(0xFF2D2D2D);
  static const Color gold = Color(0xFFFBBF24);
  static const Color goldDark = Color(0xFFF59E0B);
  static const Color lightGray = Color(0xFFA0AEC0);
  static const Color lighterGray = Color(0xFFCBD5E0);

  // Status Colors
  static const Color successGreen = Color(0xFF10B981);
  static const Color warningOrange = Color(0xFFF97316);
  static const Color errorRed = Color(0xFFEF4444);
  static const Color infoBlue = Color(0xFF3B82F6);

  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double mediumPadding = 12.0;
  static const double largePadding = 24.0;

  // Border radius
  static const double smallBorderRadius = 8.0;
  static const double mediumBorderRadius = 12.0;
  static const double largeBorderRadius = 16.0;
  static const double extraLargeBorderRadius = 24.0;
}

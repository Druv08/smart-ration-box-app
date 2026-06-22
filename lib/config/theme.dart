import 'package:flutter/material.dart';

/// Light oak / kitchen-style palette (Week 3 redesign — see product mockup).
///
/// The constant NAMES are kept from the original dark luxury theme so every
/// widget that already references them flips to the light look automatically.
/// Only the VALUES changed; the semantic role of each name is noted below:
///   * darkBg          → warm cream app background (scaffold)
///   * darkCharcoal    → white card / surface
///   * darkerCharcoal  → light oak tint (borders, inner fills, progress track)
///   * gold / goldDark → warm oak‑brown accent (primary)
///   * lighterGray     → espresso, primary text on cream
///   * lightGray       → muted warm gray, secondary text
class AppTheme {
  AppTheme._();

  // Color Palette (light oak)
  static const Color darkBg = Color(0xFFFBF7F0); // warm cream background
  static const Color darkCharcoal = Color(0xFFFFFFFF); // white card surface
  static const Color darkerCharcoal = Color(0xFFEFE7DA); // light oak tint
  static const Color gold = Color(0xFF9A6B3F); // warm oak‑brown accent
  static const Color goldDark = Color(0xFF7D5530); // deeper oak
  static const Color lightGray = Color(0xFF8A7E6D); // muted secondary text
  static const Color lighterGray = Color(0xFF3A322A); // espresso primary text
  static const Color veryLightGray = Color(0xFF5A5044);

  // Status Colors (earthy)
  static const Color successGreen = Color(0xFF4E9A51); // Normal stock (green)
  static const Color warningOrange = Color(0xFFE08A3C); // warm amber
  static const Color errorRed = Color(0xFFD9534F); // soft red (low stock)
  static const Color infoBlue = Color(0xFF4A82C2); // muted blue (refill)

  /// Soft, warm card shadow used across light‑oak surfaces.
  static List<BoxShadow> get softShadow => [
        BoxShadow(
          color: const Color(0xFF8A6A45).withValues(alpha: 0.12),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ];

  static ThemeData get darkTheme => lightOakTheme;

  static ThemeData get lightOakTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: darkBg,
      primaryColor: gold,

      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: gold,
        onPrimary: Colors.white,
        secondary: goldDark,
        onSecondary: Colors.white,
        surface: darkCharcoal,
        onSurface: lighterGray,
        error: errorRed,
        onError: Colors.white,
      ),

      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBg,
        foregroundColor: gold,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: lighterGray,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Card
      cardTheme: CardThemeData(
        color: darkCharcoal,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: darkerCharcoal,
            width: 1,
          ),
        ),
        margin: EdgeInsets.zero,
      ),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: lighterGray,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: lighterGray,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: lighterGray,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: lighterGray,
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: lighterGray,
        ),
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: lighterGray,
        ),
        titleMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: lighterGray,
        ),
        titleSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: lightGray,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: lighterGray,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: lighterGray,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: lightGray,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: gold,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: gold,
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: lightGray,
        ),
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: gold,
          foregroundColor: darkBg,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: gold,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          side: const BorderSide(color: gold, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: gold,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkerCharcoal,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkerCharcoal),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkerCharcoal, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: gold, width: 2),
        ),
        hintStyle: const TextStyle(color: lightGray),
        labelStyle: const TextStyle(color: lighterGray),
        prefixIconColor: WidgetStateColor.resolveWith(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.focused)) {
              return gold;
            }
            return lightGray;
          },
        ),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: lighterGray,
        size: 24,
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: darkCharcoal,
        selectedItemColor: gold,
        unselectedItemColor: lightGray,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),

      // Progress Indicator
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: gold,
        linearMinHeight: 8,
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: darkCharcoal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: lighterGray,
        ),
        contentTextStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: lighterGray,
        ),
      ),

      // SnackBar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: darkCharcoal,
        contentTextStyle: const TextStyle(
          color: lighterGray,
          fontSize: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

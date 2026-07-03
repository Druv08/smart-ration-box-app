import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Available app appearance modes. The redesign is light-first ("Smart
/// Ration Storage" warm theme); the enum + notifier are kept so the
/// existing Settings → Appearance toggle keeps working unchanged.
enum AppThemeMode { light, dark }

class AppTheme {
  AppTheme._();

  /// Global appearance switch. Defaults to the warm light design.
  static final ValueNotifier<AppThemeMode> mode =
      ValueNotifier<AppThemeMode>(AppThemeMode.light);

  static bool get isLight => mode.value == AppThemeMode.light;

  // ===========================================================================
  // Design tokens — warm palette with light + dark variants.
  // ---------------------------------------------------------------------------
  // Accent hues (primary/green/red/amber) stay constant across modes; the
  // surfaces, tints, text and dividers flip with [mode]. Because the whole
  // MaterialApp rebuilds when [mode] changes, these getters re-evaluate.
  // ===========================================================================

  /// Soft warm background.
  static Color get bg =>
      isLight ? const Color(0xFFFAF8F4) : const Color(0xFF17130F);

  /// Card / surface color.
  static Color get card =>
      isLight ? const Color(0xFFFFFFFF) : const Color(0xFF221D18);

  /// A slightly warmer surface for banners / tinted tiles.
  static Color get surfaceWarm =>
      isLight ? const Color(0xFFF3EDE3) : const Color(0xFF2A231C);

  /// Primary — warm wood brown (constant across modes).
  static const Color primary = Color(0xFFA9744F);
  static const Color primaryDark = Color(0xFF8A5A38);

  /// Wood-brown tuned for readable text/icon on the current surface.
  static Color get woodText =>
      isLight ? primaryDark : const Color(0xFFCB9B6E);

  /// Soft wood tint for icon chips / subtle fills.
  static Color get primaryTint =>
      isLight ? const Color(0xFFF0E6DA) : const Color(0xFF3A2C20);

  /// Accent — muted green (healthy / normal stock).
  static const Color accentGreen = Color(0xFF6F9463);
  static Color get accentGreenTint =>
      isLight ? const Color(0xFFE7EFE2) : const Color(0xFF24301E);

  /// Low stock — soft red.
  static const Color lowStock = Color(0xFFD08770);
  static Color get lowStockTint =>
      isLight ? const Color(0xFFF7E7E1) : const Color(0xFF392420);

  /// Warm amber for secondary warnings (e.g. battery low).
  static const Color amber = Color(0xFFE0A46A);

  /// Text.
  static Color get textPrimary =>
      isLight ? const Color(0xFF3A352E) : const Color(0xFFEFE7DC);
  static Color get textSecondary =>
      isLight ? const Color(0xFF9A9186) : const Color(0xFFA99F92);

  /// Divider / border / inactive track.
  static Color get divider =>
      isLight ? const Color(0xFFEDE7DC) : const Color(0xFF332B23);

  // ===========================================================================
  // Legacy token aliases
  // ---------------------------------------------------------------------------
  // The original codebase referenced these names all over. They are remapped
  // onto the warm palette so untouched widgets recolor cleanly.
  // ===========================================================================

  static const Color gold = primary;
  static const Color goldDark = primaryDark;
  static const Color onGold = Color(0xFFFFFFFF);

  /// Gold tuned for readable text/icon on the current surface.
  static Color get goldText => woodText;

  static const Color successGreen = accentGreen;
  static const Color warningOrange = amber;
  static const Color errorRed = Color(0xFFC0574A);
  static const Color infoBlue = Color(0xFF5B7C99);

  static Color get darkBg => bg;
  static Color get darkCharcoal => card;
  static Color get darkerCharcoal => divider;
  static Color get lightGray => textSecondary;
  static Color get lighterGray => textPrimary;
  static Color get veryLightGray => textPrimary;

  // ===========================================================================
  // Typography — Poppins
  // ===========================================================================

  static TextStyle heading(double size, {Color? color}) => GoogleFonts.poppins(
        fontSize: size,
        fontWeight: FontWeight.w600, // SemiBold
        color: color ?? textPrimary,
        height: 1.2,
      );

  static TextStyle label(double size, {Color? color}) => GoogleFonts.poppins(
        fontSize: size,
        fontWeight: FontWeight.w500, // Medium
        color: color ?? textPrimary,
      );

  static TextStyle body(double size, {Color? color}) => GoogleFonts.poppins(
        fontSize: size,
        fontWeight: FontWeight.w400, // Regular
        color: color ?? textSecondary,
      );

  /// SemiBold, for numbers / weights / percentages.
  static TextStyle number(double size, {Color? color}) => GoogleFonts.poppins(
        fontSize: size,
        fontWeight: FontWeight.w600,
        color: color ?? textPrimary,
      );

  static TextTheme get _textTheme => TextTheme(
        displayLarge: heading(32),
        displayMedium: heading(28),
        displaySmall: heading(24),
        headlineMedium: heading(22),
        headlineSmall: heading(18),
        titleLarge: heading(16),
        titleMedium: label(14),
        titleSmall: label(12, color: textSecondary),
        bodyLarge: body(15, color: textPrimary),
        bodyMedium: body(13, color: textPrimary),
        bodySmall: body(12),
        labelLarge: label(14),
        labelMedium: label(12),
        labelSmall: label(10, color: textSecondary),
      );

  /// Active theme. Kept name-compatible with existing call sites.
  static ThemeData get themeData => _buildTheme(isLight);
  static ThemeData get darkTheme => themeData;

  static ThemeData _buildTheme(bool light) {
    return ThemeData(
      useMaterial3: true,
      brightness: light ? Brightness.light : Brightness.dark,
      scaffoldBackgroundColor: bg,
      primaryColor: primary,
      splashFactory: InkRipple.splashFactory,

      colorScheme: ColorScheme(
        brightness: light ? Brightness.light : Brightness.dark,
        primary: primary,
        onPrimary: Colors.white,
        secondary: accentGreen,
        onSecondary: Colors.white,
        surface: card,
        onSurface: textPrimary,
        error: lowStock,
        onError: Colors.white,
      ),

      textTheme: _textTheme,

      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        foregroundColor: textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: heading(20),
      ),

      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: divider, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          textStyle: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: woodText,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          side: const BorderSide(color: primary, width: 1.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: woodText,
          textStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: bg,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: divider, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primary, width: 1.6),
        ),
        hintStyle: body(14, color: textSecondary),
        labelStyle: label(14, color: textSecondary),
        prefixIconColor: WidgetStateColor.resolveWith(
          (states) =>
              states.contains(WidgetState.focused) ? primary : textSecondary,
        ),
      ),

      iconTheme: IconThemeData(color: textPrimary, size: 24),

      chipTheme: ChipThemeData(
        backgroundColor: card,
        selectedColor: primary,
        side: BorderSide(color: divider),
        labelStyle: label(13),
        secondaryLabelStyle: label(13, color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: card,
        selectedItemColor: primary,
        unselectedItemColor: textSecondary,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        selectedLabelStyle:
            GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle:
            GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w500),
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primary,
        linearMinHeight: 8,
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        titleTextStyle: heading(18),
        contentTextStyle: body(14, color: textPrimary),
      ),

      snackBarTheme: SnackBarThemeData(
        // Fixed warm-dark chip so white text is readable in both modes.
        backgroundColor: const Color(0xFF2E2A24),
        contentTextStyle: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),

      dividerTheme: DividerThemeData(color: divider, thickness: 1),

      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}

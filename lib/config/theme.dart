import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Immutable colour set for one theme. The field names mirror the original
/// [AppTheme] colour constants so existing widgets keep compiling — they now
/// resolve through [AppTheme]'s getters against the *active* palette, which
/// lets us switch the whole app between Light Oak and Premium Dark at runtime.
class AppPalette {
  final Brightness brightness;
  final Color darkBg; // app background (scaffold)
  final Color darkCharcoal; // card / surface
  final Color darkerCharcoal; // borders, inner fills, progress track
  final Color gold; // primary accent
  final Color goldDark;
  final Color onAccent; // text/icon on top of an accent-filled button
  final Color lightGray; // secondary text
  final Color lighterGray; // primary text
  final Color veryLightGray;
  final Color appBarColor;
  final Color successGreen;
  final Color warningOrange;
  final Color errorRed;
  final Color infoBlue;
  final List<BoxShadow> softShadow;

  const AppPalette({
    required this.brightness,
    required this.darkBg,
    required this.darkCharcoal,
    required this.darkerCharcoal,
    required this.gold,
    required this.goldDark,
    required this.onAccent,
    required this.lightGray,
    required this.lighterGray,
    required this.veryLightGray,
    required this.appBarColor,
    required this.successGreen,
    required this.warningOrange,
    required this.errorRed,
    required this.infoBlue,
    required this.softShadow,
  });
}

/// Theme system for the app. Two palettes coexist:
///   * [lightOak]      — default light cream / oak kitchen look (product mockup)
///   * [premiumDark]   — original dark luxury / gold theme (optional)
///
/// Widgets read colours via the static getters below (e.g. `AppTheme.gold`),
/// which return the value from whichever palette is currently [active].
/// Swap with [usePalette] and rebuild the app (see ThemeController + app.dart).
class AppTheme {
  AppTheme._();

  // ---------------------------------------------------------------------------
  // Palettes
  // ---------------------------------------------------------------------------

  /// Default — light oak / kitchen theme.
  static const AppPalette lightOak = AppPalette(
    brightness: Brightness.light,
    darkBg: Color(0xFFFBF7F0), // warm cream background
    darkCharcoal: Color(0xFFFFFFFF), // white card surface
    darkerCharcoal: Color(0xFFEFE7DA), // light oak tint
    gold: Color(0xFF9A6B3F), // warm oak-brown accent
    goldDark: Color(0xFF7D5530),
    onAccent: Colors.white,
    lightGray: Color(0xFF8A7E6D), // muted secondary text
    lighterGray: Color(0xFF3A322A), // espresso primary text
    veryLightGray: Color(0xFF5A5044),
    appBarColor: Color(0xFFFBF7F0),
    successGreen: Color(0xFF4E9A51),
    warningOrange: Color(0xFFE08A3C),
    errorRed: Color(0xFFD9534F),
    infoBlue: Color(0xFF4A82C2),
    softShadow: [
      BoxShadow(
        color: Color(0x1F8A6A45),
        blurRadius: 16,
        offset: Offset(0, 6),
      ),
    ],
  );

  /// Optional — Premium Dark. A warm wood-dark theme (adapted from Prem's
  /// redesign) that stays cohesive with the light oak look, rather than the
  /// old charcoal + gold luxury dark.
  static const AppPalette premiumDark = AppPalette(
    brightness: Brightness.dark,
    darkBg: Color(0xFF17130F), // warm near-black background
    darkCharcoal: Color(0xFF221D18), // warm dark card / surface
    darkerCharcoal: Color(0xFF332B23), // warm divider / border / track
    gold: Color(0xFFCB9B6E), // warm tan accent (readable on dark)
    goldDark: Color(0xFFA9744F), // wood brown
    onAccent: Color(0xFF17130F), // dark text on the tan accent
    lightGray: Color(0xFFA99F92), // secondary text
    lighterGray: Color(0xFFEFE7DC), // primary text (warm off-white)
    veryLightGray: Color(0xFFEFE7DC),
    appBarColor: Color(0xFF17130F),
    successGreen: Color(0xFF6F9463), // muted green (normal stock)
    warningOrange: Color(0xFFE0A46A), // warm amber
    errorRed: Color(0xFFD08770), // soft warm red (low stock)
    infoBlue: Color(0xFF5B7C99), // muted blue (refill)
    softShadow: [
      BoxShadow(
        color: Color(0x4D000000),
        blurRadius: 12,
        offset: Offset(0, 6),
      ),
    ],
  );

  /// The palette currently in effect. Defaults to Light Oak.
  static AppPalette active = lightOak;

  /// Select the active palette (called by the theme controller on toggle).
  static void usePalette(bool premium) {
    active = premium ? premiumDark : lightOak;
  }

  // ---------------------------------------------------------------------------
  // Colour getters — resolve against the active palette so the same names work
  // for both themes (keeps all existing `AppTheme.xxx` references valid).
  // ---------------------------------------------------------------------------
  static Color get darkBg => active.darkBg;
  static Color get darkCharcoal => active.darkCharcoal;
  static Color get darkerCharcoal => active.darkerCharcoal;
  static Color get gold => active.gold;
  static Color get goldDark => active.goldDark;
  static Color get onAccent => active.onAccent;
  static Color get lightGray => active.lightGray;
  static Color get lighterGray => active.lighterGray;
  static Color get veryLightGray => active.veryLightGray;
  static Color get successGreen => active.successGreen;
  static Color get warningOrange => active.warningOrange;
  static Color get errorRed => active.errorRed;
  static Color get infoBlue => active.infoBlue;
  static List<BoxShadow> get softShadow => active.softShadow;

  // ---------------------------------------------------------------------------
  // ThemeData builders
  // ---------------------------------------------------------------------------

  /// Default theme used by the app.
  static ThemeData get lightOakTheme => _buildTheme(lightOak);

  /// Optional premium dark theme.
  static ThemeData get premiumDarkTheme => _buildTheme(premiumDark);

  /// Back-compat alias (previously the only theme).
  static ThemeData get darkTheme => lightOakTheme;

  static ThemeData _buildTheme(AppPalette p) {
    final colorScheme = ColorScheme(
      brightness: p.brightness,
      primary: p.gold,
      onPrimary: p.onAccent,
      secondary: p.goldDark,
      onSecondary: p.onAccent,
      surface: p.darkCharcoal,
      onSurface: p.lighterGray,
      error: p.errorRed,
      onError: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: p.brightness,
      scaffoldBackgroundColor: p.darkBg,
      primaryColor: p.gold,
      colorScheme: colorScheme,
      // Poppins typography (product-mockup spec): applied app-wide so both the
      // theme text styles and explicit TextStyles inherit the font.
      fontFamily: GoogleFonts.poppins().fontFamily,

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: p.appBarColor,
        foregroundColor: p.gold,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: p.lighterGray,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Card
      cardTheme: CardThemeData(
        color: p.darkCharcoal,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: p.darkerCharcoal, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: TextStyle(
            fontSize: 32, fontWeight: FontWeight.bold, color: p.lighterGray),
        displayMedium: TextStyle(
            fontSize: 28, fontWeight: FontWeight.bold, color: p.lighterGray),
        displaySmall: TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: p.lighterGray),
        headlineMedium: TextStyle(
            fontSize: 20, fontWeight: FontWeight.w600, color: p.lighterGray),
        headlineSmall: TextStyle(
            fontSize: 18, fontWeight: FontWeight.w600, color: p.lighterGray),
        titleLarge: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w600, color: p.lighterGray),
        titleMedium: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w500, color: p.lighterGray),
        titleSmall: TextStyle(
            fontSize: 12, fontWeight: FontWeight.w500, color: p.lightGray),
        bodyLarge: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w400, color: p.lighterGray),
        bodyMedium: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w400, color: p.lighterGray),
        bodySmall: TextStyle(
            fontSize: 12, fontWeight: FontWeight.w400, color: p.lightGray),
        labelLarge: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w500, color: p.gold),
        labelMedium: TextStyle(
            fontSize: 12, fontWeight: FontWeight.w500, color: p.gold),
        labelSmall: TextStyle(
            fontSize: 10, fontWeight: FontWeight.w500, color: p.lightGray),
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: p.gold,
          foregroundColor: p.onAccent,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
          textStyle:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: p.gold,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          side: BorderSide(color: p.gold, width: 1.5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: p.gold,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle:
              const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),

      // Inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: p.darkerCharcoal,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: p.darkerCharcoal),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: p.darkerCharcoal, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: p.gold, width: 2),
        ),
        hintStyle: TextStyle(color: p.lightGray),
        labelStyle: TextStyle(color: p.lighterGray),
      ),

      iconTheme: IconThemeData(color: p.lighterGray, size: 24),

      // Bottom Navigation
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: p.darkCharcoal,
        selectedItemColor: p.gold,
        unselectedItemColor: p.lightGray,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        selectedLabelStyle:
            const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle:
            const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
      ),

      progressIndicatorTheme:
          ProgressIndicatorThemeData(color: p.gold, linearMinHeight: 8),

      dialogTheme: DialogThemeData(
        backgroundColor: p.darkCharcoal,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titleTextStyle: TextStyle(
            fontSize: 20, fontWeight: FontWeight.w600, color: p.lighterGray),
        contentTextStyle: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w400, color: p.lighterGray),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: p.darkCharcoal,
        contentTextStyle: TextStyle(color: p.lighterGray, fontSize: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

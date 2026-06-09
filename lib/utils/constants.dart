/// App-wide non-visual constants (names, paddings, radii).
/// Colors live in `lib/config/theme.dart` — do not duplicate them here.
class AppConstants {
  AppConstants._();

  static const String appName = 'RationBox';
  static const String projectName = 'Smart Ration Box';

  // Paddings
  static const double smallPadding = 8.0;
  static const double mediumPadding = 12.0;
  static const double defaultPadding = 16.0;
  static const double largePadding = 24.0;

  // Border radius
  static const double smallBorderRadius = 8.0;
  static const double mediumBorderRadius = 12.0;
  static const double largeBorderRadius = 16.0;
  static const double extraLargeBorderRadius = 24.0;
}

import 'package:flutter/material.dart';

import 'theme.dart';

/// Holds the app-wide theme selection and notifies listeners on change.
///
/// Lightweight on purpose — no extra state-management packages. A single
/// shared [instance] is read by the Settings toggle and by the root app
/// (see `app.dart`), which rebuilds when this notifies.
///
/// Note: the choice lives in memory only (resets on full reload). Persisting
/// it would need `shared_preferences`; we avoid adding a dependency for now.
class ThemeController extends ChangeNotifier {
  ThemeController._();

  /// Shared instance used across the app.
  static final ThemeController instance = ThemeController._();

  bool _premiumDark = false;

  /// True when the optional Premium Dark theme is active.
  bool get isPremiumDark => _premiumDark;

  /// The ThemeData currently in effect (Light Oak by default).
  ThemeData get themeData =>
      _premiumDark ? AppTheme.premiumDarkTheme : AppTheme.lightOakTheme;

  /// Enable/disable Premium Dark. Also flips the active palette so the static
  /// `AppTheme.xxx` colour getters resolve to the matching values.
  void setPremiumDark(bool value) {
    if (_premiumDark == value) return;
    _premiumDark = value;
    AppTheme.usePalette(value);
    notifyListeners();
  }

  void toggle() => setPremiumDark(!_premiumDark);
}

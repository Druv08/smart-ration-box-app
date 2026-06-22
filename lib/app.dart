import 'package:flutter/material.dart';
import 'config/theme.dart';
import 'screens/home_screen.dart';
import 'utils/constants.dart';

class SmartRationBoxApp extends StatelessWidget {
  const SmartRationBoxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      // Force a phone-sized frame when viewed in a wide browser window.
      builder: (context, child) => _MobileFrame(child: child!),
      home: const HomeScreen(),
    );
  }
}

/// Wraps the app in a phone-shaped frame on wide screens (web / desktop),
/// so the UI keeps its mobile look in Chrome without using device emulation.
class _MobileFrame extends StatelessWidget {
  final Widget child;
  const _MobileFrame({required this.child});

  static const double _phoneWidth = 412; // typical phone width (logical px)
  static const double _phoneHeight = 892;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // On small/mobile screens, just render the app full-bleed.
    if (size.width <= 600) return child;

    // On wider screens, show a centered phone-shaped frame.
    return Scaffold(
      backgroundColor: const Color(0xFFE7E0D4), // warm light surround
      body: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Container(
            width: _phoneWidth,
            height: _phoneHeight.clamp(0, size.height - 32).toDouble(),
            decoration: BoxDecoration(
              color: AppTheme.darkBg,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6B5740).withValues(alpha: 0.25),
                  blurRadius: 30,
                  offset: const Offset(0, 12),
                ),
              ],
              border: Border.all(color: const Color(0x14000000), width: 1),
            ),
            child: MediaQuery(
              // Tell the app it's running on a phone-sized viewport.
              data: MediaQuery.of(context).copyWith(
                size: Size(_phoneWidth, _phoneHeight),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

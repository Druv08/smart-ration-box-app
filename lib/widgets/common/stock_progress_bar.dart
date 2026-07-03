import 'package:flutter/material.dart';
import '../../config/theme.dart';

/// Rounded stock level bar. Animates smoothly when [value] changes.
/// Colour follows the stock level unless [color] is provided.
class StockProgressBar extends StatelessWidget {
  /// 0.0 – 1.0
  final double value;
  final double height;
  final Color? color;

  const StockProgressBar({
    super.key,
    required this.value,
    this.height = 8,
    this.color,
  });

  Color _autoColor(double v) {
    if (v <= 0.25) return AppTheme.lowStock;
    if (v <= 0.5) return AppTheme.amber;
    return AppTheme.accentGreen;
  }

  @override
  Widget build(BuildContext context) {
    final clamped = value.clamp(0.0, 1.0);
    final barColor = color ?? _autoColor(clamped);
    return ClipRRect(
      borderRadius: BorderRadius.circular(height),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: clamped),
        duration: const Duration(milliseconds: 550),
        curve: Curves.easeOutCubic,
        builder: (context, v, _) => LinearProgressIndicator(
          value: v,
          minHeight: height,
          backgroundColor: AppTheme.divider,
          valueColor: AlwaysStoppedAnimation(barColor),
        ),
      ),
    );
  }
}

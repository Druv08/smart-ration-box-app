import 'package:flutter/material.dart';
import '../../config/theme.dart';

/// Premium card widget with luxury styling and optional glow effect
class LuxuryCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onTap;
  final bool showGlow;

  const LuxuryCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.backgroundColor,
    this.borderRadius,
    this.border,
    this.boxShadow,
    this.onTap,
    this.showGlow = false,
  });

  @override
  Widget build(BuildContext context) {
    final defaultShadow = showGlow
        ? [
            BoxShadow(
              color: AppTheme.gold.withValues(alpha:0.15),
              blurRadius: 20,
              spreadRadius: 2,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha:0.3),
              blurRadius: 8,
              spreadRadius: 0,
            ),
          ]
        : [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.25),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor ?? AppTheme.darkCharcoal,
          borderRadius: borderRadius ?? BorderRadius.circular(16),
          border:
              border ?? Border.all(color: AppTheme.darkerCharcoal, width: 1),
          boxShadow: boxShadow ?? defaultShadow,
        ),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

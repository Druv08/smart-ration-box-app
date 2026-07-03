import 'package:flutter/material.dart';
import '../../config/theme.dart';

/// Rounded white surface with a subtle warm shadow — the base container
/// for the whole design system. Tapping gives a Material ripple.
class PrimaryCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final Color? color;
  final double radius;
  final VoidCallback? onTap;
  final Border? border;
  final List<BoxShadow>? shadow;

  const PrimaryCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color,
    this.radius = 20,
    this.onTap,
    this.border,
    this.shadow,
  });

  @override
  Widget build(BuildContext context) {
    final br = BorderRadius.circular(radius);
    return Container(
      decoration: BoxDecoration(
        color: color ?? AppTheme.card,
        borderRadius: br,
        border: border ?? Border.all(color: AppTheme.divider, width: 1),
        boxShadow: shadow ??
            [
              BoxShadow(
                color: const Color(0xFF7A6A55).withValues(alpha: 0.08),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
      ),
      child: Material(
        type: MaterialType.transparency,
        borderRadius: br,
        child: InkWell(
          onTap: onTap,
          borderRadius: br,
          splashColor: AppTheme.primary.withValues(alpha: 0.08),
          highlightColor: AppTheme.primary.withValues(alpha: 0.04),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

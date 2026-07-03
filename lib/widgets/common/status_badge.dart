import 'package:flutter/material.dart';
import '../../config/theme.dart';

/// A small pill showing a status with an icon + label.
/// Use the named constructors for the common cases.
class StatusBadge extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final Color background;

  const StatusBadge({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.background,
  });

  /// Healthy / normal stock — muted green.
  factory StatusBadge.normal({String label = 'Normal Stock'}) => StatusBadge(
        label: label,
        icon: Icons.check_circle_rounded,
        color: AppTheme.accentGreen,
        background: AppTheme.accentGreenTint,
      );

  /// Low stock — soft red.
  factory StatusBadge.low({String label = 'Low Stock'}) => StatusBadge(
        label: label,
        icon: Icons.error_rounded,
        color: AppTheme.lowStock,
        background: AppTheme.lowStockTint,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(label, style: AppTheme.label(12, color: color)),
        ],
      ),
    );
  }
}

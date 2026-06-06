import 'package:flutter/material.dart';
import '../../config/theme.dart';

/// Status indicator pill widget for showing connection, battery, refill status, etc.
class StatusIndicator extends StatelessWidget {
  final bool isActive;
  final String label;
  final IconData icon;
  final Color? activeColor;
  final Color? inactiveColor;
  final bool showDot;

  const StatusIndicator({
    super.key,
    required this.isActive,
    required this.label,
    required this.icon,
    this.activeColor,
    this.inactiveColor,
    this.showDot = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive
        ? (activeColor ?? AppTheme.successGreen)
        : (inactiveColor ?? AppTheme.errorRed);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.25), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDot)
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.6),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          if (showDot) const SizedBox(width: 6),
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

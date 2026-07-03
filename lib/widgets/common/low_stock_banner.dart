import 'package:flutter/material.dart';
import '../../config/theme.dart';

/// Soft-red banner used to call out a low-stock / claim situation.
class LowStockBanner extends StatelessWidget {
  final String message;
  final IconData icon;
  final Widget? trailing;

  const LowStockBanner({
    super.key,
    required this.message,
    this.icon = Icons.error_rounded,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.lowStockTint,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppTheme.lowStock),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: AppTheme.label(12, color: AppTheme.lowStock),
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: 8), trailing!],
        ],
      ),
    );
  }
}

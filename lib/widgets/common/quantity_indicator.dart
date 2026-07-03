import 'package:flutter/material.dart';
import '../../config/theme.dart';

/// Shows "remaining / capacity unit" with a bold remaining figure, and an
/// optional percentage chip on the right.
class QuantityIndicator extends StatelessWidget {
  final double quantity;
  final double capacity;
  final String unit;
  final bool showPercent;

  const QuantityIndicator({
    super.key,
    required this.quantity,
    required this.capacity,
    required this.unit,
    this.showPercent = true,
  });

  @override
  Widget build(BuildContext context) {
    final percent =
        capacity <= 0 ? 0.0 : (quantity / capacity * 100).clamp(0, 100);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(_fmt(quantity), style: AppTheme.number(18)),
        const SizedBox(width: 2),
        Text(
          ' / ${_fmt(capacity)} $unit',
          style: AppTheme.body(12, color: AppTheme.textSecondary),
        ),
        const Spacer(),
        if (showPercent)
          Text(
            '${percent.toStringAsFixed(0)}%',
            style: AppTheme.number(14, color: AppTheme.woodText),
          ),
      ],
    );
  }

  String _fmt(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);
}

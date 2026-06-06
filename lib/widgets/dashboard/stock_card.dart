import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../models/smart_box_data.dart';
import '../common/luxury_card.dart';

/// Stock card showing container info, level, and progress
class StockCard extends StatelessWidget {
  final SmartBoxData data;
  final VoidCallback? onTap;

  const StockCard({super.key, required this.data, this.onTap});

  @override
  Widget build(BuildContext context) {
    final percent = (data.stockLevel / 100).clamp(0.0, 1.0);
    final isLowStock = data.stockLevel < 25;

    return LuxuryCard(
      onTap: onTap,
      showGlow: true,
      padding: const EdgeInsets.all(20),
      backgroundColor: AppTheme.darkerCharcoal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.containerName,
                      style: const TextStyle(
                        color: AppTheme.gold,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Smart Ration Container',
                      style: TextStyle(color: AppTheme.lightGray, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color:
                      (isLowStock
                              ? AppTheme.warningOrange
                              : AppTheme.successGreen)
                          .withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isLowStock ? Icons.warning_rounded : Icons.check_circle,
                  color: isLowStock
                      ? AppTheme.warningOrange
                      : AppTheme.successGreen,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Stock Level Display
          Text(
            '${data.stockLevel.toStringAsFixed(0)}% full',
            style: const TextStyle(
              color: AppTheme.lighterGray,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${data.currentWeight} kg / ${data.capacity} kg',
            style: TextStyle(color: AppTheme.lightGray, fontSize: 13),
          ),
          const SizedBox(height: 14),

          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 10,
              backgroundColor: AppTheme.darkerCharcoal.withOpacity(0.5),
              valueColor: AlwaysStoppedAnimation(
                isLowStock ? AppTheme.warningOrange : AppTheme.gold,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Status Chip
          if (isLowStock)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.warningOrange.withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: AppTheme.warningOrange.withOpacity(0.3),
                ),
              ),
              child: const Text(
                '⚠ Low Stock - Plan Refill',
                style: TextStyle(
                  color: AppTheme.warningOrange,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

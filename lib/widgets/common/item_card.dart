import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../models/inventory_item.dart';
import '../../utils/item_visuals.dart';
import 'app_buttons.dart';
import 'primary_card.dart';
import 'quantity_indicator.dart';
import 'status_badge.dart';
import 'stock_progress_bar.dart';

/// The core inventory card used on the Dashboard and Items screens.
/// Shows icon, name, quantity, progress and — when low — the claim state.
class ItemCard extends StatelessWidget {
  final InventoryItem item;

  /// Name of the signed-in user, used to phrase the claim label ("You").
  final String currentUser;
  final VoidCallback? onTap;

  /// Called when the user taps "Claim". Omit to hide the claim button.
  final VoidCallback? onClaim;

  const ItemCard({
    super.key,
    required this.item,
    required this.currentUser,
    this.onTap,
    this.onClaim,
  });

  @override
  Widget build(BuildContext context) {
    final low = item.isLowStock;
    return PrimaryCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _iconTile(low),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.heading(15),
                    ),
                    const SizedBox(height: 2),
                    Text(item.category, style: AppTheme.body(12)),
                  ],
                ),
              ),
              if (low) StatusBadge.low() else StatusBadge.normal(),
            ],
          ),
          const SizedBox(height: 16),
          QuantityIndicator(
            quantity: item.quantity,
            capacity: item.capacity,
            unit: item.unit,
          ),
          const SizedBox(height: 10),
          StockProgressBar(value: item.percentageFull / 100),
          if (low || item.isClaimed) ...[
            const SizedBox(height: 14),
            _claimSection(context),
          ],
        ],
      ),
    );
  }

  Widget _iconTile(bool low) {
    final bg = low ? AppTheme.lowStockTint : AppTheme.primaryTint;
    final fg = low ? AppTheme.lowStock : AppTheme.primary;
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(iconForCategory(item.category), color: fg, size: 24),
    );
  }

  Widget _claimSection(BuildContext context) {
    // Claimed → show who is responsible.
    if (item.isClaimed) {
      final who =
          item.claimedBy == currentUser ? 'You' : item.claimedBy!;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppTheme.accentGreenTint,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const Icon(Icons.verified_user_rounded,
                size: 16, color: AppTheme.accentGreen),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '$who will refill this item',
                style: AppTheme.label(12, color: AppTheme.accentGreen),
              ),
            ),
          ],
        ),
      );
    }

    // Low + unclaimed → prompt to claim.
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.lowStockTint,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.pan_tool_alt_rounded,
              size: 16, color: AppTheme.lowStock),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Waiting for someone to claim',
              style: AppTheme.label(12, color: AppTheme.lowStock),
            ),
          ),
          if (onClaim != null) ...[
            const SizedBox(width: 8),
            SizedBox(
              height: 34,
              child: PrimaryButton(
                label: 'Claim',
                onPressed: onClaim,
                expand: false,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

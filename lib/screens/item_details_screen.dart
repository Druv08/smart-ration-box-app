import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../models/inventory_item.dart';
import '../utils/item_visuals.dart';
import '../widgets/common/app_buttons.dart';
import '../widgets/common/low_stock_banner.dart';
import '../widgets/common/primary_card.dart';
import '../widgets/common/status_badge.dart';
import '../widgets/common/stock_progress_bar.dart';

/// Detailed view of a single inventory item, with the claim-responsibility
/// action. Claiming is delegated to [onClaim] (the Items screen persists it)
/// and the returned item refreshes this view.
class ItemDetailsScreen extends StatefulWidget {
  final InventoryItem item;
  final String currentUser;
  final Future<InventoryItem> Function()? onClaim;

  const ItemDetailsScreen({
    super.key,
    required this.item,
    required this.currentUser,
    this.onClaim,
  });

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  late InventoryItem _item = widget.item;
  bool _claiming = false;

  Future<void> _claim() async {
    if (widget.onClaim == null) return;
    setState(() => _claiming = true);
    final updated = await widget.onClaim!();
    if (!mounted) return;
    setState(() {
      _item = updated;
      _claiming = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final item = _item;
    final low = item.isLowStock;

    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(title: const Text('Item Details')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            // Hero icon + name
            Center(
              child: Column(
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: low ? AppTheme.lowStockTint : AppTheme.primaryTint,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Icon(
                      iconForCategory(item.category),
                      size: 44,
                      color: low ? AppTheme.lowStock : AppTheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(item.name, style: AppTheme.heading(22)),
                  const SizedBox(height: 4),
                  Text(item.category, style: AppTheme.body(13)),
                  const SizedBox(height: 12),
                  low ? StatusBadge.low() : StatusBadge.normal(),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Level card
            PrimaryCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        item.percentageFull.toStringAsFixed(0),
                        style: AppTheme.number(34),
                      ),
                      Text('%  remaining', style: AppTheme.body(14)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  StockProgressBar(value: item.percentageFull / 100, height: 10),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Stats grid
            Row(
              children: [
                Expanded(
                  child: _StatTile(
                    label: 'Current',
                    value: '${_fmt(item.quantity)} ${item.unit}',
                    icon: Icons.scale_rounded,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatTile(
                    label: 'Max Capacity',
                    value: '${_fmt(item.capacity)} ${item.unit}',
                    icon: Icons.inbox_rounded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StatTile(
                    label: 'Low Threshold',
                    value: '${_fmt(item.effectiveThreshold)} ${item.unit}',
                    icon: Icons.trending_down_rounded,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatTile(
                    label: 'Location',
                    value: item.location,
                    icon: Icons.place_rounded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Responsibility
            if (item.isClaimed)
              _ResponsibleCard(
                name: item.claimedBy == widget.currentUser
                    ? 'You'
                    : item.claimedBy!,
              )
            else if (low)
              const LowStockBanner(
                message: 'Waiting for someone to claim responsibility',
                icon: Icons.pan_tool_alt_rounded,
              ),

            if (low || item.isClaimed) const SizedBox(height: 20),

            // Primary action
            PrimaryButton(
              label: item.isClaimed ? 'Already Claimed' : 'Claim Responsibility',
              icon: item.isClaimed
                  ? Icons.check_rounded
                  : Icons.volunteer_activism_rounded,
              loading: _claiming,
              onPressed:
                  item.isClaimed || widget.onClaim == null ? null : _claim,
            ),
          ],
        ),
      ),
    );
  }

  String _fmt(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return PrimaryCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppTheme.primary),
          const SizedBox(height: 10),
          Text(label, style: AppTheme.body(11)),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTheme.number(14),
          ),
        ],
      ),
    );
  }
}

class _ResponsibleCard extends StatelessWidget {
  final String name;
  const _ResponsibleCard({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.accentGreenTint,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 18,
            backgroundColor: AppTheme.accentGreen,
            child: Icon(Icons.person_rounded, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$name will refill this item',
                    style: AppTheme.label(13, color: AppTheme.textPrimary)),
                const SizedBox(height: 2),
                Text('Responsibility claimed', style: AppTheme.body(11)),
              ],
            ),
          ),
          const Icon(Icons.verified_rounded,
              color: AppTheme.accentGreen, size: 20),
        ],
      ),
    );
  }
}

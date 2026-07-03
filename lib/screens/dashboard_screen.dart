import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../data/mock_data.dart';
import '../models/inventory_item.dart';
import '../models/smart_box_data.dart';
import '../services/box_data_source.dart';
import '../services/local_store.dart';
import '../services/mock_box_data_source.dart';
import '../widgets/common/item_card.dart';
import '../widgets/common/primary_card.dart';
import 'item_details_screen.dart';
import 'progress_screen.dart';
import 'shopping_list_screen.dart';

/// Home dashboard: greeting, device status, the user's items and recent
/// activity. Reads boxes via a [BoxDataSource] (unchanged) and inventory
/// via [LocalStore].
class DashboardScreen extends StatefulWidget {
  /// Lets the dashboard switch the bottom-nav tab (e.g. "See all" → Items).
  final void Function(int tabIndex)? onOpenTab;

  const DashboardScreen({super.key, this.onOpenTab});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final BoxDataSource _dataSource = const MockBoxDataSource();
  static const _currentUser = MockData.currentUserName;

  SmartBoxData? _primary;
  List<InventoryItem> _inventory = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final boxes = await _dataSource.fetchBoxes();
    final inventory = await LocalStore.loadInventory();
    if (!mounted) return;
    setState(() {
      _primary = boxes.isNotEmpty ? boxes.first : null;
      _inventory = inventory ?? List.of(MockData.inventoryItems);
    });
  }

  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }

  /// Attention-first ordering: low stock items surface at the top.
  List<InventoryItem> get _myItems {
    final sorted = List.of(_inventory)
      ..sort((a, b) {
        if (a.isLowStock == b.isLowStock) return 0;
        return a.isLowStock ? -1 : 1;
      });
    return sorted.take(3).toList();
  }

  InventoryItem _claim(InventoryItem item) {
    final index = _inventory.indexOf(item);
    final updated = item.copyWith(claimedBy: _currentUser);
    if (index != -1) {
      setState(() => _inventory[index] = updated);
      LocalStore.saveInventory(_inventory);
    }
    return updated;
  }

  void _openDetails(InventoryItem item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ItemDetailsScreen(
          item: item,
          currentUser: _currentUser,
          onClaim: item.isClaimed ? null : () async => _claim(item),
        ),
      ),
    );
  }

  void _push(Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          children: [
            _header(),
            const SizedBox(height: 20),
            _banner(),
            const SizedBox(height: 16),
            if (_primary != null) _statusRow(_primary!),
            const SizedBox(height: 16),
            _quickAccess(),
            const SizedBox(height: 24),
            _sectionHeader('My Items', onAction: () => widget.onOpenTab?.call(1)),
            const SizedBox(height: 12),
            ..._myItems.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: ItemCard(
                  item: item,
                  currentUser: _currentUser,
                  onTap: () => _openDetails(item),
                  onClaim: item.isClaimed ? null : () => _claim(item),
                ),
              ),
            ),
            const SizedBox(height: 12),
            _sectionHeader('Recent Activity'),
            const SizedBox(height: 12),
            _recentActivity(),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_greeting, style: AppTheme.body(13)),
              const SizedBox(height: 2),
              Text(_currentUser, style: AppTheme.heading(22)),
            ],
          ),
        ),
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: AppTheme.primaryTint,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.person_rounded, color: AppTheme.primary),
        ),
      ],
    );
  }

  Widget _banner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.primary, AppTheme.primaryDark],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Smart Ration Storage',
                    style: AppTheme.heading(18, color: Colors.white)),
                const SizedBox(height: 6),
                Text(
                  'Track every container and never run out.',
                  style: AppTheme.body(12, color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.inventory_2_rounded,
                color: Colors.white, size: 32),
          ),
        ],
      ),
    );
  }

  Widget _statusRow(SmartBoxData box) {
    return Row(
      children: [
        Expanded(
          child: _StatusTile(
            icon: box.isBatteryLow
                ? Icons.battery_alert_rounded
                : Icons.battery_full_rounded,
            label: 'Battery',
            value: '${box.battery}%',
            tint: box.isBatteryLow ? AppTheme.lowStock : AppTheme.accentGreen,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatusTile(
            icon: box.isOnline ? Icons.wifi_rounded : Icons.wifi_off_rounded,
            label: 'Connection',
            value: box.isOnline ? 'Online' : 'Offline',
            tint: box.isOnline ? AppTheme.accentGreen : AppTheme.lowStock,
          ),
        ),
      ],
    );
  }

  Widget _quickAccess() {
    return Row(
      children: [
        Expanded(
          child: _QuickTile(
            icon: Icons.shopping_cart_rounded,
            label: 'Shopping',
            onTap: () => _push(const ShoppingListScreen()),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickTile(
            icon: Icons.insights_rounded,
            label: 'Progress',
            onTap: () => _push(const ProgressScreen()),
          ),
        ),
      ],
    );
  }

  Widget _sectionHeader(String title, {VoidCallback? onAction}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTheme.heading(17)),
        if (onAction != null)
          GestureDetector(
            onTap: onAction,
            child: Text('See all',
                style: AppTheme.label(13, color: AppTheme.woodText)),
          ),
      ],
    );
  }

  Widget _recentActivity() {
    final history = MockData.refillHistory;
    return PrimaryCard(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        children: [
          for (var i = 0; i < history.length; i++) ...[
            if (i > 0) const Divider(height: 1, indent: 56),
            _ActivityRow(
              title: '${history[i].containerName} refilled',
              subtitle: _ago(history[i].date),
              amount: '+${history[i].amount} kg',
            ),
          ],
        ],
      ),
    );
  }

  String _ago(DateTime date) {
    final diff = DateTime.now().difference(date).inDays;
    if (diff <= 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return '$diff days ago';
  }
}

class _StatusTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color tint;

  const _StatusTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.tint,
  });

  @override
  Widget build(BuildContext context) {
    return PrimaryCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: tint.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: tint, size: 20),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTheme.body(11)),
              const SizedBox(height: 2),
              Text(value, style: AppTheme.number(15)),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PrimaryCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primary, size: 22),
          const SizedBox(width: 10),
          Text(label, style: AppTheme.label(14)),
          const Spacer(),
          Icon(Icons.chevron_right_rounded,
              color: AppTheme.textSecondary, size: 20),
        ],
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final String amount;

  const _ActivityRow({
    required this.title,
    required this.subtitle,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppTheme.accentGreenTint,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.local_shipping_rounded,
                color: AppTheme.accentGreen, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTheme.label(13)),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTheme.body(11)),
              ],
            ),
          ),
          Text(amount, style: AppTheme.number(13, color: AppTheme.woodText)),
        ],
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../data/mock_data.dart';
import '../models/smart_box_data.dart';
import '../services/box_data_source.dart';
import '../services/mock_box_data_source.dart';
import '../utils/item_images.dart';
import '../widgets/common/item_image.dart';
import '../widgets/common/luxury_card.dart';
import '../widgets/dashboard/alert_section.dart';
import 'item_details_screen.dart';

/// Main dashboard, styled after the light oak / kitchen product mockup.
/// Reads boxes through a [BoxDataSource] so we can swap dummy → Firebase →
/// ESP32 later without touching the UI, and listens to the live stream so
/// simulated hardware changes update the cards in real time.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // TODO: inject via provider once we adopt one.
  final BoxDataSource _dataSource = MockBoxDataSource();

  StreamSubscription<List<SmartBoxData>>? _subscription;
  List<SmartBoxData> _allBoxes = const [];
  SmartBoxData? _primary;

  @override
  void initState() {
    super.initState();
    // Listen to the live stream so simulated hardware changes (made on the
    // details page) reflect on the dashboard cards and alerts in real time.
    _subscription = _dataSource.watchBoxes().listen((boxes) {
      if (!mounted) return;
      setState(() {
        _allBoxes = boxes;
        _primary = boxes.isNotEmpty ? boxes.first : null;
      });
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _openDetails(SmartBoxData box) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ItemDetailsScreen(boxId: box.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = _primary;
    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      body: SafeArea(
        child: primary == null
            ? Center(
                child: CircularProgressIndicator(color: AppTheme.gold),
              )
            : ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                children: [
                  _GreetingHero(
                    primary: primary,
                    onMenu: _openMenu,
                    onNotifications: _openNotifications,
                  ),
                  const SizedBox(height: 16),
                  _StatusRow(primary: primary),
                  const SizedBox(height: 24),
                  _SectionHeader(
                    title: 'Your Items',
                    actionLabel: '+ Add Item',
                    onAction: () => _showComingSoon('Add Item'),
                  ),
                  const SizedBox(height: 12),
                  ..._allBoxes.map(
                    (box) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _ItemCard(
                        data: box,
                        onTap: () => _openDetails(box),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const _SectionHeader(title: 'Alerts & Notifications'),
                  const SizedBox(height: 12),
                  // Week 2 alert system, preserved. Shows the active alerts for
                  // the primary container, derived from live sensor data.
                  AlertSection(data: primary),
                  const SizedBox(height: 12),
                  const _SectionHeader(title: 'Recent Activity'),
                  const SizedBox(height: 12),
                  const _RecentActivity(),
                ],
              ),
      ),
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature is coming in a later week.')),
    );
  }

  /// Three-bar (hamburger) menu → app quick-actions sheet.
  void _openMenu() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppTheme.darkCharcoal,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.lightGray,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 8),
            _menuTile(ctx, Icons.notifications_none_rounded, 'Notifications',
                () {
              Navigator.pop(ctx);
              _openNotifications();
            }),
            _menuTile(ctx, Icons.refresh_rounded, 'Refresh data', () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Data refreshed')),
              );
            }),
            _menuTile(ctx, Icons.help_outline_rounded, 'Help & Support', () {
              Navigator.pop(ctx);
              showDialog<void>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Help & Support'),
                  content: Text(
                    'Need help with your Smart Ration Box?\n\n'
                    'Email: support@dazcan.com\n'
                    'Phone: +91 98765 43210',
                    style: TextStyle(color: AppTheme.lighterGray),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            }),
            _menuTile(ctx, Icons.info_outline_rounded, 'About', () {
              Navigator.pop(ctx);
              showAboutDialog(
                context: context,
                applicationName: 'Smart Ration Box',
                applicationVersion: 'v1.0.0',
                applicationIcon:
                    Icon(Icons.inventory_2_rounded, color: AppTheme.gold),
              );
            }),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _menuTile(
      BuildContext ctx, IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.gold),
      title: Text(label, style: TextStyle(color: AppTheme.lighterGray)),
      onTap: onTap,
    );
  }

  /// Bell icon → notifications sheet built from the live box data.
  void _openNotifications() {
    final notes = <_Notification>[];
    for (final box in _allBoxes) {
      if (!box.isOnline) {
        notes.add(_Notification(
          Icons.wifi_off_rounded,
          AppTheme.errorRed,
          '${box.containerName} is offline',
          'Check the device connection.',
        ));
      }
      if (box.isBatteryLow) {
        notes.add(_Notification(
          Icons.battery_alert_rounded,
          AppTheme.warningOrange,
          '${box.containerName} battery low',
          'Battery at ${box.battery}%.',
        ));
      }
      if (box.isLowStock) {
        notes.add(_Notification(
          Icons.error_outline_rounded,
          AppTheme.errorRed,
          '${box.containerName} low on stock',
          '${box.currentWeight} kg remaining — plan a refill.',
        ));
      }
      if (box.refillDetected) {
        notes.add(_Notification(
          Icons.autorenew_rounded,
          AppTheme.successGreen,
          '${box.containerName} refill detected',
          'Stock updated automatically.',
        ));
      }
    }

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppTheme.darkCharcoal,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Notifications',
                style: TextStyle(
                  color: AppTheme.lighterGray,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              if (notes.isEmpty)
                Row(
                  children: [
                    Icon(Icons.check_circle_rounded,
                        color: AppTheme.successGreen, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      "You're all caught up.",
                      style: TextStyle(color: AppTheme.lighterGray),
                    ),
                  ],
                )
              else
                ...notes.map(
                  (n) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: n.color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(n.icon, color: n.color, size: 18),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                n.title,
                                style: TextStyle(
                                  color: AppTheme.lighterGray,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                n.subtitle,
                                style: TextStyle(
                                    color: AppTheme.lightGray, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A single dashboard notification row model.
class _Notification {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  const _Notification(this.icon, this.color, this.title, this.subtitle);
}

/// Top greeting band + a decorative oak container "hero" image area.
class _GreetingHero extends StatelessWidget {
  final SmartBoxData primary;
  final VoidCallback onMenu;
  final VoidCallback onNotifications;
  const _GreetingHero({
    required this.primary,
    required this.onMenu,
    required this.onNotifications,
  });

  @override
  Widget build(BuildContext context) {
    final name = MockData.familyMembers.isNotEmpty
        ? MockData.familyMembers.first.name.split(' ').first
        : 'there';

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: SizedBox(
        height: 210,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background: a photo of what's actually in the primary box.
            ItemImage(
              url: heroImageUrl(primary.containerName),
              borderRadius: BorderRadius.zero,
              fallback: _oakGradient(),
            ),
            // Scrim so the greeting stays legible over any photo.
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.black.withValues(alpha: 0.20),
                    Colors.black.withValues(alpha: 0.72),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: onMenu,
                        customBorder: const CircleBorder(),
                        child: const Padding(
                          padding: EdgeInsets.all(4),
                          child: Icon(Icons.menu_rounded, color: Colors.white),
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: onNotifications,
                        customBorder: const CircleBorder(),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              const Icon(Icons.notifications_none_rounded,
                                  color: Colors.white),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: AppTheme.gold,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Text(
                    'Welcome back,',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$name!',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Here's what's in your ration box "
                          '— ${primary.currentWeight} kg on hand.',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Fallback backdrop (shown while the photo loads or if it fails).
  Widget _oakGradient() {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFD9B98C), Color(0xFFB07D4B)],
        ),
      ),
    );
  }
}

/// Battery + Connection status cards (PDF: two soft cards side by side).
class _StatusRow extends StatelessWidget {
  final SmartBoxData primary;
  const _StatusRow({required this.primary});

  @override
  Widget build(BuildContext context) {
    final batteryOk = !primary.isBatteryLow;
    final online = primary.isOnline;
    return Row(
      children: [
        Expanded(
          child: _StatusCard(
            icon: Icons.battery_charging_full_rounded,
            iconColor: batteryOk ? AppTheme.successGreen : AppTheme.errorRed,
            label: 'Battery',
            value: '${primary.battery}%',
            sub: batteryOk ? 'Good' : 'Low',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatusCard(
            icon: online ? Icons.wifi_rounded : Icons.wifi_off_rounded,
            iconColor: online ? AppTheme.successGreen : AppTheme.errorRed,
            label: 'Connection',
            value: online ? 'Connected' : 'Offline',
            sub: online ? 'Live' : 'No signal',
          ),
        ),
      ],
    );
  }
}

class _StatusCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String sub;

  const _StatusCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.sub,
  });

  @override
  Widget build(BuildContext context) {
    return LuxuryCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: AppTheme.lightGray, fontSize: 11),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    color: AppTheme.lighterGray,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  sub,
                  style: TextStyle(color: AppTheme.lightGray, fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A ration item card: name, remaining weight, status chip, percentage,
/// progress bar, and (when low) a refill hint row. Tappable → Item Details.
class _ItemCard extends StatelessWidget {
  final SmartBoxData data;
  final VoidCallback onTap;

  const _ItemCard({required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final low = data.isLowStock;
    final percent = (data.stockPercentage / 100).clamp(0.0, 1.0);
    final accent = low ? AppTheme.errorRed : AppTheme.successGreen;

    return LuxuryCard(
      padding: const EdgeInsets.all(14),
      onTap: onTap,
      child: Column(
        children: [
          Row(
            children: [
              ItemImage(
                url: imageUrlForItem(data.containerName),
                width: 52,
                height: 52,
                borderRadius: BorderRadius.circular(14),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.containerName,
                      style: TextStyle(
                        color: AppTheme.lighterGray,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${data.currentWeight} kg remaining',
                      style: TextStyle(color: AppTheme.lightGray, fontSize: 12),
                    ),
                    const SizedBox(height: 6),
                    _StatusChip(low: low),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${data.stockPercentage.toStringAsFixed(0)}%',
                    style: TextStyle(
                      color: accent,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'of ${data.capacity} kg',
                    style: TextStyle(color: AppTheme.lightGray, fontSize: 11),
                  ),
                ],
              ),
              const SizedBox(width: 4),
              Icon(Icons.chevron_right_rounded,
                  color: AppTheme.lightGray, size: 20),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 8,
              backgroundColor: AppTheme.darkerCharcoal,
              valueColor: AlwaysStoppedAnimation(accent),
            ),
          ),
          if (low) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.errorRed.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.hourglass_empty_rounded,
                      color: AppTheme.errorRed, size: 14),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Low stock — plan a refill',
                      style: TextStyle(
                        color: AppTheme.errorRed,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final bool low;
  const _StatusChip({required this.low});

  @override
  Widget build(BuildContext context) {
    final color = low ? AppTheme.errorRed : AppTheme.successGreen;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(low ? Icons.error_outline_rounded : Icons.check_circle_rounded,
              color: color, size: 12),
          const SizedBox(width: 4),
          Text(
            low ? 'Low Stock' : 'Normal Stock',
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Recent refill activity pulled from mock refill history (display-only).
class _RecentActivity extends StatelessWidget {
  const _RecentActivity();

  String _ago(DateTime date) {
    final diff = DateTime.now().difference(date).inDays;
    if (diff <= 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return '$diff days ago';
  }

  @override
  Widget build(BuildContext context) {
    final entries = [...MockData.refillHistory]
      ..sort((a, b) => b.date.compareTo(a.date));
    final recent = entries.take(3).toList();

    return LuxuryCard(
      child: Column(
        children: [
          for (var i = 0; i < recent.length; i++)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                border: i == recent.length - 1
                    ? null
                    : Border(
                        bottom: BorderSide(
                            color: AppTheme.darkerCharcoal, width: 1),
                      ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.successGreen.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.autorenew_rounded,
                        color: AppTheme.successGreen, size: 16),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${recent[i].containerName} was refilled',
                          style: TextStyle(
                            color: AppTheme.lighterGray,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '+${recent[i].amount} kg • ${_ago(recent[i].date)}',
                          style: TextStyle(
                              color: AppTheme.lightGray, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _SectionHeader({
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppTheme.lighterGray,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (actionLabel != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              actionLabel!,
              style: TextStyle(
                color: AppTheme.gold,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}

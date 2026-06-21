import 'dart:async';

import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../models/smart_box_data.dart';
import '../services/box_data_source.dart';
import '../services/mock_box_data_source.dart';
import '../widgets/common/luxury_card.dart';
import '../widgets/common/status_indicator.dart';
import '../widgets/dashboard/alert_section.dart';
import '../widgets/dashboard/device_info_grid.dart';
import '../widgets/dashboard/stock_card.dart';
import 'item_details_screen.dart';

/// Main dashboard. Reads boxes through a [BoxDataSource] so we can
/// swap dummy → Firebase → ESP32 later without touching the UI.
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
    // details page) reflect on the dashboard alerts in real time.
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
            ? const Center(
                child: CircularProgressIndicator(color: AppTheme.gold),
              )
            : _buildContent(primary),
      ),
    );
  }

  Widget _buildContent(SmartBoxData primary) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: AppTheme.darkBg,
          floating: true,
          pinned: false,
          elevation: 0,
          centerTitle: false,
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Dashboard',
                style: TextStyle(
                  color: AppTheme.lighterGray,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Smart Ration Monitoring',
                style: TextStyle(
                  color: AppTheme.lightGray,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: StatusIndicator(
                  isActive: primary.isOnline,
                  label: primary.isOnline ? 'Online' : 'Offline',
                  icon: primary.isOnline ? Icons.wifi : Icons.wifi_off,
                  activeColor: AppTheme.successGreen,
                  inactiveColor: AppTheme.errorRed,
                  showDot: true,
                ),
              ),
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                StockCard(data: primary, onTap: () => _openDetails(primary)),
                const SizedBox(height: 24),
                const _SectionHeader(title: 'Device Information'),
                const SizedBox(height: 12),
                DeviceInfoGrid(data: primary),
                const SizedBox(height: 24),
                const _SectionHeader(title: 'Quick Stats'),
                const SizedBox(height: 12),
                _QuickStatsGrid(data: primary),
                const SizedBox(height: 24),
                if (_allBoxes.length > 1) ...[
                  const _SectionHeader(
                    title: 'Other Containers',
                    actionLabel: 'View All',
                  ),
                  const SizedBox(height: 12),
                  ..._buildOtherContainers(),
                  const SizedBox(height: 24),
                ],
                const _SectionHeader(title: 'Alerts & Notifications'),
                const SizedBox(height: 12),
                AlertSection(data: primary),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildOtherContainers() {
    return _allBoxes.skip(1).map((box) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: LuxuryCard(
          padding: const EdgeInsets.all(14),
          onTap: () => _openDetails(box),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.gold.withValues(alpha:0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.inventory_2,
                  color: AppTheme.gold,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      box.containerName,
                      style: const TextStyle(
                        color: AppTheme.lighterGray,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${box.stockPercentage.toStringAsFixed(0)}% • ${box.currentWeight}/${box.capacity}kg',
                      style: const TextStyle(
                        color: AppTheme.lightGray,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: AppTheme.gold,
                size: 16,
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;

  const _SectionHeader({
    required this.title,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppTheme.lighterGray,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (actionLabel != null)
          GestureDetector(
            child: Text(
              actionLabel!,
              style: const TextStyle(
                color: AppTheme.gold,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}

class _QuickStatsGrid extends StatelessWidget {
  final SmartBoxData data;
  const _QuickStatsGrid({required this.data});

  String _lastRefillLabel() {
    final date = data.lastRefillDate;
    if (date == null) return 'Unknown';
    final diff = DateTime(2026, 6, 10).difference(date).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return '$diff days ago';
  }

  @override
  Widget build(BuildContext context) {
    final consumed = (data.capacity - data.currentWeight).clamp(0.0, data.capacity);
    return Row(
      children: [
        Expanded(
          child: LuxuryCard(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                const Icon(Icons.trending_up, color: AppTheme.gold, size: 20),
                const SizedBox(height: 8),
                const Text(
                  'Consumed',
                  style: TextStyle(color: AppTheme.lightGray, fontSize: 11),
                ),
                const SizedBox(height: 4),
                Text(
                  '${consumed.toStringAsFixed(2)} kg',
                  style: const TextStyle(
                    color: AppTheme.lighterGray,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: LuxuryCard(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                const Icon(Icons.calendar_today, color: AppTheme.gold, size: 20),
                const SizedBox(height: 8),
                const Text(
                  'Last Refill',
                  style: TextStyle(color: AppTheme.lightGray, fontSize: 11),
                ),
                const SizedBox(height: 4),
                Text(
                  _lastRefillLabel(),
                  style: const TextStyle(
                    color: AppTheme.lighterGray,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

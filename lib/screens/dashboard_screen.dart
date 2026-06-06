import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../data/mock_data.dart';
import '../models/smart_box_data.dart';
import '../widgets/dashboard/stock_card.dart';
import '../widgets/dashboard/device_info_grid.dart';
import '../widgets/common/status_indicator.dart';
import '../widgets/common/luxury_card.dart';

/// Enhanced dashboard screen for luxury theme
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late SmartBoxData primaryBoxData;
  late List<SmartBoxData> allBoxes;

  @override
  void initState() {
    super.initState();
    primaryBoxData = MockData.riceBox;
    allBoxes = [MockData.riceBox, MockData.wheatBox];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              backgroundColor: AppTheme.darkBg,
              floating: true,
              pinned: false,
              elevation: 0,
              centerTitle: false,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Dashboard',
                    style: TextStyle(
                      color: AppTheme.lighterGray,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
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
                      isActive: primaryBoxData.isOnline,
                      label: primaryBoxData.isOnline ? 'Online' : 'Offline',
                      icon: primaryBoxData.isOnline
                          ? Icons.wifi
                          : Icons.wifi_off,
                      activeColor: AppTheme.successGreen,
                      inactiveColor: AppTheme.errorRed,
                      showDot: true,
                    ),
                  ),
                ),
              ],
            ),

            // Main Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Primary Stock Card
                    const SizedBox(height: 8),
                    StockCard(data: primaryBoxData),
                    const SizedBox(height: 24),

                    // Device Info Section
                    _SectionHeader(title: 'Device Information'),
                    const SizedBox(height: 12),
                    DeviceInfoGrid(data: primaryBoxData),
                    const SizedBox(height: 24),

                    // Quick Stats Section
                    _SectionHeader(title: 'Quick Stats'),
                    const SizedBox(height: 12),
                    _QuickStatsGrid(data: primaryBoxData),
                    const SizedBox(height: 24),

                    // Other Containers
                    if (allBoxes.length > 1) ...[
                      _SectionHeader(
                        title: 'Other Containers',
                        actionLabel: 'View All',
                      ),
                      const SizedBox(height: 12),
                      ..._buildOtherContainers(),
                      const SizedBox(height: 24),
                    ],

                    // Alerts Section
                    _SectionHeader(title: 'Alerts & Notifications'),
                    const SizedBox(height: 12),
                    _AlertsSection(data: primaryBoxData),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildOtherContainers() {
    return allBoxes.skip(1).map((box) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: LuxuryCard(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.gold.withOpacity(0.15),
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
                      '${box.stockLevel.toStringAsFixed(0)}% • ${box.currentWeight}/${box.capacity}kg',
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
  final VoidCallback? onActionTap;

  const _SectionHeader({
    required this.title,
    this.actionLabel,
    this.onActionTap,
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
            onTap: onActionTap,
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

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: LuxuryCard(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Icon(Icons.trending_up, color: AppTheme.gold, size: 20),
                const SizedBox(height: 8),
                Text(
                  'Consumption',
                  style: TextStyle(color: AppTheme.lightGray, fontSize: 11),
                ),
                const SizedBox(height: 4),
                Text(
                  '${(data.capacity - data.currentWeight).toStringAsFixed(2)} kg',
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
                Icon(Icons.calendar_today, color: AppTheme.gold, size: 20),
                const SizedBox(height: 8),
                Text(
                  'Last Refill',
                  style: TextStyle(color: AppTheme.lightGray, fontSize: 11),
                ),
                const SizedBox(height: 4),
                Text(
                  '15 days ago',
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
      ],
    );
  }
}

class _AlertsSection extends StatelessWidget {
  final SmartBoxData data;

  const _AlertsSection({required this.data});

  @override
  Widget build(BuildContext context) {
    final alerts =
        <({String title, String message, Color color, IconData icon})>[];

    if (data.stockLevel < 25) {
      alerts.add((
        title: 'Low Stock',
        message: 'Stock level is below 25%. Plan a refill soon.',
        color: AppTheme.warningOrange,
        icon: Icons.warning_rounded,
      ));
    }

    if (data.battery < 20) {
      alerts.add((
        title: 'Low Battery',
        message: 'Device battery is under 20%. Recharge soon.',
        color: AppTheme.errorRed,
        icon: Icons.battery_alert_rounded,
      ));
    }

    if (!data.isOnline) {
      alerts.add((
        title: 'Device Offline',
        message: 'Smart Ration Box is not reachable right now.',
        color: AppTheme.errorRed,
        icon: Icons.wifi_off_rounded,
      ));
    }

    if (data.refillDetected) {
      alerts.add((
        title: 'Refill Detected',
        message: 'A refill was detected on the container.',
        color: AppTheme.successGreen,
        icon: Icons.local_shipping_rounded,
      ));
    }

    if (alerts.isEmpty) {
      alerts.add((
        title: 'All Good',
        message: 'Everything is running normally.',
        color: AppTheme.successGreen,
        icon: Icons.check_circle_rounded,
      ));
    }

    return Column(
      children: alerts.map((alert) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: LuxuryCard(
            padding: const EdgeInsets.all(12),
            backgroundColor: alert.color.withOpacity(0.08),
            border: Border.all(color: alert.color.withOpacity(0.25)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: alert.color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(alert.icon, color: alert.color, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        alert.title,
                        style: TextStyle(
                          color: alert.color,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        alert.message,
                        style: const TextStyle(
                          color: AppTheme.lighterGray,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

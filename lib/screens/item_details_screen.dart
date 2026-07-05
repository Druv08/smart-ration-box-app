import 'package:flutter/material.dart';

import '../config/theme.dart';
import '../models/smart_box_data.dart';
import '../services/mock_box_data_source.dart';
import '../widgets/common/luxury_card.dart';
import '../widgets/dashboard/alert_section.dart';
import '../widgets/dashboard/device_info_grid.dart';
import '../widgets/dashboard/stock_card.dart';

/// Full details for a single Smart Ration Box.
///
/// Streams live snapshots from [MockBoxDataSource] so the page reacts to the
/// mock-hardware simulation buttons below in real time. When a real
/// Firebase/ESP32 [BoxDataSource] is wired up, the read path here stays the
/// same — only the simulation controls (which are mock-only) get removed.
class ItemDetailsScreen extends StatelessWidget {
  final String boxId;

  const ItemDetailsScreen({super.key, required this.boxId});

  @override
  Widget build(BuildContext context) {
    final source = MockBoxDataSource();

    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      appBar: AppBar(
        backgroundColor: AppTheme.darkBg,
        elevation: 0,
        iconTheme: IconThemeData(color: AppTheme.gold),
        title: Text(
          'Container Details',
          style: TextStyle(
            color: AppTheme.lighterGray,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<List<SmartBoxData>>(
          stream: source.watchBoxes(),
          builder: (context, snapshot) {
            final boxes = snapshot.data;
            final data = _findBox(boxes);

            if (data == null) {
              // Either still loading the first snapshot, or the id is unknown.
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(color: AppTheme.gold),
                );
              }
              return Center(
                child: Text(
                  'Container not found.',
                  style: TextStyle(color: AppTheme.lightGray),
                ),
              );
            }

            return _buildContent(context, source, data);
          },
        ),
      ),
    );
  }

  SmartBoxData? _findBox(List<SmartBoxData>? boxes) {
    if (boxes == null) return null;
    for (final box in boxes) {
      if (box.id == boxId) return box;
    }
    return null;
  }

  Widget _buildContent(
    BuildContext context,
    MockBoxDataSource source,
    SmartBoxData data,
  ) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Text(
          data.containerName,
          style: TextStyle(
            color: AppTheme.lighterGray,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        StockCard(data: data),
        const SizedBox(height: 24),
        const _SectionHeader(title: 'Device Information'),
        const SizedBox(height: 12),
        DeviceInfoGrid(data: data),
        const SizedBox(height: 24),
        const _SectionHeader(title: 'Stock Details'),
        const SizedBox(height: 12),
        _StockDetailsCard(data: data),
        const SizedBox(height: 24),
        const _SectionHeader(title: 'Alerts & Notifications'),
        const SizedBox(height: 12),
        AlertSection(data: data),
        const SizedBox(height: 24),
        const _SectionHeader(title: 'Mock Hardware Simulation'),
        const SizedBox(height: 4),
        Text(
          'Fake ESP32 sensor events to preview how alerts change. '
          'These controls disappear once real hardware is connected.',
          style: TextStyle(color: AppTheme.lightGray, fontSize: 12),
        ),
        const SizedBox(height: 12),
        _SimulationControls(source: source, data: data),
      ],
    );
  }
}

/// Card listing the textual stock fields not already covered by the grid:
/// stock %, stock status, low-stock threshold, and last refill date.
class _StockDetailsCard extends StatelessWidget {
  final SmartBoxData data;
  const _StockDetailsCard({required this.data});

  String get _lastRefillLabel {
    final date = data.lastRefillDate;
    if (date == null) return 'Unknown';
    final diff = DateTime.now().difference(date).inDays;
    final dateText = '${date.year}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
    if (diff <= 0) return '$dateText (Today)';
    if (diff == 1) return '$dateText (Yesterday)';
    return '$dateText ($diff days ago)';
  }

  @override
  Widget build(BuildContext context) {
    return LuxuryCard(
      child: Column(
        children: [
          _DetailRow(
            label: 'Stock Percentage',
            value: '${data.stockPercentage.toStringAsFixed(0)}%',
          ),
          _DetailRow(
            label: 'Stock Status',
            value: data.isLowStock ? 'Low Stock' : 'In Stock',
            valueColor:
                data.isLowStock ? AppTheme.warningOrange : AppTheme.successGreen,
          ),
          _DetailRow(
            label: 'Low Stock Threshold',
            value: '${data.lowStockThreshold.toStringAsFixed(0)}%',
          ),
          _DetailRow(
            label: 'Refill Status',
            value: data.refillDetected ? 'Refill Detected' : 'No Recent Refill',
            valueColor:
                data.refillDetected ? AppTheme.infoBlue : AppTheme.lightGray,
          ),
          _DetailRow(
            label: 'Last Refill',
            value: _lastRefillLabel,
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isLast;

  const _DetailRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(color: AppTheme.darkerCharcoal, width: 1),
              ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: AppTheme.lightGray, fontSize: 13),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? AppTheme.lighterGray,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Mock-only buttons that drive [MockBoxDataSource] simulation methods.
class _SimulationControls extends StatelessWidget {
  final MockBoxDataSource source;
  final SmartBoxData data;

  const _SimulationControls({required this.source, required this.data});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _SimButton(
          icon: Icons.trending_down,
          label: 'Consume 0.5kg',
          color: AppTheme.warningOrange,
          onTap: () => source.simulateConsume(data.id),
        ),
        _SimButton(
          icon: Icons.local_shipping_outlined,
          label: 'Refill Box',
          color: AppTheme.successGreen,
          onTap: () => source.simulateRefill(data.id),
        ),
        _SimButton(
          icon: data.isOnline ? Icons.wifi_off : Icons.wifi,
          label: data.isOnline ? 'Go Offline' : 'Go Online',
          color: AppTheme.infoBlue,
          onTap: () => source.simulateToggleConnection(data.id),
        ),
        _SimButton(
          icon: Icons.battery_alert,
          label: data.isBatteryLow ? 'Charge Battery' : 'Drain Battery',
          color: AppTheme.errorRed,
          onTap: () => source.simulateToggleBatteryLow(data.id),
        ),
        _SimButton(
          icon: Icons.restart_alt,
          label: 'Reset',
          color: AppTheme.lightGray,
          onTap: source.resetAll,
        ),
      ],
    );
  }
}

class _SimButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _SimButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: AppTheme.lighterGray,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

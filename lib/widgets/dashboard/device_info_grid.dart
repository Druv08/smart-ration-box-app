import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../models/smart_box_data.dart';
import '../common/stat_card.dart';

/// Grid of info cards showing device info
class DeviceInfoGrid extends StatelessWidget {
  final SmartBoxData data;

  const DeviceInfoGrid({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final lowBattery = data.battery < 20;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.3,
      children: [
        StatCard(
          icon: Icons.scale,
          label: 'Current Weight',
          value: '${data.currentWeight}',
          suffix: 'kg',
          iconColor: AppTheme.infoBlue,
        ),
        StatCard(
          icon: Icons.inventory_2_outlined,
          label: 'Capacity',
          value: '${data.capacity}',
          suffix: 'kg',
          iconColor: AppTheme.gold,
        ),
        StatCard(
          icon: Icons.check_circle_outline,
          label: 'Status',
          value: data.status,
          iconColor: AppTheme.successGreen,
        ),
        StatCard(
          icon: Icons.local_shipping_outlined,
          label: 'Refill',
          value: data.refillDetected ? 'Yes' : 'No',
          valueColor: data.refillDetected
              ? AppTheme.successGreen
              : AppTheme.lightGray,
          iconColor: AppTheme.infoBlue,
        ),
        StatCard(
          icon: Icons.battery_full,
          label: 'Battery',
          value: '${data.battery}',
          suffix: '%',
          valueColor: lowBattery ? AppTheme.errorRed : AppTheme.successGreen,
          iconColor: lowBattery ? AppTheme.errorRed : AppTheme.successGreen,
        ),
        StatCard(
          icon: data.isOnline ? Icons.wifi : Icons.wifi_off,
          label: 'Connection',
          value: data.connectionStatus,
          valueColor: data.isOnline ? AppTheme.successGreen : AppTheme.errorRed,
          iconColor: data.isOnline ? AppTheme.successGreen : AppTheme.errorRed,
        ),
      ],
    );
  }
}

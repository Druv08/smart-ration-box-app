import 'package:flutter/material.dart';

import '../../config/theme.dart';
import '../../models/smart_box_data.dart';
import '../common/luxury_card.dart';

/// Dashboard alerts section. Renders one card per active [AlertState]
/// returned by [SmartBoxData.activeAlerts].
class AlertSection extends StatelessWidget {
  final SmartBoxData data;
  const AlertSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final alerts = data.activeAlerts;
    return Column(
      children: alerts.map((state) {
        final style = _styleFor(state);
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: LuxuryCard(
            padding: const EdgeInsets.all(12),
            backgroundColor: style.color.withValues(alpha:0.08),
            border: Border.all(color: style.color.withValues(alpha:0.25)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: style.color.withValues(alpha:0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(style.icon, color: style.color, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        style.title,
                        style: TextStyle(
                          color: style.color,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        style.message,
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

  _AlertStyle _styleFor(AlertState state) {
    switch (state) {
      case AlertState.allGood:
        return const _AlertStyle(
          title: 'All Good',
          message: 'Everything is running normally.',
          color: AppTheme.successGreen,
          icon: Icons.check_circle_rounded,
        );
      case AlertState.lowStock:
        return const _AlertStyle(
          title: 'Low Stock',
          message: 'Stock level is below 25%. Plan a refill soon.',
          color: AppTheme.warningOrange,
          icon: Icons.warning_rounded,
        );
      case AlertState.batteryLow:
        return const _AlertStyle(
          title: 'Battery Low',
          message: 'Device battery is under 20%. Recharge soon.',
          color: AppTheme.errorRed,
          icon: Icons.battery_alert_rounded,
        );
      case AlertState.deviceOffline:
        return const _AlertStyle(
          title: 'Device Offline',
          message: 'Smart Ration Box is not reachable right now.',
          color: AppTheme.errorRed,
          icon: Icons.wifi_off_rounded,
        );
      case AlertState.refillDetected:
        return const _AlertStyle(
          title: 'Refill Detected',
          message: 'A refill was detected on the container.',
          color: AppTheme.infoBlue,
          icon: Icons.local_shipping_rounded,
        );
    }
  }
}

class _AlertStyle {
  final String title;
  final String message;
  final Color color;
  final IconData icon;
  const _AlertStyle({
    required this.title,
    required this.message,
    required this.color,
    required this.icon,
  });
}

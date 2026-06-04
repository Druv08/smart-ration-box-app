import 'package:flutter/material.dart';

import '../models/smart_box_data.dart';

/// Shows a single alert banner whose colour, icon and copy
/// are derived from an [AlertState].
class AlertCard extends StatelessWidget {
  final AlertState state;

  const AlertCard({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final _AlertStyle s = _styleFor(state);

    return Container(
      decoration: BoxDecoration(
        color: s.bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: s.accent.withOpacity(0.25)),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: s.accent.withOpacity(0.15),
            child: Icon(s.icon, color: s.accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: s.accent,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  s.message,
                  style: const TextStyle(fontSize: 13.5, height: 1.35),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Maps each alert state to its visual + textual representation.
  _AlertStyle _styleFor(AlertState state) {
    switch (state) {
      case AlertState.allGood:
        return _AlertStyle(
          title: 'All Good',
          message: 'Everything is running normally.',
          icon: Icons.check_circle_rounded,
          accent: const Color(0xFF2E7D32),
          bg: const Color(0xFFE8F5E9),
        );
      case AlertState.lowStock:
        return _AlertStyle(
          title: 'Low Stock',
          message: 'Stock level is below 25%. Plan a refill soon.',
          icon: Icons.warning_amber_rounded,
          accent: const Color(0xFFEF6C00),
          bg: const Color(0xFFFFF3E0),
        );
      case AlertState.batteryLow:
        return _AlertStyle(
          title: 'Battery Low',
          message: 'Device battery is under 20%. Recharge soon.',
          icon: Icons.battery_alert_rounded,
          accent: const Color(0xFFD84315),
          bg: const Color(0xFFFBE9E7),
        );
      case AlertState.deviceOffline:
        return _AlertStyle(
          title: 'Device Offline',
          message: 'Smart Ration Box is not reachable right now.',
          icon: Icons.wifi_off_rounded,
          accent: const Color(0xFFC62828),
          bg: const Color(0xFFFFEBEE),
        );
      case AlertState.refillDetected:
        return _AlertStyle(
          title: 'Refill Detected',
          message: 'A refill was detected on the container.',
          icon: Icons.local_shipping_rounded,
          accent: const Color(0xFF1565C0),
          bg: const Color(0xFFE3F2FD),
        );
    }
  }
}

class _AlertStyle {
  final String title;
  final String message;
  final IconData icon;
  final Color accent;
  final Color bg;

  const _AlertStyle({
    required this.title,
    required this.message,
    required this.icon,
    required this.accent,
    required this.bg,
  });
}

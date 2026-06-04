import 'package:flutter/material.dart';

import '../data/dummy_data.dart';
import '../models/smart_box_data.dart';
import '../widgets/alert_card.dart';
import '../widgets/info_card.dart';

/// Main RationBox dashboard. Mobile-first layout:
///   header  →  stock card  →  info grid  →  alert.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SmartBoxData data = DummyData.sampleBox;
    final AlertState alert = DummyData.computeAlertState(data);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      // Mobile-style app: cap content width so it still looks like a
      // phone app when opened in a desktop browser during development.
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _Header(isOnline: data.isOnline),
                  const SizedBox(height: 18),
                  _StockCard(data: data),
                  const SizedBox(height: 20),
                  _SectionTitle(text: 'Device Info'),
                  const SizedBox(height: 10),
                  _InfoGrid(data: data),
                  const SizedBox(height: 20),
                  _SectionTitle(text: 'Alerts'),
                  const SizedBox(height: 10),
                  AlertCard(state: alert),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Top header with app name, tagline and live device status pill.
class _Header extends StatelessWidget {
  final bool isOnline;
  const _Header({required this.isOnline});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // App icon
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFF2E7D32),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.inventory_2, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'RationBox',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'Smart Ration Monitoring',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        _StatusPill(isOnline: isOnline),
      ],
    );
  }
}

/// Small green/red pill that shows device connection at a glance.
class _StatusPill extends StatelessWidget {
  final bool isOnline;
  const _StatusPill({required this.isOnline});

  @override
  Widget build(BuildContext context) {
    final color = isOnline ? const Color(0xFF2E7D32) : const Color(0xFFC62828);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            isOnline ? 'Online' : 'Offline',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

/// Prominent card showing container name, % full and weight.
class _StockCard extends StatelessWidget {
  final SmartBoxData data;
  const _StockCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final double percent = (data.stockLevel / 100).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2E7D32), Color(0xFF43A047)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E7D32).withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.containerName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${data.stockLevel.toStringAsFixed(0)}% full',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${data.currentWeight} kg / ${data.capacity} kg',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 14),
          // Stock progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 10,
              backgroundColor: Colors.white.withOpacity(0.25),
              valueColor: const AlwaysStoppedAnimation(Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

/// 2-column responsive grid of small info cards.
class _InfoGrid extends StatelessWidget {
  final SmartBoxData data;
  const _InfoGrid({required this.data});

  @override
  Widget build(BuildContext context) {
    final lowBattery = data.battery < 20;

    final tiles = <Widget>[
      InfoCard(
        icon: Icons.scale,
        label: 'Current Weight',
        value: '${data.currentWeight} kg',
      ),
      InfoCard(
        icon: Icons.inventory_2_outlined,
        label: 'Capacity',
        value: '${data.capacity} kg',
      ),
      InfoCard(
        icon: Icons.check_circle_outline,
        label: 'Status',
        value: data.status,
        iconColor: const Color(0xFF2E7D32),
      ),
      InfoCard(
        icon: Icons.local_shipping_outlined,
        label: 'Refill',
        value: data.refillDetected ? 'Detected' : 'Not Detected',
        iconColor: const Color(0xFF1565C0),
      ),
      InfoCard(
        icon: Icons.battery_full,
        label: 'Battery',
        value: '${data.battery}%',
        iconColor: lowBattery ? Colors.red : const Color(0xFF2E7D32),
      ),
      InfoCard(
        icon: data.isOnline ? Icons.wifi : Icons.wifi_off,
        label: 'Connection',
        value: data.connectionStatus,
        iconColor: data.isOnline ? Colors.blue : Colors.red,
      ),
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.25,
      children: tiles,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: Color(0xFF333333),
        ),
      ),
    );
  }
}

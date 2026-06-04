import 'package:flutter/material.dart';

import '../data/dummy_data.dart';
import '../utils/constants.dart';
import '../widgets/alert_card.dart';
import '../widgets/info_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = DummyData.sampleBox;
    final isOnline = data.connectionStatus.toLowerCase() == 'online';
    final lowStock = data.stockLevel < 25;
    final lowBattery = data.battery < 20;
    final hasAlert = lowStock || lowBattery || !isOnline;

    final alertMessage = hasAlert
        ? [
            if (lowStock) 'Stock level is low.',
            if (lowBattery) 'Battery is low.',
            if (!isOnline) 'Device is offline.',
          ].join(' ')
        : 'All systems normal. ${data.containerName} is at '
              '${data.stockLevel.toStringAsFixed(0)}% capacity.';

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Container header
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Container',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data.containerName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: (data.stockLevel / 100).clamp(0.0, 1.0),
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${data.stockLevel.toStringAsFixed(0)}% full',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Info cards
            InfoCard(
              icon: Icons.scale,
              label: 'Current Weight',
              value: '${data.currentWeight} kg',
            ),
            const SizedBox(height: 8),
            InfoCard(
              icon: Icons.inventory_2_outlined,
              label: 'Capacity',
              value: '${data.capacity} kg',
            ),
            const SizedBox(height: 8),
            InfoCard(
              icon: Icons.check_circle_outline,
              label: 'Status',
              value: data.status,
              iconColor: Colors.green,
            ),
            const SizedBox(height: 8),
            InfoCard(
              icon: Icons.local_shipping_outlined,
              label: 'Refill',
              value: data.refillDetected ? 'Detected' : 'Not Detected',
            ),
            const SizedBox(height: 8),
            InfoCard(
              icon: Icons.battery_full,
              label: 'Battery',
              value: '${data.battery}%',
              iconColor: lowBattery ? Colors.red : Colors.green,
            ),
            const SizedBox(height: 8),
            InfoCard(
              icon: isOnline ? Icons.wifi : Icons.wifi_off,
              label: 'Connection',
              value: data.connectionStatus,
              iconColor: isOnline ? Colors.blue : Colors.red,
            ),
            const SizedBox(height: 16),

            // Alerts
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: Text(
                'Alerts',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            AlertCard(
              title: hasAlert ? 'Attention Needed' : 'All Good',
              message: alertMessage,
              isWarning: hasAlert,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../data/dummy_data.dart';
import '../widgets/alert_card.dart';
import '../widgets/info_card.dart';
import '../widgets/status_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = DummyData.sampleBox;

    return Scaffold(
      appBar: AppBar(title: const Text('Smart Ration Box'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StatusCard(status: data.status),
            const SizedBox(height: 12),
            InfoCard(label: 'Rice', value: '${data.riceKg} kg'),
            const SizedBox(height: 12),
            InfoCard(label: 'Wheat', value: '${data.wheatKg} kg'),
            const SizedBox(height: 12),
            InfoCard(label: 'Sugar', value: '${data.sugarKg} kg'),
            const SizedBox(height: 12),
            const AlertCard(message: 'All levels are within normal range.'),
          ],
        ),
      ),
    );
  }
}

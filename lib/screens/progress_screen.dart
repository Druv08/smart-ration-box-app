import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../data/mock_data.dart';
import '../widgets/common/luxury_card.dart';

/// Progress screen showing consumption trends and analytics
class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final stats = MockData.getMonthlyStats();
  late int selectedMonth;

  @override
  void initState() {
    super.initState();
    selectedMonth = stats.length - 1;
  }

  @override
  Widget build(BuildContext context) {
    final currentStats = stats[selectedMonth];

    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: AppTheme.darkCharcoal,
              elevation: 0,
              title: Text(
                'Progress & Analytics',
                style: TextStyle(
                  color: AppTheme.lighterGray,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              floating: true,
              snap: true,
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Month Selector
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: stats.length,
                      itemBuilder: (_, i) {
                        final selected = selectedMonth == i;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () {
                              setState(() => selectedMonth = i);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: selected
                                    ? AppTheme.gold.withValues(alpha:0.2)
                                    : AppTheme.darkerCharcoal,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: selected
                                      ? AppTheme.gold
                                      : AppTheme.darkerCharcoal,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  stats[i].month.split(' ')[0],
                                  style: TextStyle(
                                    color: selected
                                        ? AppTheme.gold
                                        : AppTheme.lightGray,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Key Metrics
                  _MetricsRow(
                    label1: 'Total Consumption',
                    value1:
                        '${currentStats.totalConsumption.toStringAsFixed(1)} kg',
                    label2: 'Total Refills',
                    value2:
                        '${currentStats.totalRefills.toStringAsFixed(1)} kg',
                  ),
                  const SizedBox(height: 12),
                  _MetricsRow(
                    label1: 'Avg Daily',
                    value1:
                        '${currentStats.averageDailyConsumption.toStringAsFixed(2)} kg',
                    label2: 'Refill Count',
                    value2: '${currentStats.refillCount}x',
                  ),
                  const SizedBox(height: 24),

                  // Consumption Chart (Simple Bar Chart)
                  Text(
                    'Daily Consumption Trend',
                    style: TextStyle(
                      color: AppTheme.lighterGray,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  LuxuryCard(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      height: 200,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: currentStats.dailyData
                            .take(7)
                            .toList()
                            .asMap()
                            .entries
                            .map((e) {
                              final day = [
                                'S',
                                'M',
                                'T',
                                'W',
                                'T',
                                'F',
                                'S',
                              ][e.key];
                              final value = e.value.consumption;
                              final maxValue = currentStats.dailyData.isNotEmpty
                                  ? currentStats.dailyData
                                        .map((d) => d.consumption)
                                        .reduce((a, b) => a > b ? a : b)
                                  : 0.5;

                              return Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    '${(value).toStringAsFixed(1)}kg',
                                    style: TextStyle(
                                      color: AppTheme.lightGray,
                                      fontSize: 9,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    width: 20,
                                    height: 100 * (value / maxValue),
                                    decoration: BoxDecoration(
                                      color: AppTheme.gold.withValues(alpha:0.7),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(4),
                                        topRight: Radius.circular(4),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    day,
                                    style: TextStyle(
                                      color: AppTheme.lightGray,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              );
                            })
                            .toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Refill History
                  Text(
                    'Refill History',
                    style: TextStyle(
                      color: AppTheme.lighterGray,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...MockData.refillHistory.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: LuxuryCard(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppTheme.successGreen.withValues(alpha:0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.local_shipping,
                                color: AppTheme.successGreen,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    entry.containerName,
                                    style: TextStyle(
                                      color: AppTheme.lighterGray,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _formatDate(entry.date),
                                    style: TextStyle(
                                      color: AppTheme.lightGray,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '+${entry.amount} kg',
                              style: TextStyle(
                                color: AppTheme.gold,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return '$diff days ago';
  }
}

class _MetricsRow extends StatelessWidget {
  final String label1;
  final String value1;
  final String label2;
  final String value2;

  const _MetricsRow({
    required this.label1,
    required this.value1,
    required this.label2,
    required this.value2,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: LuxuryCard(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label1,
                  style: TextStyle(
                    color: AppTheme.lightGray,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value1,
                  style: TextStyle(
                    color: AppTheme.gold,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label2,
                  style: TextStyle(
                    color: AppTheme.lightGray,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value2,
                  style: TextStyle(
                    color: AppTheme.gold,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
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

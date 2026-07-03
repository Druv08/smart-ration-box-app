import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../data/mock_data.dart';
import '../models/analytics_data.dart';
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
                    padding: const EdgeInsets.fromLTRB(8, 20, 16, 12),
                    child: SizedBox(
                      height: 220,
                      child: _ConsumptionChart(
                        data: currentStats.dailyData.take(7).toList(),
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
                              child: const Icon(
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
                                color: AppTheme.goldText,
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

/// Animated bar chart of daily consumption, backed by fl_chart.
/// Shows a y-axis with kg gridlines, real weekday labels, and a
/// tap-to-reveal value tooltip on each bar.
class _ConsumptionChart extends StatelessWidget {
  final List<AnalyticsData> data;

  const _ConsumptionChart({required this.data});

  static const _weekdayLetters = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Center(
        child: Text(
          'No consumption data',
          style: TextStyle(color: AppTheme.lightGray, fontSize: 12),
        ),
      );
    }

    final maxConsumption =
        data.map((d) => d.consumption).reduce((a, b) => a > b ? a : b);
    // Round the axis ceiling up to a tidy value with a little headroom.
    final maxY = ((maxConsumption * 1.25) * 10).ceilToDouble() / 10;
    final interval = maxY <= 0 ? 0.1 : maxY / 4;

    return BarChart(
      BarChartData(
        maxY: maxY <= 0 ? 0.5 : maxY,
        alignment: BarChartAlignment.spaceAround,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => AppTheme.darkCharcoal,
            tooltipRoundedRadius: 8,
            getTooltipItem: (group, groupIdx, rod, rodIdx) => BarTooltipItem(
              '${rod.toY.toStringAsFixed(2)} kg',
              const TextStyle(
                color: AppTheme.gold,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: interval,
          getDrawingHorizontalLine: (_) => FlLine(
            color: AppTheme.darkerCharcoal,
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 34,
              interval: interval,
              getTitlesWidget: (value, meta) {
                if (value > meta.max) return const SizedBox.shrink();
                return Text(
                  value.toStringAsFixed(1),
                  style: TextStyle(color: AppTheme.lightGray, fontSize: 10),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              getTitlesWidget: (value, meta) {
                final i = value.toInt();
                if (i < 0 || i >= data.length) {
                  return const SizedBox.shrink();
                }
                final letter = _weekdayLetters[(data[i].date.weekday - 1) % 7];
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    letter,
                    style: TextStyle(color: AppTheme.lightGray, fontSize: 11),
                  ),
                );
              },
            ),
          ),
        ),
        barGroups: [
          for (var i = 0; i < data.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: data[i].consumption,
                  width: 18,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(4),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      AppTheme.goldDark,
                      AppTheme.gold,
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      duration: const Duration(milliseconds: 650),
      curve: Curves.easeOutCubic,
    );
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
                    color: AppTheme.goldText,
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
                    color: AppTheme.goldText,
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

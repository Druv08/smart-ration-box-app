/// Represents analytics and consumption data for progress tracking
class AnalyticsData {
  final String id;
  final DateTime date;
  final double consumption; // kg consumed on this date
  final String? containerName;
  final String? category;

  const AnalyticsData({
    required this.id,
    required this.date,
    required this.consumption,
    this.containerName,
    this.category,
  });
}

/// Represents refill history entry
class RefillEntry {
  final String id;
  final DateTime date;
  final double amount; // kg refilled
  final String containerName;
  final String? notes;

  const RefillEntry({
    required this.id,
    required this.date,
    required this.amount,
    required this.containerName,
    this.notes,
  });
}

/// Represents monthly statistics
class MonthlyStats {
  final String month; // e.g., "January 2024"
  final double totalConsumption;
  final double totalRefills;
  final int refillCount;
  final List<AnalyticsData> dailyData;

  const MonthlyStats({
    required this.month,
    required this.totalConsumption,
    required this.totalRefills,
    required this.refillCount,
    required this.dailyData,
  });

  double get averageDailyConsumption =>
      totalConsumption / (dailyData.isNotEmpty ? dailyData.length : 1);
}

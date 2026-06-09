/// Represents one Smart Ration Box container and its current sensor readings.
/// Data may come from mock data, Firebase, or directly from ESP32 hardware
/// — see `lib/services/box_data_source.dart`.
class SmartBoxData {
  final String containerName;
  final double currentWeight; // kg
  final double capacity; // kg (max supported: 25 kg for bulk storage)
  final String status; // 'Normal' | 'Low'
  final bool refillDetected;
  final int battery; // 0 – 100 (%)
  final String connectionStatus; // 'Online' | 'Offline'
  final DateTime? lastRefillDate;

  const SmartBoxData({
    required this.containerName,
    required this.currentWeight,
    required this.capacity,
    required this.status,
    required this.refillDetected,
    required this.battery,
    required this.connectionStatus,
    this.lastRefillDate,
  });

  /// Stock percentage computed from weight — single source of truth.
  double get stockPercentage => (currentWeight / capacity * 100).clamp(0, 100);

  bool get isOnline => connectionStatus.toLowerCase() == 'online';

  bool get isLowStock => stockPercentage < 25;

  bool get isBatteryLow => battery < 20;

  /// Returns all alerts currently active on this box (most severe first).
  /// If none, returns `[AlertState.allGood]`.
  List<AlertState> get activeAlerts {
    final result = <AlertState>[];
    if (!isOnline) result.add(AlertState.deviceOffline);
    if (isBatteryLow) result.add(AlertState.batteryLow);
    if (isLowStock) result.add(AlertState.lowStock);
    if (refillDetected) result.add(AlertState.refillDetected);
    if (result.isEmpty) result.add(AlertState.allGood);
    return result;
  }
}

/// Possible dashboard alert states derived from live/mock sensor data.
enum AlertState { allGood, lowStock, batteryLow, deviceOffline, refillDetected }

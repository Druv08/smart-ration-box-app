/// Represents one Smart Ration Box container and its current sensor readings.
/// All values here come from dummy data for Week 1.
class SmartBoxData {
  final String containerName;
  final double currentWeight; // kg
  final double capacity; // kg
  final double stockLevel; // 0 - 100 (%)
  final String status;
  final bool refillDetected;
  final int battery; // 0 - 100 (%)
  final String connectionStatus; // 'Online' / 'Offline'

  const SmartBoxData({
    required this.containerName,
    required this.currentWeight,
    required this.capacity,
    required this.stockLevel,
    required this.status,
    required this.refillDetected,
    required this.battery,
    required this.connectionStatus,
  });

  bool get isOnline => connectionStatus.toLowerCase() == 'online';
}

/// Possible dashboard alert states.
enum AlertState { allGood, lowStock, batteryLow, deviceOffline, refillDetected }

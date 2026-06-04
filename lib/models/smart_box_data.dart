class SmartBoxData {
  final String containerName;
  final double currentWeight; // in kg
  final double capacity; // in kg
  final double stockLevel; // 0-100 (%)
  final String status;
  final bool refillDetected;
  final int battery; // 0-100 (%)
  final String connectionStatus;

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
}

import '../models/smart_box_data.dart';

/// Dummy data used during Week 1 — no Firebase or ESP32 yet.
/// Change `sampleBox` values here to preview different alert states.
class DummyData {
  static const SmartBoxData sampleBox = SmartBoxData(
    containerName: 'Rice Box',
    currentWeight: 3.2,
    capacity: 5.0,
    stockLevel: 64,
    status: 'Normal',
    refillDetected: false,
    battery: 78,
    connectionStatus: 'Online',
  );

  /// Pure UI logic that decides which alert to show based on box state.
  /// Order matters: most severe state wins.
  static AlertState computeAlertState(SmartBoxData box) {
    if (!box.isOnline) return AlertState.deviceOffline;
    if (box.battery < 20) return AlertState.batteryLow;
    if (box.stockLevel < 25) return AlertState.lowStock;
    if (box.refillDetected) return AlertState.refillDetected;
    return AlertState.allGood;
  }
}

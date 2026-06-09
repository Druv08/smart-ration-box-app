import '../models/smart_box_data.dart';

/// Abstract data source for Smart Ration Box readings.
///
/// Implementations:
///   * [DummyBoxDataSource]    — local mock data (Week 1 / Week 2)
///   * [FirebaseBoxDataSource] — reads from Firebase (planned)
///   * (future) MqttBoxDataSource / EspBoxDataSource — direct ESP32 link
///
/// Screens should depend on this interface, NOT on `MockData` directly,
/// so we can swap in a real source without touching UI code.
abstract class BoxDataSource {
  /// One-shot fetch of all containers.
  Future<List<SmartBoxData>> fetchBoxes();

  /// Continuous stream of containers (for live updates from Firebase / ESP32).
  Stream<List<SmartBoxData>> watchBoxes();
}

import 'dart:async';

import '../data/mock_data.dart';
import '../models/smart_box_data.dart';
import 'box_data_source.dart';

/// In-memory implementation of [BoxDataSource] backed by [MockData].
///
/// This is a **singleton** holding a live, mutable copy of the boxes plus a
/// broadcast stream, so every screen sees the same state and updates in real
/// time. That mirrors how the real sources will behave: a future
/// [FirebaseBoxDataSource] / EspBoxDataSource will push container snapshots
/// through [watchBoxes] exactly the same way — only the data origin changes.
///
/// The `simulate*` methods exist **only** to fake hardware events (weight
/// drop, refill, going offline, battery dropping) until the ESP32 is wired up.
/// A real data source will NOT expose them; UI that drives the demo should
/// treat them as mock-only and guard behind [MockBoxDataSource].
class MockBoxDataSource implements BoxDataSource {
  MockBoxDataSource._() {
    _boxes = [...MockData.allBoxes];
  }

  /// Shared instance so the dashboard and the details page mutate/observe the
  /// same boxes. (A real implementation would be provided via DI instead.)
  static final MockBoxDataSource instance = MockBoxDataSource._();
  factory MockBoxDataSource() => instance;

  late List<SmartBoxData> _boxes;

  final StreamController<List<SmartBoxData>> _controller =
      StreamController<List<SmartBoxData>>.broadcast();

  /// How much weight one "consume" tap removes, in kg.
  static const double _consumeStep = 0.5;

  @override
  Future<List<SmartBoxData>> fetchBoxes() async {
    // Small delay so loading state is visible during development.
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return List.unmodifiable(_boxes);
  }

  @override
  Stream<List<SmartBoxData>> watchBoxes() async* {
    // Emit current state immediately, then forward every simulated change.
    yield List.unmodifiable(_boxes);
    yield* _controller.stream;
  }

  /// Returns the current snapshot of a single box, or null if unknown.
  SmartBoxData? boxById(String id) {
    for (final box in _boxes) {
      if (box.id == id) return box;
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  // Mock hardware simulation (remove once ESP32/Firebase push real readings).
  // ---------------------------------------------------------------------------

  /// Simulate consumption: load cell reports a lower weight.
  /// Recomputes [SmartBoxData.status] and clears any stale refill flag.
  void simulateConsume(String id, {double by = _consumeStep}) {
    _update(id, (box) {
      final newWeight = (box.currentWeight - by).clamp(0.0, box.capacity);
      return box.copyWith(
        currentWeight: newWeight,
        refillDetected: false,
        status: _statusFor(newWeight, box.capacity, box.lowStockThreshold),
      );
    });
  }

  /// Simulate a refill: box is topped up to capacity and the load cell flags
  /// a refill event, stamping the refill date as "now".
  void simulateRefill(String id) {
    _update(id, (box) {
      return box.copyWith(
        currentWeight: box.capacity,
        refillDetected: true,
        status: _statusFor(box.capacity, box.capacity, box.lowStockThreshold),
        lastRefillDate: DateTime.now(),
      );
    });
  }

  /// Simulate the device dropping its connection / coming back online.
  void simulateToggleConnection(String id) {
    _update(id, (box) {
      return box.copyWith(
        connectionStatus: box.isOnline ? 'Offline' : 'Online',
      );
    });
  }

  /// Simulate the battery draining into the low band (and back to healthy).
  void simulateToggleBatteryLow(String id) {
    _update(id, (box) {
      return box.copyWith(battery: box.isBatteryLow ? 85 : 10);
    });
  }

  /// Restore every box to its original mock state.
  void resetAll() {
    _boxes = [...MockData.allBoxes];
    _emit();
  }

  void _update(String id, SmartBoxData Function(SmartBoxData) transform) {
    final index = _boxes.indexWhere((box) => box.id == id);
    if (index == -1) return;
    _boxes[index] = transform(_boxes[index]);
    _emit();
  }

  void _emit() {
    if (!_controller.isClosed) {
      _controller.add(List.unmodifiable(_boxes));
    }
  }

  static String _statusFor(double weight, double capacity, double threshold) {
    final percent = capacity == 0 ? 0 : weight / capacity * 100;
    return percent < threshold ? 'Low' : 'Normal';
  }
}

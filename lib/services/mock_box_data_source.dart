import 'dart:async';

import '../data/mock_data.dart';
import '../models/smart_box_data.dart';
import 'box_data_source.dart';

/// In-memory implementation of [BoxDataSource] backed by [MockData].
/// Used for development until Firebase / ESP32 are wired up.
/// To swap in real data: replace this class with [FirebaseBoxDataSource]
/// (or a future EspBoxDataSource) in dashboard_screen.dart.
class MockBoxDataSource implements BoxDataSource {
  const MockBoxDataSource();

  @override
  Future<List<SmartBoxData>> fetchBoxes() async {
    // Small delay so loading state is visible during development.
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return MockData.allBoxes;
  }

  @override
  Stream<List<SmartBoxData>> watchBoxes() async* {
    yield MockData.allBoxes;
    // No live updates in mock mode.
    // Firebase impl will push real-time changes here.
  }
}

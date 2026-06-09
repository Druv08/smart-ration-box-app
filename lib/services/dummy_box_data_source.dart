import 'dart:async';

import '../data/mock_data.dart';
import '../models/smart_box_data.dart';
import 'box_data_source.dart';

/// In-memory implementation backed by [MockData].
/// Used for development until Firebase / ESP32 are wired up.
class DummyBoxDataSource implements BoxDataSource {
  const DummyBoxDataSource();

  @override
  Future<List<SmartBoxData>> fetchBoxes() async {
    // Simulate a tiny network delay so loading states are testable.
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return MockData.allBoxes;
  }

  @override
  Stream<List<SmartBoxData>> watchBoxes() async* {
    yield MockData.allBoxes;
    // No live updates yet — Firebase / ESP32 impl will push real changes.
  }
}

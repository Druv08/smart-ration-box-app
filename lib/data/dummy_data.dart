import '../models/smart_box_data.dart';

class DummyData {
  static SmartBoxData sampleBox = SmartBoxData(
    status: 'Online',
    riceKg: 12.5,
    wheatKg: 8.0,
    sugarKg: 3.2,
    lastUpdated: DateTime.now(),
  );
}

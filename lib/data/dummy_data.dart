import '../models/smart_box_data.dart';

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
}

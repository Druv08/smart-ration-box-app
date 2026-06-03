// Stub for future Firebase integration.
// Add the `firebase_core` and related packages to pubspec.yaml when ready.

class FirebaseService {
  FirebaseService._();

  static Future<void> init() async {
    // TODO: Initialize Firebase here.
  }

  static Future<Map<String, dynamic>> fetchBoxData() async {
    // TODO: Replace with real Firebase Realtime Database / Firestore call.
    await Future.delayed(const Duration(milliseconds: 200));
    return {'status': 'Online', 'riceKg': 12.5, 'wheatKg': 8.0, 'sugarKg': 3.2};
  }
}

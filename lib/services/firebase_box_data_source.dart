import '../models/smart_box_data.dart';
import 'box_data_source.dart';

/// Stub implementation that will read from Firebase (Firestore or
/// Realtime Database) once `firebase_core` + `cloud_firestore` are added.
///
/// Wiring plan:
///   1. Add `firebase_core` and `cloud_firestore` to `pubspec.yaml`.
///   2. Run `flutterfire configure` to generate `firebase_options.dart`.
///   3. Call `Firebase.initializeApp(...)` from `main.dart` before `runApp`.
///   4. Replace the methods below with real Firestore queries on a
///      `boxes` collection keyed by container id, mapping each document with
///      `SmartBoxData.fromMap(doc.id, doc.data())`. Writes use `box.toMap()`.
///
/// The wire format (field names + types) is documented in
/// `docs/ESP32_FIREBASE_DATA_FORMAT.md` and implemented by
/// [SmartBoxData.fromMap] / [SmartBoxData.toMap]. Example Firestore read:
///
/// ```dart
/// Stream<List<SmartBoxData>> watchBoxes() {
///   return FirebaseFirestore.instance
///       .collection('boxes')
///       .snapshots()
///       .map((snap) => snap.docs
///           .map((d) => SmartBoxData.fromMap(d.id, d.data()))
///           .toList());
/// }
/// ```
class FirebaseBoxDataSource implements BoxDataSource {
  const FirebaseBoxDataSource();

  @override
  Future<List<SmartBoxData>> fetchBoxes() {
    throw UnimplementedError(
      'FirebaseBoxDataSource.fetchBoxes is not wired yet. '
      'Add firebase_core + cloud_firestore and implement.',
    );
  }

  @override
  Stream<List<SmartBoxData>> watchBoxes() {
    throw UnimplementedError(
      'FirebaseBoxDataSource.watchBoxes is not wired yet. '
      'Add firebase_core + cloud_firestore and implement.',
    );
  }
}

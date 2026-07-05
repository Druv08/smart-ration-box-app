/// Represents one Smart Ration Box container and its current sensor readings.
/// Data may come from mock data, Firebase, or directly from ESP32 hardware
/// — see `lib/services/box_data_source.dart`.
///
/// The field names used in [toMap] / [fromMap] are the canonical wire format
/// the ESP32 firmware and Firebase documents are expected to follow. See
/// `docs/ESP32_FIREBASE_DATA_FORMAT.md` for the full contract.
class SmartBoxData {
  /// Stable identifier — used as the Firebase document id / ESP32 device id.
  final String id;
  final String containerName;
  final double currentWeight; // kg
  final double capacity; // kg (max supported: 25 kg for bulk storage)
  final String status; // 'Normal' | 'Low'
  final bool refillDetected;
  final int battery; // 0 – 100 (%)
  final String connectionStatus; // 'Online' | 'Offline'
  final DateTime? lastRefillDate;

  /// Stock percentage (0–100) below which the box is considered low on stock.
  /// Defaults to 25 %. Configurable per box so a future ESP32/Firebase payload
  /// can carry a per-container threshold.
  final double lowStockThreshold;

  const SmartBoxData({
    required this.id,
    required this.containerName,
    required this.currentWeight,
    required this.capacity,
    required this.status,
    required this.refillDetected,
    required this.battery,
    required this.connectionStatus,
    this.lastRefillDate,
    this.lowStockThreshold = 25,
  });

  /// Stock percentage computed from weight — single source of truth.
  double get stockPercentage => (currentWeight / capacity * 100).clamp(0, 100);

  bool get isOnline => connectionStatus.toLowerCase() == 'online';

  bool get isLowStock => stockPercentage < lowStockThreshold;

  bool get isBatteryLow => battery < 20;

  /// Returns all alerts currently active on this box (most severe first).
  /// If none, returns `[AlertState.allGood]`.
  List<AlertState> get activeAlerts {
    final result = <AlertState>[];
    if (!isOnline) result.add(AlertState.deviceOffline);
    if (isBatteryLow) result.add(AlertState.batteryLow);
    if (isLowStock) result.add(AlertState.lowStock);
    if (refillDetected) result.add(AlertState.refillDetected);
    if (result.isEmpty) result.add(AlertState.allGood);
    return result;
  }

  /// Returns a copy with the given fields replaced. Used by the mock hardware
  /// simulator (and, later, by real data sources reconciling partial updates)
  /// since [SmartBoxData] is immutable.
  SmartBoxData copyWith({
    String? id,
    String? containerName,
    double? currentWeight,
    double? capacity,
    String? status,
    bool? refillDetected,
    int? battery,
    String? connectionStatus,
    DateTime? lastRefillDate,
    double? lowStockThreshold,
  }) {
    return SmartBoxData(
      id: id ?? this.id,
      containerName: containerName ?? this.containerName,
      currentWeight: currentWeight ?? this.currentWeight,
      capacity: capacity ?? this.capacity,
      status: status ?? this.status,
      refillDetected: refillDetected ?? this.refillDetected,
      battery: battery ?? this.battery,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      lastRefillDate: lastRefillDate ?? this.lastRefillDate,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
    );
  }

  /// Builds a box from a decoded Firebase document / ESP32 JSON payload.
  /// Tolerates missing optional fields so partial hardware payloads don't crash.
  /// See `docs/ESP32_FIREBASE_DATA_FORMAT.md`.
  factory SmartBoxData.fromMap(String id, Map<String, dynamic> map) {
    return SmartBoxData(
      id: id,
      containerName: (map['containerName'] ?? 'Unknown Box') as String,
      currentWeight: (map['currentWeight'] as num?)?.toDouble() ?? 0,
      capacity: (map['capacity'] as num?)?.toDouble() ?? 0,
      status: (map['status'] ?? 'Normal') as String,
      refillDetected: (map['refillDetected'] ?? false) as bool,
      battery: (map['battery'] as num?)?.toInt() ?? 0,
      connectionStatus: (map['connectionStatus'] ?? 'Offline') as String,
      lastRefillDate: map['lastRefillDate'] == null
          ? null
          : DateTime.tryParse(map['lastRefillDate'].toString()),
      lowStockThreshold: (map['lowStockThreshold'] as num?)?.toDouble() ?? 25,
    );
  }

  /// Serializes this box to the canonical wire format written by the app
  /// and (in future) read back from Firebase. `id` is intentionally omitted
  /// because it is the document key, not a field.
  Map<String, dynamic> toMap() {
    return {
      'containerName': containerName,
      'currentWeight': currentWeight,
      'capacity': capacity,
      'status': status,
      'refillDetected': refillDetected,
      'battery': battery,
      'connectionStatus': connectionStatus,
      'lastRefillDate': lastRefillDate?.toIso8601String(),
      'lowStockThreshold': lowStockThreshold,
    };
  }
}

/// Possible dashboard alert states derived from live/mock sensor data.
enum AlertState { allGood, lowStock, batteryLow, deviceOffline, refillDetected }

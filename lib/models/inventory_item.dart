/// Represents a household inventory container
class InventoryItem {
  final String id;
  final String name;
  final String category; // Grains, Vegetables, Spices, etc.
  final double quantity; // in kg or units
  final double capacity; // maximum capacity
  final String unit; // kg, liters, pieces, etc.
  final String status; // In Stock, Low Stock, Out of Stock
  final String owner; // Family member who owns/manages it
  final DateTime lastRefilled;
  final String location; // Kitchen, Pantry, Store, etc.

  /// Name of the family member who claimed responsibility to refill this
  /// item when it runs low. `null` means nobody has claimed it yet.
  final String? claimedBy;

  /// Quantity at/below which the item is considered low stock. Falls back
  /// to 25% of [capacity] when not set.
  final double? lowStockThreshold;

  const InventoryItem({
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.capacity,
    required this.unit,
    required this.status,
    required this.owner,
    required this.lastRefilled,
    required this.location,
    this.claimedBy,
    this.lowStockThreshold,
  });

  double get percentageFull => (quantity / capacity * 100).clamp(0, 100);

  double get effectiveThreshold => lowStockThreshold ?? capacity * 0.25;

  bool get isLowStock => quantity < effectiveThreshold;

  bool get isClaimed => claimedBy != null && claimedBy!.trim().isNotEmpty;

  InventoryItem copyWith({
    double? quantity,
    String? status,
    Object? claimedBy = _sentinel,
    double? lowStockThreshold,
  }) {
    return InventoryItem(
      id: id,
      name: name,
      category: category,
      quantity: quantity ?? this.quantity,
      capacity: capacity,
      unit: unit,
      status: status ?? this.status,
      owner: owner,
      lastRefilled: lastRefilled,
      location: location,
      // `_sentinel` lets callers pass `null` to explicitly clear the claim.
      claimedBy: identical(claimedBy, _sentinel)
          ? this.claimedBy
          : claimedBy as String?,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
    );
  }

  static const Object _sentinel = Object();

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'quantity': quantity,
        'capacity': capacity,
        'unit': unit,
        'status': status,
        'owner': owner,
        'lastRefilled': lastRefilled.toIso8601String(),
        'location': location,
        'claimedBy': claimedBy,
        'lowStockThreshold': lowStockThreshold,
      };

  factory InventoryItem.fromJson(Map<String, dynamic> json) => InventoryItem(
        id: json['id'] as String,
        name: json['name'] as String,
        category: json['category'] as String,
        quantity: (json['quantity'] as num).toDouble(),
        capacity: (json['capacity'] as num).toDouble(),
        unit: json['unit'] as String,
        status: json['status'] as String,
        owner: json['owner'] as String,
        lastRefilled: DateTime.parse(json['lastRefilled'] as String),
        location: json['location'] as String,
        claimedBy: json['claimedBy'] as String?,
        lowStockThreshold: (json['lowStockThreshold'] as num?)?.toDouble(),
      );
}

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
  });

  double get percentageFull => (quantity / capacity * 100).clamp(0, 100);

  bool get isLowStock => quantity < (capacity * 0.25);
}

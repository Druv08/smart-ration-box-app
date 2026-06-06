/// Represents a shopping list item
class ShoppingItem {
  final String id;
  final String name;
  final String category; // Grains, Vegetables, Spices, Dairy, etc.
  final double quantity;
  final String unit; // kg, liters, pieces, etc.
  final double estimatedCost;
  final bool isPurchased;
  final DateTime addedDate;
  final DateTime? purchasedDate;
  final String? notes;

  const ShoppingItem({
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.unit,
    required this.estimatedCost,
    this.isPurchased = false,
    required this.addedDate,
    this.purchasedDate,
    this.notes,
  });

  String get displayName => '$quantity $unit $name';

  ShoppingItem copyWith({bool? isPurchased, DateTime? purchasedDate}) {
    return ShoppingItem(
      id: id,
      name: name,
      category: category,
      quantity: quantity,
      unit: unit,
      estimatedCost: estimatedCost,
      isPurchased: isPurchased ?? this.isPurchased,
      addedDate: addedDate,
      purchasedDate: purchasedDate ?? this.purchasedDate,
      notes: notes,
    );
  }
}

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

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'quantity': quantity,
        'unit': unit,
        'estimatedCost': estimatedCost,
        'isPurchased': isPurchased,
        'addedDate': addedDate.toIso8601String(),
        'purchasedDate': purchasedDate?.toIso8601String(),
        'notes': notes,
      };

  factory ShoppingItem.fromJson(Map<String, dynamic> json) => ShoppingItem(
        id: json['id'] as String,
        name: json['name'] as String,
        category: json['category'] as String,
        quantity: (json['quantity'] as num).toDouble(),
        unit: json['unit'] as String,
        estimatedCost: (json['estimatedCost'] as num).toDouble(),
        isPurchased: json['isPurchased'] as bool? ?? false,
        addedDate: DateTime.parse(json['addedDate'] as String),
        purchasedDate: json['purchasedDate'] == null
            ? null
            : DateTime.parse(json['purchasedDate'] as String),
        notes: json['notes'] as String?,
      );
}

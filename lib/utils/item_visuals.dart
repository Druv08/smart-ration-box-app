import 'package:flutter/material.dart';

/// Maps an item category to a representative icon, so cards and detail
/// screens show a consistent glyph without needing real image assets.
IconData iconForCategory(String category) {
  switch (category.toLowerCase()) {
    case 'grains':
      return Icons.grass_rounded;
    case 'legumes':
      return Icons.spa_rounded;
    case 'spices':
      return Icons.local_fire_department_rounded;
    case 'sweeteners':
      return Icons.icecream_rounded;
    case 'oils':
      return Icons.water_drop_rounded;
    case 'seasonings':
      return Icons.grain_rounded;
    case 'vegetables':
      return Icons.eco_rounded;
    case 'dairy':
      return Icons.egg_rounded;
    default:
      return Icons.inventory_2_rounded;
  }
}

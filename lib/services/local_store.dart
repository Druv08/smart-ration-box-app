import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/inventory_item.dart';
import '../models/shopping_item.dart';

/// Thin wrapper over [SharedPreferences] that persists the user's
/// inventory and shopping lists as JSON so edits survive app restarts.
///
/// Each `load*` returns `null` when nothing has been saved yet, letting
/// callers fall back to the seed data in `MockData` on first launch.
class LocalStore {
  LocalStore._();

  static const _kInventory = 'inventory_items_v1';
  static const _kShopping = 'shopping_items_v1';

  // ---- Inventory ----

  static Future<void> saveInventory(List<InventoryItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(items.map((e) => e.toJson()).toList());
    await prefs.setString(_kInventory, raw);
  }

  static Future<List<InventoryItem>?> loadInventory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kInventory);
    if (raw == null) return null;
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((e) => InventoryItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ---- Shopping ----

  static Future<void> saveShopping(List<ShoppingItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(items.map((e) => e.toJson()).toList());
    await prefs.setString(_kShopping, raw);
  }

  static Future<List<ShoppingItem>?> loadShopping() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kShopping);
    if (raw == null) return null;
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((e) => ShoppingItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

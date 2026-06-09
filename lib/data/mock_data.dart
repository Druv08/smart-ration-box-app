import '../models/smart_box_data.dart';
import '../models/inventory_item.dart';
import '../models/shopping_item.dart';
import '../models/family_member.dart';
import '../models/analytics_data.dart';

/// Single source of truth for all in-app mock data.
/// Replace individual box entries with a real [BoxDataSource] impl
/// (Firebase or ESP32) when hardware is connected — see
/// `lib/services/box_data_source.dart`.
class MockData {
  // ============ Smart Box Data ============
  // Each box below demonstrates a different alert state so all five
  // dashboard alert types (All Good, Low Stock, Battery Low,
  // Device Offline, Refill Detected) can be seen on the dashboard
  // by tapping through containers.

  /// All Good — healthy stock, good battery, online.
  static final SmartBoxData riceBox = SmartBoxData(
    containerName: 'Rice Box',
    currentWeight: 6.5,
    capacity: 10.0,
    status: 'Normal',
    refillDetected: false,
    battery: 78,
    connectionStatus: 'Online',
    lastRefillDate: DateTime(2026, 5, 26), // ~15 days ago
  );

  /// Low Stock alert — stock below 25 % of 5 kg capacity.
  static final SmartBoxData dalBox = SmartBoxData(
    containerName: 'Dal Box',
    currentWeight: 1.0,
    capacity: 5.0,
    status: 'Low',
    refillDetected: false,
    battery: 72,
    connectionStatus: 'Online',
    lastRefillDate: DateTime(2026, 5, 19), // ~22 days ago
  );

  /// Battery Low alert — battery under 20 %.
  static final SmartBoxData sugarBox = SmartBoxData(
    containerName: 'Sugar Box',
    currentWeight: 2.0,
    capacity: 3.0,
    status: 'Normal',
    refillDetected: false,
    battery: 12,
    connectionStatus: 'Online',
    lastRefillDate: DateTime(2026, 5, 11), // ~30 days ago
  );

  /// Refill Detected alert — a top-up was sensed by the load cell.
  static final SmartBoxData wheatBox = SmartBoxData(
    containerName: 'Wheat Box',
    currentWeight: 8.0,
    capacity: 10.0,
    status: 'Normal',
    refillDetected: true,
    battery: 88,
    connectionStatus: 'Online',
    lastRefillDate: DateTime(2026, 6, 9), // yesterday
  );

  /// Device Offline + Low Stock — offline with almost empty stock (25 kg sack).
  static final SmartBoxData grainSack = SmartBoxData(
    containerName: 'Grain Sack',
    currentWeight: 5.0,
    capacity: 25.0,
    status: 'Low',
    refillDetected: false,
    battery: 64,
    connectionStatus: 'Offline',
    lastRefillDate: DateTime(2026, 5, 6), // ~35 days ago
  );

  /// All boxes in display order. First entry is the dashboard primary view.
  static List<SmartBoxData> get allBoxes =>
      [riceBox, dalBox, sugarBox, wheatBox, grainSack];

  // ============ Inventory Items ============
  static List<InventoryItem> inventoryItems = [
    InventoryItem(
      id: 'inv-001',
      name: 'Basmati Rice',
      category: 'Grains',
      quantity: 6.5,
      capacity: 10.0,
      unit: 'kg',
      status: 'In Stock',
      owner: 'Raj Kumar',
      lastRefilled: DateTime(2026, 5, 26),
      location: 'Kitchen Pantry',
    ),
    InventoryItem(
      id: 'inv-002',
      name: 'Whole Wheat Flour',
      category: 'Grains',
      quantity: 8.0,
      capacity: 10.0,
      unit: 'kg',
      status: 'In Stock',
      owner: 'Priya Singh',
      lastRefilled: DateTime(2026, 6, 9),
      location: 'Kitchen Pantry',
    ),
    InventoryItem(
      id: 'inv-003',
      name: 'Lentils (Dal)',
      category: 'Legumes',
      quantity: 1.0,
      capacity: 5.0,
      unit: 'kg',
      status: 'Low Stock',
      owner: 'Raj Kumar',
      lastRefilled: DateTime(2026, 5, 19),
      location: 'Kitchen Pantry',
    ),
    InventoryItem(
      id: 'inv-004',
      name: 'Sugar',
      category: 'Sweeteners',
      quantity: 2.0,
      capacity: 3.0,
      unit: 'kg',
      status: 'In Stock',
      owner: 'Priya Singh',
      lastRefilled: DateTime(2026, 5, 11),
      location: 'Kitchen Cabinet',
    ),
    InventoryItem(
      id: 'inv-005',
      name: 'Turmeric Powder',
      category: 'Spices',
      quantity: 0.3,
      capacity: 1.0,
      unit: 'kg',
      status: 'Low Stock',
      owner: 'Raj Kumar',
      lastRefilled: DateTime(2026, 4, 26),
      location: 'Spice Rack',
    ),
    InventoryItem(
      id: 'inv-006',
      name: 'Vegetable Oil',
      category: 'Oils',
      quantity: 1.2,
      capacity: 2.0,
      unit: 'liters',
      status: 'In Stock',
      owner: 'Priya Singh',
      lastRefilled: DateTime(2026, 5, 31),
      location: 'Kitchen Pantry',
    ),
    InventoryItem(
      id: 'inv-007',
      name: 'Salt',
      category: 'Seasonings',
      quantity: 0.5,
      capacity: 1.5,
      unit: 'kg',
      status: 'In Stock',
      owner: 'Raj Kumar',
      lastRefilled: DateTime(2026, 4, 11),
      location: 'Kitchen Cabinet',
    ),
    InventoryItem(
      id: 'inv-008',
      name: 'Bulk Grain Sack',
      category: 'Grains',
      quantity: 5.0,
      capacity: 25.0,
      unit: 'kg',
      status: 'Low Stock',
      owner: 'Priya Singh',
      lastRefilled: DateTime(2026, 5, 6),
      location: 'Store Room',
    ),
  ];

  // ============ Shopping Items ============
  static List<ShoppingItem> shoppingItems = [
    ShoppingItem(
      id: 'shop-001',
      name: 'Basmati Rice',
      category: 'Grains',
      quantity: 5,
      unit: 'kg',
      estimatedCost: 350,
      isPurchased: false,
      addedDate: DateTime(2026, 6, 8),
    ),
    ShoppingItem(
      id: 'shop-002',
      name: 'Lentils',
      category: 'Legumes',
      quantity: 2,
      unit: 'kg',
      estimatedCost: 180,
      isPurchased: false,
      addedDate: DateTime(2026, 6, 9),
    ),
    ShoppingItem(
      id: 'shop-003',
      name: 'Onions',
      category: 'Vegetables',
      quantity: 3,
      unit: 'kg',
      estimatedCost: 75,
      isPurchased: true,
      addedDate: DateTime(2026, 6, 5),
      purchasedDate: DateTime(2026, 6, 8),
    ),
    ShoppingItem(
      id: 'shop-004',
      name: 'Tomatoes',
      category: 'Vegetables',
      quantity: 2.5,
      unit: 'kg',
      estimatedCost: 100,
      isPurchased: true,
      addedDate: DateTime(2026, 6, 6),
      purchasedDate: DateTime(2026, 6, 9),
    ),
    ShoppingItem(
      id: 'shop-005',
      name: 'Turmeric Powder',
      category: 'Spices',
      quantity: 0.5,
      unit: 'kg',
      estimatedCost: 120,
      isPurchased: false,
      addedDate: DateTime(2026, 6, 10),
      notes: 'High quality',
    ),
    ShoppingItem(
      id: 'shop-006',
      name: 'Vegetable Oil',
      category: 'Oils',
      quantity: 2,
      unit: 'liters',
      estimatedCost: 280,
      isPurchased: false,
      addedDate: DateTime(2026, 6, 7),
    ),
    ShoppingItem(
      id: 'shop-007',
      name: 'Wheat Flour',
      category: 'Grains',
      quantity: 4,
      unit: 'kg',
      estimatedCost: 200,
      isPurchased: true,
      addedDate: DateTime(2026, 6, 4),
      purchasedDate: DateTime(2026, 6, 7),
    ),
  ];

  // ============ Family Members ============
  static List<FamilyMember> familyMembers = [
    FamilyMember(
      id: 'fm-001',
      name: 'Raj Kumar',
      role: 'Admin',
      email: 'raj@example.com',
      joinedDate: DateTime(2025, 12, 12),
      isActive: true,
    ),
    FamilyMember(
      id: 'fm-002',
      name: 'Priya Singh',
      role: 'Member',
      email: 'priya@example.com',
      joinedDate: DateTime(2026, 1, 11),
      isActive: true,
    ),
    FamilyMember(
      id: 'fm-003',
      name: 'Arjun Kumar',
      role: 'Member',
      email: 'arjun@example.com',
      joinedDate: DateTime(2026, 3, 2),
      isActive: true,
    ),
    FamilyMember(
      id: 'fm-004',
      name: 'Neha Sharma',
      role: 'Guest',
      email: 'neha@example.com',
      joinedDate: DateTime(2026, 5, 11),
      isActive: true,
    ),
  ];

  // ============ Analytics Data ============
  static List<AnalyticsData> getAnalyticsDataForMonth() {
    final startDate = DateTime(2026, 6, 1);
    const days = 30;

    return List.generate(days, (index) {
      final date = startDate.add(Duration(days: index));
      final consumption = 0.1 + (index % 7) * 0.05;
      return AnalyticsData(
        id: 'anal-${index + 1}',
        date: date,
        consumption: consumption,
        containerName: index % 3 == 0 ? 'Rice Box' : 'Wheat Box',
        category: index % 3 == 0 ? 'Grains' : 'Legumes',
      );
    });
  }

  static List<RefillEntry> refillHistory = [
    RefillEntry(
      id: 'ref-001',
      date: DateTime(2026, 5, 26),
      amount: 5.0,
      containerName: 'Rice Box',
      notes: 'Regular refill',
    ),
    RefillEntry(
      id: 'ref-002',
      date: DateTime(2026, 5, 19),
      amount: 2.0,
      containerName: 'Dal Box',
      notes: 'Low stock refill',
    ),
    RefillEntry(
      id: 'ref-003',
      date: DateTime(2026, 6, 9),
      amount: 3.5,
      containerName: 'Wheat Box',
      notes: 'Monthly stock replenishment',
    ),
    RefillEntry(
      id: 'ref-004',
      date: DateTime(2026, 4, 26),
      amount: 1.0,
      containerName: 'Sugar Box',
      notes: 'Emergency top-up',
    ),
  ];

  static List<MonthlyStats> getMonthlyStats() {
    final analytics = getAnalyticsDataForMonth();

    double totalConsumption = 0;
    int refillCount = 0;
    double totalRefills = 0;

    for (final entry in analytics) {
      totalConsumption += entry.consumption;
    }

    for (final refill in refillHistory) {
      if (refill.date.month == 6 && refill.date.year == 2026) {
        refillCount++;
        totalRefills += refill.amount;
      }
    }

    return [
      MonthlyStats(
        month: 'April 2026',
        totalConsumption: 12.5,
        totalRefills: 8.0,
        refillCount: 3,
        dailyData: List.generate(
          30,
          (i) => AnalyticsData(
            id: 'apr-$i',
            date: DateTime(2026, 4, i + 1),
            consumption: 0.15 + (i % 7) * 0.05,
          ),
        ),
      ),
      MonthlyStats(
        month: 'May 2026',
        totalConsumption: 11.8,
        totalRefills: 7.5,
        refillCount: 2,
        dailyData: List.generate(
          31,
          (i) => AnalyticsData(
            id: 'may-$i',
            date: DateTime(2026, 5, i + 1),
            consumption: 0.14 + (i % 7) * 0.04,
          ),
        ),
      ),
      MonthlyStats(
        month: 'June 2026',
        totalConsumption: totalConsumption,
        totalRefills: totalRefills,
        refillCount: refillCount,
        dailyData: analytics,
      ),
    ];
  }
}

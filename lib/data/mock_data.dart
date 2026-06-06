import '../models/smart_box_data.dart';
import '../models/inventory_item.dart';
import '../models/shopping_item.dart';
import '../models/family_member.dart';
import '../models/analytics_data.dart';

class MockData {
  // ============ Smart Box Data ============
  static const SmartBoxData riceBox = SmartBoxData(
    containerName: 'Rice Box',
    currentWeight: 3.2,
    capacity: 5.0,
    stockLevel: 64,
    status: 'Normal',
    refillDetected: false,
    battery: 78,
    connectionStatus: 'Online',
  );

  static const SmartBoxData wheatBox = SmartBoxData(
    containerName: 'Wheat Box',
    currentWeight: 1.8,
    capacity: 4.0,
    stockLevel: 45,
    status: 'Normal',
    refillDetected: false,
    battery: 92,
    connectionStatus: 'Online',
  );

  // ============ Inventory Items ============
  static List<InventoryItem> inventoryItems = [
    InventoryItem(
      id: 'inv-001',
      name: 'Basmati Rice',
      category: 'Grains',
      quantity: 3.2,
      capacity: 5.0,
      unit: 'kg',
      status: 'In Stock',
      owner: 'Raj Kumar',
      lastRefilled: DateTime.now().subtract(const Duration(days: 15)),
      location: 'Kitchen Pantry',
    ),
    InventoryItem(
      id: 'inv-002',
      name: 'Whole Wheat Flour',
      category: 'Grains',
      quantity: 1.8,
      capacity: 4.0,
      unit: 'kg',
      status: 'In Stock',
      owner: 'Priya Singh',
      lastRefilled: DateTime.now().subtract(const Duration(days: 8)),
      location: 'Kitchen Pantry',
    ),
    InventoryItem(
      id: 'inv-003',
      name: 'Lentils (Dal)',
      category: 'Legumes',
      quantity: 0.8,
      capacity: 2.0,
      unit: 'kg',
      status: 'Low Stock',
      owner: 'Raj Kumar',
      lastRefilled: DateTime.now().subtract(const Duration(days: 22)),
      location: 'Kitchen Pantry',
    ),
    InventoryItem(
      id: 'inv-004',
      name: 'Sugar',
      category: 'Sweeteners',
      quantity: 2.5,
      capacity: 3.0,
      unit: 'kg',
      status: 'In Stock',
      owner: 'Priya Singh',
      lastRefilled: DateTime.now().subtract(const Duration(days: 30)),
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
      lastRefilled: DateTime.now().subtract(const Duration(days: 45)),
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
      lastRefilled: DateTime.now().subtract(const Duration(days: 10)),
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
      lastRefilled: DateTime.now().subtract(const Duration(days: 60)),
      location: 'Kitchen Cabinet',
    ),
    InventoryItem(
      id: 'inv-008',
      name: 'Basmati Rice (Secondary)',
      category: 'Grains',
      quantity: 0.2,
      capacity: 3.0,
      unit: 'kg',
      status: 'Low Stock',
      owner: 'Priya Singh',
      lastRefilled: DateTime.now().subtract(const Duration(days: 35)),
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
      addedDate: DateTime.now().subtract(const Duration(days: 2)),
    ),
    ShoppingItem(
      id: 'shop-002',
      name: 'Lentils',
      category: 'Legumes',
      quantity: 2,
      unit: 'kg',
      estimatedCost: 180,
      isPurchased: false,
      addedDate: DateTime.now().subtract(const Duration(days: 1)),
    ),
    ShoppingItem(
      id: 'shop-003',
      name: 'Onions',
      category: 'Vegetables',
      quantity: 3,
      unit: 'kg',
      estimatedCost: 75,
      isPurchased: true,
      addedDate: DateTime.now().subtract(const Duration(days: 5)),
      purchasedDate: DateTime.now().subtract(const Duration(days: 2)),
    ),
    ShoppingItem(
      id: 'shop-004',
      name: 'Tomatoes',
      category: 'Vegetables',
      quantity: 2.5,
      unit: 'kg',
      estimatedCost: 100,
      isPurchased: true,
      addedDate: DateTime.now().subtract(const Duration(days: 4)),
      purchasedDate: DateTime.now().subtract(const Duration(days: 1)),
    ),
    ShoppingItem(
      id: 'shop-005',
      name: 'Turmeric Powder',
      category: 'Spices',
      quantity: 0.5,
      unit: 'kg',
      estimatedCost: 120,
      isPurchased: false,
      addedDate: DateTime.now(),
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
      addedDate: DateTime.now().subtract(const Duration(days: 3)),
    ),
    ShoppingItem(
      id: 'shop-007',
      name: 'Wheat Flour',
      category: 'Grains',
      quantity: 4,
      unit: 'kg',
      estimatedCost: 200,
      isPurchased: true,
      addedDate: DateTime.now().subtract(const Duration(days: 6)),
      purchasedDate: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  // ============ Family Members ============
  static List<FamilyMember> familyMembers = [
    FamilyMember(
      id: 'fm-001',
      name: 'Raj Kumar',
      role: 'Admin',
      email: 'raj@example.com',
      joinedDate: DateTime.now().subtract(const Duration(days: 180)),
      isActive: true,
    ),
    FamilyMember(
      id: 'fm-002',
      name: 'Priya Singh',
      role: 'Member',
      email: 'priya@example.com',
      joinedDate: DateTime.now().subtract(const Duration(days: 150)),
      isActive: true,
    ),
    FamilyMember(
      id: 'fm-003',
      name: 'Arjun Kumar',
      role: 'Member',
      email: 'arjun@example.com',
      joinedDate: DateTime.now().subtract(const Duration(days: 100)),
      isActive: true,
    ),
    FamilyMember(
      id: 'fm-004',
      name: 'Neha Sharma',
      role: 'Guest',
      email: 'neha@example.com',
      joinedDate: DateTime.now().subtract(const Duration(days: 30)),
      isActive: true,
    ),
  ];

  // ============ Analytics Data ============
  static List<AnalyticsData> getAnalyticsDataForMonth() {
    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month, 1);
    final days = DateTime(now.year, now.month + 1, 0).day;

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
      date: DateTime.now().subtract(const Duration(days: 15)),
      amount: 5.0,
      containerName: 'Rice Box',
      notes: 'Regular refill',
    ),
    RefillEntry(
      id: 'ref-002',
      date: DateTime.now().subtract(const Duration(days: 22)),
      amount: 2.0,
      containerName: 'Lentils Container',
      notes: 'Low stock refill',
    ),
    RefillEntry(
      id: 'ref-003',
      date: DateTime.now().subtract(const Duration(days: 30)),
      amount: 3.0,
      containerName: 'Wheat Box',
      notes: 'Monthly stock replenishment',
    ),
    RefillEntry(
      id: 'ref-004',
      date: DateTime.now().subtract(const Duration(days: 45)),
      amount: 1.0,
      containerName: 'Spices Container',
      notes: 'Emergency top-up',
    ),
  ];

  static List<MonthlyStats> getMonthlyStats() {
    final analytics = getAnalyticsDataForMonth();
    final now = DateTime.now();

    double totalConsumption = 0;
    int refillCount = 0;
    double totalRefills = 0;

    for (var entry in analytics) {
      totalConsumption += entry.consumption;
    }

    for (var refill in refillHistory) {
      if (refill.date.month == now.month && refill.date.year == now.year) {
        refillCount++;
        totalRefills += refill.amount;
      }
    }

    return [
      MonthlyStats(
        month: 'January 2024',
        totalConsumption: 12.5,
        totalRefills: 8.0,
        refillCount: 3,
        dailyData: List.generate(
          31,
          (i) => AnalyticsData(
            id: 'jan-$i',
            date: DateTime(2024, 1, i + 1),
            consumption: 0.15 + (i % 7) * 0.05,
          ),
        ),
      ),
      MonthlyStats(
        month: 'February 2024',
        totalConsumption: 11.8,
        totalRefills: 7.5,
        refillCount: 2,
        dailyData: List.generate(
          29,
          (i) => AnalyticsData(
            id: 'feb-$i',
            date: DateTime(2024, 2, i + 1),
            consumption: 0.14 + (i % 7) * 0.04,
          ),
        ),
      ),
      MonthlyStats(
        month: 'Current Month',
        totalConsumption: totalConsumption,
        totalRefills: totalRefills,
        refillCount: refillCount,
        dailyData: analytics,
      ),
    ];
  }
}

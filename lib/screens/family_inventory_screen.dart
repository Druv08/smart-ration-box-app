import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../data/mock_data.dart';
import '../widgets/common/luxury_card.dart';

/// Family Inventory screen showing all household containers
class FamilyInventoryScreen extends StatefulWidget {
  const FamilyInventoryScreen({super.key});

  @override
  State<FamilyInventoryScreen> createState() => _FamilyInventoryScreenState();
}

class _FamilyInventoryScreenState extends State<FamilyInventoryScreen> {
  String selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final items = MockData.inventoryItems;
    final filtered = selectedFilter == 'All'
        ? items
        : items.where((i) => i.status == selectedFilter).toList();

    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: AppTheme.darkCharcoal,
              elevation: 0,
              title: const Text(
                'Family Inventory',
                style: TextStyle(
                  color: AppTheme.lighterGray,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              floating: true,
              snap: true,
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Filter Chips
                  SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: ['All', 'In Stock', 'Low Stock']
                          .map(
                            (filter) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(filter),
                                selected: selectedFilter == filter,
                                onSelected: (selected) {
                                  setState(() {
                                    selectedFilter = filter;
                                  });
                                },
                                backgroundColor: AppTheme.darkerCharcoal,
                                selectedColor: AppTheme.gold.withValues(alpha:0.2),
                                side: BorderSide(
                                  color: selectedFilter == filter
                                      ? AppTheme.gold
                                      : AppTheme.darkerCharcoal,
                                ),
                                labelStyle: TextStyle(
                                  color: selectedFilter == filter
                                      ? AppTheme.gold
                                      : AppTheme.lightGray,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...filtered.map((item) {
                    final percent = (item.quantity / item.capacity * 100).clamp(
                      0,
                      100,
                    );
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: LuxuryCard(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name,
                                        style: const TextStyle(
                                          color: AppTheme.lighterGray,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        item.category,
                                        style: const TextStyle(
                                          color: AppTheme.lightGray,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: item.isLowStock
                                        ? AppTheme.warningOrange.withValues(alpha:
                                            0.15,
                                          )
                                        : AppTheme.successGreen.withValues(alpha:
                                            0.15,
                                          ),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    item.status,
                                    style: TextStyle(
                                      color: item.isLowStock
                                          ? AppTheme.warningOrange
                                          : AppTheme.successGreen,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${item.quantity}${item.unit}',
                                  style: const TextStyle(
                                    color: AppTheme.gold,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  '/ ${item.capacity}${item.unit}',
                                  style: const TextStyle(
                                    color: AppTheme.lightGray,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: percent / 100,
                                minHeight: 6,
                                backgroundColor: AppTheme.darkerCharcoal,
                                valueColor: AlwaysStoppedAnimation(
                                  item.isLowStock
                                      ? AppTheme.warningOrange
                                      : AppTheme.gold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Owner: ${item.owner}',
                                  style: const TextStyle(
                                    color: AppTheme.lightGray,
                                    fontSize: 11,
                                  ),
                                ),
                                Text(
                                  item.location,
                                  style: const TextStyle(
                                    color: AppTheme.lightGray,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ]),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.gold,
        onPressed: () {
          // Add new item
        },
        child: const Icon(Icons.add, color: AppTheme.darkBg),
      ),
    );
  }
}

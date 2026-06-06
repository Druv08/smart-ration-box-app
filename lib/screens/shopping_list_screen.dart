import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../data/mock_data.dart';
import '../widgets/common/luxury_card.dart';

/// Shopping list screen - add, view, edit, remove items
class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  final items = MockData.shoppingItems;
  String selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final filtered = selectedCategory == 'All'
        ? items
        : items.where((i) => i.category == selectedCategory).toList();

    final purchased = filtered.where((i) => i.isPurchased).toList();
    final pending = filtered.where((i) => !i.isPurchased).toList();

    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: AppTheme.darkCharcoal,
              elevation: 0,
              title: const Text(
                'Shopping List',
                style: TextStyle(
                  color: AppTheme.lighterGray,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              floating: true,
              snap: true,
              actions: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.gold.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '₹ ${(pending.fold<double>(0, (sum, item) => sum + item.estimatedCost)).toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: AppTheme.gold,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Pending Items
                  _SectionHeader(title: 'To Buy', count: pending.length),
                  const SizedBox(height: 12),
                  if (pending.isEmpty)
                    LuxuryCard(
                      padding: const EdgeInsets.all(24),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: AppTheme.successGreen,
                              size: 40,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'All items purchased!',
                              style: TextStyle(
                                color: AppTheme.lighterGray,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ...pending.map((item) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: LuxuryCard(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Checkbox(
                                value: item.isPurchased,
                                onChanged: (val) {
                                  // Mark as purchased
                                },
                                fillColor: WidgetStateProperty.all(
                                  AppTheme.gold,
                                ),
                                checkColor: AppTheme.darkBg,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.displayName,
                                      style: const TextStyle(
                                        color: AppTheme.lighterGray,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppTheme.gold.withOpacity(
                                              0.15,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          child: Text(
                                            item.category,
                                            style: const TextStyle(
                                              color: AppTheme.gold,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '₹ ${item.estimatedCost}',
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
                              PopupMenuButton(
                                color: AppTheme.darkCharcoal,
                                itemBuilder: (_) => [
                                  const PopupMenuItem(
                                    child: Text(
                                      'Edit',
                                      style: TextStyle(
                                        color: AppTheme.lighterGray,
                                      ),
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    child: Text(
                                      'Delete',
                                      style: TextStyle(
                                        color: AppTheme.errorRed,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  const SizedBox(height: 24),

                  // Purchased Items
                  if (purchased.isNotEmpty) ...[
                    _SectionHeader(title: 'Purchased', count: purchased.length),
                    const SizedBox(height: 12),
                    ...purchased.map((item) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: LuxuryCard(
                          padding: const EdgeInsets.all(10),
                          backgroundColor: AppTheme.darkerCharcoal.withOpacity(
                            0.5,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: AppTheme.successGreen,
                                size: 18,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  item.displayName,
                                  style: const TextStyle(
                                    color: AppTheme.lightGray,
                                    fontSize: 12,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ],
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

class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;

  const _SectionHeader({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppTheme.lighterGray,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.gold.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$count',
            style: const TextStyle(
              color: AppTheme.gold,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}

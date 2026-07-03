import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../data/mock_data.dart';
import '../models/shopping_item.dart';
import '../services/local_store.dart';
import '../widgets/common/luxury_card.dart';
import '../widgets/shopping/add_shopping_sheet.dart';

/// Shopping list screen - add, view, edit, remove items
class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  List<ShoppingItem> items = [];
  String selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final saved = await LocalStore.loadShopping();
    if (!mounted) return;
    setState(() {
      // Seed from mock data on first launch, then persist so subsequent
      // launches read the user's own list.
      items = saved ?? List.of(MockData.shoppingItems);
    });
    if (saved == null) LocalStore.saveShopping(items);
  }

  void _persist() => LocalStore.saveShopping(items);

  Future<void> _addItem() async {
    final item = await AddShoppingSheet.show(context);
    if (item == null) return;
    setState(() {
      items.add(item);
    });
    _persist();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${item.name} added to shopping list')),
    );
  }

  void _togglePurchased(ShoppingItem item) {
    final index = items.indexOf(item);
    if (index == -1) return;
    final nowPurchased = !item.isPurchased;
    setState(() {
      items[index] = item.copyWith(
        isPurchased: nowPurchased,
        purchasedDate: nowPurchased ? DateTime.now() : null,
      );
    });
    _persist();
  }

  void _deleteItem(ShoppingItem item) {
    setState(() => items.remove(item));
    _persist();
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('${item.name} removed')),
      );
  }

  Future<void> _editItem(ShoppingItem item) async {
    final nameCtrl = TextEditingController(text: item.name);
    final costCtrl =
        TextEditingController(text: item.estimatedCost.toStringAsFixed(0));

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              style: TextStyle(color: AppTheme.lighterGray),
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: costCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(color: AppTheme.lighterGray),
              decoration: const InputDecoration(labelText: 'Estimated Cost (₹)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (saved != true || !mounted) return;
    final index = items.indexOf(item);
    if (index == -1) return;
    setState(() {
      items[index] = ShoppingItem(
        id: item.id,
        name: nameCtrl.text.trim().isEmpty ? item.name : nameCtrl.text.trim(),
        category: item.category,
        quantity: item.quantity,
        unit: item.unit,
        estimatedCost:
            double.tryParse(costCtrl.text.trim()) ?? item.estimatedCost,
        isPurchased: item.isPurchased,
        addedDate: item.addedDate,
        purchasedDate: item.purchasedDate,
        notes: item.notes,
      );
    });
    _persist();
  }

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
              title: Text(
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
                        color: AppTheme.gold.withValues(alpha:0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '₹ ${(pending.fold<double>(0, (sum, item) => sum + item.estimatedCost)).toStringAsFixed(0)}',
                        style: TextStyle(
                          color: AppTheme.goldText,
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
                            Text(
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
                                onChanged: (_) => _togglePurchased(item),
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
                                      style: TextStyle(
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
                                            color: AppTheme.gold.withValues(alpha:
                                              0.15,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          child: Text(
                                            item.category,
                                            style: TextStyle(
                                              color: AppTheme.goldText,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '₹ ${item.estimatedCost}',
                                          style: TextStyle(
                                            color: AppTheme.lightGray,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuButton<String>(
                                color: AppTheme.darkCharcoal,
                                icon: Icon(
                                  Icons.more_vert,
                                  color: AppTheme.lightGray,
                                ),
                                onSelected: (value) {
                                  if (value == 'edit') {
                                    _editItem(item);
                                  } else if (value == 'delete') {
                                    _deleteItem(item);
                                  }
                                },
                                itemBuilder: (_) => [
                                  PopupMenuItem(
                                    value: 'edit',
                                    child: Text(
                                      'Edit',
                                      style: TextStyle(
                                        color: AppTheme.lighterGray,
                                      ),
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 'delete',
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
                    }),
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
                          backgroundColor: AppTheme.darkerCharcoal.withValues(alpha:
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
                                  style: TextStyle(
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
                    }),
                  ],
                ]),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.gold,
        onPressed: _addItem,
        tooltip: 'Add shopping item',
        child: Icon(Icons.add, color: AppTheme.darkBg),
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
          style: TextStyle(
            color: AppTheme.lighterGray,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.gold.withValues(alpha:0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$count',
            style: TextStyle(
              color: AppTheme.goldText,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../data/mock_data.dart';
import '../models/inventory_item.dart';
import '../services/local_store.dart';
import '../widgets/common/empty_state.dart';
import '../widgets/common/item_card.dart';
import '../widgets/inventory/add_inventory_sheet.dart';
import 'item_details_screen.dart';

/// Items screen — search, category filter, and the full inventory list.
class FamilyInventoryScreen extends StatefulWidget {
  const FamilyInventoryScreen({super.key});

  @override
  State<FamilyInventoryScreen> createState() => _FamilyInventoryScreenState();
}

class _FamilyInventoryScreenState extends State<FamilyInventoryScreen> {
  List<InventoryItem> _items = [];
  String _search = '';
  String _category = 'All';

  static const _currentUser = MockData.currentUserName;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final saved = await LocalStore.loadInventory();
    if (!mounted) return;
    setState(() => _items = saved ?? List.of(MockData.inventoryItems));
    if (saved == null) LocalStore.saveInventory(_items);
  }

  List<String> get _categories {
    final set = _items.map((e) => e.category).toSet().toList()..sort();
    return ['All', ...set];
  }

  List<InventoryItem> get _filtered {
    return _items.where((item) {
      final matchesCategory = _category == 'All' || item.category == _category;
      final matchesSearch =
          _search.isEmpty || item.name.toLowerCase().contains(_search);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  Future<void> _addItem() async {
    final item = await AddInventorySheet.show(context);
    if (item == null) return;
    setState(() => _items.add(item));
    LocalStore.saveInventory(_items);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${item.name} added to inventory')),
    );
  }

  /// Claims responsibility for [item] under the current user, persists, and
  /// returns the updated item.
  InventoryItem _claim(InventoryItem item) {
    final index = _items.indexOf(item);
    final updated = item.copyWith(claimedBy: _currentUser);
    if (index != -1) {
      setState(() => _items[index] = updated);
      LocalStore.saveInventory(_items);
    }
    return updated;
  }

  void _openDetails(InventoryItem item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ItemDetailsScreen(
          item: item,
          currentUser: _currentUser,
          onClaim: item.isClaimed ? null : () async => _claim(item),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: AppTheme.bg,
              floating: true,
              snap: true,
              title: const Text('Items'),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: _AddButton(onTap: _addItem),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                child: TextField(
                  onChanged: (v) => setState(() => _search = v.toLowerCase()),
                  decoration: const InputDecoration(
                    hintText: 'Search items',
                    prefixIcon: Icon(Icons.search_rounded),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _categories.length,
                  separatorBuilder: (context, i) => const SizedBox(width: 8),
                  itemBuilder: (_, i) {
                    final cat = _categories[i];
                    final selected = cat == _category;
                    return _CategoryChip(
                      label: cat,
                      selected: selected,
                      onTap: () => setState(() => _category = cat),
                    );
                  },
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            if (filtered.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: EmptyState(
                  icon: Icons.inventory_2_rounded,
                  title: 'No items found',
                  subtitle: _search.isNotEmpty
                      ? 'Try a different search.'
                      : 'Add your first item to get started.',
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                sliver: SliverList.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (context, i) => const SizedBox(height: 14),
                  itemBuilder: (_, i) {
                    final item = filtered[i];
                    return ItemCard(
                      item: item,
                      currentUser: _currentUser,
                      onTap: () => _openDetails(item),
                      onClaim: item.isClaimed ? null : () => _claim(item),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.primary,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: const Padding(
          padding: EdgeInsets.all(8),
          child: Icon(Icons.add_rounded, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primary : AppTheme.card,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: selected ? AppTheme.primary : AppTheme.divider,
          ),
        ),
        child: Text(
          label,
          style: AppTheme.label(
            13,
            color: selected ? Colors.white : AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }
}

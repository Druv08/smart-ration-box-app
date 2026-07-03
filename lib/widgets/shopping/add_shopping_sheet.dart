import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../config/theme.dart';
import '../../models/shopping_item.dart';

/// Bottom sheet form for adding a new [ShoppingItem].
///
/// Returns the created item via [Navigator.pop] when saved, or `null`
/// when dismissed.
class AddShoppingSheet extends StatefulWidget {
  const AddShoppingSheet({super.key});

  /// Shows the sheet and returns the new item, or null if cancelled.
  static Future<ShoppingItem?> show(BuildContext context) {
    return showModalBottomSheet<ShoppingItem>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddShoppingSheet(),
    );
  }

  @override
  State<AddShoppingSheet> createState() => _AddShoppingSheetState();
}

class _AddShoppingSheetState extends State<AddShoppingSheet> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _category = TextEditingController(text: 'Grains');
  final _quantity = TextEditingController();
  final _unit = TextEditingController(text: 'kg');
  final _cost = TextEditingController();
  final _notes = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _category.dispose();
    _quantity.dispose();
    _unit.dispose();
    _cost.dispose();
    _notes.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final notes = _notes.text.trim();
    final item = ShoppingItem(
      id: 'shop-${DateTime.now().millisecondsSinceEpoch}',
      name: _name.text.trim(),
      category: _category.text.trim().isEmpty ? 'Other' : _category.text.trim(),
      quantity: double.parse(_quantity.text.trim()),
      unit: _unit.text.trim().isEmpty ? 'kg' : _unit.text.trim(),
      estimatedCost: double.tryParse(_cost.text.trim()) ?? 0,
      isPurchased: false,
      addedDate: DateTime.now(),
      notes: notes.isEmpty ? null : notes,
    );
    Navigator.of(context).pop(item);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.darkCharcoal,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          border: Border.all(color: AppTheme.darkerCharcoal),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppTheme.darkerCharcoal,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(
                  'Add Shopping Item',
                  style: TextStyle(
                    color: AppTheme.lighterGray,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                _field(_name, 'Name', hint: 'e.g. Basmati Rice', required: true),
                _field(_category, 'Category', hint: 'e.g. Grains'),
                Row(
                  children: [
                    Expanded(
                      child: _field(
                        _quantity,
                        'Quantity',
                        hint: '0.0',
                        number: true,
                        required: true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: _field(_unit, 'Unit', hint: 'kg')),
                  ],
                ),
                _field(_cost, 'Estimated Cost (₹)', hint: '0', number: true),
                _field(_notes, 'Notes', hint: 'Optional'),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.gold,
                      foregroundColor: AppTheme.onGold,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Add Item'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    String? hint,
    bool number = false,
    bool required = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType:
            number ? const TextInputType.numberWithOptions(decimal: true) : null,
        inputFormatters: number
            ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))]
            : null,
        style: TextStyle(color: AppTheme.lighterGray),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
        ),
        validator: (value) {
          final text = value?.trim() ?? '';
          if (required && text.isEmpty) return 'Required';
          if (number && text.isNotEmpty && double.tryParse(text) == null) {
            return 'Invalid number';
          }
          return null;
        },
      ),
    );
  }
}
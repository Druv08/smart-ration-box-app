import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../config/theme.dart';
import '../../data/mock_data.dart';
import '../../models/inventory_item.dart';
import '../common/app_buttons.dart';

/// Bottom sheet form for adding a new [InventoryItem]. Keeps the form
/// minimal (name, capacity, threshold) and fills the remaining model fields
/// with sensible defaults so existing data/logic stays intact.
class AddInventorySheet extends StatefulWidget {
  const AddInventorySheet({super.key});

  static Future<InventoryItem?> show(BuildContext context) {
    return showModalBottomSheet<InventoryItem>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddInventorySheet(),
    );
  }

  @override
  State<AddInventorySheet> createState() => _AddInventorySheetState();
}

class _AddInventorySheetState extends State<AddInventorySheet> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _capacity = TextEditingController();
  final _threshold = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _capacity.dispose();
    _threshold.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final capacity = double.parse(_capacity.text.trim());
    final threshold = double.tryParse(_threshold.text.trim());
    // New containers start full; remaining model fields use defaults.
    final item = InventoryItem(
      id: 'inv-${DateTime.now().millisecondsSinceEpoch}',
      name: _name.text.trim(),
      category: 'General',
      quantity: capacity,
      capacity: capacity,
      unit: 'kg',
      status: 'In Stock',
      owner: MockData.currentUserName,
      lastRefilled: DateTime.now(),
      location: 'Pantry',
      lowStockThreshold: threshold,
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
          color: AppTheme.card,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: AppTheme.divider,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text('Add Item', style: AppTheme.heading(20)),
                const SizedBox(height: 4),
                Text('Create a new storage container',
                    style: AppTheme.body(13)),
                const SizedBox(height: 24),
                _label('Item name'),
                _field(_name, hint: 'e.g. Basmati Rice', required: true),
                const SizedBox(height: 20),
                _label('Maximum capacity (kg)'),
                _field(_capacity, hint: '10', number: true, required: true),
                const SizedBox(height: 20),
                _label('Low stock threshold (kg)'),
                _field(_threshold, hint: '2.5', number: true),
                const SizedBox(height: 32),
                PrimaryButton(label: 'Save Item', onPressed: _save),
                const SizedBox(height: 12),
                SecondaryButton(
                  label: 'Cancel',
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 4),
        child: Text(text, style: AppTheme.label(13)),
      );

  Widget _field(
    TextEditingController controller, {
    String? hint,
    bool number = false,
    bool required = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType:
          number ? const TextInputType.numberWithOptions(decimal: true) : null,
      inputFormatters: number
          ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))]
          : null,
      style: AppTheme.body(15, color: AppTheme.textPrimary),
      decoration: InputDecoration(hintText: hint),
      validator: (value) {
        final text = value?.trim() ?? '';
        if (required && text.isEmpty) return 'Required';
        if (number && text.isNotEmpty) {
          final parsed = double.tryParse(text);
          if (parsed == null) return 'Invalid number';
          if (required && parsed <= 0) return 'Must be greater than 0';
        }
        return null;
      },
    );
  }
}

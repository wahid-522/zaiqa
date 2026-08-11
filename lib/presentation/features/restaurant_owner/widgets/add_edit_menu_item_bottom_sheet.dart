import 'package:flutter/material.dart';
import '../../../../domain/entities/menu_item.dart';
import '../../../../shared/widgets/zaiqa_button.dart';
import '../../../../shared/widgets/zaiqa_text_field.dart';

class AddEditMenuItemBottomSheet extends StatefulWidget {
  final String restaurantId;
  final MenuItem? itemToEdit;
  final Function(MenuItem item) onSave;

  const AddEditMenuItemBottomSheet({
    super.key,
    required this.restaurantId,
    this.itemToEdit,
    required this.onSave,
  });

  @override
  State<AddEditMenuItemBottomSheet> createState() => _AddEditMenuItemBottomSheetState();
}

class _AddEditMenuItemBottomSheetState extends State<AddEditMenuItemBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _imageUrlController;
  late TextEditingController _categoryController;
  late bool _isSpicy;
  late bool _isVegetarian;

  @override
  void initState() {
    super.initState();
    final item = widget.itemToEdit;
    _nameController = TextEditingController(text: item?.name ?? '');
    _descriptionController = TextEditingController(text: item?.description ?? '');
    _priceController = TextEditingController(text: item != null ? item.price.toInt().toString() : '');
    _imageUrlController = TextEditingController(
      text: item?.imageUrl ??
          'https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=800&auto=format&fit=crop&q=80',
    );
    _categoryController = TextEditingController(text: item?.category ?? 'Mains');
    _isSpicy = item?.isSpicy ?? false;
    _isVegetarian = item?.isVegetarian ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState?.validate() ?? false) {
      final itemId = widget.itemToEdit?.id ?? 'item_${DateTime.now().millisecondsSinceEpoch}';
      final price = double.tryParse(_priceController.text.trim()) ?? 0.0;

      final newItem = MenuItem(
        id: itemId,
        restaurantId: widget.restaurantId,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        price: price,
        imageUrl: _imageUrlController.text.trim(),
        category: _categoryController.text.trim().isEmpty ? 'Mains' : _categoryController.text.trim(),
        isSpicy: _isSpicy,
        isVegetarian: _isVegetarian,
        tags: widget.itemToEdit?.tags ?? const ['Chef Special'],
      );

      widget.onSave(newItem);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.itemToEdit != null;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
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
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Text(
                isEditing ? 'Edit Menu Item' : 'Add New Menu Item',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C221E),
                ),
              ),
              const SizedBox(height: 16),

              ZaiqaTextField(
                label: 'Item Name',
                hint: 'e.g. Garlic Naan / Chicken Tikka',
                controller: _nameController,
                validator: (val) => val == null || val.trim().isEmpty ? 'Item name required' : null,
              ),
              const SizedBox(height: 12),

              ZaiqaTextField(
                label: 'Price (Rs.)',
                hint: 'e.g. 450',
                controller: _priceController,
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Price required';
                  if (double.tryParse(val.trim()) == null) return 'Valid price required';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              ZaiqaTextField(
                label: 'Category',
                hint: 'e.g. Starters, Mains, Desserts, Beverages',
                controller: _categoryController,
                validator: (val) => val == null || val.trim().isEmpty ? 'Category required' : null,
              ),
              const SizedBox(height: 12),

              ZaiqaTextField(
                label: 'Description',
                hint: 'Describe ingredients, preparation, and flavor...',
                controller: _descriptionController,
                validator: (val) => val == null || val.trim().isEmpty ? 'Description required' : null,
              ),
              const SizedBox(height: 12),

              ZaiqaTextField(
                label: 'Image URL',
                hint: 'https://images.unsplash.com/...',
                controller: _imageUrlController,
                validator: (val) => val == null || val.trim().isEmpty ? 'Image URL required' : null,
              ),
              const SizedBox(height: 16),

              // Switches Row
              Row(
                children: [
                  Expanded(
                    child: SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Vegetarian', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      value: _isVegetarian,
                      activeThumbColor: const Color(0xFFC63D00),
                      onChanged: (val) => setState(() => _isVegetarian = val),
                    ),
                  ),
                  Expanded(
                    child: SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Spicy', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      value: _isSpicy,
                      activeThumbColor: const Color(0xFFC63D00),
                      onChanged: (val) => setState(() => _isSpicy = val),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              ZaiqaButton(
                text: isEditing ? 'Update Menu Item' : 'Add Item to Menu',
                onPressed: _onSave,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

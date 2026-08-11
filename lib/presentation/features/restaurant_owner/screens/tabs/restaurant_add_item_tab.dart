import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../domain/entities/menu_item.dart';
import '../../../../../shared/widgets/zaiqa_button.dart';
import '../../../../../shared/widgets/zaiqa_text_field.dart';
import '../../viewmodels/menu_management_viewmodel.dart';

class RestaurantAddItemTab extends ConsumerStatefulWidget {
  final MenuItem? itemToEdit;
  final VoidCallback onSaved;

  const RestaurantAddItemTab({
    super.key,
    this.itemToEdit,
    required this.onSaved,
  });

  @override
  ConsumerState<RestaurantAddItemTab> createState() => _RestaurantAddItemTabState();
}

class _RestaurantAddItemTabState extends ConsumerState<RestaurantAddItemTab> {
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
    _initControllers();
  }

  @override
  void didUpdateWidget(covariant RestaurantAddItemTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.itemToEdit != widget.itemToEdit) {
      _initControllers();
    }
  }

  void _initControllers() {
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

  void _onSave() async {
    if (_formKey.currentState?.validate() ?? false) {
      final restId = ref.read(menuManagementViewModelProvider).restaurant?.id ?? 'rest_spice_route';
      final itemId = widget.itemToEdit?.id ?? 'item_${DateTime.now().millisecondsSinceEpoch}';
      final price = double.tryParse(_priceController.text.trim()) ?? 0.0;

      final newItem = MenuItem(
        id: itemId,
        restaurantId: restId,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        price: price,
        imageUrl: _imageUrlController.text.trim(),
        category: _categoryController.text.trim().isEmpty ? 'Mains' : _categoryController.text.trim(),
        isSpicy: _isSpicy,
        isVegetarian: _isVegetarian,
        tags: widget.itemToEdit?.tags ?? const ['Chef Special'],
      );

      final viewModel = ref.read(menuManagementViewModelProvider.notifier);
      bool success;
      if (widget.itemToEdit != null) {
        success = await viewModel.updateMenuItem(newItem);
        if (mounted && success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${newItem.name} updated successfully!')),
          );
        }
      } else {
        success = await viewModel.addMenuItem(newItem);
        if (mounted && success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${newItem.name} added to menu!')),
          );
        }
      }

      if (success) {
        widget.onSaved();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.itemToEdit != null;

    return Scaffold(
      backgroundColor: const Color(0xFFFCF7F4),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),
                Text(
                  isEditing ? 'Edit Menu Item' : 'Add New Item',
                  style: GoogleFonts.outfit(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2C221E),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isEditing ? 'Update price, details, or category' : 'Fill in item details to publish to your menu',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 24),

                ZaiqaTextField(
                  label: 'Item Name',
                  hint: 'e.g. Garlic Naan / Chicken Karahi',
                  controller: _nameController,
                  prefixIcon: Icons.fastfood_outlined,
                  validator: (val) => val == null || val.trim().isEmpty ? 'Item name is required' : null,
                ),
                const SizedBox(height: 14),

                ZaiqaTextField(
                  label: 'Price (Rs.)',
                  hint: 'e.g. 450',
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  prefixIcon: Icons.payments_outlined,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Price required';
                    if (double.tryParse(val.trim()) == null) return 'Valid numeric price required';
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                ZaiqaTextField(
                  label: 'Category',
                  hint: 'e.g. Starters, Mains, Breads, Desserts',
                  controller: _categoryController,
                  prefixIcon: Icons.category_outlined,
                  validator: (val) => val == null || val.trim().isEmpty ? 'Category is required' : null,
                ),
                const SizedBox(height: 14),

                ZaiqaTextField(
                  label: 'Description',
                  hint: 'Describe ingredients, preparation, and flavor profile...',
                  controller: _descriptionController,
                  prefixIcon: Icons.description_outlined,
                  validator: (val) => val == null || val.trim().isEmpty ? 'Description is required' : null,
                ),
                const SizedBox(height: 14),

                ZaiqaTextField(
                  label: 'Image URL',
                  hint: 'https://images.unsplash.com/...',
                  controller: _imageUrlController,
                  prefixIcon: Icons.image_outlined,
                  validator: (val) => val == null || val.trim().isEmpty ? 'Image URL is required' : null,
                ),
                const SizedBox(height: 16),

                // Veg / Spicy Switch List Tiles
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    children: [
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Vegetarian Item', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        value: _isVegetarian,
                        activeThumbColor: const Color(0xFFC63D00),
                        onChanged: (val) => setState(() => _isVegetarian = val),
                      ),
                      const Divider(height: 1),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Spicy Item', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        value: _isSpicy,
                        activeThumbColor: const Color(0xFFC63D00),
                        onChanged: (val) => setState(() => _isSpicy = val),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                ZaiqaButton(
                  text: isEditing ? 'Save Changes' : 'Publish to Menu',
                  onPressed: _onSave,
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

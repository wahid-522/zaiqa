import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../domain/entities/menu_item.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import '../viewmodels/menu_management_viewmodel.dart';
import '../widgets/add_edit_menu_item_bottom_sheet.dart';

class RestaurantMenuManagementScreen extends ConsumerWidget {
  const RestaurantMenuManagementScreen({super.key});

  void _openAddEditBottomSheet(BuildContext context, WidgetRef ref, {MenuItem? itemToEdit}) {
    final viewModel = ref.read(menuManagementViewModelProvider.notifier);
    final restId = ref.read(menuManagementViewModelProvider).restaurant?.id ?? 'rest_spice_route';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return AddEditMenuItemBottomSheet(
          restaurantId: restId,
          itemToEdit: itemToEdit,
          onSave: (item) {
            if (itemToEdit == null) {
              viewModel.addMenuItem(item);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${item.name} added to your menu!')),
              );
            } else {
              viewModel.updateMenuItem(item);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${item.name} updated successfully!')),
              );
            }
          },
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, MenuItem item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Delete Menu Item?'),
          content: Text('Are you sure you want to remove "${item.name}" from your menu?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                ref.read(menuManagementViewModelProvider.notifier).deleteMenuItem(item.id);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${item.name} deleted.')),
                );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuState = ref.watch(menuManagementViewModelProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFCF7F4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFCF7F4),
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.only(left: 16),
          child: Icon(Icons.storefront_rounded, color: Color(0xFFC63D00), size: 28),
        ),
        title: Text(
          'Zaiqa Owner Portal',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF2C221E),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Color(0xFF2C221E)),
            tooltip: 'Log Out',
            onPressed: () {
              ref.read(authViewModelProvider.notifier).logout();
              context.go(RouteNames.loginPath);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFFC63D00),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Item', style: TextStyle(fontWeight: FontWeight.bold)),
        onPressed: () => _openAddEditBottomSheet(context, ref),
      ),
      body: SafeArea(
        child: menuState.isLoading
            ? const Center(child: CircularProgressIndicator(color: Color(0xFFC63D00)))
            : menuState.restaurant == null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.store_outlined, size: 64, color: Colors.grey),
                          const SizedBox(height: 16),
                          Text(
                            menuState.errorMessage ?? 'No restaurant profile found.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFC63D00),
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () => context.go(RouteNames.restaurantOnboardingPath),
                            child: const Text('Set Up Restaurant Profile'),
                          ),
                        ],
                      ),
                    ),
                  )
                : Column(
                    children: [
                      // Restaurant Header Card
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Image.network(
                                  menuState.restaurant!.imageUrl,
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    width: 70,
                                    height: 70,
                                    color: const Color(0xFFFFF0EC),
                                    child: const Icon(Icons.restaurant, color: Color(0xFFC63D00)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      menuState.restaurant!.name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2C221E),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      menuState.restaurant!.cuisineTypes.join(' • '),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        const Icon(Icons.star_rounded, size: 14, color: Color(0xFFC63D00)),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${menuState.restaurant!.rating} (${menuState.restaurant!.reviewCount} reviews)',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey.shade800,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Section Title Bar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Menu Management',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF2C221E),
                              ),
                            ),
                            Text(
                              '${menuState.restaurant!.menu.length} Items',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Category Filter Chips
                      SizedBox(
                        height: 40,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          itemCount: menuState.categories.length,
                          itemBuilder: (context, index) {
                            final cat = menuState.categories[index];
                            final isSelected = cat == menuState.selectedCategory;

                            return GestureDetector(
                              onTap: () => ref
                                  .read(menuManagementViewModelProvider.notifier)
                                  .selectCategory(cat),
                              child: Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSelected ? const Color(0xFFC63D00) : Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isSelected ? const Color(0xFFC63D00) : Colors.grey.shade300,
                                  ),
                                ),
                                child: Text(
                                  cat,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected ? Colors.white : Colors.grey.shade800,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Filtered Menu Item Cards List
                      Expanded(
                        child: menuState.filteredMenu.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.restaurant_menu, size: 48, color: Colors.grey.shade400),
                                    const SizedBox(height: 12),
                                    Text(
                                      'No items in this category yet.',
                                      style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.only(left: 18, right: 18, bottom: 80),
                                itemCount: menuState.filteredMenu.length,
                                itemBuilder: (context, index) {
                                  final item = menuState.filteredMenu[index];

                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 14),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.04),
                                          blurRadius: 10,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Item Image
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Image.network(
                                            item.imageUrl,
                                            width: 75,
                                            height: 75,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) => Container(
                                              width: 75,
                                              height: 75,
                                              color: const Color(0xFFFFF0EC),
                                              child: const Icon(Icons.fastfood, color: Color(0xFFC63D00)),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),

                                        // Item Details
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  // Veg/NonVeg Indicator
                                                  Container(
                                                    padding: const EdgeInsets.all(2),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: item.isVegetarian ? Colors.green : Colors.red,
                                                        width: 1.5,
                                                      ),
                                                      borderRadius: BorderRadius.circular(4),
                                                    ),
                                                    child: Icon(
                                                      Icons.circle,
                                                      size: 8,
                                                      color: item.isVegetarian ? Colors.green : Colors.red,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Expanded(
                                                    child: Text(
                                                      item.name,
                                                      style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.bold,
                                                        color: Color(0xFF2C221E),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                item.description,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey.shade600,
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                'Rs. ${item.price.toInt()}',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFFC63D00),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // Edit & Delete Action Buttons
                                        Column(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.edit_outlined, color: Color(0xFF2C221E), size: 20),
                                              tooltip: 'Edit Item',
                                              onPressed: () => _openAddEditBottomSheet(context, ref, itemToEdit: item),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete_outline_rounded, color: Colors.red, size: 20),
                                              tooltip: 'Delete Item',
                                              onPressed: () => _confirmDelete(context, ref, item),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
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

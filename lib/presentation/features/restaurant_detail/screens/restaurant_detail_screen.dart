import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/loading_shimmer.dart';
import '../../../../shared/widgets/menu_item_card.dart';
import '../viewmodels/restaurant_detail_viewmodel.dart';
import '../widgets/item_detail_bottom_sheet.dart';

class RestaurantDetailScreen extends ConsumerStatefulWidget {
  final String restaurantId;

  const RestaurantDetailScreen({
    super.key,
    required this.restaurantId,
  });

  @override
  ConsumerState<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends ConsumerState<RestaurantDetailScreen> {
  String _selectedCategory = 'Starters';

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(restaurantDetailViewModelProvider(widget.restaurantId));
    final viewModel = ref.read(restaurantDetailViewModelProvider(widget.restaurantId).notifier);
    final restaurant = state.restaurant;

    if (state.isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFFCF7F4),
        appBar: AppBar(backgroundColor: const Color(0xFFFCF7F4)),
        body: const Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              LoadingShimmer(width: double.infinity, height: 200, borderRadius: 16),
              SizedBox(height: 20),
              LoadingShimmer(width: double.infinity, height: 100, borderRadius: 12),
            ],
          ),
        ),
      );
    }

    if (restaurant == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFFCF7F4),
        appBar: AppBar(title: const Text('Restaurant Details'), backgroundColor: const Color(0xFFFCF7F4)),
        body: EmptyStateWidget(
          icon: Icons.error_outline,
          title: 'Restaurant Not Found',
          description: state.errorMessage ?? 'Unable to fetch menu for this restaurant.',
          buttonText: 'Go Back',
          onButtonPressed: () => context.pop(),
        ),
      );
    }

    // Group Menu Items by Category
    final categoriesMap = <String, List<dynamic>>{};
    for (var item in restaurant.menu) {
      categoriesMap.putIfAbsent(item.category, () => []).add(item);
    }

    final categories = categoriesMap.keys.toList();
    if (!categories.contains(_selectedCategory) && categories.isNotEmpty) {
      _selectedCategory = categories.first;
    }

    final currentCategoryItems = categoriesMap[_selectedCategory] ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFFCF7F4),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Hero Image & Top Floating Actions Header
              SliverToBoxAdapter(
                child: Stack(
                  children: [
                    // Cover Image with rounded bottom
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                      child: Image.network(
                        restaurant.imageUrl,
                        height: 240,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 240,
                          color: const Color(0xFFFFF0EC),
                          child: const Icon(Icons.restaurant, size: 64, color: AppColors.primary),
                        ),
                      ),
                    ),

                    // Top Bar Floating Action Buttons
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Back Button
                            GestureDetector(
                              onTap: () => context.pop(),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.arrow_back, color: Color(0xFF2C221E), size: 20),
                              ),
                            ),

                            // Share & Favorite Buttons
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.share_outlined, color: Color(0xFF2C221E), size: 20),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    restaurant.isFavorite ? Icons.favorite : Icons.favorite_border,
                                    color: const Color(0xFFC63D00),
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Overlapping Restaurant Specs Card
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title & Rating Pill Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  restaurant.name,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2C221E),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  restaurant.cuisineTypes.join(', '),
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Rating Box
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF0EC),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      restaurant.rating.toStringAsFixed(1),
                                      style: const TextStyle(
                                        color: Color(0xFFC63D00),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(width: 2),
                                    const Icon(Icons.star_rounded, color: Color(0xFFD84315), size: 14),
                                  ],
                                ),
                                Text(
                                  '${(restaurant.reviewCount / 1000).toStringAsFixed(0)}k+ ratings',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Delivery Time & Distance Row
                      Row(
                        children: [
                          // Delivery Time
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFFF0EC),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.access_time_rounded, size: 16, color: Color(0xFFC63D00)),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    restaurant.deliveryTime,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF2C221E),
                                    ),
                                  ),
                                  Text(
                                    'Delivery Time',
                                    style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(width: 24),

                          // Distance
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFFF0EC),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.location_on_outlined, size: 16, color: Color(0xFFC63D00)),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    '2.5 km',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF2C221E),
                                    ),
                                  ),
                                  Text(
                                    'Distance',
                                    style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Category Filter Tabs Row
              SliverToBoxAdapter(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: categories.map((cat) {
                      final isSelected = cat == _selectedCategory;
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCategory = cat;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFFC63D00) : const Color(0xFFFFF0EC),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              cat,
                              style: TextStyle(
                                color: isSelected ? Colors.white : const Color(0xFF2C221E),
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              // Category Section Title
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                  child: Row(
                    children: [
                      Text(
                        _selectedCategory,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C221E),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '(${currentCategoryItems.length})',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Selected Category Menu Items List
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final menuItem = currentCategoryItems[index];
                      final qty = state.itemQuantities[menuItem.id] ?? 0;
                      return GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (ctx) => ItemDetailBottomSheet(
                              menuItem: menuItem,
                              onAddToCart: (quantity, selectedSize, totalPrice) {
                                for (int i = 0; i < quantity; i++) {
                                  viewModel.addToCart(menuItem);
                                }
                              },
                            ),
                          );
                        },
                        child: MenuItemCard(
                          menuItem: menuItem,
                          cartQuantity: qty,
                          onAdd: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (ctx) => ItemDetailBottomSheet(
                                menuItem: menuItem,
                                onAddToCart: (quantity, selectedSize, totalPrice) {
                                  for (int i = 0; i < quantity; i++) {
                                    viewModel.addToCart(menuItem);
                                  }
                                },
                              ),
                            );
                          },
                          onIncrement: () => viewModel.incrementQuantity(menuItem),
                          onDecrement: () => viewModel.decrementQuantity(menuItem),
                        ),
                      );
                    },
                    childCount: currentCategoryItems.length,
                  ),
                ),
              ),

              const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
            ],
          ),

          // Sticky Floating View Cart Bar
          if (state.cartTotalCount > 0)
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: GestureDetector(
                onTap: () => context.push(RouteNames.cartPath),
                child: Container(
                  height: 58,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFC63D00),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFC63D00).withValues(alpha: 0.35),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${state.cartTotalCount} ITEMS ADDED',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Rs. ${state.cartSubtotal.toInt()}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      const Row(
                        children: [
                          Text(
                            'View Cart',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 18),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

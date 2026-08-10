import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../shared/widgets/cuisine_filter_chip.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/loading_shimmer.dart';
import '../../../../shared/widgets/restaurant_card.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import '../viewmodels/restaurant_list_viewmodel.dart';

class RestaurantListScreen extends ConsumerWidget {
  const RestaurantListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(restaurantListViewModelProvider);
    final viewModel = ref.read(restaurantListViewModelProvider.notifier);
    final user = ref.watch(authViewModelProvider).user;

    return Scaffold(
      backgroundColor: const Color(0xFFFCF7F4), // Warm off-white background matching design
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => viewModel.loadRestaurants(),
          color: const Color(0xFFC63D00),
          child: CustomScrollView(
            slivers: [
              // Top Bar with Drawer Icon, Brand Logo & Profile Avatar
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notes_rounded, size: 26, color: Color(0xFF2C221E)),
                        onPressed: () {},
                      ),
                      Text(
                        'Zaiqa',
                        style: GoogleFonts.outfit(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFC63D00),
                          letterSpacing: -0.5,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.push(RouteNames.profilePath),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Color(0xFFF5EBE6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person_outline_rounded,
                            size: 22,
                            color: Color(0xFF2C221E),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Deliver To Address Selector
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                sliver: SliverToBoxAdapter(
                  child: GestureDetector(
                    onTap: () async {
                      final selectedAddress = await context.push<dynamic>('/address-picker');
                      if (selectedAddress != null) {
                        viewModel.loadRestaurants();
                      }
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 22,
                          color: Color(0xFFC63D00),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'DELIVER TO',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF756A63),
                                  letterSpacing: 0.8,
                                ),
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      user?.savedAddresses.isNotEmpty == true
                                          ? user!.savedAddresses.first
                                          : '123 Culinary Avenue, Food District',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Color(0xFF2C221E),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    size: 18,
                                    color: Color(0xFF2C221E),
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
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 16)),

              // Search Input Bar with Filter Button
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                sliver: SliverToBoxAdapter(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF0EC),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextField(
                      onChanged: (val) => viewModel.setSearchQuery(val),
                      decoration: InputDecoration(
                        hintText: 'What are you craving?',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: Color(0xFF756A63),
                          size: 22,
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.tune_rounded,
                            color: Color(0xFFC63D00),
                            size: 20,
                          ),
                          onPressed: () {},
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 18)),

              // Horizontal Cuisine Categories Chips
              SliverPadding(
                padding: const EdgeInsets.only(left: 18),
                sliver: SliverToBoxAdapter(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: AppConstants.cuisineCategories.map((category) {
                        return CuisineFilterChip(
                          label: category,
                          isSelected: state.selectedCategory == category,
                          onTap: () => viewModel.selectCategory(category),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 18)),

              // Restaurant List / Shimmer / Empty State
              if (state.isLoading)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => const Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: LoadingShimmer(width: double.infinity, height: 230, borderRadius: 20),
                      ),
                      childCount: 3,
                    ),
                  ),
                )
              else if (state.restaurants.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: EmptyStateWidget(
                      icon: Icons.search_off,
                      title: 'No Restaurants Found',
                      description:
                          'We couldn\'t find any restaurants matching "${state.searchQuery}". Try a different keyword!',
                      buttonText: 'Reset Filters',
                      onButtonPressed: () {
                        viewModel.setSearchQuery('');
                        viewModel.selectCategory('All');
                      },
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final restaurant = state.restaurants[index];
                        return RestaurantCard(
                          restaurant: restaurant,
                          onTap: () => context.push('/restaurant/${restaurant.id}'),
                          onFavoriteToggle: () => viewModel.toggleFavorite(restaurant.id),
                        );
                      },
                      childCount: state.restaurants.length,
                    ),
                  ),
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ),
      ),
    );
  }
}

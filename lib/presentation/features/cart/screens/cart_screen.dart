import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../viewmodels/cart_viewmodel.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cartViewModelProvider.notifier).loadCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(cartViewModelProvider);
    final viewModel = ref.read(cartViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFFCF7F4),
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar Header with Logo & Avatar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

            state.items.isEmpty
                ? Expanded(
                    child: EmptyStateWidget(
                      icon: Icons.shopping_bag_outlined,
                      title: 'Your cart is empty',
                      description: 'Explore restaurants and add your favorite dishes to the cart.',
                      buttonText: 'Browse Restaurants',
                      onButtonPressed: () => context.go(RouteNames.homePath),
                    ),
                  )
                : Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Screen Title Section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Your Cart',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2C221E),
                                ),
                              ),
                              TextButton(
                                onPressed: () => viewModel.clearCart(),
                                child: const Text(
                                  'Clear All',
                                  style: TextStyle(color: AppColors.error, fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Review your selections from Spice Route Kitchen.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Itemized Cart Cards List
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.items.length,
                            itemBuilder: (context, index) {
                              final item = state.items[index];
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
                                  children: [
                                    // Thumbnail
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        item.menuItem.imageUrl,
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

                                    // Item Info & Controls
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.menuItem.name,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF2C221E),
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 3),
                                          Text(
                                            item.menuItem.description,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade600,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Rs. ${item.menuItem.price.toInt()}',
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFFC63D00),
                                                ),
                                              ),

                                              // Quantity Capsule Pill
                                              Container(
                                                height: 32,
                                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFFFF0EC),
                                                  borderRadius: BorderRadius.circular(16),
                                                ),
                                                child: Row(
                                                  children: [
                                                    IconButton(
                                                      icon: const Icon(Icons.remove, size: 16, color: Color(0xFFC63D00)),
                                                      padding: EdgeInsets.zero,
                                                      constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
                                                      onPressed: () => viewModel.updateQuantity(item.id, item.quantity - 1),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 6),
                                                      child: Text(
                                                        '${item.quantity}',
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 14,
                                                          color: Color(0xFF2C221E),
                                                        ),
                                                      ),
                                                    ),
                                                    IconButton(
                                                      icon: const Icon(Icons.add, size: 16, color: Color(0xFFC63D00)),
                                                      padding: EdgeInsets.zero,
                                                      constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
                                                      onPressed: () => viewModel.updateQuantity(item.id, item.quantity + 1),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 6),

                          // Add More Items Outlined Dashed Button
                          GestureDetector(
                            onTap: () => context.push(RouteNames.homePath),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF0EC),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(0xFFC63D00).withValues(alpha: 0.3),
                                  width: 1.2,
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_circle_outline, color: Color(0xFFC63D00), size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    'Add more items',
                                    style: TextStyle(
                                      color: Color(0xFFC63D00),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Order Summary Card
                          Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Order Summary',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2C221E),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Subtotal', style: TextStyle(color: Colors.grey.shade700, fontSize: 14)),
                                    Text(
                                      'Rs. ${state.subtotal.toInt()}',
                                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Delivery Fee', style: TextStyle(color: Colors.grey.shade700, fontSize: 14)),
                                    Text(
                                      'Rs. ${state.deliveryFee.toInt()}',
                                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Taxes & Fees', style: TextStyle(color: Colors.grey.shade700, fontSize: 14)),
                                    Text(
                                      'Rs. ${state.taxAmount.toInt()}',
                                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                    ),
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  child: Divider(height: 1),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Total',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2C221E),
                                      ),
                                    ),
                                    Text(
                                      'Rs. ${state.totalAmount.toInt()}',
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFC63D00),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Proceed to Checkout Button
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFC63D00),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              onPressed: () => context.push(RouteNames.checkoutPath),
                              child: const Text(
                                'Proceed to Checkout',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

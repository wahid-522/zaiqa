import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../domain/entities/order.dart';
import '../../../../shared_providers.dart';
import '../../../auth/viewmodels/auth_viewmodel.dart';
import '../../viewmodels/menu_management_viewmodel.dart';

final restaurantOrdersProvider = FutureProvider.autoDispose<List<Order>>((ref) async {
  final user = ref.watch(authViewModelProvider).user;
  final restId = user?.restaurantId ?? 'rest_spice_route';
  final useCase = ref.watch(getRestaurantOrdersUseCaseProvider);

  final result = await useCase.execute(restId);
  return result.when(
    success: (orders) => orders,
    failure: (_) => const [],
  );
});

class RestaurantOrdersTab extends ConsumerWidget {
  const RestaurantOrdersTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(restaurantOrdersProvider);
    final restaurant = ref.watch(menuManagementViewModelProvider).restaurant;

    return Scaffold(
      backgroundColor: const Color(0xFFFCF7F4),
      body: SafeArea(
        child: Column(
          children: [
            // Top Title Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Incoming Orders',
                      style: GoogleFonts.outfit(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2C221E),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Orders placed for ${restaurant?.name ?? 'your restaurant'}',
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: ordersAsync.when(
                loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFFC63D00))),
                error: (err, stack) => Center(child: Text('Failed to load orders: $err')),
                data: (orders) {
                  if (orders.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.receipt_long_outlined, size: 56, color: Colors.grey.shade400),
                          const SizedBox(height: 14),
                          Text(
                            'No orders received yet.',
                            style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      final isCancelled = order.status == OrderStatus.cancelled;
                      final isDelivered = order.status == OrderStatus.delivered;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(16),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header Row: Order ID, Date & Status Badge
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      order.id,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2C221E),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year} • ${order.paymentMethod}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),

                                // Status Badge
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: isCancelled
                                        ? const Color(0xFFFFEBEE)
                                        : isDelivered
                                            ? const Color(0xFFFFF0EC)
                                            : const Color(0xFFE8F5E9),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        isCancelled
                                            ? Icons.cancel_outlined
                                            : isDelivered
                                                ? Icons.check_circle_outline
                                                : Icons.local_shipping_outlined,
                                        size: 13,
                                        color: isCancelled
                                            ? const Color(0xFFD32F2F)
                                            : isDelivered
                                                ? const Color(0xFF8D4B38)
                                                : const Color(0xFF2E7D32),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        order.status.displayName,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: isCancelled
                                              ? const Color(0xFFD32F2F)
                                              : isDelivered
                                                  ? const Color(0xFF8D4B38)
                                                  : const Color(0xFF2E7D32),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Divider(height: 1),
                            ),

                            // Delivery Address & Total Price
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Icon(Icons.location_on_outlined, size: 16, color: Colors.grey.shade600),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          order.deliveryAddress,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'Rs. ${order.totalAmount.toInt()}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFC63D00),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
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

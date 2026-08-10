import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/loading_shimmer.dart';
import '../../../../shared/widgets/status_stepper.dart';
import '../viewmodels/order_tracking_viewmodel.dart';

class OrderTrackingScreen extends ConsumerWidget {
  final String orderId;

  const OrderTrackingScreen({
    super.key,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(orderTrackingViewModelProvider(orderId));
    final viewModel = ref.read(orderTrackingViewModelProvider(orderId).notifier);
    final order = state.order;

    if (state.isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFFCF7F4),
        appBar: AppBar(backgroundColor: const Color(0xFFFCF7F4)),
        body: const Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              LoadingShimmer(width: double.infinity, height: 100, borderRadius: 16),
              SizedBox(height: 16),
              LoadingShimmer(width: double.infinity, height: 200, borderRadius: 16),
            ],
          ),
        ),
      );
    }

    if (order == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFFCF7F4),
        appBar: AppBar(title: const Text('Order Tracking'), backgroundColor: const Color(0xFFFCF7F4)),
        body: EmptyStateWidget(
          icon: Icons.search_off,
          title: 'Order Not Found',
          description: 'We couldn\'t find order ID: $orderId',
          buttonText: 'Back to Home',
          onButtonPressed: () => context.go(RouteNames.homePath),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFCF7F4),
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.go(RouteNames.homePath),
                    child: const Icon(Icons.arrow_back, color: Color(0xFF2C221E), size: 24),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Order Placed!',
                        style: GoogleFonts.outfit(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFC63D00),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 24), // Balance left arrow
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                child: Column(
                  children: [
                    // Estimated Arrival Card Header
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
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
                      child: Column(
                        children: [
                          Text(
                            'Estimated Arrival',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            order.estimatedDeliveryTime.isEmpty ? '45 – 55 min' : order.estimatedDeliveryTime,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFC63D00),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Order #${order.id}',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Track Order Timeline Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Track Order',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2C221E),
                                ),
                              ),
                              // Demo button to advance status
                              GestureDetector(
                                onTap: () => viewModel.advanceStatus(),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFF0EC),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    'Advance ➔',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFC63D00),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),

                          // Vertical Stepper Timeline
                          StatusStepperWidget(currentStatus: order.status),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Order Summary Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
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

                          // Itemized items
                          ...order.items.map((item) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${item.quantity}x ${item.menuItem.name}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF2C221E),
                                            ),
                                          ),
                                          if (item.menuItem.description.isNotEmpty) ...[
                                            const SizedBox(height: 2),
                                            Text(
                                              item.menuItem.description,
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey.shade600,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                    Text(
                                      'Rs. ${item.totalPrice.toInt()}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF2C221E),
                                      ),
                                    ),
                                  ],
                                ),
                              )),

                          const Divider(height: 20),

                          // Total Row
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
                                'Rs. ${order.totalAmount.toInt()}',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFC63D00),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Contact Support Button
                          GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Support agent is connecting...')),
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              height: 46,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF0EC),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.headset_mic_outlined, size: 18, color: Color(0xFFC63D00)),
                                  SizedBox(width: 8),
                                  Text(
                                    'Contact Support',
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
                        ],
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

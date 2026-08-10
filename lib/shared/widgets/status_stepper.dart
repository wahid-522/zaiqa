import 'package:flutter/material.dart';
import '../../domain/entities/order.dart';

class StatusStepperWidget extends StatelessWidget {
  final OrderStatus currentStatus;

  const StatusStepperWidget({
    super.key,
    required this.currentStatus,
  });

  int get _currentStepIndex {
    switch (currentStatus) {
      case OrderStatus.placed:
        return 0;
      case OrderStatus.preparing:
        return 1;
      case OrderStatus.outForDelivery:
        return 2;
      case OrderStatus.delivered:
        return 3;
      case OrderStatus.cancelled:
        return -1;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentStatus == OrderStatus.cancelled) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.red[200]!),
        ),
        child: const Row(
          children: [
            Icon(Icons.cancel, color: Colors.red),
            SizedBox(width: 12),
            Text(
              'This order has been cancelled',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }

    final activeIndex = _currentStepIndex;

    final steps = [
      {
        'title': 'Order Placed',
        'subtitle': 'We have received your order.',
        'icon': Icons.check,
      },
      {
        'title': 'Preparing',
        'subtitle': 'The kitchen is preparing your food.',
        'icon': Icons.soup_kitchen_outlined,
      },
      {
        'title': 'Out for Delivery',
        'subtitle': 'Your order is on the way.',
        'icon': Icons.delivery_dining_outlined,
      },
      {
        'title': 'Delivered',
        'subtitle': 'Enjoy your meal!',
        'icon': Icons.home_outlined,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(steps.length, (index) {
        final isCompleted = index < activeIndex;
        final isCurrent = index == activeIndex;
        final isLast = index == steps.length - 1;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Column of Icon & Vertical Line
              Column(
                children: [
                  // Step Circle Indicator
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted
                          ? const Color(0xFFC63D00)
                          : isCurrent
                              ? Colors.white
                              : const Color(0xFFFFF0EC),
                      border: Border.all(
                        color: isCompleted || isCurrent
                            ? const Color(0xFFC63D00)
                            : Colors.transparent,
                        width: isCurrent ? 2 : 1,
                      ),
                    ),
                    child: Icon(
                      steps[index]['icon'] as IconData,
                      size: isCompleted ? 18 : 20,
                      color: isCompleted
                          ? Colors.white
                          : isCurrent
                              ? const Color(0xFFC63D00)
                              : Colors.grey.shade400,
                    ),
                  ),

                  // Vertical Line to next step
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        color: isCompleted ? const Color(0xFFC63D00) : const Color(0xFFFFDBCF),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 14),

              // Title & Subtitle Column
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        steps[index]['title'] as String,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isCompleted || isCurrent
                              ? const Color(0xFFC63D00)
                              : const Color(0xFF2C221E),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        steps[index]['subtitle'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

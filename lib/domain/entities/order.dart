import 'package:equatable/equatable.dart';
import 'cart_item.dart';

enum OrderStatus {
  placed,
  preparing,
  outForDelivery,
  delivered,
  cancelled;

  String get displayName {
    switch (this) {
      case OrderStatus.placed:
        return 'Order Placed';
      case OrderStatus.preparing:
        return 'Preparing in Kitchen';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get description {
    switch (this) {
      case OrderStatus.placed:
        return 'Restaurant has received your order.';
      case OrderStatus.preparing:
        return 'The chef is cooking your delicious meal.';
      case OrderStatus.outForDelivery:
        return 'Rider is on the way to your delivery location.';
      case OrderStatus.delivered:
        return 'Enjoy your meal! Delivered safely.';
      case OrderStatus.cancelled:
        return 'Order was cancelled.';
    }
  }
}

/// Pure Domain Entity representing a completed/active Order.
class Order extends Equatable {
  final String id;
  final String restaurantId;
  final String restaurantName;
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;
  final double totalAmount;
  final String deliveryAddress;
  final String paymentMethod;
  final OrderStatus status;
  final DateTime createdAt;
  final String estimatedDeliveryTime;

  const Order({
    required this.id,
    required this.restaurantId,
    required this.restaurantName,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.totalAmount,
    required this.deliveryAddress,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
    required this.estimatedDeliveryTime,
  });

  Order copyWith({
    String? id,
    String? restaurantId,
    String? restaurantName,
    List<CartItem>? items,
    double? subtotal,
    double? deliveryFee,
    double? totalAmount,
    String? deliveryAddress,
    String? paymentMethod,
    OrderStatus? status,
    DateTime? createdAt,
    String? estimatedDeliveryTime,
  }) {
    return Order(
      id: id ?? this.id,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantName: restaurantName ?? this.restaurantName,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      totalAmount: totalAmount ?? this.totalAmount,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      estimatedDeliveryTime: estimatedDeliveryTime ?? this.estimatedDeliveryTime,
    );
  }

  @override
  List<Object?> get props => [
        id,
        restaurantId,
        restaurantName,
        items,
        subtotal,
        deliveryFee,
        totalAmount,
        deliveryAddress,
        paymentMethod,
        status,
        createdAt,
        estimatedDeliveryTime,
      ];
}

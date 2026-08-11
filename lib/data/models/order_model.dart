import '../../domain/entities/order.dart';
import '../../domain/entities/cart_item.dart';
import 'cart_item_model.dart';

class OrderModel extends Order {
  const OrderModel({
    required super.id,
    super.userId,
    required super.restaurantId,
    required super.restaurantName,
    required super.items,
    required super.subtotal,
    required super.deliveryFee,
    required super.totalAmount,
    required super.deliveryAddress,
    required super.paymentMethod,
    required super.status,
    required super.createdAt,
    required super.estimatedDeliveryTime,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      userId: json['userId'] as String?,
      restaurantId: json['restaurantId'] as String,
      restaurantName: json['restaurantName'] as String,
      items: (json['items'] as List<dynamic>)
          .map((item) => CartItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      subtotal: (json['subtotal'] as num).toDouble(),
      deliveryFee: (json['deliveryFee'] as num).toDouble(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      deliveryAddress: json['deliveryAddress'] as String,
      paymentMethod: json['paymentMethod'] as String,
      status: OrderStatus.values.byName(json['status'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      estimatedDeliveryTime: json['estimatedDeliveryTime'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'items': items.map((item) => CartItemModel.fromEntity(item).toJson()).toList(),
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'totalAmount': totalAmount,
      'deliveryAddress': deliveryAddress,
      'paymentMethod': paymentMethod,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'estimatedDeliveryTime': estimatedDeliveryTime,
    };
  }

  factory OrderModel.fromEntity(Order entity) {
    return OrderModel(
      id: entity.id,
      userId: entity.userId,
      restaurantId: entity.restaurantId,
      restaurantName: entity.restaurantName,
      items: entity.items,
      subtotal: entity.subtotal,
      deliveryFee: entity.deliveryFee,
      totalAmount: entity.totalAmount,
      deliveryAddress: entity.deliveryAddress,
      paymentMethod: entity.paymentMethod,
      status: entity.status,
      createdAt: entity.createdAt,
      estimatedDeliveryTime: entity.estimatedDeliveryTime,
    );
  }

  @override
  OrderModel copyWith({
    String? id,
    String? userId,
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
    return OrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
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
}

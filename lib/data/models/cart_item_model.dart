import '../../domain/entities/cart_item.dart';
import 'menu_item_model.dart';

class CartItemModel extends CartItem {
  const CartItemModel({
    required super.id,
    required super.menuItem,
    required super.quantity,
    super.specialInstructions,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] as String,
      menuItem: MenuItemModel.fromJson(json['menuItem'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
      specialInstructions: json['specialInstructions'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'menuItem': MenuItemModel.fromEntity(menuItem).toJson(),
      'quantity': quantity,
      'specialInstructions': specialInstructions,
    };
  }

  factory CartItemModel.fromEntity(CartItem entity) {
    return CartItemModel(
      id: entity.id,
      menuItem: entity.menuItem,
      quantity: entity.quantity,
      specialInstructions: entity.specialInstructions,
    );
  }
}

import 'package:equatable/equatable.dart';
import 'menu_item.dart';

/// Pure Domain Entity representing an item in the Cart.
class CartItem extends Equatable {
  final String id;
  final MenuItem menuItem;
  final int quantity;
  final String specialInstructions;

  const CartItem({
    required this.id,
    required this.menuItem,
    required this.quantity,
    this.specialInstructions = '',
  });

  double get totalPrice => menuItem.price * quantity;

  CartItem copyWith({
    String? id,
    MenuItem? menuItem,
    int? quantity,
    String? specialInstructions,
  }) {
    return CartItem(
      id: id ?? this.id,
      menuItem: menuItem ?? this.menuItem,
      quantity: quantity ?? this.quantity,
      specialInstructions: specialInstructions ?? this.specialInstructions,
    );
  }

  @override
  List<Object?> get props => [id, menuItem, quantity, specialInstructions];
}

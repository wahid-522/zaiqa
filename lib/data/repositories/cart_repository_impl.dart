import 'package:uuid/uuid.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/menu_item.dart';
import '../../domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final List<CartItem> _items = [
    CartItem(
      id: 'cart_1',
      menuItem: const MenuItem(
        id: 'sr_5',
        restaurantId: 'rest_spice_route',
        name: 'Classic Butter Chicken',
        description: 'Rich tomato gravy, cream, spices',
        price: 480.0,
        imageUrl: 'https://images.unsplash.com/photo-1588166524941-3bf61a9c41db?w=800&auto=format&fit=crop&q=80',
        category: 'Mains',
      ),
      quantity: 1,
    ),
    CartItem(
      id: 'cart_2',
      menuItem: const MenuItem(
        id: 'sr_6',
        restaurantId: 'rest_spice_route',
        name: 'Garlic Naan',
        description: 'Tandoor baked flatbread',
        price: 90.0,
        imageUrl: 'https://images.unsplash.com/photo-1626074353765-517a681e40be?w=800&auto=format&fit=crop&q=80',
        category: 'Breads',
      ),
      quantity: 2,
    ),
  ];
  final _uuid = const Uuid();

  @override
  Future<Result<AppFailure, List<CartItem>>> getCartItems() async {
    return Success(List.unmodifiable(_items));
  }

  @override
  Future<Result<AppFailure, List<CartItem>>> addToCart({
    required MenuItem menuItem,
    required int quantity,
    String? specialInstructions,
  }) async {
    try {
      final existingIndex = _items.indexWhere((item) => item.menuItem.id == menuItem.id);

      if (existingIndex != -1) {
        final existing = _items[existingIndex];
        _items[existingIndex] = existing.copyWith(
          quantity: existing.quantity + quantity,
          specialInstructions: specialInstructions ?? existing.specialInstructions,
        );
      } else {
        _items.add(
          CartItem(
            id: _uuid.v4(),
            menuItem: menuItem,
            quantity: quantity,
            specialInstructions: specialInstructions ?? '',
          ),
        );
      }
      return Success(List.unmodifiable(_items));
    } catch (e) {
      return Failure(AppFailure('Failed to add item to cart: $e'));
    }
  }

  @override
  Future<Result<AppFailure, List<CartItem>>> updateQuantity(
    String cartItemId,
    int newQuantity,
  ) async {
    try {
      if (newQuantity <= 0) {
        _items.removeWhere((item) => item.id == cartItemId);
      } else {
        final index = _items.indexWhere((item) => item.id == cartItemId);
        if (index != -1) {
          _items[index] = _items[index].copyWith(quantity: newQuantity);
        }
      }
      return Success(List.unmodifiable(_items));
    } catch (e) {
      return Failure(AppFailure('Failed to update cart quantity: $e'));
    }
  }

  @override
  Future<Result<AppFailure, List<CartItem>>> removeFromCart(String cartItemId) async {
    try {
      _items.removeWhere((item) => item.id == cartItemId);
      return Success(List.unmodifiable(_items));
    } catch (e) {
      return Failure(AppFailure('Failed to remove item from cart: $e'));
    }
  }

  @override
  Future<Result<AppFailure, void>> clearCart() async {
    _items.clear();
    return const Success(null);
  }
}

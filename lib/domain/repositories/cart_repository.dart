import '../entities/cart_item.dart';
import '../entities/menu_item.dart';
import '../../core/utils/result.dart';

abstract class CartRepository {
  Future<Result<AppFailure, List<CartItem>>> getCartItems();

  Future<Result<AppFailure, List<CartItem>>> addToCart({
    required MenuItem menuItem,
    required int quantity,
    String? specialInstructions,
  });

  Future<Result<AppFailure, List<CartItem>>> updateQuantity(
    String cartItemId,
    int newQuantity,
  );

  Future<Result<AppFailure, List<CartItem>>> removeFromCart(String cartItemId);

  Future<Result<AppFailure, void>> clearCart();
}

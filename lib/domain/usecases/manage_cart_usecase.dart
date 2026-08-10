import '../../core/utils/result.dart';
import '../entities/cart_item.dart';
import '../entities/menu_item.dart';
import '../repositories/cart_repository.dart';

class ManageCartUseCase {
  final CartRepository _repository;

  ManageCartUseCase(this._repository);

  Future<Result<AppFailure, List<CartItem>>> getItems() => _repository.getCartItems();

  Future<Result<AppFailure, List<CartItem>>> addItem({
    required MenuItem menuItem,
    required int quantity,
    String? specialInstructions,
  }) {
    return _repository.addToCart(
      menuItem: menuItem,
      quantity: quantity,
      specialInstructions: specialInstructions,
    );
  }

  Future<Result<AppFailure, List<CartItem>>> updateQuantity(
    String cartItemId,
    int newQuantity,
  ) {
    return _repository.updateQuantity(cartItemId, newQuantity);
  }

  Future<Result<AppFailure, List<CartItem>>> removeItem(String cartItemId) {
    return _repository.removeFromCart(cartItemId);
  }

  Future<Result<AppFailure, void>> clear() => _repository.clearCart();
}

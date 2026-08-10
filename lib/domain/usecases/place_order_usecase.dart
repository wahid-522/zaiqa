import '../../core/utils/result.dart';
import '../entities/cart_item.dart';
import '../entities/order.dart';
import '../repositories/order_repository.dart';

class PlaceOrderUseCase {
  final OrderRepository _repository;

  PlaceOrderUseCase(this._repository);

  Future<Result<AppFailure, Order>> execute({
    required String restaurantId,
    required String restaurantName,
    required List<CartItem> items,
    required double subtotal,
    required double deliveryFee,
    required String deliveryAddress,
    required String paymentMethod,
  }) {
    return _repository.placeOrder(
      restaurantId: restaurantId,
      restaurantName: restaurantName,
      items: items,
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      deliveryAddress: deliveryAddress,
      paymentMethod: paymentMethod,
    );
  }
}

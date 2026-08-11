import '../entities/order.dart';
import '../entities/cart_item.dart';
import '../../core/utils/result.dart';

abstract class OrderRepository {
  Future<Result<AppFailure, Order>> placeOrder({
    required String restaurantId,
    required String restaurantName,
    required List<CartItem> items,
    required double subtotal,
    required double deliveryFee,
    required String deliveryAddress,
    required String paymentMethod,
  });

  Future<Result<AppFailure, Order>> getOrderById(String orderId);

  Future<Result<AppFailure, List<Order>>> getOrderHistory();

  Future<Result<AppFailure, List<Order>>> getRestaurantOrders(String restaurantId);

  Future<Result<AppFailure, Order>> updateOrderStatus(
    String orderId,
    OrderStatus newStatus,
  );
}

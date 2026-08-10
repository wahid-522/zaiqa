import 'package:uuid/uuid.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/local_mock_datasource.dart';
import '../models/order_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  final LocalMockDataSource _dataSource;
  final _uuid = const Uuid();

  OrderRepositoryImpl(this._dataSource);

  @override
  Future<Result<AppFailure, Order>> placeOrder({
    required String restaurantId,
    required String restaurantName,
    required List<CartItem> items,
    required double subtotal,
    required double deliveryFee,
    required String deliveryAddress,
    required String paymentMethod,
  }) async {
    try {
      final totalAmount = subtotal + deliveryFee;
      final orderModel = OrderModel(
        id: 'ZQ-${_uuid.v4().substring(0, 8).toUpperCase()}',
        restaurantId: restaurantId,
        restaurantName: restaurantName,
        items: items,
        subtotal: subtotal,
        deliveryFee: deliveryFee,
        totalAmount: totalAmount,
        deliveryAddress: deliveryAddress,
        paymentMethod: paymentMethod,
        status: OrderStatus.placed,
        createdAt: DateTime.now(),
        estimatedDeliveryTime: '30-40 min',
      );

      final saved = await _dataSource.saveOrder(orderModel);
      return Success(saved);
    } catch (e) {
      return Failure(AppFailure('Failed to place order: $e'));
    }
  }

  @override
  Future<Result<AppFailure, Order>> getOrderById(String orderId) async {
    try {
      final order = await _dataSource.getOrderById(orderId);
      if (order == null) {
        return const Failure(AppFailure('Order not found'));
      }
      return Success(order);
    } catch (e) {
      return Failure(AppFailure('Failed to fetch order: $e'));
    }
  }

  @override
  Future<Result<AppFailure, List<Order>>> getOrderHistory() async {
    try {
      final history = await _dataSource.getOrderHistory();
      return Success(history);
    } catch (e) {
      return Failure(AppFailure('Failed to fetch order history: $e'));
    }
  }

  @override
  Future<Result<AppFailure, Order>> updateOrderStatus(
    String orderId,
    OrderStatus newStatus,
  ) async {
    try {
      final updated = await _dataSource.updateOrderStatus(orderId, newStatus);
      if (updated == null) {
        return const Failure(AppFailure('Order not found to update status'));
      }
      return Success(updated);
    } catch (e) {
      return Failure(AppFailure('Failed to update order status: $e'));
    }
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/order.dart';
import '../../../../domain/repositories/order_repository.dart';
import '../../../shared_providers.dart';

class OrderTrackingState {
  final Order? order;
  final bool isLoading;
  final String? errorMessage;

  const OrderTrackingState({
    this.order,
    this.isLoading = false,
    this.errorMessage,
  });

  OrderTrackingState copyWith({
    Order? order,
    bool? isLoading,
    String? errorMessage,
  }) {
    return OrderTrackingState(
      order: order ?? this.order,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class OrderTrackingViewModel extends StateNotifier<OrderTrackingState> {
  final OrderRepository _orderRepository;
  final String orderId;

  OrderTrackingViewModel(this._orderRepository, this.orderId)
      : super(const OrderTrackingState()) {
    loadOrderDetails();
  }

  Future<void> loadOrderDetails() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _orderRepository.getOrderById(orderId);
    result.when(
      success: (order) {
        state = state.copyWith(order: order, isLoading: false);
      },
      failure: (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
      },
    );
  }

  Future<void> advanceStatus() async {
    final current = state.order;
    if (current == null) return;

    OrderStatus next;
    switch (current.status) {
      case OrderStatus.placed:
        next = OrderStatus.preparing;
        break;
      case OrderStatus.preparing:
        next = OrderStatus.outForDelivery;
        break;
      case OrderStatus.outForDelivery:
        next = OrderStatus.delivered;
        break;
      case OrderStatus.delivered:
      case OrderStatus.cancelled:
        return;
    }

    final result = await _orderRepository.updateOrderStatus(orderId, next);
    result.when(
      success: (updated) {
        state = state.copyWith(order: updated);
      },
      failure: (_) {},
    );
  }
}

final orderTrackingViewModelProvider = StateNotifierProvider.family
    .autoDispose<OrderTrackingViewModel, OrderTrackingState, String>((ref, orderId) {
  return OrderTrackingViewModel(ref.watch(orderRepositoryProvider), orderId);
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/order.dart';
import '../../../../domain/usecases/place_order_usecase.dart';
import '../../../shared_providers.dart';
import '../../cart/viewmodels/cart_viewmodel.dart';

class CheckoutState {
  final String selectedAddress;
  final String selectedPaymentMethod;
  final bool isPlacingOrder;
  final String? errorMessage;
  final Order? placedOrder;

  const CheckoutState({
    this.selectedAddress = 'House #42, Block 5, Gulshan-e-Iqbal, Karachi',
    this.selectedPaymentMethod = 'Cash on Delivery',
    this.isPlacingOrder = false,
    this.errorMessage,
    this.placedOrder,
  });

  CheckoutState copyWith({
    String? selectedAddress,
    String? selectedPaymentMethod,
    bool? isPlacingOrder,
    String? errorMessage,
    Order? placedOrder,
  }) {
    return CheckoutState(
      selectedAddress: selectedAddress ?? this.selectedAddress,
      selectedPaymentMethod: selectedPaymentMethod ?? this.selectedPaymentMethod,
      isPlacingOrder: isPlacingOrder ?? this.isPlacingOrder,
      errorMessage: errorMessage,
      placedOrder: placedOrder ?? this.placedOrder,
    );
  }
}

class CheckoutViewModel extends StateNotifier<CheckoutState> {
  final PlaceOrderUseCase _placeOrderUseCase;
  final Ref _ref;

  CheckoutViewModel(this._placeOrderUseCase, this._ref) : super(const CheckoutState());

  void setAddress(String address) {
    state = state.copyWith(selectedAddress: address);
  }

  void setPaymentMethod(String method) {
    state = state.copyWith(selectedPaymentMethod: method);
  }

  Future<Order?> placeOrder() async {
    final cartState = _ref.read(cartViewModelProvider);
    if (cartState.items.isEmpty) {
      state = state.copyWith(errorMessage: 'Cart is empty');
      return null;
    }

    state = state.copyWith(isPlacingOrder: true, errorMessage: null);

    final result = await _placeOrderUseCase.execute(
      restaurantId: cartState.restaurantId ?? 'rest_1',
      restaurantName: cartState.items.first.menuItem.category,
      items: cartState.items,
      subtotal: cartState.subtotal,
      deliveryFee: cartState.deliveryFee,
      deliveryAddress: state.selectedAddress,
      paymentMethod: state.selectedPaymentMethod,
    );

    return result.when(
      success: (order) async {
        state = state.copyWith(isPlacingOrder: false, placedOrder: order);
        await _ref.read(cartViewModelProvider.notifier).clearCart();
        return order;
      },
      failure: (failure) {
        state = state.copyWith(isPlacingOrder: false, errorMessage: failure.message);
        return null;
      },
    );
  }
}

final checkoutViewModelProvider = StateNotifierProvider<CheckoutViewModel, CheckoutState>((ref) {
  return CheckoutViewModel(ref.watch(placeOrderUseCaseProvider), ref);
});

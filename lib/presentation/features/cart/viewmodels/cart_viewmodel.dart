import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../domain/entities/menu_item.dart';
import '../../../../domain/entities/cart_item.dart';
import '../../../../domain/usecases/manage_cart_usecase.dart';
import '../../../shared_providers.dart';

class CartState {
  final List<CartItem> items;
  final bool isLoading;
  final String? errorMessage;

  const CartState({
    this.items = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  CartState copyWith({
    List<CartItem>? items,
    bool? isLoading,
    String? errorMessage,
  }) {
    return CartState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  double get subtotal => items.fold(0.0, (sum, item) => sum + item.totalPrice);
  double get deliveryFee => items.isEmpty ? 0.0 : AppConstants.defaultDeliveryFee;
  double get taxAmount => subtotal * AppConstants.taxRate;
  double get totalAmount => subtotal + deliveryFee + taxAmount;
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  String? get restaurantId => items.isNotEmpty ? items.first.menuItem.restaurantId : null;
}

class CartViewModel extends StateNotifier<CartState> {
  final ManageCartUseCase _manageCartUseCase;

  CartViewModel(this._manageCartUseCase) : super(const CartState()) {
    loadCart();
  }

  Future<void> loadCart() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await _manageCartUseCase.getItems();
    result.when(
      success: (items) {
        state = state.copyWith(items: items, isLoading: false);
      },
      failure: (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
      },
    );
  }

  Future<void> addItem(MenuItem menuItem, {int quantity = 1}) async {
    final result = await _manageCartUseCase.addItem(menuItem: menuItem, quantity: quantity);
    result.when(
      success: (items) {
        state = state.copyWith(items: items);
      },
      failure: (_) {},
    );
  }

  void syncItems(List<CartItem> items) {
    state = state.copyWith(items: items);
  }

  Future<void> updateQuantity(String cartItemId, int newQuantity) async {
    final result = await _manageCartUseCase.updateQuantity(cartItemId, newQuantity);
    result.when(
      success: (items) {
        state = state.copyWith(items: items);
      },
      failure: (_) {},
    );
  }

  Future<void> removeItem(String cartItemId) async {
    final result = await _manageCartUseCase.removeItem(cartItemId);
    result.when(
      success: (items) {
        state = state.copyWith(items: items);
      },
      failure: (_) {},
    );
  }

  Future<void> clearCart() async {
    await _manageCartUseCase.clear();
    state = const CartState();
  }
}

final cartViewModelProvider = StateNotifierProvider<CartViewModel, CartState>((ref) {
  return CartViewModel(ref.watch(manageCartUseCaseProvider));
});

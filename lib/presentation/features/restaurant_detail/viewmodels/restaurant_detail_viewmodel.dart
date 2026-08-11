import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/cart_item.dart';
import '../../../../domain/entities/menu_item.dart';
import '../../../../domain/entities/restaurant.dart';
import '../../../../domain/usecases/get_restaurant_detail_usecase.dart';
import '../../../../domain/usecases/manage_cart_usecase.dart';
import '../../../shared_providers.dart';
import '../../cart/viewmodels/cart_viewmodel.dart';

class RestaurantDetailState {
  final Restaurant? restaurant;
  final bool isLoading;
  final String? errorMessage;
  final Map<String, int> itemQuantities;
  final List<CartItem> cartItems;

  const RestaurantDetailState({
    this.restaurant,
    this.isLoading = false,
    this.errorMessage,
    this.itemQuantities = const {},
    this.cartItems = const [],
  });

  RestaurantDetailState copyWith({
    Restaurant? restaurant,
    bool? isLoading,
    String? errorMessage,
    Map<String, int>? itemQuantities,
    List<CartItem>? cartItems,
  }) {
    return RestaurantDetailState(
      restaurant: restaurant ?? this.restaurant,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      itemQuantities: itemQuantities ?? this.itemQuantities,
      cartItems: cartItems ?? this.cartItems,
    );
  }

  double get cartSubtotal {
    return cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  int get cartTotalCount {
    return cartItems.fold(0, (sum, item) => sum + item.quantity);
  }
}

class RestaurantDetailViewModel extends StateNotifier<RestaurantDetailState> {
  final GetRestaurantDetailUseCase _getRestaurantDetailUseCase;
  final ManageCartUseCase _manageCartUseCase;
  final String restaurantId;
  final CartViewModel? _cartNotifier;

  RestaurantDetailViewModel(
    this._getRestaurantDetailUseCase,
    this._manageCartUseCase,
    this.restaurantId, {
    CartViewModel? cartNotifier,
  })  : _cartNotifier = cartNotifier,
        super(const RestaurantDetailState()) {
    loadDetails();
  }

  Future<void> loadDetails() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final resResult = await _getRestaurantDetailUseCase.execute(restaurantId);
    final cartResult = await _manageCartUseCase.getItems();

    resResult.when(
      success: (restaurant) {
        cartResult.when(
          success: (cartItems) {
            final quantities = <String, int>{};
            for (var c in cartItems) {
              quantities[c.menuItem.id] = c.quantity;
            }
            state = state.copyWith(
              restaurant: restaurant,
              cartItems: cartItems,
              itemQuantities: quantities,
              isLoading: false,
            );
          },
          failure: (_) {
            state = state.copyWith(restaurant: restaurant, isLoading: false);
          },
        );
      },
      failure: (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
      },
    );
  }

  Future<void> addToCart(MenuItem item) async {
    final result = await _manageCartUseCase.addItem(menuItem: item, quantity: 1);
    result.when(
      success: (items) {
        _syncCart(items);
      },
      failure: (_) {},
    );
  }

  Future<void> incrementQuantity(MenuItem item) async {
    await addToCart(item);
  }

  Future<void> decrementQuantity(MenuItem item) async {
    final cartItemIndex = state.cartItems.indexWhere((c) => c.menuItem.id == item.id);
    if (cartItemIndex != -1) {
      final cartItem = state.cartItems[cartItemIndex];
      final result = await _manageCartUseCase.updateQuantity(cartItem.id, cartItem.quantity - 1);
      result.when(
        success: (items) {
          _syncCart(items);
        },
        failure: (_) {},
      );
    }
  }

  void _syncCart(List<CartItem> items) {
    final quantities = <String, int>{};
    for (var c in items) {
      quantities[c.menuItem.id] = c.quantity;
    }
    state = state.copyWith(cartItems: items, itemQuantities: quantities);
    _cartNotifier?.syncItems(items);
  }
}

final restaurantDetailViewModelProvider = StateNotifierProvider.family
    .autoDispose<RestaurantDetailViewModel, RestaurantDetailState, String>(
        (ref, restaurantId) {
  final cartNotifier = ref.watch(cartViewModelProvider.notifier);
  return RestaurantDetailViewModel(
    ref.watch(getRestaurantDetailUseCaseProvider),
    ref.watch(manageCartUseCaseProvider),
    restaurantId,
    cartNotifier: cartNotifier,
  );
});

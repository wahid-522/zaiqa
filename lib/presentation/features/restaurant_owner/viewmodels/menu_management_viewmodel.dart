import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/menu_item.dart';
import '../../../../domain/entities/restaurant.dart';
import '../../../../domain/usecases/get_restaurant_detail_usecase.dart';
import '../../../../domain/usecases/manage_menu_usecase.dart';
import '../../../shared_providers.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';

class MenuManagementState {
  final Restaurant? restaurant;
  final bool isLoading;
  final String? errorMessage;
  final String selectedCategory;

  const MenuManagementState({
    this.restaurant,
    this.isLoading = false,
    this.errorMessage,
    this.selectedCategory = 'All',
  });

  List<MenuItem> get filteredMenu {
    if (restaurant == null) return [];
    if (selectedCategory == 'All') return restaurant!.menu;
    return restaurant!.menu.where((m) => m.category == selectedCategory).toList();
  }

  List<String> get categories {
    if (restaurant == null) return ['All'];
    final cats = restaurant!.menu.map((m) => m.category).toSet().toList();
    return ['All', ...cats];
  }

  MenuManagementState copyWith({
    Restaurant? restaurant,
    bool? isLoading,
    String? errorMessage,
    String? selectedCategory,
  }) {
    return MenuManagementState(
      restaurant: restaurant ?? this.restaurant,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

class MenuManagementViewModel extends StateNotifier<MenuManagementState> {
  final GetRestaurantDetailUseCase _getRestaurantDetailUseCase;
  final ManageMenuUseCase _manageMenuUseCase;
  final String? _restaurantId;

  MenuManagementViewModel(
    this._getRestaurantDetailUseCase,
    this._manageMenuUseCase,
    this._restaurantId,
  ) : super(const MenuManagementState()) {
    loadRestaurantMenu();
  }

  Future<void> loadRestaurantMenu() async {
    final restId = _restaurantId;
    if (restId == null || restId.isEmpty) {
      state = state.copyWith(errorMessage: 'No restaurant linked to this account.');
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await _getRestaurantDetailUseCase.execute(restId);

    result.when(
      success: (restaurant) {
        state = state.copyWith(
          restaurant: restaurant,
          isLoading: false,
        );
      },
      failure: (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
    );
  }

  void selectCategory(String cat) {
    state = state.copyWith(selectedCategory: cat);
  }

  Future<bool> addMenuItem(MenuItem item) async {
    if (state.restaurant == null) return false;
    final restId = state.restaurant!.id;

    final res = await _manageMenuUseCase.addMenuItem(restId, item);
    return res.when(
      success: (newItem) {
        final updatedMenu = List<MenuItem>.from(state.restaurant!.menu)..add(newItem);
        final updatedRest = state.restaurant!.copyWith(menu: updatedMenu);
        state = state.copyWith(restaurant: updatedRest);
        return true;
      },
      failure: (failure) {
        state = state.copyWith(errorMessage: failure.message);
        return false;
      },
    );
  }

  Future<bool> updateMenuItem(MenuItem item) async {
    if (state.restaurant == null) return false;
    final restId = state.restaurant!.id;

    final res = await _manageMenuUseCase.updateMenuItem(restId, item);
    return res.when(
      success: (updatedItem) {
        final currentMenu = List<MenuItem>.from(state.restaurant!.menu);
        final idx = currentMenu.indexWhere((m) => m.id == updatedItem.id);
        if (idx != -1) {
          currentMenu[idx] = updatedItem;
          final updatedRest = state.restaurant!.copyWith(menu: currentMenu);
          state = state.copyWith(restaurant: updatedRest);
        }
        return true;
      },
      failure: (failure) {
        state = state.copyWith(errorMessage: failure.message);
        return false;
      },
    );
  }

  Future<bool> deleteMenuItem(String menuItemId) async {
    if (state.restaurant == null) return false;
    final restId = state.restaurant!.id;

    final res = await _manageMenuUseCase.deleteMenuItem(restId, menuItemId);
    return res.when(
      success: (_) {
        final updatedMenu = List<MenuItem>.from(state.restaurant!.menu)
          ..removeWhere((m) => m.id == menuItemId);
        final updatedRest = state.restaurant!.copyWith(menu: updatedMenu);
        state = state.copyWith(restaurant: updatedRest);
        return true;
      },
      failure: (failure) {
        state = state.copyWith(errorMessage: failure.message);
        return false;
      },
    );
  }
}

final menuManagementViewModelProvider =
    StateNotifierProvider.autoDispose<MenuManagementViewModel, MenuManagementState>((ref) {
  final user = ref.watch(authViewModelProvider).user;
  final restId = user?.restaurantId ?? 'rest_spice_route';

  return MenuManagementViewModel(
    ref.watch(getRestaurantDetailUseCaseProvider),
    ref.watch(manageMenuUseCaseProvider),
    restId,
  );
});

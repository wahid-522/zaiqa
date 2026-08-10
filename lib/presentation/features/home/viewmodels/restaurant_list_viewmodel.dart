import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/restaurant.dart';
import '../../../../domain/repositories/restaurant_repository.dart';
import '../../../../domain/usecases/get_restaurants_usecase.dart';
import '../../../shared_providers.dart';

class RestaurantListState {
  final List<Restaurant> restaurants;
  final bool isLoading;
  final String? selectedCategory;
  final String searchQuery;
  final String? errorMessage;

  const RestaurantListState({
    this.restaurants = const [],
    this.isLoading = false,
    this.selectedCategory = 'All',
    this.searchQuery = '',
    this.errorMessage,
  });

  RestaurantListState copyWith({
    List<Restaurant>? restaurants,
    bool? isLoading,
    String? selectedCategory,
    String? searchQuery,
    String? errorMessage,
  }) {
    return RestaurantListState(
      restaurants: restaurants ?? this.restaurants,
      isLoading: isLoading ?? this.isLoading,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage,
    );
  }
}

class RestaurantListViewModel extends StateNotifier<RestaurantListState> {
  final GetRestaurantsUseCase _getRestaurantsUseCase;
  final RestaurantRepository _restaurantRepository;

  RestaurantListViewModel(
    this._getRestaurantsUseCase,
    this._restaurantRepository,
  ) : super(const RestaurantListState()) {
    loadRestaurants();
  }

  Future<void> loadRestaurants() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _getRestaurantsUseCase.execute(
      categoryFilter: state.selectedCategory,
      searchQuery: state.searchQuery,
    );

    result.when(
      success: (data) {
        state = state.copyWith(restaurants: data, isLoading: false);
      },
      failure: (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
    );
  }

  void selectCategory(String category) {
    if (state.selectedCategory == category) return;
    state = state.copyWith(selectedCategory: category);
    loadRestaurants();
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    loadRestaurants();
  }

  Future<void> toggleFavorite(String restaurantId) async {
    final result = await _restaurantRepository.toggleFavoriteStatus(restaurantId);

    result.when(
      success: (isFav) {
        final updatedList = state.restaurants.map((r) {
          if (r.id == restaurantId) {
            return r.copyWith(isFavorite: isFav);
          }
          return r;
        }).toList();
        state = state.copyWith(restaurants: updatedList);
      },
      failure: (_) {},
    );
  }
}

final restaurantListViewModelProvider =
    StateNotifierProvider<RestaurantListViewModel, RestaurantListState>((ref) {
  return RestaurantListViewModel(
    ref.watch(getRestaurantsUseCaseProvider),
    ref.watch(restaurantRepositoryProvider),
  );
});

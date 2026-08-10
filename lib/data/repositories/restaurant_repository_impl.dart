import '../../core/utils/result.dart';
import '../../domain/entities/restaurant.dart';
import '../../domain/repositories/restaurant_repository.dart';
import '../datasources/local_mock_datasource.dart';

class RestaurantRepositoryImpl implements RestaurantRepository {
  final LocalMockDataSource _dataSource;

  RestaurantRepositoryImpl(this._dataSource);

  @override
  Future<Result<AppFailure, List<Restaurant>>> getRestaurants({
    String? categoryFilter,
    String? searchQuery,
  }) async {
    try {
      final list = await _dataSource.getRestaurants(
        categoryFilter: categoryFilter,
        searchQuery: searchQuery,
      );
      return Success(list);
    } catch (e) {
      return Failure(AppFailure('Failed to load restaurants: $e'));
    }
  }

  @override
  Future<Result<AppFailure, Restaurant>> getRestaurantById(String id) async {
    try {
      final restaurant = await _dataSource.getRestaurantById(id);
      if (restaurant == null) {
        return const Failure(AppFailure('Restaurant not found'));
      }
      return Success(restaurant);
    } catch (e) {
      return Failure(AppFailure('Error fetching restaurant details: $e'));
    }
  }

  @override
  Future<Result<AppFailure, List<Restaurant>>> getFavoriteRestaurants() async {
    try {
      final favorites = await _dataSource.getFavoriteRestaurants();
      return Success(favorites);
    } catch (e) {
      return Failure(AppFailure('Failed to load favorite restaurants: $e'));
    }
  }

  @override
  Future<Result<AppFailure, bool>> toggleFavoriteStatus(String restaurantId) async {
    try {
      final isFav = await _dataSource.toggleFavorite(restaurantId);
      return Success(isFav);
    } catch (e) {
      return Failure(AppFailure('Failed to update favorite status: $e'));
    }
  }
}

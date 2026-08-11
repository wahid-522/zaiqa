import '../../core/utils/result.dart';
import '../../domain/entities/menu_item.dart';
import '../../domain/entities/restaurant.dart';
import '../../domain/repositories/restaurant_repository.dart';
import '../datasources/local_mock_datasource.dart';
import '../models/menu_item_model.dart';
import '../models/restaurant_model.dart';

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

  @override
  Future<Result<AppFailure, MenuItem>> addMenuItem(String restaurantId, MenuItem item) async {
    try {
      final model = MenuItemModel.fromEntity(item);
      final added = await _dataSource.addMenuItem(restaurantId, model);
      return Success(added);
    } catch (e) {
      return Failure(AppFailure('Failed to add menu item: $e'));
    }
  }

  @override
  Future<Result<AppFailure, MenuItem>> updateMenuItem(String restaurantId, MenuItem item) async {
    try {
      final model = MenuItemModel.fromEntity(item);
      final updated = await _dataSource.updateMenuItem(restaurantId, model);
      return Success(updated);
    } catch (e) {
      return Failure(AppFailure('Failed to update menu item: $e'));
    }
  }

  @override
  Future<Result<AppFailure, bool>> deleteMenuItem(String restaurantId, String menuItemId) async {
    try {
      final res = await _dataSource.deleteMenuItem(restaurantId, menuItemId);
      return Success(res);
    } catch (e) {
      return Failure(AppFailure('Failed to delete menu item: $e'));
    }
  }

  @override
  Future<Result<AppFailure, Restaurant>> createRestaurant(Restaurant restaurant) async {
    try {
      final model = RestaurantModel.fromEntity(restaurant);
      final created = await _dataSource.createRestaurant(model);
      return Success(created);
    } catch (e) {
      return Failure(AppFailure('Failed to create restaurant: $e'));
    }
  }
}

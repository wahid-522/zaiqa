import '../entities/menu_item.dart';
import '../entities/restaurant.dart';
import '../../core/utils/result.dart';

abstract class RestaurantRepository {
  Future<Result<AppFailure, List<Restaurant>>> getRestaurants({
    String? categoryFilter,
    String? searchQuery,
  });

  Future<Result<AppFailure, Restaurant>> getRestaurantById(String id);

  Future<Result<AppFailure, List<Restaurant>>> getFavoriteRestaurants();

  Future<Result<AppFailure, bool>> toggleFavoriteStatus(String restaurantId);

  // Restaurant Owner Menu Management Methods
  Future<Result<AppFailure, MenuItem>> addMenuItem(String restaurantId, MenuItem item);

  Future<Result<AppFailure, MenuItem>> updateMenuItem(String restaurantId, MenuItem item);

  Future<Result<AppFailure, bool>> deleteMenuItem(String restaurantId, String menuItemId);

  Future<Result<AppFailure, Restaurant>> createRestaurant(Restaurant restaurant);
}

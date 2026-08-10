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
}

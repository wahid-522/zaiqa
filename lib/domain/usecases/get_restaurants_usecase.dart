import '../../core/utils/result.dart';
import '../entities/restaurant.dart';
import '../repositories/restaurant_repository.dart';

class GetRestaurantsUseCase {
  final RestaurantRepository _repository;

  GetRestaurantsUseCase(this._repository);

  Future<Result<AppFailure, List<Restaurant>>> execute({
    String? categoryFilter,
    String? searchQuery,
  }) {
    return _repository.getRestaurants(
      categoryFilter: categoryFilter,
      searchQuery: searchQuery,
    );
  }
}

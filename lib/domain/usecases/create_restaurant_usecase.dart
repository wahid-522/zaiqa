import '../../core/utils/result.dart';
import '../entities/restaurant.dart';
import '../repositories/restaurant_repository.dart';

class CreateRestaurantUseCase {
  final RestaurantRepository _repository;

  CreateRestaurantUseCase(this._repository);

  Future<Result<AppFailure, Restaurant>> execute(Restaurant restaurant) {
    return _repository.createRestaurant(restaurant);
  }
}

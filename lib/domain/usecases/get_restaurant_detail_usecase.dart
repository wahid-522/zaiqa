import '../../core/utils/result.dart';
import '../entities/restaurant.dart';
import '../repositories/restaurant_repository.dart';

class GetRestaurantDetailUseCase {
  final RestaurantRepository _repository;

  GetRestaurantDetailUseCase(this._repository);

  Future<Result<AppFailure, Restaurant>> execute(String id) {
    return _repository.getRestaurantById(id);
  }
}

import '../../core/utils/result.dart';
import '../entities/order.dart';
import '../repositories/order_repository.dart';

class GetRestaurantOrdersUseCase {
  final OrderRepository _repository;

  GetRestaurantOrdersUseCase(this._repository);

  Future<Result<AppFailure, List<Order>>> execute(String restaurantId) {
    return _repository.getRestaurantOrders(restaurantId);
  }
}

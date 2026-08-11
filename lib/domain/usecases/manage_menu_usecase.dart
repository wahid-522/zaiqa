import '../../core/utils/result.dart';
import '../entities/menu_item.dart';
import '../repositories/restaurant_repository.dart';

class ManageMenuUseCase {
  final RestaurantRepository _repository;

  ManageMenuUseCase(this._repository);

  Future<Result<AppFailure, MenuItem>> addMenuItem(String restaurantId, MenuItem item) {
    return _repository.addMenuItem(restaurantId, item);
  }

  Future<Result<AppFailure, MenuItem>> updateMenuItem(String restaurantId, MenuItem item) {
    return _repository.updateMenuItem(restaurantId, item);
  }

  Future<Result<AppFailure, bool>> deleteMenuItem(String restaurantId, String menuItemId) {
    return _repository.deleteMenuItem(restaurantId, menuItemId);
  }
}

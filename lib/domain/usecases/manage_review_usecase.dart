import '../../core/utils/result.dart';
import '../entities/order.dart';
import '../entities/review.dart';
import '../repositories/order_repository.dart';
import '../repositories/review_repository.dart';

class SubmitReviewUseCase {
  final ReviewRepository _reviewRepository;
  final OrderRepository _orderRepository;

  SubmitReviewUseCase(this._reviewRepository, this._orderRepository);

  Future<Result<AppFailure, Review>> execute(Review review) async {
    // Rule 1: Validate Order status is DELIVERED
    final orderResult = await _orderRepository.getOrderById(review.orderId);
    final order = orderResult.when(
      success: (o) => o,
      failure: (_) => null,
    );

    if (order != null && order.status != OrderStatus.delivered) {
      return const Failure(
        AppFailure('Reviews can only be submitted for delivered orders.'),
      );
    }

    // Rule 2: Enforce ONE review per order
    final existingReviewResult = await _reviewRepository.getReviewForOrder(review.orderId);
    final existingReview = existingReviewResult.when(
      success: (r) => r,
      failure: (_) => null,
    );

    if (existingReview != null) {
      return const Failure(
        AppFailure('A review has already been submitted for this order.'),
      );
    }

    // Submit review via repository
    return await _reviewRepository.submitReview(review);
  }
}

class GetReviewForOrderUseCase {
  final ReviewRepository _reviewRepository;

  GetReviewForOrderUseCase(this._reviewRepository);

  Future<Result<AppFailure, Review?>> execute(String orderId) async {
    return await _reviewRepository.getReviewForOrder(orderId);
  }
}

class GetRestaurantReviewsUseCase {
  final ReviewRepository _reviewRepository;

  GetRestaurantReviewsUseCase(this._reviewRepository);

  Future<Result<AppFailure, List<Review>>> execute(String restaurantId) async {
    return await _reviewRepository.getReviewsForRestaurant(restaurantId);
  }
}

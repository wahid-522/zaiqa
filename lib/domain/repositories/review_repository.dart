import '../entities/review.dart';
import '../../core/utils/result.dart';

abstract class ReviewRepository {
  Future<Result<AppFailure, Review>> submitReview(Review review);
  Future<Result<AppFailure, Review?>> getReviewForOrder(String orderId);
  Future<Result<AppFailure, List<Review>>> getReviewsForRestaurant(String restaurantId);
}

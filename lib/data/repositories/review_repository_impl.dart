import '../../core/utils/result.dart';
import '../../domain/entities/review.dart';
import '../../domain/repositories/review_repository.dart';
import '../datasources/local_mock_datasource.dart';
import '../models/review_model.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final LocalMockDataSource _dataSource;

  ReviewRepositoryImpl(this._dataSource);

  @override
  Future<Result<AppFailure, Review>> submitReview(Review review) async {
    try {
      final model = ReviewModel.fromEntity(review);
      final savedModel = await _dataSource.submitReview(model);
      return Success(savedModel.toEntity());
    } catch (e) {
      return Failure(AppFailure('Failed to submit review: $e'));
    }
  }

  @override
  Future<Result<AppFailure, Review?>> getReviewForOrder(String orderId) async {
    try {
      final model = await _dataSource.getReviewForOrder(orderId);
      return Success(model?.toEntity());
    } catch (e) {
      return Failure(AppFailure('Failed to fetch review for order: $e'));
    }
  }

  @override
  Future<Result<AppFailure, List<Review>>> getReviewsForRestaurant(String restaurantId) async {
    try {
      final models = await _dataSource.getReviewsForRestaurant(restaurantId);
      final entities = models.map((m) => m.toEntity()).toList();
      return Success(entities);
    } catch (e) {
      return Failure(AppFailure('Failed to fetch restaurant reviews: $e'));
    }
  }
}

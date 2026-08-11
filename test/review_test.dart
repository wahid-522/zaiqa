import 'package:flutter_test/flutter_test.dart';
import 'package:zaiqa/data/datasources/local_mock_datasource.dart';
import 'package:zaiqa/data/repositories/order_repository_impl.dart';
import 'package:zaiqa/data/repositories/review_repository_impl.dart';
import 'package:zaiqa/domain/entities/review.dart';
import 'package:zaiqa/domain/usecases/manage_review_usecase.dart';

void main() {
  group('Review Clean Architecture & Business Rules Tests', () {
    late LocalMockDataSource dataSource;
    late ReviewRepositoryImpl reviewRepository;
    late OrderRepositoryImpl orderRepository;
    late SubmitReviewUseCase submitReviewUseCase;
    late GetReviewForOrderUseCase getReviewForOrderUseCase;

    setUp(() {
      dataSource = LocalMockDataSource();
      reviewRepository = ReviewRepositoryImpl(dataSource);
      orderRepository = OrderRepositoryImpl(dataSource);
      submitReviewUseCase = SubmitReviewUseCase(reviewRepository, orderRepository);
      getReviewForOrderUseCase = GetReviewForOrderUseCase(reviewRepository);
    });

    test('submitReview succeeds for delivered order', () async {
      final review = Review(
        id: 'test_rev_1',
        orderId: 'ZQ-90183', // ZQ-90183 is delivered and unreviewed in mock data
        restaurantId: 'rest_spice_route',
        userId: 'user_101',
        rating: 5,
        comment: 'Great meal!',
        createdAt: DateTime.now(),
      );

      final result = await submitReviewUseCase.execute(review);
      expect(result.isSuccess, isTrue);
    });

    test('submitReview rejects submission for non-delivered order', () async {
      final review = Review(
        id: 'test_rev_2',
        orderId: 'ZQ-90175', // ZQ-90175 is in preparing status in mock data
        restaurantId: 'rest_spice_route',
        userId: 'user_101',
        rating: 4,
        comment: 'Too early review',
        createdAt: DateTime.now(),
      );

      final result = await submitReviewUseCase.execute(review);
      expect(result.isFailure, isTrue);
      result.when(
        success: (_) => fail('Should have failed'),
        failure: (failure) {
          expect(failure.message, contains('delivered'));
        },
      );
    });

    test('submitReview rejects duplicate submission for same order', () async {
      final review = Review(
        id: 'test_rev_duplicate',
        orderId: 'ZQ-90182', // ZQ-90182 already has a review in mock data
        restaurantId: 'rest_spice_route',
        userId: 'user_101',
        rating: 5,
        comment: 'Duplicate review',
        createdAt: DateTime.now(),
      );

      final result = await submitReviewUseCase.execute(review);
      expect(result.isFailure, isTrue);
      result.when(
        success: (_) => fail('Should have failed'),
        failure: (failure) {
          expect(failure.message, contains('already been submitted'));
        },
      );
    });

    test('getReviewForOrder fetches existing review correctly', () async {
      final result = await getReviewForOrderUseCase.execute('ZQ-90182');
      expect(result.isSuccess, isTrue);
      result.when(
        success: (review) {
          expect(review, isNotNull);
          expect(review!.orderId, equals('ZQ-90182'));
          expect(review.rating, equals(5));
        },
        failure: (_) => fail('Should have succeeded'),
      );
    });
  });
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/datasources/local_mock_datasource.dart';
import '../data/datasources/google_directions_datasource.dart';
import '../data/repositories/restaurant_repository_impl.dart';
import '../data/repositories/cart_repository_impl.dart';
import '../data/repositories/order_repository_impl.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/repositories/directions_repository_impl.dart';
import '../domain/repositories/restaurant_repository.dart';
import '../domain/repositories/cart_repository.dart';
import '../domain/repositories/order_repository.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/directions_repository.dart';
import '../domain/usecases/get_restaurants_usecase.dart';
import '../domain/usecases/get_restaurant_detail_usecase.dart';
import '../domain/usecases/manage_cart_usecase.dart';
import '../domain/usecases/place_order_usecase.dart';
import '../domain/usecases/manage_menu_usecase.dart';
import '../domain/usecases/create_restaurant_usecase.dart';
import '../domain/usecases/get_restaurant_orders_usecase.dart';
import '../data/repositories/review_repository_impl.dart';
import '../domain/repositories/review_repository.dart';
import '../domain/usecases/manage_review_usecase.dart';
import 'features/address_picker/viewmodels/address_picker_viewmodel.dart';

// Datasource Providers
final localMockDataSourceProvider = Provider<LocalMockDataSource>((ref) {
  return LocalMockDataSource();
});

final googleDirectionsDataSourceProvider = Provider<GoogleDirectionsDataSource>((ref) {
  return GoogleDirectionsDataSource();
});

// Repository Providers
final restaurantRepositoryProvider = Provider<RestaurantRepository>((ref) {
  return RestaurantRepositoryImpl(ref.watch(localMockDataSourceProvider));
});

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  return CartRepositoryImpl();
});

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepositoryImpl(ref.watch(localMockDataSourceProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

final directionsRepositoryProvider = Provider<DirectionsRepository>((ref) {
  return DirectionsRepositoryImpl(
    dataSource: ref.watch(googleDirectionsDataSourceProvider),
  );
});

// UseCase Providers
final getRestaurantsUseCaseProvider = Provider<GetRestaurantsUseCase>((ref) {
  return GetRestaurantsUseCase(ref.watch(restaurantRepositoryProvider));
});

final getRestaurantDetailUseCaseProvider = Provider<GetRestaurantDetailUseCase>((ref) {
  return GetRestaurantDetailUseCase(ref.watch(restaurantRepositoryProvider));
});

final manageCartUseCaseProvider = Provider<ManageCartUseCase>((ref) {
  return ManageCartUseCase(ref.watch(cartRepositoryProvider));
});

final placeOrderUseCaseProvider = Provider<PlaceOrderUseCase>((ref) {
  return PlaceOrderUseCase(ref.watch(orderRepositoryProvider));
});

final manageMenuUseCaseProvider = Provider<ManageMenuUseCase>((ref) {
  return ManageMenuUseCase(ref.watch(restaurantRepositoryProvider));
});

final createRestaurantUseCaseProvider = Provider<CreateRestaurantUseCase>((ref) {
  return CreateRestaurantUseCase(ref.watch(restaurantRepositoryProvider));
});

final getRestaurantOrdersUseCaseProvider = Provider<GetRestaurantOrdersUseCase>((ref) {
  return GetRestaurantOrdersUseCase(ref.watch(orderRepositoryProvider));
});

final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  return ReviewRepositoryImpl(ref.watch(localMockDataSourceProvider));
});

final submitReviewUseCaseProvider = Provider<SubmitReviewUseCase>((ref) {
  return SubmitReviewUseCase(
    ref.watch(reviewRepositoryProvider),
    ref.watch(orderRepositoryProvider),
  );
});

final getReviewForOrderUseCaseProvider = Provider<GetReviewForOrderUseCase>((ref) {
  return GetReviewForOrderUseCase(ref.watch(reviewRepositoryProvider));
});

final getRestaurantReviewsUseCaseProvider = Provider<GetRestaurantReviewsUseCase>((ref) {
  return GetRestaurantReviewsUseCase(ref.watch(reviewRepositoryProvider));
});

// ViewModel Providers
final addressPickerViewModelProvider = StateNotifierProvider<AddressPickerViewModel, AddressPickerState>((ref) {
  return AddressPickerViewModel(
    directionsRepository: ref.watch(directionsRepositoryProvider),
  );
});

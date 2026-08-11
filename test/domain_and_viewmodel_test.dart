import 'package:flutter_test/flutter_test.dart';
import 'package:zaiqa/data/datasources/google_directions_datasource.dart';
import 'package:zaiqa/data/datasources/local_mock_datasource.dart';
import 'package:zaiqa/data/repositories/cart_repository_impl.dart';
import 'package:zaiqa/data/repositories/restaurant_repository_impl.dart';
import 'package:zaiqa/domain/entities/delivery_route.dart';
import 'package:zaiqa/domain/entities/menu_item.dart';
import 'package:zaiqa/domain/entities/user_profile.dart';
import 'package:zaiqa/domain/usecases/get_restaurants_usecase.dart';
import 'package:zaiqa/domain/usecases/manage_cart_usecase.dart';
import 'package:zaiqa/domain/usecases/manage_menu_usecase.dart';

void main() {
  group('Clean Architecture - Domain & Repository Tests', () {
    late LocalMockDataSource dataSource;
    late RestaurantRepositoryImpl restaurantRepo;
    late GetRestaurantsUseCase getRestaurantsUseCase;
    late ManageMenuUseCase manageMenuUseCase;

    setUp(() {
      dataSource = LocalMockDataSource();
      restaurantRepo = RestaurantRepositoryImpl(dataSource);
      getRestaurantsUseCase = GetRestaurantsUseCase(restaurantRepo);
      manageMenuUseCase = ManageMenuUseCase(restaurantRepo);
    });

    test('GetRestaurantsUseCase returns mock restaurants list successfully', () async {
      final result = await getRestaurantsUseCase.execute();
      expect(result.isSuccess, isTrue);
      expect(result.data, isNotNull);
      expect(result.data!.length, greaterThan(0));
    });

    test('ManageMenuUseCase adds, updates, and deletes menu items correctly', () async {
      const newItem = MenuItem(
        id: 'test_item_99',
        restaurantId: 'rest_spice_route',
        name: 'Test Gourmet Naan',
        description: 'Cheesy garlic naan',
        price: 250.0,
        imageUrl: 'http://test.jpg',
        category: 'Breads',
      );

      // 1. Add menu item
      final addResult = await manageMenuUseCase.addMenuItem('rest_spice_route', newItem);
      expect(addResult.isSuccess, isTrue);
      expect(addResult.data!.name, equals('Test Gourmet Naan'));

      // 2. Update menu item
      final updatedItem = newItem.copyWith(price: 300.0, name: 'Updated Gourmet Naan');
      final updateResult = await manageMenuUseCase.updateMenuItem('rest_spice_route', updatedItem);
      expect(updateResult.isSuccess, isTrue);
      expect(updateResult.data!.price, equals(300.0));

      // 3. Delete menu item
      final deleteResult = await manageMenuUseCase.deleteMenuItem('rest_spice_route', 'test_item_99');
      expect(deleteResult.isSuccess, isTrue);
    });

    test('UserProfile evaluates user roles correctly', () {
      const customer = UserProfile(
        id: 'u1',
        name: 'Customer User',
        email: 'customer@test.com',
        phone: '123',
        role: UserRole.customer,
      );
      expect(customer.isCustomer, isTrue);
      expect(customer.isRestaurantOwner, isFalse);

      const owner = UserProfile(
        id: 'u2',
        name: 'Owner User',
        email: 'owner@test.com',
        phone: '456',
        role: UserRole.restaurantOwner,
        restaurantId: 'rest_spice_route',
      );
      expect(owner.isRestaurantOwner, isTrue);
      expect(owner.isCustomer, isFalse);
      expect(owner.restaurantId, equals('rest_spice_route'));
    });

    test('CartRepository manages cart item quantities correctly', () async {
      final cartRepo = CartRepositoryImpl();
      final manageCart = ManageCartUseCase(cartRepo);

      const testItem = MenuItem(
        id: 'test_1',
        restaurantId: 'rest_1',
        name: 'Test Chicken Biryani',
        description: 'Test Biryani',
        price: 350.0,
        imageUrl: 'http://test.jpg',
        category: 'Biryani',
      );

      // Add item to cart
      final addResult = await manageCart.addItem(menuItem: testItem, quantity: 2);
      expect(addResult.isSuccess, isTrue);
      final addedItem = addResult.data!.firstWhere((i) => i.menuItem.id == 'test_1');
      expect(addedItem.quantity, equals(2));
      expect(addedItem.totalPrice, equals(700.0));

      // Remove item
      final initialLength = addResult.data!.length;
      final removeResult = await manageCart.removeItem(addedItem.id);
      expect(removeResult.isSuccess, isTrue);
      expect(removeResult.data!.length, equals(initialLength - 1));
    });

    test('GoogleDirectionsDataSource calculates route distance and duration correctly', () async {
      final dataSource = GoogleDirectionsDataSource();
      final route = await dataSource.getDirections(
        origin: const LatLngPoint(24.8719, 67.0593),
        destination: const LatLngPoint(24.8607, 67.0011),
      );

      expect(route.distanceKm, greaterThan(0));
      expect(route.durationMinutes, greaterThan(0));
      expect(route.polylinePoints.length, greaterThanOrEqualTo(2));
    });
  });
}

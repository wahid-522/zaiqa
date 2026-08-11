import '../models/restaurant_model.dart';
import '../models/menu_item_model.dart';
import '../models/user_model.dart';
import '../models/order_model.dart';
import '../models/review_model.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/user_profile.dart';

/// DEVELOPMENT MOCK DATASET
/// This file provides clearly-labeled mock data for Zaiqa during local development.
/// It simulates async network delays to ensure ViewModels handle loading states smoothly.
class LocalMockDataSource {
  final Duration simulatedDelay;

  LocalMockDataSource({this.simulatedDelay = const Duration(milliseconds: 600)});

  // In-memory persistent state for development session
  final Set<String> _favoriteIds = {'rest_1', 'rest_3'};
  final List<OrderModel> _orderHistory = [
    OrderModel(
      id: 'ZQ-90182',
      restaurantId: 'rest_spice_route',
      restaurantName: 'The Spice Route',
      items: const [],
      subtotal: 1300.0,
      deliveryFee: 150.0,
      totalAmount: 1450.0,
      status: OrderStatus.delivered,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      deliveryAddress: 'House #12, Street 4, DHA Phase 6, Karachi',
      paymentMethod: 'Cash on Delivery',
      estimatedDeliveryTime: 'Delivered in 35 min',
    ),
    OrderModel(
      id: 'ZQ-90175',
      restaurantId: 'rest_spice_route',
      restaurantName: 'The Spice Route',
      items: const [],
      subtotal: 950.0,
      deliveryFee: 150.0,
      totalAmount: 1100.0,
      status: OrderStatus.preparing,
      createdAt: DateTime.now().subtract(const Duration(minutes: 25)),
      deliveryAddress: 'Apartment 4B, Falcon Complex, Karachi',
      paymentMethod: 'Credit Card',
      estimatedDeliveryTime: '25 min',
    ),
    OrderModel(
      id: 'ZQ-90183',
      restaurantId: 'rest_spice_route',
      restaurantName: 'The Spice Route',
      items: const [],
      subtotal: 1500.0,
      deliveryFee: 150.0,
      totalAmount: 1650.0,
      status: OrderStatus.delivered,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      deliveryAddress: 'House #42, Block 5, Gulshan-e-Iqbal, Karachi',
      paymentMethod: 'Credit Card',
      estimatedDeliveryTime: 'Delivered in 30 min',
    ),
  ];
  UserModel _currentUser = const UserModel(
    id: 'user_101',
    name: 'Hamza Khan',
    email: 'hamza@zaiqa.app',
    phone: '+92 300 1234567',
    savedAddresses: [
      'House #42, Block 5, Gulshan-e-Iqbal, Karachi',
      'Office 302, Tech Heights, Shahrah-e-Faisal, Karachi',
    ],
    favoriteRestaurantIds: ['rest_1', 'rest_3'],
  );

  static final List<RestaurantModel> _restaurants = [
    RestaurantModel(
      id: 'rest_spice_route',
      name: 'The Spice Route',
      imageUrl: 'https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=800&auto=format&fit=crop&q=80',
      rating: 4.8,
      reviewCount: 2000,
      deliveryTime: '35-45 mins',
      deliveryFee: 150.0,
      cuisineTypes: const ['North Indian', 'Mughlai', 'Kebabs'],
      isFavorite: true,
      isOpen: true,
      address: 'Gulshan-e-Iqbal, Karachi',
      menu: const [
        MenuItemModel(
          id: 'sr_0',
          restaurantId: 'rest_spice_route',
          name: 'Signature Tikka Masala',
          description: 'Tender marinated chicken pieces simmered in a rich, creamy, and mildly spiced tomato sauce. Served with a side of fragrant basmati rice or fresh naan.',
          price: 850.0,
          imageUrl: 'https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=800&auto=format&fit=crop&q=80',
          category: 'Mains',
          isSpicy: true,
          tags: ['Chef Special', 'Best Seller'],
        ),
        MenuItemModel(
          id: 'sr_1',
          restaurantId: 'rest_spice_route',
          name: 'Classic Paneer Tikka',
          description: 'Cottage cheese marinated in aromatic spices and yogurt, grilled to perfection.',
          price: 320.0,
          imageUrl: 'https://images.unsplash.com/photo-1567188040759-fb8a883dc6d8?w=800&auto=format&fit=crop&q=80',
          category: 'Starters',
          isVegetarian: true,
        ),
        MenuItemModel(
          id: 'sr_2',
          restaurantId: 'rest_spice_route',
          name: 'Punjabi Samosa (2 pcs)',
          description: 'Crispy pastry filled with spiced potatoes and peas, served with mint chutney.',
          price: 120.0,
          imageUrl: 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=800&auto=format&fit=crop&q=80',
          category: 'Starters',
          isVegetarian: true,
        ),
        MenuItemModel(
          id: 'sr_3',
          restaurantId: 'rest_spice_route',
          name: 'Murgh Tikka',
          description: 'Tender chicken chunks marinated in spicy yogurt and tandoori spices.',
          price: 450.0,
          imageUrl: 'https://images.unsplash.com/photo-1599487488170-d11ec9c172f0?w=800&auto=format&fit=crop&q=80',
          category: 'Starters',
          isSpicy: true,
          isVegetarian: false,
        ),
        MenuItemModel(
          id: 'sr_4',
          restaurantId: 'rest_spice_route',
          name: 'Onion Bhaji',
          description: 'Crispy onion fritters made with gram flour and aromatic spices.',
          price: 180.0,
          imageUrl: 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?w=800&auto=format&fit=crop&q=80',
          category: 'Starters',
          isVegetarian: true,
        ),
        MenuItemModel(
          id: 'sr_5',
          restaurantId: 'rest_spice_route',
          name: 'Butter Chicken Special',
          description: 'Tender tandoori chicken cooked in rich tomato butter cream gravy.',
          price: 950.0,
          imageUrl: 'https://images.unsplash.com/photo-1588166524941-3bf61a9c41db?w=800&auto=format&fit=crop&q=80',
          category: 'Mains',
        ),
        MenuItemModel(
          id: 'sr_6',
          restaurantId: 'rest_spice_route',
          name: 'Garlic Butter Naan',
          description: 'Fresh tandoori naan brushed with garlic butter.',
          price: 80.0,
          imageUrl: 'https://images.unsplash.com/photo-1626074353765-517a681e40be?w=800&auto=format&fit=crop&q=80',
          category: 'Breads',
          isVegetarian: true,
        ),
      ],
    ),
    RestaurantModel(
      id: 'rest_1',
      name: 'Burger Haven',
      imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=800&auto=format&fit=crop&q=80',
      rating: 4.8,
      reviewCount: 1420,
      deliveryTime: '20-30 min',
      deliveryFee: 150.0,
      cuisineTypes: const ['American', 'Fast Food', 'Burgers'],
      isFavorite: true,
      isOpen: true,
      address: '123 Culinary Avenue, Food District',
      menu: const [
        MenuItemModel(
          id: 'menu_1_1',
          restaurantId: 'rest_1',
          name: 'Double Truffle Smash Burger',
          description: 'Two smashed beef patties, melted cheddar, caramelised onions, truffle mayo on brioche.',
          price: 950.0,
          imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=800&auto=format&fit=crop&q=80',
          category: 'Burgers',
          tags: ['Gourmet', 'Must Try'],
        ),
        MenuItemModel(
          id: 'menu_1_2',
          restaurantId: 'rest_1',
          name: 'Crispy Bacon & Cheese Burger',
          description: 'Juicy beef patty, smoked bacon, double cheddar cheese, lettuce, tomato.',
          price: 850.0,
          imageUrl: 'https://images.unsplash.com/photo-1586190848861-99aa4a171e90?w=800&auto=format&fit=crop&q=80',
          category: 'Burgers',
          tags: ['Popular'],
        ),
      ],
    ),
    RestaurantModel(
      id: 'rest_2',
      name: 'Lahori Karahi Express',
      imageUrl: 'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?w=800&auto=format&fit=crop&q=80',
      rating: 4.5,
      reviewCount: 2310,
      deliveryTime: '35-45 min',
      deliveryFee: 0.0,
      cuisineTypes: const ['Desi', 'Pakistani', 'Curries'],
      isFavorite: false,
      isOpen: true,
      address: 'Food Street, Lahore',
      menu: const [
        MenuItemModel(
          id: 'menu_2_1',
          restaurantId: 'rest_2',
          name: 'Desi Ghee Chicken Karahi (Full)',
          description: 'Wok-cooked chicken in pure organic desi ghee, fresh tomatoes, and ginger juliennes.',
          price: 1850.0,
          imageUrl: 'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?w=800&auto=format&fit=crop&q=80',
          category: 'Desi',
          isSpicy: true,
          tags: ['Popular', 'Desi Ghee'],
        ),
      ],
    ),
    RestaurantModel(
      id: 'rest_3',
      name: 'Sakura Sushi',
      imageUrl: 'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=800&auto=format&fit=crop&q=80',
      rating: 4.9,
      reviewCount: 980,
      deliveryTime: '40-55 min',
      deliveryFee: 250.0,
      cuisineTypes: const ['Japanese', 'Sushi', 'Asian'],
      isFavorite: true,
      isOpen: true,
      address: 'DHA Phase 6, Karachi',
      menu: const [
        MenuItemModel(
          id: 'menu_3_1',
          restaurantId: 'rest_3',
          name: 'Salmon & Tuna Nigiri Combo (8 Pcs)',
          description: 'Fresh Atlantic salmon and yellowfin tuna nigiri with spicy mayo dip.',
          price: 1650.0,
          imageUrl: 'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=800&auto=format&fit=crop&q=80',
          category: 'Asian',
          tags: ['Fresh', 'Chef Special'],
        ),
      ],
    ),
    RestaurantModel(
      id: 'rest_4',
      name: 'Delizioso Gelato & Desserts',
      imageUrl: 'https://images.unsplash.com/photo-1551024709-8f23befc6f87?w=800&auto=format&fit=crop&q=80',
      rating: 4.6,
      reviewCount: 650,
      deliveryTime: '15-25 min',
      deliveryFee: 100.0,
      cuisineTypes: const ['Desserts & Sweets', 'Beverages'],
      isFavorite: false,
      isOpen: true,
      address: 'PECHS Block 2, Karachi',
      menu: const [
        MenuItemModel(
          id: 'menu_4_1',
          restaurantId: 'rest_4',
          name: 'Molten Lava Cake with Vanilla Gelato',
          description: 'Warm gooey chocolate cake served with handcrafted Madagascar vanilla bean gelato.',
          price: 680.0,
          imageUrl: 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=800&auto=format&fit=crop&q=80',
          category: 'Desserts & Sweets',
          isVegetarian: true,
          tags: ['Hot Seller'],
        ),
        MenuItemModel(
          id: 'menu_4_2',
          restaurantId: 'rest_4',
          name: 'Traditional Shahi Gulab Jamun (4 Pcs)',
          description: 'Hot milk solid dumplings soaked in saffron-cardamom sugar syrup.',
          price: 320.0,
          imageUrl: 'https://images.unsplash.com/photo-1599785209707-a456fc1337bb?w=800&auto=format&fit=crop&q=80',
          category: 'Desserts & Sweets',
          isVegetarian: true,
          tags: ['Traditional'],
        ),
      ],
    ),
  ];

  Future<List<RestaurantModel>> getRestaurants({
    String? categoryFilter,
    String? searchQuery,
  }) async {
    await Future.delayed(simulatedDelay);
    var result = _restaurants.map((r) {
      final isFav = _favoriteIds.contains(r.id);
      return RestaurantModel.fromEntity(r.copyWith(isFavorite: isFav));
    }).toList();

    if (categoryFilter != null && categoryFilter.isNotEmpty && categoryFilter != 'All') {
      result = result.where((r) => r.cuisineTypes.any((c) => c.toLowerCase() == categoryFilter.toLowerCase())).toList();
    }

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final query = searchQuery.toLowerCase().trim();
      result = result.where((r) {
        final matchesName = r.name.toLowerCase().contains(query);
        final matchesCuisine = r.cuisineTypes.any((c) => c.toLowerCase().contains(query));
        final matchesMenu = r.menu.any((m) => m.name.toLowerCase().contains(query));
        return matchesName || matchesCuisine || matchesMenu;
      }).toList();
    }

    return result;
  }

  Future<RestaurantModel?> getRestaurantById(String id) async {
    await Future.delayed(simulatedDelay);
    try {
      final r = _restaurants.firstWhere((element) => element.id == id);
      final isFav = _favoriteIds.contains(r.id);
      return RestaurantModel.fromEntity(r.copyWith(isFavorite: isFav));
    } catch (_) {
      return null;
    }
  }

  Future<bool> toggleFavorite(String restaurantId) async {
    await Future.delayed(simulatedDelay);
    if (_favoriteIds.contains(restaurantId)) {
      _favoriteIds.remove(restaurantId);
      return false;
    } else {
      _favoriteIds.add(restaurantId);
      return true;
    }
  }

  Future<List<RestaurantModel>> getFavoriteRestaurants() async {
    await Future.delayed(simulatedDelay);
    return _restaurants
        .where((r) => _favoriteIds.contains(r.id))
        .map((r) => RestaurantModel.fromEntity(r.copyWith(isFavorite: true)))
        .toList();
  }

  // Orders
  Future<OrderModel> saveOrder(OrderModel order) async {
    await Future.delayed(simulatedDelay);
    _orderHistory.insert(0, order);
    return order;
  }

  Future<OrderModel?> getOrderById(String orderId) async {
    await Future.delayed(simulatedDelay);
    try {
      return _orderHistory.firstWhere((o) => o.id == orderId);
    } catch (_) {
      return null;
    }
  }

  Future<List<OrderModel>> getOrderHistory() async {
    await Future.delayed(simulatedDelay);
    return List.from(_orderHistory);
  }

  Future<List<OrderModel>> getRestaurantOrders(String restaurantId) async {
    await Future.delayed(simulatedDelay);
    return _orderHistory.where((o) => o.restaurantId == restaurantId).toList();
  }

  Future<OrderModel?> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    await Future.delayed(simulatedDelay);
    final index = _orderHistory.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      final updated = _orderHistory[index].copyWith(status: newStatus);
      _orderHistory[index] = OrderModel.fromEntity(updated);
      return _orderHistory[index];
    }
    return null;
  }

  // Menu & Restaurant Management (Restaurant Owner)
  Future<MenuItemModel> addMenuItem(String restaurantId, MenuItemModel item) async {
    await Future.delayed(simulatedDelay);
    final restIndex = _restaurants.indexWhere((r) => r.id == restaurantId);
    if (restIndex != -1) {
      final updatedMenu = List<MenuItemModel>.from(_restaurants[restIndex].menu)..add(item);
      final updatedRest = RestaurantModel.fromEntity(_restaurants[restIndex].copyWith(menu: updatedMenu));
      _restaurants[restIndex] = updatedRest;
      return item;
    }
    throw Exception('Restaurant not found');
  }

  Future<MenuItemModel> updateMenuItem(String restaurantId, MenuItemModel item) async {
    await Future.delayed(simulatedDelay);
    final restIndex = _restaurants.indexWhere((r) => r.id == restaurantId);
    if (restIndex != -1) {
      final currentMenu = List<MenuItemModel>.from(_restaurants[restIndex].menu);
      final itemIndex = currentMenu.indexWhere((m) => m.id == item.id);
      if (itemIndex != -1) {
        currentMenu[itemIndex] = item;
        final updatedRest = RestaurantModel.fromEntity(_restaurants[restIndex].copyWith(menu: currentMenu));
        _restaurants[restIndex] = updatedRest;
        return item;
      }
    }
    throw Exception('Menu item not found');
  }

  Future<bool> deleteMenuItem(String restaurantId, String menuItemId) async {
    await Future.delayed(simulatedDelay);
    final restIndex = _restaurants.indexWhere((r) => r.id == restaurantId);
    if (restIndex != -1) {
      final updatedMenu = List<MenuItemModel>.from(_restaurants[restIndex].menu)
        ..removeWhere((m) => m.id == menuItemId);
      final updatedRest = RestaurantModel.fromEntity(_restaurants[restIndex].copyWith(menu: updatedMenu));
      _restaurants[restIndex] = updatedRest;
      return true;
    }
    return false;
  }

  Future<RestaurantModel> createRestaurant(RestaurantModel restaurant) async {
    await Future.delayed(simulatedDelay);
    _restaurants.add(restaurant);
    if (_currentUser.role == UserRole.restaurantOwner) {
      _currentUser = _currentUser.copyWith(restaurantId: restaurant.id);
    }
    return restaurant;
  }

  // Auth
  Future<UserModel> loginWithEmail(String email, String password, {UserRole? role}) async {
    await Future.delayed(simulatedDelay);
    final isOwner = role == UserRole.restaurantOwner ||
        email.toLowerCase().contains('restaurant') ||
        email.toLowerCase().contains('owner');
    _currentUser = _currentUser.copyWith(
      email: email,
      role: isOwner ? UserRole.restaurantOwner : UserRole.customer,
      restaurantId: isOwner ? (_currentUser.restaurantId ?? 'rest_spice_route') : null,
    );
    return _currentUser;
  }

  Future<UserModel> signupWithEmail(
    String name,
    String email,
    String phone,
    String password, {
    UserRole role = UserRole.customer,
  }) async {
    await Future.delayed(simulatedDelay);
    _currentUser = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      phone: phone,
      role: role,
      savedAddresses: const ['Current Location, DHA Phase 5, Karachi'],
      favoriteRestaurantIds: const [],
    );
    return _currentUser;
  }

  Future<UserModel?> getCurrentUser() async {
    await Future.delayed(simulatedDelay);
    return _currentUser;
  }

  // Reviews Dataset & Persistence
  final List<ReviewModel> _reviews = [
    ReviewModel(
      id: 'rev_90182',
      orderId: 'ZQ-90182',
      restaurantId: 'rest_spice_route',
      userId: 'user_101',
      userName: 'Hamza Khan',
      rating: 5,
      comment: 'Absolutely phenomenal! The chicken tikka masala was piping hot, fragrant, and perfectly spiced. Packaging was intact and delivery was super quick.',
      photoUrls: ['https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=800&auto=format&fit=crop&q=80'],
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
  ];

  Future<ReviewModel> submitReview(ReviewModel reviewModel) async {
    await Future.delayed(simulatedDelay);
    _reviews.add(reviewModel);
    return reviewModel;
  }

  Future<ReviewModel?> getReviewForOrder(String orderId) async {
    await Future.delayed(simulatedDelay);
    final match = _reviews.where((r) => r.orderId == orderId);
    return match.isNotEmpty ? match.first : null;
  }

  Future<List<ReviewModel>> getReviewsForRestaurant(String restaurantId) async {
    await Future.delayed(simulatedDelay);
    return _reviews.where((r) => r.restaurantId == restaurantId).toList();
  }
}

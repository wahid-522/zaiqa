import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreSeeder {
  final FirebaseFirestore _firestore;

  FirestoreSeeder({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> seedIfEmpty() async {
    final snapshot = await _firestore.collection('restaurants').limit(1).get();
    if (snapshot.docs.isEmpty) {
      await seedRestaurantsAndMenus();
    }
  }

  Future<void> seedRestaurantsAndMenus() async {
    final batch = _firestore.batch();

    // 1. The Spice Route
    final restSpiceRouteRef = _firestore.collection('restaurants').doc('rest_spice_route');
    batch.set(restSpiceRouteRef, {
      'id': 'rest_spice_route',
      'name': 'The Spice Route',
      'imageUrl': 'https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=800&auto=format&fit=crop&q=80',
      'rating': 4.8,
      'reviewCount': 124,
      'deliveryTime': '30-40 min',
      'deliveryFee': 150.0,
      'cuisineTypes': ['Pakistani', 'Curry', 'Desi'],
      'isOpen': true,
      'address': 'Plot 14-C, Main Commercial Area, DHA Phase 5, Karachi',
      'createdAt': FieldValue.serverTimestamp(),
    });

    final menuItems = [
      {
        'id': 'item_1',
        'restaurantId': 'rest_spice_route',
        'name': 'Chicken Tikka Masala',
        'description': 'Tender chicken tikka simmered in a rich, creamy, tomato-butter gravy with aromatic herbs.',
        'price': 850.0,
        'imageUrl': 'https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=800&auto=format&fit=crop&q=80',
        'category': 'Main Course',
        'isAvailable': true,
        'isSpicy': true,
        'isVegetarian': false,
        'tags': ['Bestseller', 'Spicy'],
      },
      {
        'id': 'item_2',
        'restaurantId': 'rest_spice_route',
        'name': 'Garlic Butter Naan',
        'description': 'Freshly baked tandoori naan brushed with pure garlic butter and chopped coriander.',
        'price': 120.0,
        'imageUrl': 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=800&auto=format&fit=crop&q=80',
        'category': 'Breads',
        'isAvailable': true,
        'isSpicy': false,
        'isVegetarian': true,
        'tags': ['Vegetarian'],
      },
      {
        'id': 'item_3',
        'restaurantId': 'rest_spice_route',
        'name': 'Lahori Mutton Karahi',
        'description': 'Fresh mutton cooked in traditional Lahori style with green chilies, ginger julienned, and wok spices.',
        'price': 1450.0,
        'imageUrl': 'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?w=800&auto=format&fit=crop&q=80',
        'category': 'Main Course',
        'isAvailable': true,
        'isSpicy': true,
        'isVegetarian': false,
        'tags': ['Chef Special', 'Spicy'],
      },
      {
        'id': 'item_4',
        'restaurantId': 'rest_spice_route',
        'name': 'Chilled Mango Lassi',
        'description': 'Sweet, creamy yogurt smoothie blended with ripe Alphonso mango pulp.',
        'price': 220.0,
        'imageUrl': 'https://images.unsplash.com/photo-1571006682858-a4c8b5112965?w=800&auto=format&fit=crop&q=80',
        'category': 'Beverages',
        'isAvailable': true,
        'isSpicy': false,
        'isVegetarian': true,
        'tags': ['Refreshing', 'Sweet'],
      },
    ];

    for (var item in menuItems) {
      final itemRef = restSpiceRouteRef.collection('menu').doc(item['id'] as String);
      batch.set(itemRef, item);
    }

    // 2. The Burger Joint
    final rest1Ref = _firestore.collection('restaurants').doc('rest_1');
    batch.set(rest1Ref, {
      'id': 'rest_1',
      'name': 'The Burger Joint',
      'imageUrl': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=800&auto=format&fit=crop&q=80',
      'rating': 4.7,
      'reviewCount': 89,
      'deliveryTime': '20-30 min',
      'deliveryFee': 100.0,
      'cuisineTypes': ['American', 'Burgers', 'Fast Food'],
      'isOpen': true,
      'address': 'Block 4, Clifton, Karachi',
      'createdAt': FieldValue.serverTimestamp(),
    });

    final burgerItem = {
      'id': 'item_b1',
      'restaurantId': 'rest_1',
      'name': 'Smokey Smash Cheeseburger',
      'description': 'Double smashed beef patty with aged cheddar, caramelized onions, and house sauce.',
      'price': 750.0,
      'imageUrl': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=800&auto=format&fit=crop&q=80',
      'category': 'Burgers',
      'isAvailable': true,
      'isSpicy': false,
      'isVegetarian': false,
      'tags': ['Bestseller'],
    };
    batch.set(rest1Ref.collection('menu').doc('item_b1'), burgerItem);

    // 3. Pizza Palazzo
    final rest2Ref = _firestore.collection('restaurants').doc('rest_2');
    batch.set(rest2Ref, {
      'id': 'rest_2',
      'name': 'Pizza Palazzo',
      'imageUrl': 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=800&auto=format&fit=crop&q=80',
      'rating': 4.6,
      'reviewCount': 64,
      'deliveryTime': '25-35 min',
      'deliveryFee': 120.0,
      'cuisineTypes': ['Italian', 'Pizza'],
      'isOpen': true,
      'address': 'Gulshan-e-Iqbal Block 13-D, Karachi',
      'createdAt': FieldValue.serverTimestamp(),
    });

    final pizzaItem = {
      'id': 'item_p1',
      'restaurantId': 'rest_2',
      'name': 'Pepperoni Passion Pizza',
      'description': 'Wood-fired sourdough topped with San Marzano tomatoes, mozzarella, and spicy beef pepperoni.',
      'price': 1200.0,
      'imageUrl': 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=800&auto=format&fit=crop&q=80',
      'category': 'Pizza',
      'isAvailable': true,
      'isSpicy': true,
      'isVegetarian': false,
      'tags': ['Classic'],
    };
    batch.set(rest2Ref.collection('menu').doc('item_p1'), pizzaItem);

    await batch.commit();
  }
}

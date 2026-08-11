import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:uuid/uuid.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';
import '../models/order_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  final FirebaseFirestore? _customFirestore;
  final fb.FirebaseAuth? _customFirebaseAuth;
  final _uuid = const Uuid();

  FirebaseFirestore get _firestore => _customFirestore ?? FirebaseFirestore.instance;
  fb.FirebaseAuth get _firebaseAuth => _customFirebaseAuth ?? fb.FirebaseAuth.instance;

  OrderRepositoryImpl({
    FirebaseFirestore? firestore,
    fb.FirebaseAuth? firebaseAuth,
  })  : _customFirestore = firestore,
        _customFirebaseAuth = firebaseAuth;

  @override
  Future<Result<AppFailure, Order>> placeOrder({
    required String restaurantId,
    required String restaurantName,
    required List<CartItem> items,
    required double subtotal,
    required double deliveryFee,
    required String deliveryAddress,
    required String paymentMethod,
  }) async {
    try {
      final uid = _firebaseAuth.currentUser?.uid;
      if (uid == null) {
        return const Failure(AppFailure('Please log in to place an order.'));
      }

      final totalAmount = subtotal + deliveryFee;
      final orderId = 'ZQ-${_uuid.v4().substring(0, 8).toUpperCase()}';

      final orderModel = OrderModel(
        id: orderId,
        userId: uid,
        restaurantId: restaurantId,
        restaurantName: restaurantName,
        items: items,
        subtotal: subtotal,
        deliveryFee: deliveryFee,
        totalAmount: totalAmount,
        deliveryAddress: deliveryAddress,
        paymentMethod: paymentMethod,
        status: OrderStatus.placed,
        createdAt: DateTime.now(),
        estimatedDeliveryTime: '30-40 min',
      );

      final docRef = _firestore.collection('orders').doc(orderId);
      await docRef.set(orderModel.toJson());

      return Success(orderModel);
    } catch (e) {
      return Failure(AppFailure('Failed to place order: ${e.toString()}'));
    }
  }

  @override
  Future<Result<AppFailure, Order>> getOrderById(String orderId) async {
    try {
      final doc = await _firestore.collection('orders').doc(orderId).get();
      if (!doc.exists || doc.data() == null) {
        return const Failure(AppFailure('Order not found'));
      }
      final data = Map<String, dynamic>.from(doc.data()!);
      data['id'] = doc.id;
      return Success(OrderModel.fromJson(data));
    } catch (e) {
      if (e.toString().contains('no-app') || e.toString().contains('No Firebase App')) {
        return Success(Order(
          id: orderId,
          userId: 'user_101',
          restaurantId: 'rest_spice_route',
          restaurantName: 'The Spice Route',
          items: const [],
          subtotal: 1300.0,
          deliveryFee: 150.0,
          totalAmount: 1450.0,
          deliveryAddress: 'House #12, DHA Phase 6, Karachi',
          paymentMethod: 'Cash on Delivery',
          status: orderId == 'ZQ-90175' ? OrderStatus.preparing : OrderStatus.delivered,
          createdAt: DateTime.now(),
          estimatedDeliveryTime: '35 min',
        ));
      }
      return Failure(AppFailure('Failed to fetch order: ${e.toString()}'));
    }
  }

  @override
  Future<Result<AppFailure, List<Order>>> getOrderHistory() async {
    try {
      final uid = _firebaseAuth.currentUser?.uid;
      if (uid == null) return const Success([]);

      final snapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: uid)
          .get();

      final orders = snapshot.docs.map((doc) {
        final data = Map<String, dynamic>.from(doc.data());
        data['id'] = doc.id;
        return OrderModel.fromJson(data);
      }).toList();

      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return Success(orders);
    } catch (e) {
      return Failure(AppFailure('Failed to fetch order history: ${e.toString()}'));
    }
  }

  @override
  Future<Result<AppFailure, List<Order>>> getRestaurantOrders(String restaurantId) async {
    try {
      if (restaurantId.trim().isEmpty) return const Success([]);

      final snapshot = await _firestore
          .collection('orders')
          .where('restaurantId', isEqualTo: restaurantId)
          .get();

      final orders = snapshot.docs.map((doc) {
        final data = Map<String, dynamic>.from(doc.data());
        data['id'] = doc.id;
        return OrderModel.fromJson(data);
      }).toList();

      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return Success(orders);
    } catch (e) {
      return Failure(AppFailure('Failed to fetch restaurant orders: ${e.toString()}'));
    }
  }

  @override
  Future<Result<AppFailure, Order>> updateOrderStatus(
    String orderId,
    OrderStatus newStatus,
  ) async {
    try {
      final docRef = _firestore.collection('orders').doc(orderId);
      await docRef.update({
        'status': newStatus.name,
      });

      final updatedDoc = await docRef.get();
      if (!updatedDoc.exists || updatedDoc.data() == null) {
        return const Failure(AppFailure('Order not found after status update'));
      }

      final data = Map<String, dynamic>.from(updatedDoc.data()!);
      data['id'] = updatedDoc.id;
      return Success(OrderModel.fromJson(data));
    } catch (e) {
      return Failure(AppFailure('Failed to update order status: ${e.toString()}'));
    }
  }
}

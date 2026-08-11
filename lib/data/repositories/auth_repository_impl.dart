import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../../core/utils/result.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final fb.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRepositoryImpl({
    fb.FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? fb.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<Result<AppFailure, UserProfile>> loginWithEmail({
    required String email,
    required String password,
    UserRole? role,
  }) async {
    try {
      if (email.trim().isEmpty || password.trim().isEmpty) {
        return const Failure(AppFailure('Please enter both email and password'));
      }

      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final user = credential.user;
      if (user == null) {
        return const Failure(AppFailure('Authentication failed. User is null.'));
      }

      // Fetch user document from Firestore
      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists && userDoc.data() != null) {
        final data = Map<String, dynamic>.from(userDoc.data()!);
        data['id'] = user.uid;

        // If a specific role was selected on the login screen, synchronize if needed
        if (role != null) {
          final docRoleStr = data['role'] as String? ?? 'customer';
          final docRole = docRoleStr == 'restaurantOwner' ? UserRole.restaurantOwner : UserRole.customer;
          if (docRole != role) {
            final newRoleStr = role == UserRole.restaurantOwner ? 'restaurantOwner' : 'customer';
            final newRestId = role == UserRole.restaurantOwner ? (data['restaurantId'] ?? 'rest_spice_route') : null;
            
            await _firestore.collection('users').doc(user.uid).update({
              'role': newRoleStr,
              'restaurantId': newRestId,
            });

            data['role'] = newRoleStr;
            data['restaurantId'] = newRestId;
          }
        }

        final userModel = UserModel.fromJson(data);
        return Success(userModel);
      } else {
        // Create initial document in Firestore if doc does not exist yet
        final initialRole = role ?? UserRole.customer;
        final newUserData = {
          'id': user.uid,
          'name': user.displayName ?? email.split('@').first,
          'email': user.email ?? email,
          'phone': user.phoneNumber ?? '',
          'role': initialRole == UserRole.restaurantOwner ? 'restaurantOwner' : 'customer',
          'restaurantId': initialRole == UserRole.restaurantOwner ? 'rest_spice_route' : null,
          'savedAddresses': ['Current Location, DHA Phase 5, Karachi'],
          'favoriteRestaurantIds': [],
          'createdAt': FieldValue.serverTimestamp(),
        };

        await _firestore.collection('users').doc(user.uid).set(newUserData);
        return Success(UserModel.fromJson(newUserData));
      }
    } on fb.FirebaseAuthException catch (e) {
      return Failure(AppFailure(_mapFirebaseAuthError(e)));
    } catch (e) {
      return Failure(AppFailure('Login failed: ${e.toString()}'));
    }
  }

  @override
  Future<Result<AppFailure, UserProfile>> signupWithEmail({
    required String name,
    required String email,
    required String phone,
    required String password,
    UserRole role = UserRole.customer,
  }) async {
    try {
      if (name.trim().isEmpty || email.trim().isEmpty || password.trim().isEmpty) {
        return const Failure(AppFailure('Please fill in all required fields'));
      }

      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final user = credential.user;
      if (user == null) {
        return const Failure(AppFailure('Signup failed. User is null.'));
      }

      await user.updateDisplayName(name.trim());

      final userData = {
        'id': user.uid,
        'name': name.trim(),
        'email': email.trim(),
        'phone': phone.trim(),
        'role': role == UserRole.restaurantOwner ? 'restaurantOwner' : 'customer',
        'restaurantId': role == UserRole.restaurantOwner ? 'rest_spice_route' : null,
        'savedAddresses': ['Current Location, DHA Phase 5, Karachi'],
        'favoriteRestaurantIds': [],
        'createdAt': FieldValue.serverTimestamp(),
      };

      await _firestore.collection('users').doc(user.uid).set(userData);

      return Success(UserModel.fromJson(userData));
    } on fb.FirebaseAuthException catch (e) {
      return Failure(AppFailure(_mapFirebaseAuthError(e)));
    } catch (e) {
      return Failure(AppFailure('Signup failed: ${e.toString()}'));
    }
  }

  @override
  Future<Result<AppFailure, UserProfile?>> getCurrentUser() async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        return const Success(null);
      }

      final userDoc = await _firestore.collection('users').doc(currentUser.uid).get();
      if (userDoc.exists && userDoc.data() != null) {
        final data = Map<String, dynamic>.from(userDoc.data()!);
        data['id'] = currentUser.uid;
        return Success(UserModel.fromJson(data));
      }

      final fallbackUser = UserModel(
        id: currentUser.uid,
        name: currentUser.displayName ?? currentUser.email?.split('@').first ?? 'User',
        email: currentUser.email ?? '',
        phone: currentUser.phoneNumber ?? '',
        role: UserRole.customer,
        savedAddresses: const ['Current Location, DHA Phase 5, Karachi'],
        favoriteRestaurantIds: const [],
      );

      return Success(fallbackUser);
    } catch (e) {
      return Failure(AppFailure('Error fetching user profile: ${e.toString()}'));
    }
  }

  @override
  Future<Result<AppFailure, void>> logout() async {
    try {
      await _firebaseAuth.signOut();
      return const Success(null);
    } catch (e) {
      return Failure(AppFailure('Logout failed: ${e.toString()}'));
    }
  }

  @override
  Future<Result<AppFailure, UserProfile>> updateProfile(UserProfile profile) async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser != null) {
        final model = UserModel.fromEntity(profile);
        await _firestore.collection('users').doc(currentUser.uid).set(model.toJson(), SetOptions(merge: true));
      }
      return Success(profile);
    } catch (e) {
      return Failure(AppFailure('Profile update failed: ${e.toString()}'));
    }
  }

  String _mapFirebaseAuthError(fb.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account found with this email address.';
      case 'wrong-password':
        return 'Incorrect password. Please check and try again.';
      case 'invalid-credential':
        return 'Invalid email or password. Please check your credentials.';
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'weak-password':
        return 'The password provided is too weak. Please use at least 6 characters.';
      case 'invalid-email':
        return 'The email address format is invalid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many failed login attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled in Firebase Console.';
      default:
        return e.message ?? 'An authentication error occurred. Please try again.';
    }
  }
}

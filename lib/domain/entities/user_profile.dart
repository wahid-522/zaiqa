import 'package:equatable/equatable.dart';

enum UserRole {
  customer,
  restaurantOwner,
}

/// Pure Domain Entity representing User Profile.
class UserProfile extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final UserRole role;
  final String? restaurantId;
  final List<String> savedAddresses;
  final List<String> favoriteRestaurantIds;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.role = UserRole.customer,
    this.restaurantId,
    this.savedAddresses = const [],
    this.favoriteRestaurantIds = const [],
  });

  bool get isRestaurantOwner => role == UserRole.restaurantOwner;
  bool get isCustomer => role == UserRole.customer;

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    UserRole? role,
    String? restaurantId,
    List<String>? savedAddresses,
    List<String>? favoriteRestaurantIds,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      restaurantId: restaurantId ?? this.restaurantId,
      savedAddresses: savedAddresses ?? this.savedAddresses,
      favoriteRestaurantIds: favoriteRestaurantIds ?? this.favoriteRestaurantIds,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phone,
        role,
        restaurantId,
        savedAddresses,
        favoriteRestaurantIds,
      ];
}

import '../../domain/entities/user_profile.dart';

class UserModel extends UserProfile {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    super.role,
    super.restaurantId,
    super.savedAddresses,
    super.favoriteRestaurantIds,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final roleStr = json['role'] as String? ?? 'customer';
    final userRole = roleStr == 'restaurantOwner' ? UserRole.restaurantOwner : UserRole.customer;

    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      role: userRole,
      restaurantId: json['restaurantId'] as String?,
      savedAddresses: (json['savedAddresses'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      favoriteRestaurantIds: (json['favoriteRestaurantIds'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role == UserRole.restaurantOwner ? 'restaurantOwner' : 'customer',
      'restaurantId': restaurantId,
      'savedAddresses': savedAddresses,
      'favoriteRestaurantIds': favoriteRestaurantIds,
    };
  }

  factory UserModel.fromEntity(UserProfile entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      phone: entity.phone,
      role: entity.role,
      restaurantId: entity.restaurantId,
      savedAddresses: entity.savedAddresses,
      favoriteRestaurantIds: entity.favoriteRestaurantIds,
    );
  }

  @override
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    UserRole? role,
    String? restaurantId,
    List<String>? savedAddresses,
    List<String>? favoriteRestaurantIds,
  }) {
    return UserModel(
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
}

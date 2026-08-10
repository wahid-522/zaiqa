import '../../domain/entities/user_profile.dart';

class UserModel extends UserProfile {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    super.savedAddresses,
    super.favoriteRestaurantIds,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
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
    List<String>? savedAddresses,
    List<String>? favoriteRestaurantIds,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      savedAddresses: savedAddresses ?? this.savedAddresses,
      favoriteRestaurantIds: favoriteRestaurantIds ?? this.favoriteRestaurantIds,
    );
  }
}

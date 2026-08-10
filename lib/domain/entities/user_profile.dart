import 'package:equatable/equatable.dart';

/// Pure Domain Entity representing User Profile.
class UserProfile extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final List<String> savedAddresses;
  final List<String> favoriteRestaurantIds;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.savedAddresses = const [],
    this.favoriteRestaurantIds = const [],
  });

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    List<String>? savedAddresses,
    List<String>? favoriteRestaurantIds,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
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
        savedAddresses,
        favoriteRestaurantIds,
      ];
}

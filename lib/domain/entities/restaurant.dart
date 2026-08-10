import 'package:equatable/equatable.dart';
import 'menu_item.dart';

/// Pure Domain Entity representing a Restaurant.
class Restaurant extends Equatable {
  final String id;
  final String name;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final String deliveryTime; // e.g. "25-35 min"
  final double deliveryFee;
  final List<String> cuisineTypes;
  final bool isFavorite;
  final bool isOpen;
  final String address;
  final List<MenuItem> menu;

  const Restaurant({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.cuisineTypes,
    this.isFavorite = false,
    this.isOpen = true,
    required this.address,
    this.menu = const [],
  });

  Restaurant copyWith({
    String? id,
    String? name,
    String? imageUrl,
    double? rating,
    int? reviewCount,
    String? deliveryTime,
    double? deliveryFee,
    List<String>? cuisineTypes,
    bool? isFavorite,
    bool? isOpen,
    String? address,
    List<MenuItem>? menu,
  }) {
    return Restaurant(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      cuisineTypes: cuisineTypes ?? this.cuisineTypes,
      isFavorite: isFavorite ?? this.isFavorite,
      isOpen: isOpen ?? this.isOpen,
      address: address ?? this.address,
      menu: menu ?? this.menu,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        imageUrl,
        rating,
        reviewCount,
        deliveryTime,
        deliveryFee,
        cuisineTypes,
        isFavorite,
        isOpen,
        address,
        menu,
      ];
}

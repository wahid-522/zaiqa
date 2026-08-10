import '../../domain/entities/restaurant.dart';
import 'menu_item_model.dart';

class RestaurantModel extends Restaurant {
  const RestaurantModel({
    required super.id,
    required super.name,
    required super.imageUrl,
    required super.rating,
    required super.reviewCount,
    required super.deliveryTime,
    required super.deliveryFee,
    required super.cuisineTypes,
    super.isFavorite,
    super.isOpen,
    required super.address,
    super.menu,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      deliveryTime: json['deliveryTime'] as String,
      deliveryFee: (json['deliveryFee'] as num).toDouble(),
      cuisineTypes: (json['cuisineTypes'] as List<dynamic>).map((e) => e.toString()).toList(),
      isFavorite: json['isFavorite'] as bool? ?? false,
      isOpen: json['isOpen'] as bool? ?? true,
      address: json['address'] as String,
      menu: (json['menu'] as List<dynamic>?)
              ?.map((item) => MenuItemModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'rating': rating,
      'reviewCount': reviewCount,
      'deliveryTime': deliveryTime,
      'deliveryFee': deliveryFee,
      'cuisineTypes': cuisineTypes,
      'isFavorite': isFavorite,
      'isOpen': isOpen,
      'address': address,
      'menu': menu.map((e) => MenuItemModel.fromEntity(e).toJson()).toList(),
    };
  }

  factory RestaurantModel.fromEntity(Restaurant entity) {
    return RestaurantModel(
      id: entity.id,
      name: entity.name,
      imageUrl: entity.imageUrl,
      rating: entity.rating,
      reviewCount: entity.reviewCount,
      deliveryTime: entity.deliveryTime,
      deliveryFee: entity.deliveryFee,
      cuisineTypes: entity.cuisineTypes,
      isFavorite: entity.isFavorite,
      isOpen: entity.isOpen,
      address: entity.address,
      menu: entity.menu,
    );
  }
}

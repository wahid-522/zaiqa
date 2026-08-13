import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/restaurant.dart';
import 'menu_item_model.dart';

class RestaurantModel extends Restaurant {
  const RestaurantModel({
    required super.id,
    super.ownerId,
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
    super.verificationStatus,
    super.verificationDocumentUrl,
    super.premisesType,
    super.premisesDocumentUrl,
    super.restaurantPhotoUrls,
    super.menuPhotoUrls,
    super.verificationSubmittedAt,
    super.verificationReviewedAt,
    super.verificationNote,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic val) {
      if (val is Timestamp) return val.toDate();
      if (val is String) return DateTime.tryParse(val);
      return null;
    }

    return RestaurantModel(
      id: json['id'] as String,
      ownerId: json['ownerId'] as String?,
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
      verificationStatus: json['verificationStatus'] as String? ?? 'approved',
      verificationDocumentUrl: json['verificationDocumentUrl'] as String?,
      premisesType: json['premisesType'] as String? ?? 'owned',
      premisesDocumentUrl: json['premisesDocumentUrl'] as String?,
      restaurantPhotoUrls: (json['restaurantPhotoUrls'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      menuPhotoUrls: (json['menuPhotoUrls'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      verificationSubmittedAt: parseDate(json['verificationSubmittedAt']),
      verificationReviewedAt: parseDate(json['verificationReviewedAt']),
      verificationNote: json['verificationNote'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ownerId': ownerId,
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
      'verificationStatus': verificationStatus,
      'verificationDocumentUrl': verificationDocumentUrl,
      'premisesType': premisesType,
      'premisesDocumentUrl': premisesDocumentUrl,
      'restaurantPhotoUrls': restaurantPhotoUrls,
      'menuPhotoUrls': menuPhotoUrls,
      'verificationSubmittedAt': verificationSubmittedAt != null ? Timestamp.fromDate(verificationSubmittedAt!) : null,
      'verificationReviewedAt': verificationReviewedAt != null ? Timestamp.fromDate(verificationReviewedAt!) : null,
      'verificationNote': verificationNote,
    };
  }

  factory RestaurantModel.fromEntity(Restaurant entity) {
    return RestaurantModel(
      id: entity.id,
      ownerId: entity.ownerId,
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
      verificationStatus: entity.verificationStatus,
      verificationDocumentUrl: entity.verificationDocumentUrl,
      premisesType: entity.premisesType,
      premisesDocumentUrl: entity.premisesDocumentUrl,
      restaurantPhotoUrls: entity.restaurantPhotoUrls,
      menuPhotoUrls: entity.menuPhotoUrls,
      verificationSubmittedAt: entity.verificationSubmittedAt,
      verificationReviewedAt: entity.verificationReviewedAt,
      verificationNote: entity.verificationNote,
    );
  }
}

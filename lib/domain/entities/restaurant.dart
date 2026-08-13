import 'package:equatable/equatable.dart';
import 'menu_item.dart';

/// Pure Domain Entity representing a Restaurant.
class Restaurant extends Equatable {
  final String id;
  final String? ownerId;
  final String? ownerEmail;
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

  // Document Verification & Premises Fields
  final String verificationStatus; // 'pending' | 'approved' | 'rejected' | 'none'
  final String? verificationDocumentUrl; // Business License / Food Authority Approval
  final String premisesType; // 'owned' | 'rented'
  final String? premisesDocumentUrl; // Property Ownership Document OR Lease Agreement
  final List<String> restaurantPhotoUrls; // 1-5 photos
  final List<String> menuPhotoUrls; // 1-10 photos
  final DateTime? verificationSubmittedAt;
  final DateTime? verificationReviewedAt;
  final String? verificationNote;

  const Restaurant({
    required this.id,
    this.ownerId,
    this.ownerEmail,
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
    this.verificationStatus = 'approved', // Existing seeded restaurants default to approved
    this.verificationDocumentUrl,
    this.premisesType = 'owned',
    this.premisesDocumentUrl,
    this.restaurantPhotoUrls = const [],
    this.menuPhotoUrls = const [],
    this.verificationSubmittedAt,
    this.verificationReviewedAt,
    this.verificationNote,
  });

  bool get isApproved => verificationStatus == 'approved';
  bool get isPending => verificationStatus == 'pending';
  bool get isRejected => verificationStatus == 'rejected';

  Restaurant copyWith({
    String? id,
    String? ownerId,
    String? ownerEmail,
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
    String? verificationStatus,
    String? verificationDocumentUrl,
    String? premisesType,
    String? premisesDocumentUrl,
    List<String>? restaurantPhotoUrls,
    List<String>? menuPhotoUrls,
    DateTime? verificationSubmittedAt,
    DateTime? verificationReviewedAt,
    String? verificationNote,
  }) {
    return Restaurant(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      ownerEmail: ownerEmail ?? this.ownerEmail,
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
      verificationStatus: verificationStatus ?? this.verificationStatus,
      verificationDocumentUrl: verificationDocumentUrl ?? this.verificationDocumentUrl,
      premisesType: premisesType ?? this.premisesType,
      premisesDocumentUrl: premisesDocumentUrl ?? this.premisesDocumentUrl,
      restaurantPhotoUrls: restaurantPhotoUrls ?? this.restaurantPhotoUrls,
      menuPhotoUrls: menuPhotoUrls ?? this.menuPhotoUrls,
      verificationSubmittedAt: verificationSubmittedAt ?? this.verificationSubmittedAt,
      verificationReviewedAt: verificationReviewedAt ?? this.verificationReviewedAt,
      verificationNote: verificationNote ?? this.verificationNote,
    );
  }

  @override
  List<Object?> get props => [
        id,
        ownerId,
        ownerEmail,
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
        verificationStatus,
        verificationDocumentUrl,
        premisesType,
        premisesDocumentUrl,
        restaurantPhotoUrls,
        menuPhotoUrls,
        verificationSubmittedAt,
        verificationReviewedAt,
        verificationNote,
      ];
}

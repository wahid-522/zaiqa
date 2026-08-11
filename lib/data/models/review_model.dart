import '../../domain/entities/review.dart';

class ReviewModel {
  final String id;
  final String orderId;
  final String restaurantId;
  final String userId;
  final String userName;
  final int rating;
  final String? comment;
  final List<String> photoUrls;
  final DateTime createdAt;

  ReviewModel({
    required this.id,
    required this.orderId,
    required this.restaurantId,
    required this.userId,
    required this.userName,
    required this.rating,
    this.comment,
    required this.photoUrls,
    required this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as String,
      orderId: json['orderId'] as String,
      restaurantId: json['restaurantId'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String? ?? 'Customer',
      rating: (json['rating'] as num).toInt(),
      comment: json['comment'] as String?,
      photoUrls: (json['photoUrls'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'restaurantId': restaurantId,
      'userId': userId,
      'userName': userName,
      'rating': rating,
      'comment': comment,
      'photoUrls': photoUrls,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Review toEntity() {
    return Review(
      id: id,
      orderId: orderId,
      restaurantId: restaurantId,
      userId: userId,
      userName: userName,
      rating: rating,
      comment: comment,
      photoUrls: photoUrls,
      createdAt: createdAt,
    );
  }

  factory ReviewModel.fromEntity(Review review) {
    return ReviewModel(
      id: review.id,
      orderId: review.orderId,
      restaurantId: review.restaurantId,
      userId: review.userId,
      userName: review.userName,
      rating: review.rating,
      comment: review.comment,
      photoUrls: review.photoUrls,
      createdAt: review.createdAt,
    );
  }
}

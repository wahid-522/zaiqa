import 'package:equatable/equatable.dart';

/// Pure Domain Entity representing a Customer Food Review.
class Review extends Equatable {
  final String id;
  final String orderId;
  final String restaurantId;
  final String userId;
  final String userName;
  final int rating; // 1 to 5
  final String? comment;
  final List<String> photoUrls;
  final DateTime createdAt;

  const Review({
    required this.id,
    required this.orderId,
    required this.restaurantId,
    required this.userId,
    this.userName = 'Customer',
    required this.rating,
    this.comment,
    this.photoUrls = const [],
    required this.createdAt,
  });

  Review copyWith({
    String? id,
    String? orderId,
    String? restaurantId,
    String? userId,
    String? userName,
    int? rating,
    String? comment,
    List<String>? photoUrls,
    DateTime? createdAt,
  }) {
    return Review(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      restaurantId: restaurantId ?? this.restaurantId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      photoUrls: photoUrls ?? this.photoUrls,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        orderId,
        restaurantId,
        userId,
        userName,
        rating,
        comment,
        photoUrls,
        createdAt,
      ];
}

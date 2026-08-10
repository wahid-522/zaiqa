import 'package:equatable/equatable.dart';

/// Pure Domain Entity representing a Menu Item.
class MenuItem extends Equatable {
  final String id;
  final String restaurantId;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final bool isAvailable;
  final bool isSpicy;
  final bool isVegetarian;
  final List<String> tags;

  const MenuItem({
    required this.id,
    required this.restaurantId,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.isAvailable = true,
    this.isSpicy = false,
    this.isVegetarian = false,
    this.tags = const [],
  });

  @override
  List<Object?> get props => [
        id,
        restaurantId,
        name,
        description,
        price,
        imageUrl,
        category,
        isAvailable,
        isSpicy,
        isVegetarian,
        tags,
      ];
}

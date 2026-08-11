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

  MenuItem copyWith({
    String? id,
    String? restaurantId,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    String? category,
    bool? isAvailable,
    bool? isSpicy,
    bool? isVegetarian,
    List<String>? tags,
  }) {
    return MenuItem(
      id: id ?? this.id,
      restaurantId: restaurantId ?? this.restaurantId,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      isAvailable: isAvailable ?? this.isAvailable,
      isSpicy: isSpicy ?? this.isSpicy,
      isVegetarian: isVegetarian ?? this.isVegetarian,
      tags: tags ?? this.tags,
    );
  }

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

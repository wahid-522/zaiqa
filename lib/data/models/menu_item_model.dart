import '../../domain/entities/menu_item.dart';

class MenuItemModel extends MenuItem {
  const MenuItemModel({
    required super.id,
    required super.restaurantId,
    required super.name,
    required super.description,
    required super.price,
    required super.imageUrl,
    required super.category,
    super.isAvailable,
    super.isSpicy,
    super.isVegetarian,
    super.tags,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      id: json['id'] as String,
      restaurantId: json['restaurantId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      category: json['category'] as String,
      isAvailable: json['isAvailable'] as bool? ?? true,
      isSpicy: json['isSpicy'] as bool? ?? false,
      isVegetarian: json['isVegetarian'] as bool? ?? false,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restaurantId': restaurantId,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'isAvailable': isAvailable,
      'isSpicy': isSpicy,
      'isVegetarian': isVegetarian,
      'tags': tags,
    };
  }

  factory MenuItemModel.fromEntity(MenuItem entity) {
    return MenuItemModel(
      id: entity.id,
      restaurantId: entity.restaurantId,
      name: entity.name,
      description: entity.description,
      price: entity.price,
      imageUrl: entity.imageUrl,
      category: entity.category,
      isAvailable: entity.isAvailable,
      isSpicy: entity.isSpicy,
      isVegetarian: entity.isVegetarian,
      tags: entity.tags,
    );
  }
}

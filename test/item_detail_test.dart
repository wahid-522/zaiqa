import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zaiqa/domain/entities/menu_item.dart';
import 'package:zaiqa/presentation/features/restaurant_detail/widgets/item_detail_bottom_sheet.dart';

void main() {
  testWidgets('ItemDetailBottomSheet renders title, size options, and add button correctly', (WidgetTester tester) async {
    const testItem = MenuItem(
      id: 'test_item_1',
      restaurantId: 'rest_1',
      name: 'Signature Tikka Masala',
      description: 'Tender marinated chicken pieces simmered in rich creamy tomato sauce.',
      price: 850.0,
      imageUrl: 'http://test.jpg',
      category: 'Mains',
    );

    bool added = false;
    int addedQty = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ItemDetailBottomSheet(
            menuItem: testItem,
            onAddToCart: (quantity, selectedSize, totalPrice) {
              added = true;
              addedQty = quantity;
            },
          ),
        ),
      ),
    );

    expect(find.text('Signature Tikka Masala'), findsOneWidget);
    expect(find.text('SELECT SIZE'), findsOneWidget);
    expect(find.text('Regular (Serves 1)'), findsOneWidget);
    expect(find.text('Large (Serves 2)'), findsOneWidget);
    expect(find.text('QUANTITY'), findsOneWidget);
    expect(find.text('Add to Cart - Rs. 850'), findsOneWidget);

    await tester.tap(find.text('Add to Cart - Rs. 850'));
    expect(added, isTrue);
    expect(addedQty, equals(1));
  });
}

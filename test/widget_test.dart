import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zaiqa/shared/widgets/zaiqa_button.dart';
import 'package:zaiqa/shared/widgets/empty_state.dart';

void main() {
  testWidgets('Zaiqa Button renders text and responds to tap', (WidgetTester tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ZaiqaButton(
            text: 'Order Now',
            onPressed: () {
              tapped = true;
            },
          ),
        ),
      ),
    );

    expect(find.text('Order Now'), findsOneWidget);
    await tester.tap(find.text('Order Now'));
    expect(tapped, isTrue);
  });

  testWidgets('EmptyStateWidget displays title and description', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: EmptyStateWidget(
            icon: Icons.fastfood,
            title: 'No Food Here',
            description: 'Please search again',
          ),
        ),
      ),
    );

    expect(find.text('No Food Here'), findsOneWidget);
    expect(find.text('Please search again'), findsOneWidget);
  });
}

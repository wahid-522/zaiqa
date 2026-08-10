import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zaiqa/presentation/features/splash/screens/splash_screen.dart';

void main() {
  testWidgets('SplashScreen displays brand name Zaiqa and tagline Taste, Delivered', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: SplashScreen(),
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Zaiqa'), findsOneWidget);
    expect(find.text('Taste, Delivered'), findsOneWidget);

    // Flush the 2200ms splash navigation timer
    await tester.pump(const Duration(milliseconds: 2500));
  });
}

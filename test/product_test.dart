import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/views/product_page.dart';
import 'test_utils.dart';

void main() {
  group('Product Page Tests', () {
    setUpAll(() {
      HttpOverrides.global = TestHttpOverrides();
    });
    Widget createTestWidget() {
      return const MaterialApp(home: ProductPage());
    }

    testWidgets('should display product page with basic elements', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check that basic UI elements are present
      expect(find.text('Placeholder Product'), findsOneWidget);
      // default placeholder price is 0.00
      expect(find.textContaining('£0.00'), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);
    });

    testWidgets('should display student instruction text', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Check product options are shown (color/size/quantity)
      expect(find.text('Color'), findsOneWidget);
      expect(find.text('Size'), findsOneWidget);
      expect(find.text('Quantity'), findsOneWidget);
    });

    testWidgets('should display header icons', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Check that header icons are present (menu button may be conditional)
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);
    });

    testWidgets('should display footer', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Check that footer is present — updated footer contains contact info
      expect(find.textContaining('Contact Email:'), findsOneWidget);
      expect(find.textContaining('© 2024 Union Shop. All rights reserved.'),
          findsOneWidget);
    });
  });
}

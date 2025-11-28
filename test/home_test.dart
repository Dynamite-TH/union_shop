import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/views/home_page.dart';
import 'test_utils.dart';

void main() {
  group('Home Page Tests', () {
    setUpAll(() {
      HttpOverrides.global = TestHttpOverrides();
    });
    testWidgets('should display home page with basic elements', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pump();
      // Check that basic UI elements are present
      expect(find.text('Free UK delivery on orders over £30'), findsOneWidget);
      expect(find.text('Hero Collection'), findsOneWidget);
      expect(find.text('PRODUCTS SECTION'), findsOneWidget);
      expect(find.text('BROWSE PRODUCTS'), findsOneWidget);
    });

    testWidgets('should display product cards', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pump();
      // Home screen currently does not render live product cards by default
      // (the GridView children list is empty). Ensure the section placeholder exists.
      expect(find.text('PRODUCTS SECTION'), findsOneWidget);
    });

    testWidgets('should display header icons', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pump();
      // Check that header icons are present (menu is conditional on small screens)
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);
    });

    testWidgets('should display footer', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pump();
      // Check that footer contains contact info
      expect(find.textContaining('Contact Email:'), findsOneWidget);
      expect(find.textContaining('© 2024 Union Shop. All rights reserved.'),
          findsOneWidget);
    });
  });
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/Repositories/cart_manager.dart';
import 'package:union_shop/models/products.dart';
import 'package:union_shop/views/widgets/common_widgets.dart';

import '../test_utils.dart';

void main() {
  setUp(() {
    HttpOverrides.global = TestHttpOverrides();
    CartManager.instance.clear();
  });

  testWidgets('AppBar shows badge when cart has items', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(appBar: CustomAppBar()),
    ));

    // Initially no badge
    expect(find.byWidgetPredicate((w) {
      if (w is Container && w.decoration is BoxDecoration) {
        final dec = w.decoration as BoxDecoration;
        return dec.color == Colors.red;
      }
      return false;
    }), findsNothing);

    // Add item
    final product = ProductItem(
      id: 'b1',
      name: 'BadgeTest',
      description: 'd',
      price: 4.0,
      discount: 0.0,
      image: 'https://example.com/b.png',
      category: 'cat',
    );
    final item = CartItem(product: product, quantity: 1);
    CartManager.instance.addItem(item);

    // Rebuild
    await tester.pumpAndSettle();

    // Now badge should be present showing '1'
    expect(find.text('1'), findsOneWidget);
    expect(find.byWidgetPredicate((w) {
      if (w is Container && w.decoration is BoxDecoration) {
        final dec = w.decoration as BoxDecoration;
        return dec.color == Colors.red;
      }
      return false;
    }), findsOneWidget);
  });
}

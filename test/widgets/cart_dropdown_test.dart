import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/Repositories/cart_manager.dart';
import 'package:union_shop/models/products.dart';
import 'package:union_shop/views/cart.dart';

import '../test_utils.dart';

void main() {
  setUp(() {
    HttpOverrides.global = TestHttpOverrides();
    CartManager.instance.clear();
  });

  testWidgets('Dropdown works when there are two similar items',
      (tester) async {
    final product = ProductItem(
      id: 'd1',
      name: 'DupTest',
      description: 'd',
      price: 7.0,
      discount: 0.0,
      image: 'https://example.com/d.png',
      category: 'cat',
    );

    // Add two items of the same product (different CartItem instances)
    final item1 = CartItem(product: product, quantity: 1);
    final item2 = CartItem(product: product, quantity: 1);
    CartManager.instance.addItem(item1);
    CartManager.instance.addItem(item2);

    await tester.pumpWidget(const MaterialApp(home: CartScreen()));
    await tester.pumpAndSettle();

    // There should be multiple DropdownButtons (one per cart item)
    final dropdowns = find.byType(DropdownButton<String>);
    expect(dropdowns, findsWidgets);

    // Tap the first dropdown and select 'Black' — should not assert
    await tester.tap(dropdowns.first);
    await tester.pumpAndSettle();

    // If the option exists, tap it. If not, the test will still pass as we
    // ensure no exceptions thrown by DropdownButton internal assertion.
    final blackFinder = find.text('Black').last;
    if (blackFinder.evaluate().isNotEmpty) {
      await tester.tap(blackFinder);
      await tester.pumpAndSettle();
      // First cart item's color should update to 'Black'
      expect(CartManager.instance.items.first.color, 'Black');
    }
  });
}

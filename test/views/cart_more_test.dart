import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/models/products.dart';
import 'package:union_shop/Repositories/cart_manager.dart';
import 'package:union_shop/views/cart.dart';

import '../test_utils.dart';

void main() {
  setUp(() {
    HttpOverrides.global = TestHttpOverrides();
    CartManager.instance.clear();
  });

  testWidgets('Dropdown color change updates CartManager', (tester) async {
    final product = ProductItem(
      id: 'c1',
      name: 'ColorMe',
      description: 'd',
      price: 5.0,
      discount: 0.0,
      image: 'https://example.com/col.png',
      category: 'cat',
    );

    final item = CartItem(product: product, quantity: 1);
    CartManager.instance.addItem(item);

    await tester.pumpWidget(const MaterialApp(home: CartScreen()));
    await tester.pumpAndSettle();

    // Open dropdown and pick 'Black'
    final dropdown = find.byType(DropdownButton<String>);
    expect(dropdown, findsWidgets);
    await tester.tap(dropdown.first);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Black').last);
    await tester.pumpAndSettle();

    expect(CartManager.instance.items.first.color, 'Black');
  });

  testWidgets('Quantity cannot go below 1 and delete removes item',
      (tester) async {
    final product = ProductItem(
      id: 'q1',
      name: 'QtyTest',
      description: 'd',
      price: 6.0,
      discount: 0.0,
      image: 'https://example.com/q.png',
      category: 'cat',
    );

    final item = CartItem(product: product, quantity: 1);
    CartManager.instance.addItem(item);

    await tester.pumpWidget(const MaterialApp(home: CartScreen()));
    await tester.pumpAndSettle();

    final remove = find.byIcon(Icons.remove);
    expect(remove, findsWidgets);
    await tester.tap(remove.first);
    await tester.pumpAndSettle();

    // quantity should remain at least 1
    expect(CartManager.instance.items.first.quantity, 1);

    // Now delete
    final del = find.byIcon(Icons.delete_outline);
    await tester.tap(del.first);
    await tester.pumpAndSettle();

    expect(CartManager.instance.items.isEmpty, isTrue);
  });

  testWidgets('Checkout cancel does not clear cart', (tester) async {
    final product = ProductItem(
      id: 'ck',
      name: 'Checkout',
      description: 'd',
      price: 9.0,
      discount: 0.0,
      image: 'https://example.com/ck.png',
      category: 'cat',
    );

    final item = CartItem(product: product, quantity: 1);
    CartManager.instance.addItem(item);

    await tester.pumpWidget(const MaterialApp(home: CartScreen()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('CHECKOUT'));
    await tester.pumpAndSettle();

    // Cancel
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(CartManager.instance.items.isNotEmpty, isTrue);
  });
}

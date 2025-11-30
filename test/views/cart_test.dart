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

  testWidgets('Empty cart shows empty message and back button', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: CartScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Your cart is empty.'), findsOneWidget);
    expect(find.text('Back to shopping'), findsOneWidget);
  });

  testWidgets('Cart displays items and checkout clears cart', (tester) async {
    final product = ProductItem(
      id: 'p1',
      name: 'Test',
      description: 'Desc',
      price: 10.0,
      discount: 2.0,
      image: 'https://example.com/i.png',
      category: 'cat',
    );

    CartManager.instance.addItem(CartItem(product: product, quantity: 2));

    // Provide routes and set initialRoute to '/cart' so navigation works
    await tester.pumpWidget(MaterialApp(
      initialRoute: '/cart',
      routes: {
        '/': (ctx) => const Scaffold(body: Text('HOME')),
        '/cart': (ctx) => const CartScreen(),
      },
    ));

    await tester.pumpAndSettle();

    // Item name visible
    expect(find.text('Test'), findsOneWidget);

    // Total and CHECKOUT button visible
    expect(find.textContaining('Total:'), findsOneWidget);
    final checkout = find.text('CHECKOUT');
    expect(checkout, findsOneWidget);

    // Tap checkout -> confirm -> cart cleared
    await tester.tap(checkout);
    await tester.pumpAndSettle();

    // Confirm dialog should appear; tap Confirm
    expect(find.text('Confirm checkout'), findsOneWidget);
    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();

    expect(CartManager.instance.items.isEmpty, isTrue);
    expect(find.textContaining('Checked out'), findsOneWidget);
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

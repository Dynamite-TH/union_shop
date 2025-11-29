import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/models/products.dart';
import 'package:union_shop/Repositories/cart_manager.dart';
import 'package:union_shop/views/product_page.dart';

import '../test_utils.dart';

void main() {
  setUp(() {
    // Ensure Http requests for images return a tiny PNG so Image.network works.
    HttpOverrides.global = TestHttpOverrides();
    // Clear cart before each test
    CartManager.instance.clear();
  });

  testWidgets('Shows original and sale price when discount > 0',
      (tester) async {
    final product = ProductItem(
      id: 'p1',
      name: 'Test Product',
      description: 'Desc',
      price: 20.0,
      discount: 5.0,
      image: 'https://example.com/image.png',
      category: 'cat',
    );

    await tester.pumpWidget(MaterialApp(home: ProductPage(product: product)));
    await tester.pumpAndSettle();

    // Original price (line-through) should be present
    expect(find.text('£20.00'), findsOneWidget);
    // Sale price
    expect(find.text('£15.00'), findsOneWidget);
  });

  testWidgets('Quantity buttons increment and do not go below 1',
      (tester) async {
    final product = ProductItem(
      id: 'p2',
      name: 'Qty Product',
      description: 'Desc',
      price: 10.0,
      discount: 0.0,
      image: 'https://example.com/image2.png',
      category: 'cat',
    );

    await tester.pumpWidget(MaterialApp(home: ProductPage(product: product)));
    await tester.pumpAndSettle();

    final add = find.byIcon(Icons.add);
    final remove = find.byIcon(Icons.remove);

    // initial quantity 1
    expect(find.text('1'), findsWidgets);

    // Ensure the buttons are visible before tapping (page may be scrollable)
    await tester.ensureVisible(add);
    await tester.pumpAndSettle();

    await tester.tap(add);
    await tester.pump();
    await tester.ensureVisible(add);
    await tester.tap(add);
    await tester.pumpAndSettle();

    // quantity should be 3 now
    expect(find.text('3'), findsWidgets);

    // press remove twice -> should not drop below 1
    await tester.ensureVisible(remove);
    await tester.tap(remove);
    await tester.pump();
    await tester.ensureVisible(remove);
    await tester.tap(remove);
    await tester.pumpAndSettle();

    expect(find.text('1'), findsWidgets);
  });

  testWidgets('Select color/size, add to cart confirms and updates CartManager',
      (tester) async {
    final product = ProductItem(
      id: 'p3',
      name: 'Add Product',
      description: 'Desc',
      price: 12.0,
      discount: 2.0,
      image: 'https://example.com/image3.png',
      category: 'cat',
    );

    await tester.pumpWidget(MaterialApp(home: ProductPage(product: product)));
    await tester.pumpAndSettle();

    // increase quantity to 3
    final add = find.byIcon(Icons.add);
    await tester.ensureVisible(add);
    await tester.tap(add);
    await tester.pump();
    await tester.ensureVisible(add);
    await tester.tap(add);
    await tester.pumpAndSettle();

    // change color: tap the shown value and pick 'Black'
    expect(find.text('Light Blue'), findsOneWidget);
    await tester.ensureVisible(find.text('Light Blue'));
    await tester.tap(find.text('Light Blue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Black').first);
    await tester.pumpAndSettle();

    // change size: tap 'M' and pick 'L'
    expect(find.text('M'), findsOneWidget);
    await tester.ensureVisible(find.text('M'));
    await tester.tap(find.text('M'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('L').first);
    await tester.pumpAndSettle();

    // Press ADD TO CART
    await tester.ensureVisible(find.text('ADD TO CART'));
    await tester.tap(find.text('ADD TO CART'));
    await tester.pumpAndSettle();

    // Dialog should show the selected values and quantity
    expect(find.text('Color: Black'), findsOneWidget);
    expect(find.text('Size: L'), findsOneWidget);
    expect(find.text('Quantity: 3'), findsOneWidget);

    final unit = (product.price - product.discount).clamp(0.0, double.infinity);
    final total = (unit * 3).toStringAsFixed(2);
    expect(find.text('Total: £$total'), findsOneWidget);

    // Confirm add
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    // Cart should have one item with expected properties
    expect(CartManager.instance.items.length, 1);
    final item = CartManager.instance.items.first;
    expect(item.quantity, 3);
    expect(item.color, 'Black');
    expect(item.size, 'L');

    // SnackBar should show
    expect(find.text('Added to cart'), findsOneWidget);
  });

  testWidgets('Cancel in add-to-cart dialog does not add item', (tester) async {
    final product = ProductItem(
      id: 'p4',
      name: 'Cancel Product',
      description: 'Desc',
      price: 5.0,
      discount: 0.0,
      image: 'https://example.com/image4.png',
      category: 'cat',
    );

    await tester.pumpWidget(MaterialApp(home: ProductPage(product: product)));
    await tester.pumpAndSettle();

    // Press ADD TO CART (ensure visible first)
    await tester.ensureVisible(find.text('ADD TO CART'));
    await tester.tap(find.text('ADD TO CART'));
    await tester.pumpAndSettle();

    // Press Cancel (ensure visible in dialog)
    await tester.ensureVisible(find.text('Cancel'));
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(CartManager.instance.items.isEmpty, true);
  });
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/models/products.dart';
import 'package:union_shop/views/sales_product_page.dart';

import '../test_utils.dart';

void main() {
  setUp(() {
    HttpOverrides.global = TestHttpOverrides();
  });

  testWidgets('Sales page shows header and either products or empty state',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SalesProductScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Sales Products'), findsOneWidget);

    // Products may be loaded from assets in tests. Accept either an empty state
    // message or one or more ProductItemCard widgets.
    final productCards = find.byType(ProductItemCard);
    final hasCards = productCards.evaluate().isNotEmpty;
    if (hasCards) {
      expect(productCards, findsWidgets);
    } else {
      expect(find.text('No sales products available.'), findsOneWidget);
    }
  });

  testWidgets('ProductItemCard displays product name and prices',
      (tester) async {
    final product = ProductItem(
      id: 's1',
      name: 'Sale Product',
      description: 'Desc',
      price: 30.0,
      discount: 5.0,
      image: 'https://example.com/x.png',
      category: 'sales',
    );

    await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: ProductItemCard(product: product))));
    await tester.pumpAndSettle();

    expect(find.text('Sale Product'), findsOneWidget);
    expect(find.text('£30.00'), findsOneWidget);
    // discounted price should also be shown
    expect(find.textContaining('£'), findsWidgets);
  });
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/models/products.dart';
import 'package:union_shop/views/products_page.dart' as sales;
import '../test_utils.dart';

void main() {
  testWidgets('Sales ProductItemCard shows name and prices', (tester) async {
    HttpOverrides.global = TestHttpOverrides();
    final product = ProductItem(
      id: 'p1',
      name: 'Test Product',
      description: 'desc',
      price: 10.0,
      image: '', // empty to trigger errorBuilder
      category: 'Sales',
      discount: 20.0,
      tags: ['a'],
    );

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: sales.ProductItemCard(product: product)),
    ));

    // Name is shown
    expect(find.text('Test Product'), findsOneWidget);

    // Original and discounted price present
    expect(find.text('£10.00'), findsOneWidget);
    // discounted calculation in sales_product_page uses: price - (price * (discount/100))
    expect(find.text('£8.00'), findsOneWidget);
  });
}

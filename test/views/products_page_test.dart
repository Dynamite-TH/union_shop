import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/views/products_page.dart';
import 'package:union_shop/models/collections.dart';
import 'package:union_shop/views/widgets/common_widgets.dart';

import '../test_utils.dart';

void main() {
  setUp(() {
    HttpOverrides.global = TestHttpOverrides();
  });

  testWidgets('ProductsScreen shows product cards for known filter',
      (tester) async {
    final collections = CollectionsItem(
        id: 'c1', name: 'Sales', description: 'Test collection');

    await tester.pumpWidget(MaterialApp(
        home: ProductsScreen(filter: 'sales', collections: collections)));

    // wait for async product loading
    await tester.pumpAndSettle();

    // Expect at least one ProductItemCard rendered for sales
    expect(find.byType(ProductItemCard), findsWidgets);
    // Spot-check a product name from assets
    expect(find.textContaining('Union Tee'), findsWidgets);
  });
}

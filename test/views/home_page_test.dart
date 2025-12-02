import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/views/home_page.dart';
import 'package:union_shop/Repositories/cart_manager.dart';
import 'package:union_shop/views/widgets/common_widgets.dart';
import 'package:union_shop/models/products.dart';
import 'package:union_shop/views/product_page.dart';

import '../test_utils.dart';

class _TestObserver extends NavigatorObserver {
  final List<Route<dynamic>> pushed = [];
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pushed.add(route);
    super.didPush(route, previousRoute);
  }
}

void main() {
  setUp(() {
    HttpOverrides.global = TestHttpOverrides();
  });
  group('Home Page Tests', () {
    setUp(() {
      // Ensure cart is empty before each test
      CartManager.instance.clear();
    });
    setUpAll(() {
      HttpOverrides.global = TestHttpOverrides();
    });
    testWidgets('should display home page with basic elements', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      // wait for async product/collection loading
      await tester.pumpAndSettle();
      // Check that basic UI elements are present
      expect(find.text('Free UK delivery on orders over £30'), findsOneWidget);
      // Updated app shows 'Sales' hero header and section titles
      expect(find.text('Sales'), findsOneWidget);
      expect(find.text('UNIVERSITY ESSENTIALS'), findsOneWidget);
      expect(find.text('BROWSE PRODUCTS'), findsOneWidget);
    });

    testWidgets('should display product cards', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pumpAndSettle();
      // Home screen shows section header for promotional products
      expect(find.text('UNIVERSITY ESSENTIALS'), findsOneWidget);
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

    testWidgets('BROWSE PRODUCTS button navigates to /collections',
        (tester) async {
      final observer = _TestObserver();

      await tester.pumpWidget(MediaQuery(
        data: const MediaQueryData(size: Size(800, 1200)),
        child: MaterialApp(
          navigatorObservers: [observer],
          routes: {
            '/collections/sales': (ctx) => const Scaffold(body: Text('SALES')),
          },
          home: const HomeScreen(),
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.text('BROWSE PRODUCTS'), findsOneWidget);

      await tester.tap(find.text('BROWSE PRODUCTS'));
      await tester.pumpAndSettle();

      expect(observer.pushed.isNotEmpty, true);
      expect(observer.pushed.last.settings.name, '/collections/sales');
    });

    testWidgets('GridView uses 1 column on small width and 2 on wide width',
        (tester) async {
      // small width
      await tester.pumpWidget(const MediaQuery(
        data: MediaQueryData(size: Size(360, 800)),
        child: MaterialApp(home: HomeScreen()),
      ));
      await tester.pumpAndSettle();

      // There may be multiple GridViews on the page (promotional and accessories)
      // Pick the first one to inspect.
      final gvSmall = tester.widgetList<GridView>(find.byType(GridView)).first;
      final delegateSmall = gvSmall.gridDelegate;
      expect(delegateSmall, isA<SliverGridDelegateWithFixedCrossAxisCount>());
      final crossSmall =
          (delegateSmall as SliverGridDelegateWithFixedCrossAxisCount)
              .crossAxisCount;
      expect(crossSmall, 1);

      // wide width
      await tester.pumpWidget(const MediaQuery(
        data: MediaQueryData(size: Size(900, 1200)),
        child: MaterialApp(home: HomeScreen()),
      ));
      await tester.pumpAndSettle();

      final gvWide = tester.widgetList<GridView>(find.byType(GridView)).first;
      final delegateWide =
          gvWide.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegateWide.crossAxisCount, 2);
    });

    testWidgets('ProductItemCard tap navigates to provided route',
        (tester) async {
      // Create a small sample product
      final sample = ProductItem(
          id: '1',
          name: 'Sample Product',
          description: 'desc',
          price: 9.99,
          image: 'https://example.com/sample.png',
          category: 'sales',
          discount: 0.0,
          colors: ['Black'],
          tags: []);

      final observer = _TestObserver();

      await tester.pumpWidget(MaterialApp(
        navigatorObservers: [observer],
        routes: {
          '/collections/sample-product/sample-product': (ctx) =>
              const Scaffold(body: Text('PRODUCT')),
        },
        home: Scaffold(
          body: Center(
            child: ProductItemCard(
              product: sample,
              route: '/collections/sample-product/',
              colours: sample.colors,
            ),
          ),
        ),
      ));

      await tester.pumpAndSettle();

      // Tap the image (the GestureDetector wraps the image)
      final gd = find.byType(GestureDetector);
      expect(gd, findsOneWidget);
      await tester.tap(gd);
      await tester.pumpAndSettle();

      expect(observer.pushed.isNotEmpty, true);
      expect(observer.pushed.last.settings.name,
          '/collections/sample-product/sample-product');
    });
  });
}

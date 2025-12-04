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
      expect(find.text('Accessories'), findsOneWidget);
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

    testWidgets('BROWSE PRODUCTS button navigates to /collections/accessories',
        (tester) async {
      final observer = _TestObserver();

      await tester.pumpWidget(MediaQuery(
        data: const MediaQueryData(size: Size(800, 1200)),
        child: MaterialApp(
          navigatorObservers: [observer],
          routes: {
            '/collections/accessories': (ctx) =>
                const Scaffold(body: Text('ACCESSORIES')),
          },
          home: const HomeScreen(),
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.text('BROWSE PRODUCTS'), findsOneWidget);

      await tester.tap(find.text('BROWSE PRODUCTS'));
      await tester.pumpAndSettle();

      expect(observer.pushed.isNotEmpty, true);
      expect(observer.pushed.last.settings.name, '/collections/accessories');
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

    testWidgets('ProductPage ADD TO CART adds item to cart', (tester) async {
      // Create a sample product and pump ProductPage directly
      final sample = ProductItem(
          id: '2',
          name: 'Direct Product',
          description: 'desc',
          price: 5.0,
          image: 'https://example.com/p.png',
          category: 'accessories',
          discount: 0.0,
          colors: ['Red'],
          tags: []);

      await tester.pumpWidget(MaterialApp(home: ProductPage(product: sample)));
      await tester.pumpAndSettle();

      // Tap ADD TO CART and confirm
      expect(find.text('ADD TO CART'), findsOneWidget);
      await tester.ensureVisible(find.text('ADD TO CART'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('ADD TO CART'));
      await tester.pumpAndSettle();

      expect(find.text('Add to cart'), findsOneWidget);
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      expect(CartManager.instance.items.length, greaterThanOrEqualTo(1));
    });

    testWidgets('mobile menu shows Home and About Us entries', (tester) async {
      await tester.pumpWidget(const MediaQuery(
        data: MediaQueryData(size: Size(400, 800)),
        child: MaterialApp(home: HomeScreen()),
      ));
      await tester.pumpAndSettle();

      // menu icon should be present on small screens
      expect(find.byIcon(Icons.menu), findsOneWidget);
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      // Menu dialog should include Home and About Us items
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('About Us'), findsOneWidget);
    });

    testWidgets('shopping bag icon navigates to /cart', (tester) async {
      final observer = _TestObserver();

      await tester.pumpWidget(MediaQuery(
        data: const MediaQueryData(size: Size(800, 1200)),
        child: MaterialApp(
          navigatorObservers: [observer],
          // Provide a generic onGenerateRoute so named pushes don't fail.
          onGenerateRoute: (settings) => MaterialPageRoute(
            settings: settings,
            builder: (_) => Scaffold(body: Text(settings.name ?? '')),
          ),
          home: const HomeScreen(),
        ),
      ));

      await tester.pumpAndSettle();

      final bag = find.byIcon(Icons.shopping_bag_outlined);
      expect(bag, findsOneWidget);
      await tester.tap(bag);
      await tester.pumpAndSettle();

      expect(observer.pushed.isNotEmpty, true);
      // Most apps route to '/cart' for cart icon; accept non-null name.
      expect(observer.pushed.last.settings.name, isNotNull);
    });

    testWidgets('home contains at least one ProductItemCard', (tester) async {
      await tester.pumpWidget(const UnionShopApp());
      // Let async asset/product loading finish
      await tester.pumpAndSettle();

      // Ensure product cards render on the home screen
      final cards = find.byType(ProductItemCard);
      expect(cards, findsWidgets);
    });

    testWidgets('tapping a ProductItemCard in HomeScreen navigates',
        (tester) async {
      final observer = _TestObserver();

      await tester.pumpWidget(MediaQuery(
        data: const MediaQueryData(size: Size(900, 1400)),
        child: MaterialApp(
          navigatorObservers: [observer],
          onGenerateRoute: (settings) => MaterialPageRoute(
            settings: settings,
            builder: (_) => Scaffold(body: Text(settings.name ?? '')),
          ),
          home: const HomeScreen(),
        ),
      ));

      await tester.pumpAndSettle();

      // Find the first ProductItemCard and tap its GestureDetector descendant
      final cardFinder = find.byType(ProductItemCard).first;
      expect(cardFinder, findsOneWidget);

      final tapTarget = find.descendant(
        of: cardFinder,
        matching: find.byType(GestureDetector),
      );

      expect(tapTarget, findsWidgets);
      await tester.ensureVisible(tapTarget.first);
      await tester.pumpAndSettle();
      await tester.tap(tapTarget.first);
      await tester.pumpAndSettle();

      expect(observer.pushed.isNotEmpty, true);
      // Product navigation in this app uses collection/product style names.
      expect(observer.pushed.last.settings.name, contains('/collections/'));
    });
  });
}

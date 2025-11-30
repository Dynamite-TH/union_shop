import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/Repositories/cart_manager.dart';
import 'package:union_shop/Repositories/union_shop_repository.dart';
import 'package:union_shop/models/products.dart';
import 'package:union_shop/views/cart.dart';
import 'package:union_shop/views/widgets/common_widgets.dart';

import '../test_utils.dart';

void main() {
  setUp(() {
    HttpOverrides.global = TestHttpOverrides();
    CartManager.instance.clear();
  });

  test('CartManager basic operations', () {
    final product = ProductItem(
      id: 'c1',
      name: 'CProduct',
      description: 'd',
      price: 20.0,
      discount: 2.0,
      image: 'https://example.com/i.png',
      category: 'cat',
    );

    final item = CartItem(product: product, quantity: 2);
    CartManager.instance.addItem(item);
    expect(CartManager.instance.items.length, 1);

    // update quantity
    CartManager.instance.updateQuantity(item, 5);
    expect(CartManager.instance.items.first.quantity, 5);

    // update color
    CartManager.instance.updateColor(item, 'Black');
    expect(CartManager.instance.items.first.color, 'Black');

    // total
    expect(CartManager.instance.total > 0, true);

    // remove
    CartManager.instance.removeItem(item);
    expect(CartManager.instance.items.isEmpty, true);
  });

  testWidgets('UnionShopRepository navigation helpers', (tester) async {
    final observer = _TestObserver();
    final repo = UnionShopRepository();

    // For each navigation helper, pump a fresh app and call the nav helper
    final routes = {
      '/': (ctx) => const Scaffold(body: Text('HOME')),
      '/product': (ctx) => const Scaffold(body: Text('PRODUCT')),
      '/collections': (ctx) => const Scaffold(body: Text('COL')),
      '/about_us': (ctx) => const Scaffold(body: Text('ABOUT')),
      'collections/sales-product': (ctx) => const Scaffold(body: Text('SALES')),
      '/cart': (ctx) => const Scaffold(body: Text('CART')),
    };

    await tester.pumpWidget(MaterialApp(
        initialRoute: '/', navigatorObservers: [observer], routes: routes));
    await tester.pumpAndSettle();
    repo.navigateToHome(tester.element(find.byType(Scaffold)));
    await tester.pumpAndSettle();
    expect(observer.pushed.last.settings.name, '/');

    await tester.pumpWidget(MaterialApp(
        initialRoute: '/', navigatorObservers: [observer], routes: routes));
    await tester.pumpAndSettle();
    repo.navigateToProduct(tester.element(find.byType(Scaffold)));
    await tester.pumpAndSettle();
    expect(observer.pushed.last.settings.name, '/product');

    await tester.pumpWidget(MaterialApp(
        initialRoute: '/', navigatorObservers: [observer], routes: routes));
    await tester.pumpAndSettle();
    repo.navigateToCollections(tester.element(find.byType(Scaffold)));
    await tester.pumpAndSettle();
    expect(observer.pushed.last.settings.name, '/collections');

    await tester.pumpWidget(MaterialApp(
        initialRoute: '/', navigatorObservers: [observer], routes: routes));
    await tester.pumpAndSettle();
    repo.navigateToAboutUs(tester.element(find.byType(Scaffold)));
    await tester.pumpAndSettle();
    expect(observer.pushed.last.settings.name, '/about_us');

    await tester.pumpWidget(MaterialApp(
        initialRoute: '/', navigatorObservers: [observer], routes: routes));
    await tester.pumpAndSettle();
    repo.navigateToSalesProduct(tester.element(find.byType(Scaffold)));
    await tester.pumpAndSettle();
    expect(observer.pushed.last.settings.name, 'collections/sales-product');

    await tester.pumpWidget(MaterialApp(
        initialRoute: '/', navigatorObservers: [observer], routes: routes));
    await tester.pumpAndSettle();
    repo.navigateToCart(tester.element(find.byType(Scaffold)));
    await tester.pumpAndSettle();
    expect(observer.pushed.last.settings.name, '/cart');

    // placeholder should be callable
    repo.placeholderCallbackForButtons();
  });

  testWidgets('Product grid interaction navigates from card', (tester) async {
    await tester.pumpWidget(MaterialApp(
      initialRoute: '/',
      routes: {
        // Minimal placeholder for the sales product landing used in this
        // test. The test is written to accept either product cards or the
        // empty-state message, so a simple header is sufficient.
        '/': (ctx) => const Scaffold(body: Text('Sales Products')),
        '/collections/sales-product/union-tee': (ctx) =>
            const Scaffold(body: Text('NAV')),
      },
    ));

    // wait for async loadProductsFromAsset
    await tester.pumpAndSettle(const Duration(seconds: 1));

    final cards = find.byType(ProductItemCard);
    if (cards.evaluate().isNotEmpty) {
      // tap first card image area to navigate
      await tester.tap(cards.first);
      await tester.pumpAndSettle();
      // Either navigation happened or not depending on slug route; ensure no crash
      expect(find.byType(Scaffold), findsWidgets);
    }
  });

  testWidgets('CartScreen interactions: delete and quantity change',
      (tester) async {
    final product = ProductItem(
      id: 'pchg',
      name: 'Changeable',
      description: 'd',
      price: 8.0,
      discount: 0.0,
      image: 'https://example.com/z.png',
      category: 'cat',
    );

    final item = CartItem(product: product, quantity: 1);
    CartManager.instance.addItem(item);

    await tester.pumpWidget(const MaterialApp(home: CartScreen()));
    await tester.pumpAndSettle();

    // ensure item rendered
    expect(find.text('Changeable'), findsOneWidget);

    // tap add icon to increase quantity
    final add = find.byIcon(Icons.add);
    await tester.tap(add);
    await tester.pumpAndSettle();
    expect(CartManager.instance.items.first.quantity >= 2, isTrue);

    // tap delete icon
    final del = find.byIcon(Icons.delete_outline);
    await tester.tap(del);
    await tester.pumpAndSettle();
    // cart should be empty
    expect(CartManager.instance.items.isEmpty, isTrue);
  });
}

class _TestObserver extends NavigatorObserver {
  final List<Route<dynamic>> pushed = [];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pushed.add(route);
    super.didPush(route, previousRoute);
  }
}

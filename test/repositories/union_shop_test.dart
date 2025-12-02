import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/Repositories/union_shop_repository.dart';
import '../test_utils.dart';
import 'package:union_shop/Repositories/cart_manager.dart';

void main() {
  setUp(() {
    HttpOverrides.global = TestHttpOverrides();
    CartManager.instance.clear();
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
      '/authentication': (ctx) => const Scaffold(body: Text('AUTH')),
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

    await tester.pumpWidget(MaterialApp(
        initialRoute: '/', navigatorObservers: [observer], routes: routes));
    await tester.pumpAndSettle();
    repo.navigateToAuthentication(tester.element(find.byType(Scaffold)));
    await tester.pumpAndSettle();
    expect(observer.pushed.last.settings.name, '/authentication');

    // placeholder should be callable
    repo.placeholderCallbackForButtons();
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

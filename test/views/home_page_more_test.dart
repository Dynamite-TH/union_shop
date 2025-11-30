import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/views/home_page.dart';

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

  testWidgets('BROWSE PRODUCTS button navigates to /collections',
      (tester) async {
    final observer = _TestObserver();

    await tester.pumpWidget(MediaQuery(
      data: const MediaQueryData(size: Size(800, 1200)),
      child: MaterialApp(
        navigatorObservers: [observer],
        routes: {
          '/collections': (ctx) => const Scaffold(body: Text('COL')),
        },
        home: const HomeScreen(),
      ),
    ));

    await tester.pumpAndSettle();

    expect(find.text('BROWSE PRODUCTS'), findsOneWidget);

    await tester.tap(find.text('BROWSE PRODUCTS'));
    await tester.pumpAndSettle();

    expect(observer.pushed.isNotEmpty, true);
    expect(observer.pushed.last.settings.name, '/collections');
  });

  testWidgets('GridView uses 1 column on small width and 2 on wide width',
      (tester) async {
    // small width
    await tester.pumpWidget(MediaQuery(
      data: const MediaQueryData(size: Size(360, 800)),
      child: const MaterialApp(home: HomeScreen()),
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
    await tester.pumpWidget(MediaQuery(
      data: const MediaQueryData(size: Size(900, 1200)),
      child: const MaterialApp(home: HomeScreen()),
    ));
    await tester.pumpAndSettle();

    final gvWide = tester.widgetList<GridView>(find.byType(GridView)).first;
    final delegateWide =
        gvWide.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
    expect(delegateWide.crossAxisCount, 2);
  });
}

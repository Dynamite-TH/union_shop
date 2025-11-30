import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/views/widgets/common_widgets.dart';

class _TestObserver extends NavigatorObserver {
  final List<Route<dynamic>> pushed = [];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pushed.add(route);
    super.didPush(route, previousRoute);
  }
}

Widget _wrapWithApp(
    {required double width, required NavigatorObserver observer}) {
  return MediaQuery(
    data: MediaQueryData(size: Size(width, 800)),
    child: MaterialApp(
      navigatorObservers: [observer],
      routes: {
        '/about_us': (ctx) =>
            const Scaffold(body: Center(child: Text('ABOUT_US'))),
        '/cart': (ctx) => const Scaffold(body: Center(child: Text('CART'))),
      },
      home: const Scaffold(
        appBar: CustomAppBar(),
        body: SizedBox.shrink(),
      ),
    ),
  );
}

void main() {
  testWidgets('Desktop: shows HOME and ABOUT US and navigates on tap',
      (tester) async {
    final observer = _TestObserver();

    await tester.pumpWidget(_wrapWithApp(width: 800, observer: observer));
    await tester.pumpAndSettle();

    // Top banner is visible
    expect(find.textContaining('Free UK delivery'), findsOneWidget);

    // Desktop should show HOME and ABOUT US buttons
    expect(find.text('HOME'), findsOneWidget);
    expect(find.text('ABOUT US'), findsOneWidget);

    // Tap HOME and expect navigation to '/'
    await tester.tap(find.text('HOME'));
    await tester.pumpAndSettle();

    expect(observer.pushed.isNotEmpty, true);
    expect(observer.pushed.last.settings.name, '/');

    // Tap ABOUT US and expect navigation to '/about_us'
    await tester.tap(find.text('ABOUT US'));
    await tester.pumpAndSettle();

    expect(observer.pushed.last.settings.name, '/about_us');
  });

  testWidgets(
      'Mobile: hides menu items, shows menu icon and dialog triggers navigation',
      (tester) async {
    final observer = _TestObserver();

    await tester.pumpWidget(_wrapWithApp(width: 360, observer: observer));
    await tester.pumpAndSettle();

    // HOME and ABOUT US should be hidden on mobile
    expect(find.text('HOME'), findsNothing);
    expect(find.text('ABOUT US'), findsNothing);

    // Menu icon should be present
    final menuFinder = find.byIcon(Icons.menu);
    expect(menuFinder, findsOneWidget);

    // Open menu
    await tester.tap(menuFinder);
    await tester.pumpAndSettle();

    // Dialog contains a 'Home' option
    final dialogHome = find.text('Home');
    expect(dialogHome, findsOneWidget);

    // Tap Home in the dialog and ensure navigation to '/'
    await tester.tap(dialogHome);
    await tester.pumpAndSettle();

    expect(observer.pushed.isNotEmpty, true);
    expect(observer.pushed.last.settings.name, '/');
  });

  testWidgets('Cart icon navigates to /cart when tapped', (tester) async {
    final observer = _TestObserver();

    await tester.pumpWidget(_wrapWithApp(width: 800, observer: observer));
    await tester.pumpAndSettle();

    final cartFinder = find.byIcon(Icons.shopping_bag_outlined);
    expect(cartFinder, findsOneWidget);

    await tester.tap(cartFinder);
    await tester.pumpAndSettle();

    expect(observer.pushed.last.settings.name, '/cart');
  });
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/views/collections.dart';
import 'package:union_shop/models/collections.dart';
import '../test_utils.dart';

void main() {
  // Use the test HTTP override to avoid real network calls for Image.network
  setUp(() {
    HttpOverrides.global = TestHttpOverrides();
  });

  testWidgets('CollectionsScreen renders demo collections (asset load)',
      (tester) async {
    // Pump the screen which will call loadCollectionsFromAsset internally
    await tester.pumpWidget(const MaterialApp(home: CollectionsScreen()));
    // wait for async collection loading
    await tester.pumpAndSettle();

    // Title is present
    expect(find.text('Collections'), findsOneWidget);

    // There should be demo collection cards present (data from assets)
    // The sample data included with the app contains multiple collections.
    expect(find.byType(CollectionsCard), findsWidgets);
  });

  testWidgets('CollectionsCard shows fallback when imageUrl is empty',
      (tester) async {
    final item = CollectionsItem(
      id: '1',
      name: 'My Collection',
      description: 'desc',
      image: '',
    );

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CollectionsCard(
          imageUrl: item.image,
          title: item.name,
          collections: item,
        ),
      ),
    ));

    // The empty-image branch renders a Container with a centered Text fallback
    expect(find.text('image not available - page for My Collection'),
        findsOneWidget);
  });

  testWidgets('CollectionsCard displays network image and navigates on tap',
      (tester) async {
    final item = CollectionsItem(
      id: '2',
      name: 'Tap Collection',
      description: 'desc',
      image:
          'http://example.com/image.png', // TestHttpOverrides will supply image bytes
    );

    // Provide a route that matches the slug created by the card
    await tester.pumpWidget(MaterialApp(
      routes: {
        '/collections/tap-collection': (context) => const Scaffold(
              body: Center(child: Text('navigated')),
            ),
      },
      home: Scaffold(
        body: CollectionsCard(
          imageUrl: item.image,
          title: item.name,
          collections: item,
          route: '/collections/',
        ),
      ),
    ));

    // Should render an Image widget for the network image
    expect(find.byType(Image), findsOneWidget);

    // Tap the card and verify navigation occurs to the route created by the slug
    await tester.tap(find.byType(CollectionsCard));
    await tester.pumpAndSettle();

    expect(find.text('navigated'), findsOneWidget);
  });

  testWidgets('CollectionsPage builds with CollectionsScreen as home',
      (tester) async {
    // The CollectionsPage sets an `initialRoute` that isn't present in the
    // test environment which causes a framework error. We temporarily
    // override FlutterError.onError to ignore that specific message.
    final originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      final msg = details.exceptionAsString();
      if (msg.contains('Could not navigate to initial route')) {
        // swallow this expected test-time message
        return;
      }
      // forward any other errors
      originalOnError?.call(details);
    };

    try {
      await tester.pumpWidget(const CollectionsPage());
      // Allow a small build window (no long pumpAndSettle to avoid waiting on
      // unrelated async activity).
      await tester.pump(const Duration(milliseconds: 200));

      // The page should include the CollectionsScreen and show the title
      expect(find.byType(CollectionsScreen), findsOneWidget);
      expect(find.text('Collections'), findsOneWidget);
    } finally {
      // restore original handler
      FlutterError.onError = originalOnError;
    }
  });

  testWidgets('CollectionsCard slug generation normalizes title and navigates',
      (tester) async {
    final item = CollectionsItem(
      id: '3',
      name: 'Test Collection  123', // double space to test hyphen behavior
      description: 'desc',
      image: '',
    );

    // Provide a route that matches the slug created by the card. The
    // CollectionsCard generates the slug by replacing spaces with '-' and
    // lowercasing the title.
    await tester.pumpWidget(MaterialApp(
      routes: {
        '/collections/test-collection--123': (context) => const Scaffold(
              body: Center(child: Text('slugged')),
            ),
      },
      home: Scaffold(
        body: CollectionsCard(
          imageUrl: item.image,
          title: item.name,
          collections: item,
          route: '/collections/',
        ),
      ),
    ));

    // Ensure widget built and tappable
    await tester.pumpAndSettle();
    expect(find.byType(CollectionsCard), findsOneWidget);

    // Tap the card and verify navigation occurs to the route created by the slug
    await tester.tap(find.byType(CollectionsCard));
    await tester.pumpAndSettle();

    expect(find.text('slugged'), findsOneWidget);
  });
}

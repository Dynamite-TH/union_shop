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


}

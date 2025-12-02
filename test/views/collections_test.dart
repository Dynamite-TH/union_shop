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
}

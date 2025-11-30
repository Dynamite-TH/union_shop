import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/views/collections.dart';
import '../test_utils.dart';

void main() {
  testWidgets('CollectionsScreen renders demo collections', (tester) async {
    HttpOverrides.global = TestHttpOverrides();
    await tester.pumpWidget(const MaterialApp(home: CollectionsScreen()));
    // wait for async collection loading
    await tester.pumpAndSettle();

    // Title is present
    expect(find.text('Collections'), findsOneWidget);

    // There should be the demo collection cards present
    // We can assert by finding the CollectionsCard type instances
    expect(find.byType(CollectionsCard), findsNWidgets(5));

  // Some demo collections may have no image and show a fallback text — accept either case
  // (we don't require a fallback message to be present in every environment).
  });
}

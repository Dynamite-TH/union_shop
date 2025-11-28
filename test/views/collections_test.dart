import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/views/collections.dart';

void main() {
  testWidgets('CollectionsScreen renders demo collections', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: CollectionsScreen()));

    // Title is present
    expect(find.text('Collections'), findsOneWidget);

    // There should be the demo collection cards present
    // We can assert by finding the CollectionsCard type instances
    expect(find.byType(CollectionsCard), findsNWidgets(5));

    // Some demo collections have no image and show a fallback text — assert at least one fallback visible
    expect(find.textContaining('page for'), findsWidgets);
  });
}

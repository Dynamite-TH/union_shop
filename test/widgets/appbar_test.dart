import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/views/widgets/appbar.dart';

void main() {
  testWidgets('CustomAppBar shows banner and icons', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(appBar: CustomAppBar()),
    ));

    // Top banner message
    expect(find.text('Free UK delivery on orders over £30'), findsOneWidget);

    // Expect core icon buttons to exist
    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.byIcon(Icons.person_outline), findsOneWidget);
    expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);
  });
}

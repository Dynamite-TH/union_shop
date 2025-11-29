import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/views/about_us.dart';

import '../test_utils.dart';

void main() {
  setUp(() {
    HttpOverrides.global = TestHttpOverrides();
  });

  testWidgets('About Us page shows heading and contact info', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: AboutUsScreen()));
    await tester.pumpAndSettle();

    expect(find.text('About Us'), findsOneWidget);
    expect(find.textContaining('Contact Email'), findsOneWidget);
    expect(find.textContaining('© 2024 Union Shop'), findsOneWidget);
  });
}

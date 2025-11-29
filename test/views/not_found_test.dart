import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/views/not_found.dart';

import '../test_utils.dart';

void main() {
  setUp(() {
    HttpOverrides.global = TestHttpOverrides();
  });

  testWidgets('Not found page shows 404 message', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: PageNotFoundScreen()));
    await tester.pumpAndSettle();

    expect(
        find.textContaining(
            '404 - The page you are looking for does not exist.'),
        findsOneWidget);
  });
}

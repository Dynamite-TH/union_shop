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

  testWidgets(
      'AppBar shows top banner and ABOUT US menu, body text and logo image',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: AboutUsScreen()));
    await tester.pumpAndSettle();

    // Top banner text from CustomAppBar
    expect(find.text('Free UK delivery on orders over £30'), findsOneWidget);

    // The menu contains an ABOUT US button on wider screens
    expect(find.text('ABOUT US'), findsWidgets);

    // The About Us body paragraph should be present
    expect(find.text('This is the About Us page.'), findsOneWidget);

    // Logo is an Image (Image.network) in the app bar
    expect(find.byType(Image), findsWidgets);
  });

  testWidgets('Footer shows phone number and policy links', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: AboutUsScreen()));
    await tester.pumpAndSettle();

    expect(find.textContaining('Phone: 123-456-7890'), findsOneWidget);
    expect(find.textContaining('Privacy Policy'), findsOneWidget);
    expect(find.textContaining('Terms of Service'), findsOneWidget);
  });

  testWidgets('about us page has correct texts', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: AboutUsScreen()));
    await tester.pumpAndSettle();

    expect(find.text('About Us'), findsOneWidget);
    expect(find.textContaining('This is the About Us page.'), findsOneWidget);
    expect(
        find.textContaining(
            'Here you can provide information about your company, mission, values, and team.'),
        findsOneWidget);
    expect(
        find.textContaining(
            'Feel free to customize this section to best represent your brand and connect with your audience.'),
        findsOneWidget);
  });
}

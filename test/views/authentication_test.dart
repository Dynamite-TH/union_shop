import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/views/authentication.dart';

void main() {
  Future<void> pumpAuthWidget(WidgetTester tester) async {
    // Pump the AuthenticationScreen directly as the MaterialApp home. Do not
    // wrap it with another Scaffold to avoid nested scaffold/hit-test issues.
    await tester.pumpWidget(
      const MaterialApp(
        home: AuthenticationScreen(),
      ),
    );
    // Allow initial frames and animations to settle
    await tester.pumpAndSettle();
  }

  testWidgets('shows validation errors when fields are empty', (tester) async {
    await pumpAuthWidget(tester);

    // Tap the Submit button
    final submitFinder = find.widgetWithText(ElevatedButton, 'Submit');
    expect(submitFinder, findsOneWidget);
    await tester.tap(submitFinder);
    await tester.pumpAndSettle();

    expect(find.text('Please enter a username'), findsOneWidget);
    expect(find.text('Please enter an email'), findsOneWidget);
    expect(find.text('Please enter a password'), findsOneWidget);
  });
}

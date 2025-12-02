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

  testWidgets('username consisting of spaces is treated as empty',
      (tester) async {
    await pumpAuthWidget(tester);

    final usernameField = find.byType(TextFormField).at(0);
    await tester.enterText(usernameField, '   ');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Submit'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter a username'), findsOneWidget);
  });

  testWidgets('invalid email shows proper validation error', (tester) async {
    await pumpAuthWidget(tester);

    await tester.enterText(find.byType(TextFormField).at(0), 'user');
    await tester.enterText(find.byType(TextFormField).at(1), 'bad@');
    await tester.enterText(find.byType(TextFormField).at(2), 'password123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Submit'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter a valid email address'), findsOneWidget);
  });

  testWidgets('password too short shows validation error', (tester) async {
    await pumpAuthWidget(tester);

    await tester.enterText(find.byType(TextFormField).at(0), 'user');
    await tester.enterText(
        find.byType(TextFormField).at(1), 'test@example.com');
    await tester.enterText(find.byType(TextFormField).at(2), '123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Submit'));
    await tester.pumpAndSettle();

    expect(find.text('Password must be at least 6 characters'), findsOneWidget);
  });

  testWidgets('successful submit shows snackbar and clears password',
      (tester) async {
    await pumpAuthWidget(tester);

    final username = 'alice';
    final email = 'alice@example.com';
    const password = 'securePass';

    // Enter valid input
    await tester.enterText(find.byType(TextFormField).at(0), username);
    await tester.enterText(find.byType(TextFormField).at(1), email);
    await tester.enterText(find.byType(TextFormField).at(2), password);

    // Submit
    await tester.tap(find.widgetWithText(ElevatedButton, 'Submit'));
    await tester.pumpAndSettle();

    // SnackBar shows submitted data (username and email only)
    expect(find.text('Submitted: username="$username", email="$email"'),
        findsOneWidget);

    // Verify password controller was cleared by inspecting the password TextFormField widget
    final passwordFieldWidget =
        tester.widget<TextFormField>(find.byType(TextFormField).at(2));
    expect(passwordFieldWidget.controller?.text, isEmpty);
  });
}

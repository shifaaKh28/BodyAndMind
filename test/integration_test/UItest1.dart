import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:swe_project/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets('Trainee Login Test - Specific Credentials', (WidgetTester tester) async {
    // Launch the app
    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();

    // Navigate to Trainee Login
    await tester.tap(find.text('Trainee'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    // Enter Email and Password
    await tester.enterText(find.byType(TextField).at(0), 'hello@gmail.com'); // Change to actual trainee email
    await tester.enterText(find.byType(TextField).at(1), 'helloworld'); // Change to actual trainee password
    await tester.pumpAndSettle();

    // Tap Login Button
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    // Debugging Step: Check if login failed
    if (find.text('Invalid credentials').evaluate().isNotEmpty) {
      fail("Login failed due to incorrect credentials.");
    }

    // Debugging Step: Print visible widgets to verify login success
    print("Widgets found after login:");
    find
        .byType(Text)
        .evaluate()
        .map((e) => (e.widget as Text).data)
        .forEach(print);

    // Allow time for navigation
    await Future.delayed(Duration(seconds: 3));
    await tester.pumpAndSettle();

    // Checking for "Dashboard"
    expect(find.text('Dashboard'), findsOneWidget);
  });
}

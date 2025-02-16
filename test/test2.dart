import 'package:flutter_test/flutter_test.dart';
import 'package:swe_project/screens/trainee/profile/body_stats.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('BMI calculation is correct', (WidgetTester tester) async {
    // Create the widget
    final bodyStatsScreen = BodyStatsScreen();

    // Insert the widget into the widget tree
    await tester.pumpWidget(MaterialApp(home: bodyStatsScreen));

    // Get the state of the widget
    final bodyStatsScreenState = tester.state<BodyStatsScreenState>(find.byType(BodyStatsScreen));

    // Set initial height and weight
    bodyStatsScreenState.height = 180;
    bodyStatsScreenState.weight = 75;

    // Calculate BMI
    bodyStatsScreenState.calculateBMI();

    // Rebuild the widget
    await tester.pump();

    // Check if the BMI is calculated correctly
    expect(bodyStatsScreenState.bmi, closeTo(23.15, 0.01));
  });
}
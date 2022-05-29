import 'package:finance_buddy/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App launches and starts on the Dashboard page', (tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp(
      initialTheme: ThemeMode.system,
      shouldShowInstructions: false,
      budgetOverflowEnabled: false,
      monthlyLimit: 0,
    ));

    // Verify that the dashboard page is displayed.
    expect(find.text('Dashboard'), findsNWidgets(2));
    expect(find.text('Transactions'), findsOneWidget);
    expect(find.text('Wealth'), findsOneWidget);
  });
}

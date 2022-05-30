import 'package:finance_buddy/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('User can utilize the bottom navigation bar', (tester) async {
    await tester.pumpWidget(const MyApp(
      initialTheme: ThemeMode.system,
      shouldShowInstructions: false,
      budgetOverflowEnabled: false,
      monthlyLimit: 0,
    ));
    // Go to the transactions page
    await tester.tap(find.byIcon(Icons.compare_arrows_rounded));
    await tester.pump();
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Transactions'), findsNWidgets(2));
    expect(find.text('Wealth'), findsOneWidget);

    // Go to the wealth page
    await tester.tap(find.byIcon(Icons.attach_money_rounded));
    await tester.pump();
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Transactions'), findsOneWidget);
    expect(find.text('Wealth'), findsNWidgets(2));

    // Go to the dashboard page
    await tester.tap(find.byIcon(Icons.bar_chart_rounded));
    await tester.pump();
    expect(find.text('Dashboard'), findsNWidgets(2));
    expect(find.text('Transactions'), findsOneWidget);
    expect(find.text('Wealth'), findsOneWidget);
  });

  testWidgets('Instructions are not shown if the boolean is set to false',
      (tester) async {
    await tester.pumpWidget(const MyApp(
      initialTheme: ThemeMode.system,
      shouldShowInstructions: false,
      budgetOverflowEnabled: false,
      monthlyLimit: 0,
    ));
    await tester.pump();
    expect(find.byKey(const Key("instructions-page-widget")), findsNothing);
    expect(find.byIcon(Icons.close), findsNothing);
  });
}

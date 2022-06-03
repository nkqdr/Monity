import 'package:monity/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('User can open the "Add Transaction" sheet', (tester) async {
    // Render app
    await tester.pumpWidget(const MyApp(
      initialTheme: ThemeMode.system,
      shouldShowInstructions: false,
      budgetOverflowEnabled: false,
      monthlyLimit: 0,
    ));
    expect(find.text('Transactions'), findsOneWidget);

    // Go to transactions page
    await tester.tap(find.byIcon(Icons.compare_arrows_rounded));
    await tester.pump();
    expect(find.byIcon(Icons.add), findsOneWidget);

    // Tap the add icon in the top right corner
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    expect(find.text('Add transaction'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsNWidgets(3));
  });
}

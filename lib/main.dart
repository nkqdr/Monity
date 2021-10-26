import 'package:finance_buddy/home.dart';
import 'package:finance_buddy/theme/custom_themes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FinanceBuddy',
      themeMode: ThemeMode.system,
      theme: CustomThemes.lightTheme,
      darkTheme: CustomThemes.darkTheme,
      home: const HomePage(),
    );
  }
}

import 'package:finance_buddy/home.dart';
import 'package:finance_buddy/theme/custom_themes.dart';
import 'package:finance_buddy/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      builder: (context, _) {
        final provider = Provider.of<ThemeProvider>(context);
        return MaterialApp(
          title: 'FinanceBuddy',
          themeMode: provider.themeMode,
          theme: CustomThemes.lightTheme,
          darkTheme: CustomThemes.darkTheme,
          home: const HomePage(),
        );
      },
    );
  }
}

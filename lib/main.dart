import 'package:finance_buddy/api/settings_api.dart';
import 'package:finance_buddy/home.dart';
import 'package:finance_buddy/theme/custom_themes.dart';
import 'package:finance_buddy/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  ThemeMode mode = await SettingsApi.getAppearance();
  runApp(MyApp(
    initialTheme: mode,
  ));
}

class MyApp extends StatelessWidget {
  final ThemeMode initialTheme;
  const MyApp({
    Key? key,
    required this.initialTheme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(
        themeMode: initialTheme,
      ),
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

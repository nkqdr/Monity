import 'package:finance_buddy/controller/settings_api.dart';
import 'package:finance_buddy/home.dart';
import 'package:finance_buddy/l10n/language_provider.dart';
import 'package:finance_buddy/theme/custom_themes.dart';
import 'package:finance_buddy/theme/theme_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  ThemeMode mode = await SettingsApi.getTheme();
  Locale? locale = await SettingsApi.getLocale();
  runApp(MyApp(
    initialTheme: mode,
    selectedLocale: locale,
  ));
}

class MyApp extends StatelessWidget {
  final ThemeMode initialTheme;
  final Locale? selectedLocale;

  const MyApp({
    Key? key,
    required this.initialTheme,
    this.selectedLocale,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LanguageProvider(
        locale: selectedLocale,
      ),
      builder: (context, _) {
        final languageProvider = Provider.of<LanguageProvider>(context);
        return ChangeNotifierProvider(
          create: (context) => ThemeProvider(
            themeMode: initialTheme,
          ),
          builder: (context, _) {
            final themeProvider = Provider.of<ThemeProvider>(context);
            return MaterialApp(
              title: 'FinanceBuddy',
              themeMode: themeProvider.themeMode,
              locale: languageProvider.locale,
              theme: CustomThemes.lightTheme,
              darkTheme: CustomThemes.darkTheme,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: const HomePage(),
            );
          },
        );
      },
    );
  }
}

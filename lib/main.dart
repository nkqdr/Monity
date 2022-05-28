import 'package:finance_buddy/backend/key_value_database.dart';
import 'package:finance_buddy/helper/config_provider.dart';
import 'package:finance_buddy/home.dart';
import 'package:finance_buddy/l10n/language_provider.dart';
import 'package:finance_buddy/theme/custom_themes.dart';
import 'package:finance_buddy/theme/theme_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  Paint.enableDithering = true;
  bool? firstStartUp = await KeyValueDatabase.getFirstStartup();
  ThemeMode mode = await KeyValueDatabase.getTheme();
  Locale? locale = await KeyValueDatabase.getLocale();
  bool? budgetOverflowEnabled =
      await KeyValueDatabase.getBudgetOverflowEnabled();
  runApp(MyApp(
    initialTheme: mode,
    selectedLocale: locale,
    shouldShowInstructions: firstStartUp ?? true,
    budgetOverflowEnabled: budgetOverflowEnabled ?? false,
  ));
}

class MyApp extends StatelessWidget {
  final ThemeMode initialTheme;
  final Locale? selectedLocale;
  final bool shouldShowInstructions;
  final bool budgetOverflowEnabled;

  const MyApp({
    Key? key,
    required this.initialTheme,
    required this.shouldShowInstructions,
    required this.budgetOverflowEnabled,
    this.selectedLocale,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => LanguageProvider(locale: selectedLocale)),
        ChangeNotifierProvider(
            create: (_) => ThemeProvider(themeMode: initialTheme)),
        ChangeNotifierProvider(
            create: (_) =>
                ConfigProvider(budgetOverflowEnabled: budgetOverflowEnabled)),
      ],
      builder: (context, _) {
        final languageProvider = Provider.of<LanguageProvider>(context);
        final themeProvider = Provider.of<ThemeProvider>(context);
        return MaterialApp(
          title: 'Monity',
          themeMode: themeProvider.themeMode,
          debugShowCheckedModeBanner: false,
          locale: languageProvider.locale,
          theme: CustomThemes.lightTheme,
          darkTheme: CustomThemes.darkTheme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          // localeListResolutionCallback: (locales, supportedLocales) {
          //   for (Locale locale in locales!) {
          //     // if device language is supported by the app,
          //     // just return it to set it as current app language
          //     if (supportedLocales.contains(locale)) {
          //       return locale;
          //     }
          //   }

          //   // if device language is not supported by the app,
          //   // the app will set it to english but return this to set to Bahasa instead
          //   return const Locale('en', 'US');
          // },
          home: HomePage(
            showInstructions: shouldShowInstructions,
          ),
        );
      },
    );
  }
}

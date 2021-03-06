import 'package:monity/l10n/language_provider.dart';
import 'package:monity/theme/theme_provider.dart';
import 'package:monity/widgets/custom_appbar.dart';
import 'package:monity/widgets/multiple_choice_select.dart';
import 'package:monity/widgets/view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppearancePage extends StatelessWidget {
  const AppearancePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeProvider _themeProvider = Provider.of<ThemeProvider>(context);
    final LanguageProvider _languageProvider = Provider.of<LanguageProvider>(context);
    var language = AppLocalizations.of(context)!;

    return View(
      appBar: CustomAppBar(
        title: language.appearance,
        left: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: Theme.of(context).primaryColor,
          ),
          splashRadius: 18,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      fixedAppBar: true,
      children: [
        MultipleChoiceSection<ThemeMode>(
          title: language.theme,
          options: [
            MultipleChoiceOption(name: language.system, value: ThemeMode.system),
            MultipleChoiceOption(name: language.lightTheme, value: ThemeMode.light),
            MultipleChoiceOption(name: language.darkTheme, value: ThemeMode.dark),
          ],
          value: _themeProvider.themeMode,
          onChanged: (value) => setThemeMode(context, value),
        ),
        MultipleChoiceSection<String?>(
          title: language.language,
          options: [
            MultipleChoiceOption(name: language.system, value: null),
            const MultipleChoiceOption(name: 'English', value: 'en'),
            const MultipleChoiceOption(name: 'Deutsch', value: 'de'),
          ],
          value: _languageProvider.locale?.toString(),
          onChanged: (value) => setLanguage(context, value),
        ),
      ],
    );
  }

  void setThemeMode(BuildContext context, ThemeMode mode) {
    final provider = Provider.of<ThemeProvider>(context, listen: false);
    provider.setThemeMode(mode);
  }

  void setLanguage(BuildContext context, String? languageCode) {
    final provider = Provider.of<LanguageProvider>(context, listen: false);
    provider.setLocale(languageCode);
  }
}

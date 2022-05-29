import 'package:finance_buddy/backend/key_value_database.dart';
import 'package:finance_buddy/l10n/language_provider.dart';
import 'package:finance_buddy/theme/theme_provider.dart';
import 'package:finance_buddy/widgets/custom_appbar.dart';
import 'package:finance_buddy/widgets/custom_section.dart';
import 'package:finance_buddy/widgets/view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppearancePage extends StatelessWidget {
  const AppearancePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeProvider _themeProvider = Provider.of<ThemeProvider>(context);
    final LanguageProvider _languageProvider =
        Provider.of<LanguageProvider>(context);
    var language = AppLocalizations.of(context)!;
    return View(
      appBar: CustomAppBar(
        title: language.appearance,
        left: IconButton(
          icon: const Icon(
            Icons.chevron_left,
          ),
          splashRadius: 18,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      fixedAppBar: true,
      children: [
        CustomSection(
          title: language.theme,
          children: [
            MultipleChoiceSetting(
              title: language.system,
              isActive: _themeProvider.themeMode == ThemeMode.system,
              onTap: () {
                setThemeMode(context, ThemeMode.system);
              },
            ),
            MultipleChoiceSetting(
              title: language.lightTheme,
              isActive: _themeProvider.themeMode == ThemeMode.light,
              onTap: () {
                setThemeMode(context, ThemeMode.light);
              },
            ),
            MultipleChoiceSetting(
              title: language.darkTheme,
              isActive: _themeProvider.themeMode == ThemeMode.dark,
              onTap: () {
                setThemeMode(context, ThemeMode.dark);
              },
            ),
          ],
        ),
        CustomSection(
          title: language.language,
          children: [
            MultipleChoiceSetting(
              title: 'System',
              isActive: _languageProvider.locale == null,
              onTap: () {
                setLanguage(context, null);
              },
            ),
            MultipleChoiceSetting(
              title: 'English',
              isActive: _languageProvider.locale == const Locale('en'),
              onTap: () {
                setLanguage(context, 'en');
              },
            ),
            MultipleChoiceSetting(
              title: 'Deutsch',
              isActive: _languageProvider.locale == const Locale('de'),
              onTap: () {
                setLanguage(context, 'de');
              },
            ),
          ],
        ),
      ],
    );
  }

  void setThemeMode(BuildContext context, ThemeMode mode) {
    final provider = Provider.of<ThemeProvider>(context, listen: false);
    KeyValueDatabase.setTheme(mode);
    provider.setThemeMode(mode);
  }

  void setLanguage(BuildContext context, String? languageCode) {
    final provider = Provider.of<LanguageProvider>(context, listen: false);
    KeyValueDatabase.setLanguage(languageCode);
    if (languageCode == null) {
      provider.setLocale(null);
      return;
    }
    provider.setLocale(Locale(languageCode));
  }
}

class MultipleChoiceSetting extends StatelessWidget {
  final String title;
  final bool isActive;
  final void Function()? onTap;
  const MultipleChoiceSetting({
    Key? key,
    required this.title,
    required this.isActive,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: Colors.grey),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: SizedBox(
                    width: 12,
                    height: 12,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isActive
                            ? Theme.of(context).colorScheme.onBackground
                            : Theme.of(context).scaffoldBackgroundColor,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

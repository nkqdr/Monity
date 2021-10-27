import 'package:finance_buddy/api/settings_api.dart';
import 'package:finance_buddy/theme/theme_provider.dart';
import 'package:finance_buddy/widgets/custom_appbar.dart';
import 'package:finance_buddy/widgets/custom_section.dart';
import 'package:finance_buddy/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AppearancePage extends StatefulWidget {
  const AppearancePage({Key? key}) : super(key: key);

  @override
  _AppearancePageState createState() => _AppearancePageState();
}

class _AppearancePageState extends State<AppearancePage> {
  @override
  Widget build(BuildContext context) {
    final ThemeProvider _themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: Theme.of(context).appBarTheme.systemOverlayStyle
            as SystemUiOverlayStyle,
        child: SafeArea(
          child: ListView(
            children: [
              CustomAppBar(
                title: 'Appearance',
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
              const SizedBox(
                height: 20,
              ),
              CustomSection(
                title: 'Theme',
                titleSize: 18,
                titlePadding: 10,
                children: [
                  ThemeModeSetting(
                    title: 'System',
                    isActive: _themeProvider.getThemeMode() == ThemeMode.system,
                    onTap: () {
                      setThemeMode(ThemeMode.system, _themeProvider);
                    },
                  ),
                  ThemeModeSetting(
                    title: 'Light',
                    isActive: _themeProvider.getThemeMode() == ThemeMode.light,
                    onTap: () {
                      setThemeMode(ThemeMode.light, _themeProvider);
                    },
                  ),
                  ThemeModeSetting(
                    title: 'Dark',
                    isActive: _themeProvider.getThemeMode() == ThemeMode.dark,
                    onTap: () {
                      setThemeMode(ThemeMode.dark, _themeProvider);
                    },
                  ),
                ],
              ),
              CustomSection(
                title: 'Language',
                titleSize: 18,
                titlePadding: 10,
                children: [
                  ThemeModeSetting(
                    title: 'English',
                    isActive: true,
                    onTap: () {},
                  ),
                  ThemeModeSetting(
                    title: 'Deutsch',
                    isActive: false,
                    onTap: () {},
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void setThemeMode(ThemeMode mode, ThemeProvider themeProvider) {
    final provider = Provider.of<ThemeProvider>(context, listen: false);
    SettingsApi.setAppearance(mode);
    provider.setThemeMode(mode);
  }
}

class ThemeModeSetting extends StatelessWidget {
  final String title;
  final bool isActive;
  final void Function()? onTap;
  const ThemeModeSetting({
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
                CustomText(
                  title,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
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

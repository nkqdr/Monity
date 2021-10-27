import 'package:finance_buddy/pages/settings/appearance_page.dart';
import 'package:finance_buddy/widgets/custom_appbar.dart';
import 'package:finance_buddy/widgets/setting_nav_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: Theme.of(context).appBarTheme.systemOverlayStyle
            as SystemUiOverlayStyle,
        child: SafeArea(
          child: ListView(
            children: [
              CustomAppBar(
                title: language.settingsTitle,
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
              SettingNavButton(
                name: language.system,
              ),
              SettingNavButton(
                name: language.appearance,
                destination: const AppearancePage(),
              ),
              SettingNavButton(
                name: language.transactionsSettings,
              ),
              SettingNavButton(
                name: language.help,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

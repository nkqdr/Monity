import 'package:finance_buddy/pages/settings/appearance_page.dart';
import 'package:finance_buddy/pages/settings/help_page.dart';
import 'package:finance_buddy/pages/settings/investments_settings_page.dart';
import 'package:finance_buddy/pages/settings/options_page.dart';
import 'package:finance_buddy/pages/settings/system_settings_page.dart';
import 'package:finance_buddy/pages/settings/transactions_settings_page.dart';
import 'package:finance_buddy/widgets/custom_appbar.dart';
import 'package:finance_buddy/widgets/custom_section.dart';
import 'package:finance_buddy/widgets/setting_nav_button.dart';
import 'package:finance_buddy/widgets/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    return View(
      appBar: CustomAppBar(
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
      fixedAppBar: true,
      children: [
        CustomSection(
          groupItems: true,
          title: language.general,
          children: [
            SettingNavButton(
              name: language.system,
              destination: const SystemSettingsPage(),
            ),
            SettingNavButton(
              name: language.options,
              destination: const OptionsPage(),
            ),
            SettingNavButton(
              name: language.appearance,
              destination: const AppearancePage(),
            ),
          ],
        ),
        CustomSection(
          groupItems: true,
          title: language.configuration,
          children: [
            SettingNavButton(
              name: language.transactionsSettings,
              destination: const TransactionsSettingsPage(),
            ),
            SettingNavButton(
              name: language.investments,
              destination: const InvestmentsSettingsPage(),
            ),
          ],
        ),
        CustomSection(
          groupItems: true,
          title: language.help,
          children: [
            SettingNavButton(
              name: language.about,
              destination: const HelpPage(),
            ),
          ],
        ),
      ],
    );
  }
}

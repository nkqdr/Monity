import 'package:monity/helper/showcase_keys_provider.dart';
import 'package:monity/pages/settings/appearance_page.dart';
import 'package:monity/pages/settings/faq_page.dart';
import 'package:monity/pages/settings/help_page.dart';
import 'package:monity/pages/settings/investments_settings_page.dart';
import 'package:monity/pages/settings/options_page.dart';
import 'package:monity/pages/settings/system_settings_page.dart';
import 'package:monity/pages/settings/transactions_settings_page.dart';
import 'package:monity/widgets/custom_appbar.dart';
import 'package:monity/widgets/custom_section.dart';
import 'package:monity/widgets/custom_showcase.dart';
import 'package:monity/widgets/setting_nav_button.dart';
import 'package:monity/widgets/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BuildContext? myContext;
    var language = AppLocalizations.of(context)!;
    var showcaseKeys = Provider.of<ShowcaseProvider>(context, listen: false);

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      showcaseKeys.startTourIfNeeded(
        myContext!,
        [showcaseKeys.generalSettingsKey, showcaseKeys.configurationSettingsKey],
        delay: const Duration(milliseconds: 200),
      );
    });
    return ShowCaseWidget(
      builder: Builder(
        builder: (BuildContext context) {
          myContext = context;
          return View(
            appBar: CustomAppBar(
              title: language.settingsTitle,
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
              CustomShowcase(
                showcaseKey: showcaseKeys.generalSettingsKey,
                title: language.this_is_settings_page,
                description: language.this_is_settings_page_desc,
                child: Column(
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
                        CustomShowcase(
                          showcaseKey: showcaseKeys.configurationSettingsKey,
                          description: language.start_set_limit_and_categories,
                          disableBackdropClick: true,
                          disposeOnTap: true,
                          onTargetClick: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const TransactionsSettingsPage(),
                              ),
                            );
                          },
                          child: SettingNavButton(
                            name: language.transactionsSettings,
                            destination: const TransactionsSettingsPage(),
                          ),
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
                        // SettingNavButton(
                        //   name: language.faq,
                        //   destination: const FaqPage(),
                        // ),
                        SettingNavButton(
                          name: language.about,
                          destination: const HelpPage(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

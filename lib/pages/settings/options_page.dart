import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:monity/backend/key_value_database.dart';
import 'package:monity/helper/config_provider.dart';
import 'package:monity/pages/settings/recurring_transactions_page.dart';
import 'package:monity/widgets/custom_appbar.dart';
import 'package:monity/widgets/custom_section.dart';
import 'package:monity/widgets/setting_nav_button.dart';
import 'package:monity/widgets/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OptionsPage extends StatelessWidget {
  const OptionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    Locale locale = Localizations.localeOf(context);
    var currencyFormat = NumberFormat.simpleCurrency(locale: locale.toString(), decimalDigits: 2);
    var configProvider = Provider.of<ConfigProvider>(context);
    Future<double?> currentOverflow = KeyValueDatabase.getBudgetOverflow();

    return View(
      appBar: CustomAppBar(
        title: language.options,
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
        // Option to carry over the remaining budget into the next month.
        CustomSection(
          groupItems: true,
          title: language.overflow,
          subtitle: language.remainingBudgetOverflow,
          children: [
            _BooleanSetting(
              title: language.enableOverflow,
              value: configProvider.budgetOverflowEnabled,
              onChanged: (value) => _toggleOverflow(context, value),
              additionalInfoOnActive: FutureBuilder(
                future: currentOverflow,
                builder: ((context, snapshot) {
                  return Text(
                    "${language.currentOverflow} ${currencyFormat.format(snapshot.hasData ? snapshot.data : 0)}",
                    style: TextStyle(
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                  );
                }),
              ),
            )
          ],
        ),
        CustomSection(
          title: language.recurringTransactions,
          subtitle: language.recurringTransactionsSubtitle,
          groupItems: true,
          children: [
            SettingNavButton(
              name: language.edit,
              destination: const RecurringTransactions(),
            ),
            _BooleanSetting(
              title: language.disable,
              value: configProvider.disableRecurringTransactions,
              onChanged: configProvider.setDisableRecurringTransactions,
              isDestructive: true,
            )
          ],
        )
      ],
    );
  }

  void _toggleOverflow(BuildContext context, bool value) async {
    var language = AppLocalizations.of(context)!;
    if (!value) {
      var result = await showOkCancelAlertDialog(
        context: context,
        title: language.attention,
        message: language.sureDeleteOverflow,
        isDestructiveAction: true,
      );
      if (result == OkCancelResult.cancel) {
        return;
      }
    }
    Provider.of<ConfigProvider>(context, listen: false).setBudgetOverflow(value);
  }
}

class _BooleanSetting extends StatelessWidget {
  final String title;
  final bool value;
  final Widget? additionalInfoOnActive;
  final bool isDestructive;
  final void Function(bool) onChanged;
  const _BooleanSetting({
    Key? key,
    this.additionalInfoOnActive,
    this.isDestructive = false,
    required this.title,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: isDestructive ? Theme.of(context).errorColor : null,
                    fontSize: 18,
                  ),
                ),
                Switch.adaptive(
                  value: value,
                  onChanged: onChanged,
                  activeColor: Theme.of(context).errorColor,
                )
              ],
            ),
            if (additionalInfoOnActive != null && value) additionalInfoOnActive!
          ],
        ),
      ),
    );
  }
}

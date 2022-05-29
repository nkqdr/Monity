import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:finance_buddy/backend/key_value_database.dart';
import 'package:finance_buddy/helper/config_provider.dart';
import 'package:finance_buddy/widgets/custom_appbar.dart';
import 'package:finance_buddy/widgets/custom_section.dart';
import 'package:finance_buddy/widgets/view.dart';
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
    var currencyFormat = NumberFormat.simpleCurrency(
        locale: locale.toString(), decimalDigits: 2);
    bool enableOverflow =
        Provider.of<ConfigProvider>(context).budgetOverflowEnabled;
    Future<double?> currentOverflow = KeyValueDatabase.getBudgetOverflow();

    return View(
        appBar: CustomAppBar(
          title: language.options,
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
          // Option to carry over the remaining budget into the next month.
          CustomSection(
            groupItems: true,
            subtitle: language.remainingBudgetOverflow,
            children: [
              Container(
                color: Theme.of(context).cardColor,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            language.enableOverflow,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                          Switch.adaptive(
                              value: enableOverflow,
                              onChanged: (value) =>
                                  _toggleOverflow(context, value))
                        ],
                      ),
                      if (enableOverflow)
                        FutureBuilder(
                          future: currentOverflow,
                          builder: ((context, snapshot) {
                            return Text(
                              "${language.currentOverflow} ${currencyFormat.format(snapshot.hasData ? snapshot.data : 0)}",
                              style: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor,
                              ),
                            );
                          }),
                        )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ]);
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
    Provider.of<ConfigProvider>(context, listen: false)
        .setBudgetOverflow(value);
  }
}

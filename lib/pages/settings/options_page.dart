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

class OptionsPage extends StatefulWidget {
  const OptionsPage({Key? key}) : super(key: key);

  @override
  _OptionsPageState createState() => _OptionsPageState();
}

class _OptionsPageState extends State<OptionsPage> {
  bool isLoading = false;
  late bool enableOverflow;
  late double currentOverflow;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    enableOverflow = Provider.of<ConfigProvider>(context).budgetOverflowEnabled;
    _refreshCurrentOverflow();
  }

  Future _refreshCurrentOverflow() async {
    setState(() => isLoading = true);
    double? currentOverflowValue = await KeyValueDatabase.getBudgetOverflow();
    currentOverflow = currentOverflowValue ?? 0;
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    Locale locale = Localizations.localeOf(context);
    var currencyFormat = NumberFormat.simpleCurrency(
        locale: locale.toString(), decimalDigits: 2);
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
                              value: enableOverflow, onChanged: _toggleOverflow)
                        ],
                      ),
                      if (enableOverflow && !isLoading)
                        Text(
                          "${language.currentOverflow} ${currencyFormat.format(currentOverflow)}",
                          style: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ]);
  }

  void _toggleOverflow(bool value) async {
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
    setState(() => enableOverflow = value);
    Provider.of<ConfigProvider>(context, listen: false)
        .setBudgetOverflow(value);
  }
}

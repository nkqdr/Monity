import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:finance_buddy/backend/finances_database.dart';
import 'package:finance_buddy/backend/key_value_database.dart';
import 'package:finance_buddy/backend/models/transaction_model.dart';
import 'package:finance_buddy/helper/config_provider.dart';
import 'package:finance_buddy/widgets/adaptive_progress_indicator.dart';
import 'package:finance_buddy/widgets/adaptive_text_button.dart';
import 'package:finance_buddy/widgets/category_tile.dart';
import 'package:finance_buddy/widgets/custom_appbar.dart';
import 'package:finance_buddy/widgets/custom_section.dart';
import 'package:finance_buddy/widgets/category_bottom_sheet.dart';
import 'package:finance_buddy/widgets/view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TransactionsSettingsPage extends StatefulWidget {
  const TransactionsSettingsPage({Key? key}) : super(key: key);

  @override
  State<TransactionsSettingsPage> createState() =>
      _TransactionsSettingsPageState();
}

class _TransactionsSettingsPageState extends State<TransactionsSettingsPage> {
  late List<TransactionCategory> categories;
  late double? monthlyLimit;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _refreshCategories();
  }

  Future _refreshCategories() async {
    setState(() => isLoading = true);
    categories = await FinancesDatabase.instance.readAllTransactionCategories();
    monthlyLimit = await KeyValueDatabase.getMonthlyLimit();
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
        title: language.transactionsSettings,
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
          title: language.monthlyLimit,
          // titleSize: 18,
          titlePadding: 10,
          subtitle: language.monthlyLimitDescription,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: isLoading
                    ? const AdaptiveProgressIndicator()
                    : Row(children: [
                        Text(
                          monthlyLimit != null
                              ? language.yourMonthlyLimit
                              : language.noMonthlyLimit,
                          style: monthlyLimit != null
                              ? null
                              : TextStyle(
                                  color: Theme.of(context).secondaryHeaderColor,
                                ),
                        ),
                        if (monthlyLimit != null)
                          Text(
                            currencyFormat.format(monthlyLimit),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).hintColor,
                            ),
                          )
                      ]),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AdaptiveTextButton(
                  text: language.changeMonthlyLimit,
                  onPressed: _handleSetMonthlyLimit,
                ),
                AdaptiveTextButton(
                  text: language.deleteMonthlyLimit,
                  isDescructive: true,
                  onPressed: _handleDeleteMonthlyLimit,
                ),
              ],
            ),
          ],
        ),
        CustomSection(
          title: language.categories,
          //titleSize: 18,
          titlePadding: 10,
          subtitle: language.categoriesDescription,
          trailing: InkWell(
            borderRadius: BorderRadius.circular(20),
            child: const Icon(
              Icons.add,
              color: Colors.blue,
            ),
            onTap: _handleAddCategory,
          ),
          children: isLoading
              ? [const Center(child: AdaptiveProgressIndicator())]
              : [
                  ...categories.map(
                    (e) => CategoryTile(
                      category: e,
                      categories: categories,
                      refreshCallback: _refreshCategories,
                    ),
                  ),
                ],
        ),
      ],
    );
  }

  Future _handleDeleteMonthlyLimit() async {
    var language = AppLocalizations.of(context)!;
    var dialogResult = await showOkCancelAlertDialog(
      context: context,
      title: language.attention,
      message: language.sureDeleteMonthlyLimit,
      isDestructiveAction: true,
      okLabel: language.delete,
      cancelLabel: language.abort,
    );
    if (dialogResult == OkCancelResult.ok) {
      await KeyValueDatabase.deleteMonthlyLimit();
      await _refreshCategories();
    }
  }

  Future _handleSetMonthlyLimit() async {
    var language = AppLocalizations.of(context)!;
    var dialogResult = await showTextInputDialog(
      context: context,
      title: language.changeMonthlyLimit,
      message: language.enterNewMonthlyLimit,
      okLabel: language.saveButton,
      cancelLabel: language.abort,
      textFields: [
        const DialogTextField(
            keyboardType:
                TextInputType.numberWithOptions(decimal: true, signed: false))
      ],
    );
    if (dialogResult != null) {
      double limit;
      try {
        limit = double.parse(dialogResult.first);
      } catch (e) {
        return;
      }
      Provider.of<ConfigProvider>(context, listen: false)
          .setMonthlyLimit(limit);
      await _refreshCategories();
    }
  }

  Future _handleAddCategory() async {
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: CategoryBottomSheet(
              mode: CategoryBottomSheetMode.add,
              categories: categories,
              onSubmit: (s) {
                FinancesDatabase.instance
                    .createTransactionCategory(TransactionCategory(name: s));
              },
            ),
          );
        });
    _refreshCategories();
  }
}

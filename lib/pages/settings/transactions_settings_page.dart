import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:monity/backend/models/transaction_model.dart';
import 'package:monity/helper/category_list_provider.dart';
import 'package:monity/helper/config_provider.dart';
import 'package:monity/widgets/adaptive_text_button.dart';
import 'package:monity/widgets/category_tile.dart';
import 'package:monity/widgets/custom_appbar.dart';
import 'package:monity/widgets/custom_section.dart';
import 'package:monity/widgets/category_bottom_sheet.dart';
import 'package:monity/widgets/view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TransactionsSettingsPage extends StatelessWidget {
  const TransactionsSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    Locale locale = Localizations.localeOf(context);
    var currencyFormat = NumberFormat.simpleCurrency(locale: locale.toString(), decimalDigits: 2);
    double? monthlyLimit = Provider.of<ConfigProvider>(context).monthlyLimit;
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
                child: Row(
                  children: [
                    Text(
                      monthlyLimit != null ? language.yourMonthlyLimit : language.noMonthlyLimit,
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
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AdaptiveTextButton(
                  text: language.changeMonthlyLimit,
                  onPressed: () => _handleSetMonthlyLimit(context),
                ),
                AdaptiveTextButton(
                  text: language.deleteMonthlyLimit,
                  isDescructive: true,
                  onPressed: () => _handleDeleteMonthlyLimit(context),
                ),
              ],
            ),
          ],
        ),
        CustomSection(
          title: language.categories,
          titlePadding: 10,
          subtitle: language.categoriesDescription,
          trailing: InkWell(
            borderRadius: BorderRadius.circular(15),
            child: const Icon(
              Icons.add,
              color: Colors.blue,
            ),
            onTap: () => _handleAddCategory(context),
          ),
          children: const [
            TransactionCategoriesList(),
          ],
        )
      ],
    );
  }

  Future _handleDeleteMonthlyLimit(BuildContext context) async {
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
      await Provider.of<ConfigProvider>(context, listen: false).deleteMonthlyLimit();
    }
  }

  Future _handleSetMonthlyLimit(BuildContext context) async {
    var language = AppLocalizations.of(context)!;
    var dialogResult = await showTextInputDialog(
      context: context,
      title: language.changeMonthlyLimit,
      message: language.enterNewMonthlyLimit,
      okLabel: language.saveButton,
      cancelLabel: language.abort,
      textFields: [const DialogTextField(keyboardType: TextInputType.numberWithOptions(decimal: true, signed: false))],
    );
    if (dialogResult != null) {
      var amountString = dialogResult.first.replaceAll(",", ".");
      double limit;
      try {
        limit = double.parse(amountString);
      } catch (e) {
        return;
      }
      Provider.of<ConfigProvider>(context, listen: false).setMonthlyLimit(limit);
    }
  }

  Future _handleAddCategory(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: CategoryBottomSheet<TransactionCategory>(
            mode: CategoryBottomSheetMode.add,
          ),
        );
      },
    );
  }
}

class TransactionCategoriesList extends StatelessWidget {
  const TransactionCategoriesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _categoriesList = Provider.of<ListProvider<TransactionCategory>>(context);
    return Column(
      children: [
        ..._categoriesList.list.map(
          (e) => CategoryTile<TransactionCategory>(
            category: e,
          ),
        ),
      ],
    );
  }
}

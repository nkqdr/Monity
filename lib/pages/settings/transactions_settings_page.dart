import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:finance_buddy/backend/finances_database.dart';
import 'package:finance_buddy/backend/key_value_database.dart';
import 'package:finance_buddy/backend/models/transaction_model.dart';
import 'package:finance_buddy/widgets/adaptive_progress_indicator.dart';
import 'package:finance_buddy/widgets/adaptive_text_button.dart';
import 'package:finance_buddy/widgets/custom_appbar.dart';
import 'package:finance_buddy/widgets/custom_section.dart';
import 'package:finance_buddy/widgets/transaction_category_bottom_sheet.dart';
import 'package:finance_buddy/widgets/view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    var currencyFormat =
        NumberFormat.currency(locale: "de_DE", decimalDigits: 2, symbol: "€");
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
          titleSize: 18,
          titlePadding: 10,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: isLoading
                    ? const AdaptiveProgressIndicator()
                    : RichText(
                        text: TextSpan(
                          text: monthlyLimit != null
                              ? language.yourMonthlyLimit
                              : language.noMonthlyLimit,
                          style: monthlyLimit != null
                              ? null
                              : TextStyle(
                                  color: Theme.of(context).secondaryHeaderColor,
                                ),
                          children: monthlyLimit != null
                              ? [
                                  TextSpan(
                                    text: currencyFormat.format(monthlyLimit),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ),
                                ]
                              : [],
                        ),
                      ),
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
          titleSize: 18,
          titlePadding: 10,
          trailing: IconButton(
            icon: const Icon(Icons.add),
            onPressed: _handleAddCategory,
            splashRadius: 18,
          ),
          children: isLoading
              ? [const Center(child: AdaptiveProgressIndicator())]
              : [
                  ...categories.map(
                    (e) => TransactionCategoryTile(
                      category: e,
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
      await KeyValueDatabase.setMonthlyLimit(limit);
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
            child: TransactionCategoryBottomSheet(
              mode: CategoryBottomSheetMode.add,
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

class TransactionCategoryTile extends StatefulWidget {
  final TransactionCategory category;
  final Function refreshCallback;

  const TransactionCategoryTile({
    Key? key,
    required this.refreshCallback,
    required this.category,
  }) : super(key: key);

  @override
  State<TransactionCategoryTile> createState() =>
      _TransactionCategoryTileState();
}

class _TransactionCategoryTileState extends State<TransactionCategoryTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).cardColor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.category.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              Row(
                children: [
                  InkWell(
                    child: const Icon(Icons.edit_rounded),
                    onTap: _handleEdit,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  InkWell(
                    child: const Icon(Icons.delete_rounded, color: Colors.red),
                    onTap: _handleDelete,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _handleEdit() async {
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
            child: TransactionCategoryBottomSheet(
              mode: CategoryBottomSheetMode.edit,
              placeholder: widget.category.name,
              onSubmit: (s) {
                FinancesDatabase.instance
                    .updateTransactionCategory(widget.category.copy(name: s));
              },
            ),
          );
        });
    widget.refreshCallback();
  }

  Future _handleDelete() async {
    var language = AppLocalizations.of(context)!;
    var dialogResult = await showOkCancelAlertDialog(
      context: context,
      title: language.attention,
      message: language.sureDeleteCategory,
      isDestructiveAction: true,
      okLabel: language.delete,
      cancelLabel: language.abort,
    );
    if (dialogResult == OkCancelResult.ok) {
      await FinancesDatabase.instance
          .deleteTransactionCategory(widget.category.id!);
      widget.refreshCallback();
    }
  }
}

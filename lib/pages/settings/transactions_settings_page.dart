import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:finance_buddy/backend/finances_database.dart';
import 'package:finance_buddy/backend/models/transaction_model.dart';
import 'package:finance_buddy/widgets/custom_appbar.dart';
import 'package:finance_buddy/widgets/custom_section.dart';
import 'package:finance_buddy/widgets/transaction_category_bottom_sheet.dart';
import 'package:finance_buddy/widgets/view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class TransactionsSettingsPage extends StatefulWidget {
  const TransactionsSettingsPage({Key? key}) : super(key: key);

  @override
  State<TransactionsSettingsPage> createState() =>
      _TransactionsSettingsPageState();
}

class _TransactionsSettingsPageState extends State<TransactionsSettingsPage> {
  late List<TransactionCategory> categories;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _refreshCategories();
  }

  Future _refreshCategories() async {
    setState(() {
      isLoading = true;
    });
    categories = await FinancesDatabase.instance.readAllTransactionCategories();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;
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
          children: [],
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
              ? [const Center(child: CircularProgressIndicator())]
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

  void _handleAddCategory() async {
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
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
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

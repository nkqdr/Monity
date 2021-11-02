import 'package:finance_buddy/backend/finances_database.dart';
import 'package:finance_buddy/backend/models/transaction_model.dart';
import 'package:finance_buddy/l10n/language_provider.dart';
import 'package:finance_buddy/widgets/adaptive_progress_indicator.dart';
import 'package:finance_buddy/widgets/add_transaction_bottom_sheet.dart';
import 'package:finance_buddy/widgets/custom_appbar.dart';
import 'package:finance_buddy/widgets/custom_section.dart';
import 'package:finance_buddy/widgets/transaction_tile.dart';
import 'package:finance_buddy/widgets/view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({Key? key}) : super(key: key);

  @override
  _TransactionsPageState createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  late List<DateTime> months;
  late List<Transaction> transactions;
  late List<TransactionCategory> transactionCategories;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _refreshTransactions();
  }

  Future _refreshTransactions() async {
    setState(() => isLoading = true);
    transactions = await FinancesDatabase.instance.readAllTransactions();
    months = transactions
        .map((e) => DateTime(e.date.year, e.date.month))
        .toSet()
        .toList();
    transactionCategories =
        await FinancesDatabase.instance.readAllTransactionCategories();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LanguageProvider>(context);
    DateFormat dateFormatter;
    if (provider.locale == null) {
      dateFormatter =
          DateFormat.yMMMM(Localizations.localeOf(context).toString());
    } else {
      dateFormatter = DateFormat.yMMMM(provider.locale!.languageCode);
    }

    var language = AppLocalizations.of(context)!;
    return View(
      appBar: CustomAppBar(
        title: language.transactionsTitle,
        left: IconButton(
          icon: const Icon(
            Icons.filter_alt_rounded,
          ),
          splashRadius: 18,
          onPressed: () {},
        ),
        right: IconButton(
          icon: const Icon(
            Icons.add,
          ),
          splashRadius: 18,
          onPressed: _handleAddTransaction,
        ),
      ),
      fixedAppBar: true,
      safeAreaBottomDisabled: true,
      children: [
        if (isLoading)
          SizedBox(
            height: MediaQuery.of(context).size.height - 150,
            child: const Center(
              child: AdaptiveProgressIndicator(),
            ),
          )
        else if (transactions.isEmpty)
          SizedBox(
            height: MediaQuery.of(context).size.height - 150,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  language.noTransactions,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                ),
              ),
            ),
          )
        else
          ...months.map((date) {
            return CustomSection(
              title: dateFormatter.format(date),
              children: _getTransactionsFor(date).map((e) {
                return TransactionTile(
                  transaction: e,
                  category: transactionCategories
                      .where((c) => c.id == e.categoryId)
                      .first,
                );
              }).toList(),
            );
          }),
      ],
    );
  }

  List<Transaction> _getTransactionsFor(DateTime date) {
    return transactions
        .where((e) => e.date.year == date.year && e.date.month == date.month)
        .toList();
  }

  void _handleAddTransaction() async {
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
            child: const AddTransactionBottomSheet(),
          );
        });
    _refreshTransactions();
  }
}

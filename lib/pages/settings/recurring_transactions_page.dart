import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:monity/backend/finances_database.dart';
import 'package:monity/backend/models/transaction_model.dart';
import 'package:monity/helper/category_list_provider.dart';
import 'package:monity/widgets/adaptive_progress_indicator.dart';
import 'package:monity/widgets/add_transaction_bottom_sheet.dart';
import 'package:monity/widgets/custom_appbar.dart';
import 'package:monity/widgets/custom_section.dart';
import 'package:monity/widgets/transaction_tile.dart';
import 'package:monity/widgets/view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class RecurringTransactions extends StatefulWidget {
  const RecurringTransactions({Key? key}) : super(key: key);

  @override
  State<RecurringTransactions> createState() => _RecurringTransactionsState();
}

class _RecurringTransactionsState extends State<RecurringTransactions> {
  late Future<List<Transaction>> _recurringTransactions;

  @override
  void initState() {
    _refreshTransactions();
    super.initState();
  }

  void _refreshTransactions() {
    setState(() {
      _recurringTransactions = FinancesDatabase.instance.readAllTransactions(recurring: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    var transactionCategories = Provider.of<ListProvider<TransactionCategory>>(context).list;
    Locale locale = Localizations.localeOf(context);
    var currencyFormat = NumberFormat.simpleCurrency(locale: locale.toString(), decimalDigits: 2);
    return View(
        appBar: CustomAppBar(
          title: language.transactionsTitle,
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
          right: IconButton(
            icon: Icon(
              Icons.add,
              color: Theme.of(context).primaryColor,
            ),
            splashRadius: 18,
            onPressed: _handleAddTransaction,
          ),
        ),
        fixedAppBar: true,
        children: [
          FutureBuilder<List<Transaction>>(
              future: _recurringTransactions,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isEmpty) {
                    return SizedBox(
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
                    );
                  }
                  return Column(
                    children: [
                      CustomSection(
                        title: language.fixedMonthlyIncome,
                        subtitle: currencyFormat.format(
                          _getMonthlyFixed(snapshot.data!, TransactionType.income),
                        ),
                        subtitleTextStyle: TextStyle(
                          color: Theme.of(context).hintColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          ...snapshot.data!.where((element) => element.type == TransactionType.income).map(
                                (e) => TransactionTile(
                                  transaction: e,
                                  category: transactionCategories.firstWhere((element) => element.id == e.categoryId),
                                  isRecurring: true,
                                  refreshFunction: _refreshTransactions,
                                ),
                              ),
                        ],
                      ),
                      CustomSection(
                        title: language.fixedMonthlyExpenses,
                        subtitle: currencyFormat.format(
                          _getMonthlyFixed(snapshot.data!, TransactionType.expense),
                        ),
                        subtitleTextStyle: TextStyle(
                          color: Theme.of(context).errorColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          ...snapshot.data!.where((element) => element.type == TransactionType.expense).map(
                                (e) => TransactionTile(
                                  transaction: e,
                                  category: transactionCategories.firstWhere((element) => element.id == e.categoryId),
                                  isRecurring: true,
                                  refreshFunction: _refreshTransactions,
                                ),
                              ),
                        ],
                      ),
                    ],
                  );
                } else {
                  return const Center(child: AdaptiveProgressIndicator());
                }
              })
        ]);
  }

  double _getMonthlyFixed(List<Transaction> transactions, TransactionType type) {
    double sum = 0;
    for (var transaction in transactions) {
      if (transaction.type == type) {
        sum += transaction.amount;
      }
    }
    return sum;
  }

  void _handleAddTransaction() async {
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: const AddTransactionBottomSheet(
              isRecurring: true,
            ),
          );
        });
    _refreshTransactions();
  }
}

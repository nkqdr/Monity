import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:monity/backend/finances_database.dart';
import 'package:monity/backend/models/transaction_model.dart';
import 'package:monity/widgets/transaction_context_menu.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;
  final TransactionCategory category;
  final Function? refreshFunction;

  const TransactionTile({
    Key? key,
    this.refreshFunction,
    required this.transaction,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Locale locale = Localizations.localeOf(context);
    var currencyFormat = NumberFormat.simpleCurrency(locale: locale.toString(), decimalDigits: 2);
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, left: 10, right: 10),
      child: TransactionContextMenu(
        transaction: transaction,
        transactionCategory: category,
        handleDelete: () => _handleDeleteTransaction(context),
        child: Material(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [
                Theme.of(context).scaffoldBackgroundColor,
                (transaction.type == TransactionType.income ? Colors.green[600] as Color : Colors.red[600] as Color),
              ], stops: const [
                0.1,
                1
              ]),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: SizedBox(
                height: 75,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                constraints: const BoxConstraints(maxWidth: 200),
                                child: Text(
                                  category.name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                currencyFormat.format(transaction.amount),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: transaction.type == TransactionType.income
                                      ? Theme.of(context).hintColor
                                      : Theme.of(context).errorColor,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          child: Text(
                            transaction.description ?? "",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Theme.of(context).textTheme.bodyText1!.color!.withOpacity(0.8),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _handleDeleteTransaction(BuildContext context) async {
    var language = AppLocalizations.of(context)!;
    var result = await showOkCancelAlertDialog(
        context: context,
        title: language.deleteTransaction,
        message: language.sureDeleteTransaction,
        isDestructiveAction: true);
    if (result == OkCancelResult.ok) {
      FinancesDatabase.instance.deleteTransaction(transaction.id as int);
      refreshFunction!();
    }
  }
}

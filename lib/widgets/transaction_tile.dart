import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:finance_buddy/backend/finances_database.dart';
import 'package:finance_buddy/backend/models/transaction_model.dart';
import 'package:finance_buddy/widgets/transaction_context_menu.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// import 'add_transaction_bottom_sheet.dart';

class TransactionTile extends StatefulWidget {
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
  State<TransactionTile> createState() => _TransactionTileState();
}

class _TransactionTileState extends State<TransactionTile> {
  @override
  Widget build(BuildContext context) {
    Locale locale = Localizations.localeOf(context);
    var currencyFormat = NumberFormat.simpleCurrency(
        locale: locale.toString(), decimalDigits: 2);
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, left: 10, right: 10),
      child: TransactionContextMenu(
        transaction: widget.transaction,
        transactionCategory: widget.category,
        handleDelete: _handleDeleteTransaction,
        child: Material(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).scaffoldBackgroundColor,
              // border: Border.all(
              //     color: widget.transaction.type == TransactionType.income
              //         ? Colors.green.withOpacity(1)
              //         : Colors.red.withOpacity(1),
              //     width: 1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                height: 75,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 10,
                          child: Container(
                            color: widget.transaction.type ==
                                    TransactionType.income
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                constraints:
                                    const BoxConstraints(maxWidth: 200),
                                child: Text(
                                  widget.category.name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                currencyFormat
                                    .format(widget.transaction.amount),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: widget.transaction.type ==
                                          TransactionType.income
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
                            widget.transaction.description ?? "",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Theme.of(context).secondaryHeaderColor,
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

  _handleDeleteTransaction() async {
    var language = AppLocalizations.of(context)!;
    var result = await showOkCancelAlertDialog(
        context: context,
        title: language.deleteTransaction,
        message: language.sureDeleteTransaction,
        isDestructiveAction: true);
    if (result == OkCancelResult.ok) {
      FinancesDatabase.instance.deleteTransaction(widget.transaction.id as int);
      widget.refreshFunction!();
    }
  }

  // _handleEditTransaction() async {
  //   await showModalBottomSheet(
  //       context: context,
  //       isScrollControlled: true,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(20.0),
  //       ),
  //       builder: (context) {
  //         return Padding(
  //           padding: EdgeInsets.only(
  //               bottom: MediaQuery.of(context).viewInsets.bottom),
  //           child: const AddTransactionBottomSheet(),
  //         );
  //       });
  // }
}

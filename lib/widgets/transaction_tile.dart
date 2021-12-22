import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:finance_buddy/backend/finances_database.dart';
import 'package:finance_buddy/backend/models/transaction_model.dart';
import 'package:finance_buddy/widgets/adaptive_context_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    var language = AppLocalizations.of(context)!;
    var currencyFormat =
        NumberFormat.currency(locale: "de_DE", decimalDigits: 2, symbol: "€");
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: AdaptiveContextMenu(
        actions: [
          CupertinoContextMenuAction(
            child: Text(language.edit),
            trailingIcon: CupertinoIcons.pencil,
            onPressed: () {
              Navigator.pop(context);
              _handleEditTransaction();
            },
          ),
          CupertinoContextMenuAction(
            child: Text(language.delete),
            isDestructiveAction: true,
            trailingIcon: CupertinoIcons.delete,
            onPressed: () {
              Navigator.pop(context);
              _handleDeleteTransaction();
            },
          ),
        ],
        child: Material(
          child: Container(
            color: Colors.black,
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
                              Text(
                                widget.category.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
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
                    SizedBox(
                      width: 150,
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

  _handleEditTransaction() {}
}

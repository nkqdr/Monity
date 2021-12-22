import 'package:finance_buddy/backend/models/transaction_model.dart';
import 'package:finance_buddy/l10n/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TransactionContextMenu extends StatelessWidget {
  final Widget child;
  final List<Widget> actions;
  final Transaction transaction;
  final TransactionCategory transactionCategory;
  const TransactionContextMenu({
    Key? key,
    required this.transactionCategory,
    required this.transaction,
    required this.child,
    required this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    final provider = Provider.of<LanguageProvider>(context);
    var currencyFormat =
        NumberFormat.currency(locale: "de_DE", decimalDigits: 2, symbol: "€");
    DateFormat dateFormatter;
    if (provider.locale == null) {
      dateFormatter =
          DateFormat.yMMMd(Localizations.localeOf(context).toString());
    } else {
      dateFormatter = DateFormat.yMMMd(provider.locale!.languageCode);
    }
    return CupertinoContextMenu(
      previewBuilder: (context, animation, child) {
        return Material(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 40,
            height: transaction.description != ""
                ? MediaQuery.of(context).size.height / 2
                : MediaQuery.of(context).size.height / 5,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          transactionCategory.name,
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          dateFormatter.format(transaction.date),
                          style: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          currencyFormat.format(transaction.amount),
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: transaction.type == TransactionType.expense
                                  ? Theme.of(context).errorColor
                                  : Theme.of(context).hintColor),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Text(
                      transaction.description != ""
                          ? language.descriptionDetailTitle
                          : "",
                      style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      transaction.description ?? "",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      actions: actions,
      child: SingleChildScrollView(
        child: child,
      ),
    );
  }
}

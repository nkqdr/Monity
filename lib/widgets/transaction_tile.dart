import 'package:finance_buddy/backend/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;
  final TransactionCategory category;

  const TransactionTile({
    Key? key,
    required this.transaction,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var currencyFormat =
        NumberFormat.currency(locale: "de_DE", decimalDigits: 2, symbol: "€");
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
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
                      color: transaction.type == TransactionType.income
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
                          category.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          currencyFormat.format(transaction.amount),
                          style: TextStyle(
                            fontSize: 16,
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
              SizedBox(
                width: 150,
                child: Text(
                  transaction.description ?? "",
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
    );
  }
}

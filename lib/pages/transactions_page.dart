import 'package:finance_buddy/api/transactions_api.dart';
import 'package:finance_buddy/widgets/custom_appbar.dart';
import 'package:finance_buddy/widgets/custom_section.dart';
import 'package:finance_buddy/widgets/transaction_tile.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({Key? key}) : super(key: key);

  @override
  _TransactionsPageState createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  List<DateTime> months = [];

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('en_US');
    months = TransactionsApi.getAllMonths();
  }

  @override
  Widget build(BuildContext context) {
    var dateFormatter = DateFormat.yMMMM("en_US");
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView(
          children: [
            CustomAppBar(
              title: "Transactions",
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
                onPressed: () {},
              ),
            ),
            ...months.map((date) {
              return CustomSection(
                title: dateFormatter.format(date),
                children: TransactionsApi.getTransactionsFor(date).map((e) {
                  return TransactionTile(
                    transaction: e,
                  );
                }).toList(),
              );
            })
          ],
        ),
      ),
    );
  }
}

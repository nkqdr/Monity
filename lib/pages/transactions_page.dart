import 'package:finance_buddy/controller/transactions_api.dart';
import 'package:finance_buddy/l10n/language_provider.dart';
import 'package:finance_buddy/widgets/add_transaction_bottom_sheet.dart';
import 'package:finance_buddy/widgets/custom_appbar.dart';
import 'package:finance_buddy/widgets/custom_section.dart';
import 'package:finance_buddy/widgets/transaction_tile.dart';
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
  List<DateTime> months = [];

  @override
  void initState() {
    super.initState();
    months = TransactionsApi.getAllMonths();
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
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView(
          children: [
            CustomAppBar(
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
            ...months.map((date) {
              return CustomSection(
                title: dateFormatter.format(date),
                children: TransactionsApi.getTransactionsFor(date).map((e) {
                  return TransactionTile(
                    transaction: e,
                  );
                }).toList(),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _handleAddTransaction() {
    showModalBottomSheet(
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
  }
}

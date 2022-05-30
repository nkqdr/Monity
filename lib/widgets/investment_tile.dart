import 'package:finance_buddy/backend/finances_database.dart';
import 'package:finance_buddy/backend/models/investment_model.dart';
import 'package:finance_buddy/helper/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InvestmentTile extends StatelessWidget {
  final InvestmentCategory category;

  const InvestmentTile({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormatter = Utils.getDateFormatter(context);
    Locale locale = Localizations.localeOf(context);
    var currencyFormat = NumberFormat.simpleCurrency(
        locale: locale.toString(), decimalDigits: 2);
    var language = AppLocalizations.of(context)!;
    Future<InvestmentSnapshot?> lastSnapshot =
        FinancesDatabase.instance.readLastSnapshotFor(category: category);
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 10, right: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          color: Theme.of(context).cardColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    FutureBuilder<InvestmentSnapshot?>(
                      future: lastSnapshot,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Text(
                            "-",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }
                        return Text(
                          currencyFormat.format(snapshot.data!.amount),
                          style: TextStyle(
                            fontSize: 18,
                            color: snapshot.data!.amount < 0
                                ? Theme.of(context).errorColor
                                : Theme.of(context).hintColor,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      language.lastChange,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).secondaryHeaderColor,
                      ),
                    ),
                    FutureBuilder<InvestmentSnapshot?>(
                      future: lastSnapshot,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Text(
                            "-",
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).secondaryHeaderColor,
                            ),
                          );
                        }

                        return Text(
                          dateFormatter.format(snapshot.data!.date),
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).secondaryHeaderColor,
                          ),
                        );
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

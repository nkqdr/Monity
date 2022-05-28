import 'package:finance_buddy/backend/finances_database.dart';
import 'package:finance_buddy/backend/models/investment_model.dart';
import 'package:finance_buddy/l10n/language_provider.dart';
import 'package:finance_buddy/widgets/adaptive_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InvestmentTile extends StatelessWidget {
  final InvestmentCategory category;

  const InvestmentTile({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LanguageProvider>(context);
    DateFormat dateFormatter;
    if (provider.locale == null) {
      dateFormatter =
          DateFormat.yMMMMd(Localizations.localeOf(context).toString());
    } else {
      dateFormatter = DateFormat.yMMMMd(provider.locale!.languageCode);
    }
    Locale locale = Localizations.localeOf(context);
    var currencyFormat = NumberFormat.simpleCurrency(
        locale: locale.toString(), decimalDigits: 2);
    var language = AppLocalizations.of(context)!;
    Future<InvestmentSnapshot?> lastSnapshot =
        FinancesDatabase.instance.readLastSnapshotFor(category: category);
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, left: 10, right: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          color: Theme.of(context).cardColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
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
                          return const AdaptiveProgressIndicator();
                        }
                        return Text(
                          snapshot.data != null
                              ? currencyFormat.format(snapshot.data!.amount)
                              : "-",
                          style: TextStyle(
                            fontSize: 18,
                            color: snapshot.data != null
                                ? (snapshot.data!.amount < 0
                                    ? Theme.of(context).errorColor
                                    : Theme.of(context).hintColor)
                                : null,
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
                          return const AdaptiveProgressIndicator();
                        }

                        return Text(
                          snapshot.data != null
                              ? dateFormatter.format(snapshot.data!.date)
                              : "-",
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

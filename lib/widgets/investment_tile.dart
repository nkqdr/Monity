import 'package:finance_buddy/backend/finances_database.dart';
import 'package:finance_buddy/backend/models/investment_model.dart';
import 'package:finance_buddy/l10n/language_provider.dart';
import 'package:finance_buddy/pages/wealth_category_page.dart';
import 'package:finance_buddy/widgets/adaptive_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InvestmentTile extends StatefulWidget {
  final InvestmentCategory category;

  const InvestmentTile({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  State<InvestmentTile> createState() => _InvestmentTileState();
}

class _InvestmentTileState extends State<InvestmentTile> {
  bool isLoading = false;
  late InvestmentSnapshot? lastSnapshot;

  @override
  void initState() {
    super.initState();
    _refreshSnapshot();
  }

  Future _refreshSnapshot() async {
    setState(() => isLoading = true);
    lastSnapshot = await FinancesDatabase.instance
        .readLastSnapshotFor(category: widget.category);
    setState(() => isLoading = false);
  }

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
    var currencyFormat =
        NumberFormat.currency(locale: "de_DE", decimalDigits: 2, symbol: "€");
    var language = AppLocalizations.of(context)!;
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
                      widget.category.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (isLoading)
                      const AdaptiveProgressIndicator()
                    else
                      Text(
                        lastSnapshot != null
                            ? currencyFormat.format(lastSnapshot!.amount)
                            : "-",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                    if (isLoading)
                      const AdaptiveProgressIndicator()
                    else
                      Text(
                        lastSnapshot != null
                            ? dateFormatter.format(lastSnapshot!.date)
                            : "-",
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                      ),
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

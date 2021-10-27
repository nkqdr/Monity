import 'package:finance_buddy/api/wealth_api.dart';
import 'package:finance_buddy/helper/wealth_entry.dart';
import 'package:finance_buddy/l10n/language_provider.dart';
import 'package:finance_buddy/widgets/custom_appbar.dart';
import 'package:finance_buddy/widgets/custom_text.dart';
import 'package:finance_buddy/widgets/dashboard_tile.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WealthPage extends StatefulWidget {
  const WealthPage({Key? key}) : super(key: key);

  @override
  _WealthPageState createState() => _WealthPageState();
}

class _WealthPageState extends State<WealthPage> {
  List<WealthEntry> wealthEntries = [];

  @override
  void initState() {
    super.initState();
    wealthEntries = WealthApi.getAllEntries();
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
    return SafeArea(
      bottom: false,
      child: ListView(
        children: [
          CustomAppBar(
            title: language.wealthTitle,
            right: IconButton(
              icon: const Icon(
                Icons.add,
              ),
              splashRadius: 18,
              onPressed: () {},
            ),
          ),
          DashboardTile(
            title: currencyFormat.format(WealthApi.getCurrentWealth()),
            titleColor: Theme.of(context).colorScheme.onBackground,
            titleSize: 24,
            child: SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  backgroundColor: Theme.of(context).cardColor,
                  minX: 0,
                  maxX: wealthEntries.length - 1,
                  minY: 0,
                  maxY: WealthApi.getMaxLineChartValue() + 1,
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: SideTitles(showTitles: false),
                    topTitles: SideTitles(showTitles: false),
                    leftTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 0,
                      margin: 3,
                      getTextStyles: (context, d) {
                        return TextStyle(color: Theme.of(context).cardColor);
                      },
                    ),
                    rightTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 0,
                        margin: 4,
                        getTextStyles: (context, d) {
                          return TextStyle(color: Theme.of(context).cardColor);
                        }),
                  ),
                  gridData: FlGridData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                        isCurved: true,
                        barWidth: 3,
                        spots: wealthEntries.asMap().entries.map((e) {
                          return FlSpot(
                            e.key.toDouble(),
                            e.value.amount / WealthApi.getDivisor(),
                          );
                        }).toList())
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 15),
            child: CustomText(
              language.logbook,
              color: Theme.of(context).secondaryHeaderColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          ...wealthEntries.reversed.map((e) {
            return Padding(
              padding: const EdgeInsets.only(top: 15.0, left: 10, right: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  height: 60,
                  child: Container(
                    color: Theme.of(context).cardColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            currencyFormat.format(e.amount),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            dateFormatter.format(e.date),
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
          CupertinoButton(
            child: Text(
              language.viewAll,
              style: const TextStyle(color: Colors.blue),
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

import 'package:finance_buddy/api/wealth_api.dart';
import 'package:finance_buddy/helper/wealth_entry.dart';
import 'package:finance_buddy/l10n/language_provider.dart';
import 'package:finance_buddy/widgets/custom_appbar.dart';
import 'package:finance_buddy/widgets/custom_text.dart';
import 'package:finance_buddy/widgets/dashboard_tile.dart';
import 'package:finance_buddy/widgets/investment_tile.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';
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
  double displayWealth = WealthApi.getCurrentWealth();
  String? subtitle = null;

  @override
  void initState() {
    super.initState();
    wealthEntries = WealthApi.getAllEntries();
  }

  void _handleChartTouch(
      FlTouchEvent event, LineTouchResponse? response, DateFormat dateFormat) {
    if (event is FlTapUpEvent ||
        event is FlPanCancelEvent ||
        event is FlPanEndEvent ||
        event is FlLongPressEnd) {
      setState(() {
        subtitle = null;
        displayWealth = WealthApi.getCurrentWealth();
      });
      return;
    }

    if (response != null && response.lineBarSpots != null) {
      var value = response.lineBarSpots?[0].y;

      if (value != null && value * WealthApi.getDivisor() != displayWealth) {
        HapticFeedback.mediumImpact();
        setState(() {
          displayWealth = value * WealthApi.getDivisor();
          subtitle = dateFormat.format(
              wealthEntries[response.lineBarSpots?[0].x.toInt() as int].date);
        });
      }
    }
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
            title: currencyFormat.format(displayWealth),
            titleColor: Theme.of(context).colorScheme.onBackground,
            titleSize: 24,
            subtitle: subtitle,
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 180,
                  child: LineChart(
                    LineChartData(
                      backgroundColor: Theme.of(context).cardColor,
                      minX: 0,
                      maxX: wealthEntries.length - 1,
                      minY: 0,
                      maxY: WealthApi.getMaxLineChartValue() + 1,
                      titlesData: FlTitlesData(
                        show: false,
                      ),
                      lineTouchData: LineTouchData(
                          enabled: false,
                          touchCallback: (e, v) {
                            _handleChartTouch(e, v, dateFormatter);
                          }),
                      borderData: FlBorderData(show: false),
                      gridData: FlGridData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                            isCurved: true,
                            preventCurveOverShooting: true,
                            dotData: FlDotData(show: false),
                            barWidth: 4,
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
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 15),
            child: CustomText(
              language.investments,
              color: Theme.of(context).secondaryHeaderColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          // Render investment categories
          const InvestmentTile(title: 'Trade Republic'),
          const InvestmentTile(title: 'Crypto'),
          const InvestmentTile(title: 'MLP-Depot'),
          const InvestmentTile(title: 'Tresor'),
          const InvestmentTile(title: 'Girokonto'),
          const InvestmentTile(title: 'Tagesgeldkonto'),
          const InvestmentTile(title: 'DKB-Cash'),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}

import 'package:finance_buddy/api/wealth_api.dart';
import 'package:finance_buddy/l10n/language_provider.dart';
import 'package:finance_buddy/widgets/custom_appbar.dart';
import 'package:finance_buddy/widgets/dashboard_tile.dart';
import 'package:finance_buddy/widgets/investment_tile.dart';
import 'package:finance_buddy/widgets/wealth_chart.dart';
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
  double displayWealth = WealthApi.getCurrentWealth();
  VerticalLine? _indexLine;
  String? subtitle;
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
                  height: 40,
                ),
                SizedBox(
                  height: 180,
                  child: WealthChart(
                    indexLine: _indexLine,
                    touchHandler: (e, v) {
                      _handleChartTouch(e, v, dateFormatter);
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 15),
            child: Text(
              language.investments,
              style: TextStyle(
                color: Theme.of(context).secondaryHeaderColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
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

  void _handleChartTouch(
      FlTouchEvent event, LineTouchResponse? response, DateFormat dateFormat) {
    if (event is FlTapUpEvent ||
        event is FlPanCancelEvent ||
        event is FlPanEndEvent ||
        event is FlLongPressEnd) {
      setState(() {
        subtitle = null;
        _indexLine = null;
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
          _indexLine = VerticalLine(
            x: response.lineBarSpots?[0].x as double,
            color: Theme.of(context).secondaryHeaderColor,
            strokeWidth: 1,
          );
        });
      }
    }
  }
}

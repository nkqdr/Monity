import 'package:finance_buddy/api/wealth_api.dart';
import 'package:finance_buddy/pages/settings_page.dart';
import 'package:finance_buddy/widgets/custom_appbar.dart';
import 'package:finance_buddy/widgets/pie_chart.dart' as custom;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:finance_buddy/widgets/dashboard_tile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    var currencyFormat =
        NumberFormat.currency(locale: "de_DE", decimalDigits: 2, symbol: "€");
    var language = AppLocalizations.of(context)!;
    return SafeArea(
      bottom: false,
      child: ListView(
        children: [
          CustomAppBar(
            title: language.dashboardTitle,
            right: IconButton(
              icon: const Icon(
                Icons.settings,
              ),
              splashRadius: 18,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SettingsPage(),
                  ),
                );
              },
            ),
          ),
          Row(
            children: [
              DashboardTile(
                title: language.currentMonthOverview,
                width: DashboardTileWidth.half,
                child: Padding(
                  padding: const EdgeInsets.only(top: 60, left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        language.remainingDays,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "15",
                        style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        language.remainingBudget,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "+" + currencyFormat.format(352.31),
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              DashboardTile(
                title: language.performanceTitle,
                subtitle: language.lastYear,
                subtitleStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                width: DashboardTileWidth.half,
                child: Padding(
                  padding: const EdgeInsets.only(top: 80.0, left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Icon(
                        Icons.arrow_upward_rounded,
                        size: 60,
                        color: Colors.green,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "+23,4%",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          DashboardTile(
            title: language.wealthTitle,
            subtitle: currencyFormat.format(WealthApi.getCurrentWealth()),
            subtitleStyle: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
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
                      ),
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
          const DashboardTile(
            title: 'Trade Republic',
          ),
          const DashboardTile(
            title: 'Crypto',
          ),
          const DashboardTile(
            title: 'MLP-Depot',
          ),
          DashboardTile(
            title: language.cashFlow,
          ),
          DashboardTile(
            title: language.income,
            height: 240,
            fill: const DashboardTileFillLeaveTitle(),
            child: custom.PieChart(
              colorScheme: custom.PieChartColors.green,
              dataset: datasetIncome,
            ),
            sideWidget: SizedBox(
              height: 20,
              child: IconButton(
                padding: const EdgeInsets.all(0.0),
                icon: const Icon(
                  Icons.more_horiz,
                ),
                onPressed: () {
                  print("Works!");
                },
                splashRadius: 10,
              ),
            ),
          ),
          DashboardTile(
            title: language.expenses,
            fill: const DashboardTileFillLeaveTitle(),
            height: 240,
            child: custom.PieChart(
              colorScheme: custom.PieChartColors.red,
              dataset: dataset,
            ),
            sideWidget: SizedBox(
              height: 20,
              child: IconButton(
                padding: const EdgeInsets.all(0.0),
                icon: const Icon(
                  Icons.more_horiz,
                ),
                onPressed: () {
                  print("Works!");
                },
                splashRadius: 10,
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}

final datasetIncome = [
  custom.PieChartDatapoint(name: 'Support', amount: 500.00),
  custom.PieChartDatapoint(name: 'Translations', amount: 150.00),
  custom.PieChartDatapoint(name: 'Freelancing', amount: 900.00),
  custom.PieChartDatapoint(name: 'Others', amount: 900.00),
];

final dataset = [
  custom.PieChartDatapoint(name: 'Groceries', amount: 500.00),
  custom.PieChartDatapoint(name: 'Online Shopping', amount: 150.00),
  custom.PieChartDatapoint(name: 'Eating', amount: 900.00),
  custom.PieChartDatapoint(name: 'Bills', amount: 900.00),
  custom.PieChartDatapoint(name: 'Subscriptions', amount: 400.00),
  custom.PieChartDatapoint(name: 'Fees', amount: 200.50),
];

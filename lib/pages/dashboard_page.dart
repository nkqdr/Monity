import 'dart:ui';

import 'package:finance_buddy/pages/settings_page.dart';
import 'package:finance_buddy/widgets/custom_appbar.dart';
import 'package:finance_buddy/widgets/pie_chart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:finance_buddy/widgets/dashboard_tile.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
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
              ),
              DashboardTile(
                title: language.performanceTitle,
                width: DashboardTileWidth.half,
              ),
            ],
          ),
          DashboardTile(
            title: language.wealthTitle,
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
            fill: const DashboardTileFillLeaveTitle(),
            child: PieChart(
              colorScheme: PieChartColors.green,
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
            child: PieChart(
              colorScheme: PieChartColors.red,
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
  PieChartDatapoint(name: 'Support', amount: 500.00),
  PieChartDatapoint(name: 'Translations', amount: 150.00),
  PieChartDatapoint(name: 'Freelancing', amount: 900.00),
  PieChartDatapoint(name: 'Others', amount: 900.00),
];

final dataset = [
  PieChartDatapoint(name: 'Groceries', amount: 500.00),
  PieChartDatapoint(name: 'Online Shopping', amount: 150.00),
  PieChartDatapoint(name: 'Eating', amount: 900.00),
  PieChartDatapoint(name: 'Bills', amount: 900.00),
  PieChartDatapoint(name: 'Subscriptions', amount: 400.00),
  PieChartDatapoint(name: 'Fees', amount: 200.50),
];

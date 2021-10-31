import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../dashboard_tile.dart';
import '../pie_chart.dart';

class ExpensesTile extends StatelessWidget {
  const ExpensesTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    return DashboardTile(
      title: language.expenses,
      fill: const DashboardTileFillLeaveTitle(),
      height: 240,
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
    );
  }
}

final dataset = [
  PieChartDatapoint(name: 'Groceries', amount: 500.00),
  PieChartDatapoint(name: 'Online Shopping', amount: 150.00),
  PieChartDatapoint(name: 'Eating', amount: 900.00),
  PieChartDatapoint(name: 'Bills', amount: 900.00),
  PieChartDatapoint(name: 'Subscriptions', amount: 400.00),
  PieChartDatapoint(name: 'Fees', amount: 200.50),
];

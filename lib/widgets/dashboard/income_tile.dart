import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../dashboard_tile.dart';
import '../pie_chart.dart';

class IncomeTile extends StatelessWidget {
  const IncomeTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    return DashboardTile(
      title: language.income,
      height: 240,
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
    );
  }
}

final datasetIncome = [
  PieChartDatapoint(name: 'Support', amount: 500.00),
  PieChartDatapoint(name: 'Translations', amount: 150.00),
  PieChartDatapoint(name: 'Freelancing', amount: 900.00),
  PieChartDatapoint(name: 'Others', amount: 900.00),
];

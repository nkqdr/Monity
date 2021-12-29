import 'package:finance_buddy/backend/finances_database.dart';
import 'package:finance_buddy/backend/models/investment_model.dart';
import 'package:finance_buddy/backend/models/transaction_model.dart';
import 'package:finance_buddy/pages/settings_page.dart';
import 'package:finance_buddy/widgets/adaptive_progress_indicator.dart';
import 'package:finance_buddy/widgets/custom_appbar.dart';
import 'package:finance_buddy/widgets/dashboard/cashflow_tile.dart';
import 'package:finance_buddy/widgets/dashboard/current_month_tile.dart';
import 'package:finance_buddy/widgets/dashboard/piechart_tile.dart';
import 'package:finance_buddy/widgets/dashboard/performance_tile.dart';
import 'package:finance_buddy/widgets/pie_chart.dart';
import 'package:finance_buddy/widgets/view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool keyToggle = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    return View(
      appBar: CustomAppBar(
        title: language.dashboardTitle,
        right: IconButton(
          icon: const Icon(
            Icons.settings,
          ),
          splashRadius: 18,
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const SettingsPage(),
              ),
            );
            setState(() => keyToggle = !keyToggle);
          },
        ),
      ),
      fixedAppBar: true,
      safeAreaBottomDisabled: true,
      children: [
        Row(
          children: [
            CurrentMonthTile(
              key: ValueKey<bool>(keyToggle),
            ),
            const PerformanceTile(),
          ],
        ),
        if (isLoading)
          const SizedBox(
            height: 200,
            child: Center(
              child: AdaptiveProgressIndicator(),
            ),
          )
        else
          Column(
            children: [
              PieChartDashboardTile(
                title: language.income_plural,
                type: TransactionType.income,
                colorTheme: PieChartColors.green,
              ),
              PieChartDashboardTile(
                title: language.expenses,
                type: TransactionType.expense,
                colorTheme: PieChartColors.red,
              ),
              const CashFlowTile(),
              // ...investmentCategories
              //     .map((e) => DashboardTile(
              //           title: e.name,
              //         ))
              //     .toList(),
            ],
          ),
        const SizedBox(
          height: 50,
        ),
      ],
    );
  }
}

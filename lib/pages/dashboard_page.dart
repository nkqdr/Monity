import 'package:finance_buddy/backend/finances_database.dart';
import 'package:finance_buddy/backend/models/investment_model.dart';
import 'package:finance_buddy/pages/settings_page.dart';
import 'package:finance_buddy/widgets/adaptive_progress_indicator.dart';
import 'package:finance_buddy/widgets/custom_appbar.dart';
import 'package:finance_buddy/widgets/dashboard/current_month_tile.dart';
import 'package:finance_buddy/widgets/dashboard/expenses_tile.dart';
import 'package:finance_buddy/widgets/dashboard/income_tile.dart';
import 'package:finance_buddy/widgets/dashboard/performance_tile.dart';
import 'package:finance_buddy/widgets/view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:finance_buddy/widgets/dashboard_tile.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late List<InvestmentCategory> investmentCategories;
  bool keyToggle = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _refreshCategories();
  }

  Future _refreshCategories() async {
    setState(() => isLoading = true);
    investmentCategories =
        await FinancesDatabase.instance.readAllInvestmentCategories();
    setState(() => isLoading = false);
  }

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
            _refreshCategories();
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
              ...investmentCategories
                  .map((e) => DashboardTile(
                        title: e.name,
                      ))
                  .toList(),
              const IncomeTile(),
              const ExpensesTile(),
            ],
          ),
        const SizedBox(
          height: 50,
        ),
      ],
    );
  }
}

import 'package:finance_buddy/pages/settings_page.dart';
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
  bool keyToggle = false;

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
        // DashboardTile(
        //   title: language.wealthTitle,
        //   subtitle: currencyFormat.format(WealthApi.getCurrentWealth()),
        //   subtitleStyle: const TextStyle(
        //     fontSize: 20,
        //     fontWeight: FontWeight.bold,
        //   ),
        //   child: Column(
        //     children: const [
        //       SizedBox(
        //         height: 40,
        //       ),
        //       SizedBox(
        //         height: 180,
        //         child: WealthChart(),
        //       ),
        //     ],
        //   ),
        // ),
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
        const IncomeTile(),
        const ExpensesTile(),
        const SizedBox(
          height: 50,
        ),
      ],
    );
  }
}

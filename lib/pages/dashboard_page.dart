import 'package:monity/backend/models/transaction_model.dart';
import 'package:monity/helper/showcase_keys_provider.dart';
import 'package:monity/pages/settings_page.dart';
import 'package:monity/widgets/custom_appbar.dart';
import 'package:monity/widgets/custom_showcase.dart';
import 'package:monity/widgets/dashboard/cashflow_tile.dart';
import 'package:monity/widgets/dashboard/current_month_tile.dart';
import 'package:monity/widgets/dashboard/piechart_tile.dart';
import 'package:monity/widgets/dashboard/performance_tile.dart';
import 'package:monity/widgets/pie_chart.dart';
import 'package:monity/widgets/view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    var showcaseKeys = Provider.of<ShowcaseProvider>(context);
    return View(
      appBar: CustomAppBar(
        title: language.dashboardTitle,
        right: CustomShowcase(
          showcaseKey: showcaseKeys.settingsKey,
          title: language.settingsTitle,
          description: language.tap_to_view_settings,
          disposeOnTap: false,
          onTargetClick: () {
            Navigator.of(context)
                .push(
              MaterialPageRoute(
                builder: (context) => const SettingsPage(),
              ),
            )
                .then((value) {
              showcaseKeys.startTourIfNeeded(context, [showcaseKeys.currentMonthKey, showcaseKeys.transactionsKey],
                  delay: const Duration(milliseconds: 200));
            });
          },
          disableBackdropClick: true,
          child: IconButton(
            icon: Icon(
              Icons.settings,
              color: Theme.of(context).primaryColor,
            ),
            splashRadius: 18,
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
          ),
        ),
      ),
      fixedAppBar: true,
      safeAreaBottomDisabled: true,
      children: [
        Row(
          children: [
            CustomShowcase(
              title: language.good_job,
              description: language.current_month_tile_showcase,
              showcaseKey: showcaseKeys.currentMonthKey,
              child: const CurrentMonthTile(),
            ),
            const PerformanceTile(),
          ],
        ),
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
        const SizedBox(
          height: 50,
        ),
      ],
    );
  }
}

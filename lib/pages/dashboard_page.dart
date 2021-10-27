import 'dart:ui';

import 'package:finance_buddy/pages/settings_page.dart';
import 'package:finance_buddy/widgets/custom_appbar.dart';
import 'package:finance_buddy/widgets/custom_text.dart';
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
          ),
          DashboardTile(
            title: language.expenses,
          ),
          const SizedBox(
            height: 50,
          )
        ],
      ),
    );
  }
}

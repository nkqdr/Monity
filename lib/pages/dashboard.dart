import 'dart:ui';

import 'package:finance_buddy/pages/settings.dart';
import 'package:finance_buddy/widgets/custom_appbar.dart';
import 'package:finance_buddy/widgets/custom_text.dart';
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
    return SafeArea(
      bottom: false,
      child: ListView(
        children: [
          CustomAppBar(
            title: "Dashboard",
            right: IconButton(
              icon: const Icon(
                Icons.settings,
                color: Colors.white,
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
            children: const [
              DashboardTile(
                title: "Current month overview",
                width: DashboardTileWidth.half,
              ),
              DashboardTile(
                title: "Performance",
                width: DashboardTileWidth.half,
              ),
            ],
          ),
          const DashboardTile(
            title: "Wealth",
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
          const DashboardTile(
            title: "Cash Flow",
          ),
          const DashboardTile(
            title: "Income",
          ),
          const DashboardTile(
            title: "Expenses",
          ),
          const SizedBox(
            height: 50,
          )
        ],
      ),
    );
  }
}

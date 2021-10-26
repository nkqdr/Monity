import 'package:finance_buddy/pages/settings.dart';
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                width: 50,
              ),
              const CustomText(
                'Dashboard',
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(
                width: 50,
                child: IconButton(
                  icon: const Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SettingsPage(),
                      ),
                    );
                  },
                ),
              ),
            ],
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
            title: "Cash Flow",
          ),
          const DashboardTile(
            title: "Income",
          ),
          const DashboardTile(
            title: "Expenses",
          ),
        ],
      ),
    );
  }
}

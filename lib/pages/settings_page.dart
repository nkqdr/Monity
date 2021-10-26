import 'package:finance_buddy/widgets/custom_appbar.dart';
import 'package:finance_buddy/widgets/setting_nav_button.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            CustomAppBar(
              title: "Settings",
              left: IconButton(
                icon: const Icon(
                  Icons.chevron_left,
                ),
                splashRadius: 18,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const SettingNavButton(
              name: "System",
            ),
            const SettingNavButton(
              name: "Appearance",
            ),
            const SettingNavButton(
              name: "Transactions",
            ),
            const SettingNavButton(
              name: "Help",
            ),
          ],
        ),
      ),
    );
  }
}

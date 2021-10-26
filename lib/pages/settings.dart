import 'package:finance_buddy/widgets/custom_appbar.dart';
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
      backgroundColor: Colors.black, //Colors.grey[900],
      body: ListView(
        children: [
          CustomAppBar(
            title: "Settings",
            left: IconButton(
              icon: const Icon(
                Icons.chevron_left,
                color: Colors.white,
              ),
              splashRadius: 18,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}

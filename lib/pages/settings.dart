import 'package:finance_buddy/widgets/custom_text.dart';
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
      // appBar: AppBar(
      //   backgroundColor: Colors.grey[800],
      //   title: const CustomText(
      //     'Settings',
      //   ),
      //   leading: IconButton(
      //     icon: const Icon(
      //       Icons.chevron_left,
      //       color: Colors.white,
      //     ),
      //     onPressed: () {
      //       Navigator.of(context).pop();
      //     },
      //   ),
      //   shape: const RoundedRectangleBorder(
      //     borderRadius: BorderRadius.vertical(
      //       bottom: Radius.circular(20),
      //     ),
      //   ),
      // ),
      body: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 50,
                child: IconButton(
                  icon: const Icon(
                    Icons.chevron_left,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              const CustomText(
                'Settings',
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(
                width: 50,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:finance_buddy/widgets/custom_appbar.dart';
import 'package:finance_buddy/widgets/custom_text.dart';
import 'package:finance_buddy/widgets/dashboard_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WealthPage extends StatefulWidget {
  const WealthPage({Key? key}) : super(key: key);

  @override
  _WealthPageState createState() => _WealthPageState();
}

class _WealthPageState extends State<WealthPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ListView(
        children: [
          CustomAppBar(
            title: "Wealth",
            right: IconButton(
              icon: const Icon(
                Icons.add,
              ),
              splashRadius: 18,
              onPressed: () {},
            ),
          ),
          const DashboardTile(),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 15),
            child: CustomText(
              'Log:',
              color: Theme.of(context).secondaryHeaderColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          CupertinoButton(
            child: const Text(
              'View all',
              style: TextStyle(color: Colors.blue),
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

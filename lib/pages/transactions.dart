import 'package:finance_buddy/widgets/custom_appbar.dart';
import 'package:finance_buddy/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({Key? key}) : super(key: key);

  @override
  _TransactionsPageState createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ListView(
        children: [
          CustomAppBar(
            title: "Transactions",
            left: IconButton(
              icon: const Icon(
                Icons.filter_alt_rounded,
                color: Colors.white,
              ),
              splashRadius: 18,
              onPressed: () {},
            ),
            right: IconButton(
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              splashRadius: 18,
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}

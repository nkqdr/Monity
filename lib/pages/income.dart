import 'package:finance_buddy/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class IncomePage extends StatefulWidget {
  const IncomePage({Key? key}) : super(key: key);

  @override
  _IncomePageState createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CustomText(
        'IncomePage',
      ),
    );
  }
}

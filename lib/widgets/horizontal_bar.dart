import 'dart:math';

import 'package:monity/backend/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HorizontalBar extends StatelessWidget {
  final double amount;
  final double size;
  final TransactionType? type;
  final Color? color;
  const HorizontalBar({
    Key? key,
    required this.amount,
    required this.size,
    this.type,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Locale locale = Localizations.localeOf(context);
    var currencyFormat = NumberFormat.simpleCurrency(locale: locale.toString(), decimalDigits: 2);
    return Container(
      decoration: BoxDecoration(
        color: type == TransactionType.expense ? Colors.red : Colors.green,
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: _getGradient(),
        ),
      ),
      height: 40,
      width: min(max((MediaQuery.of(context).size.width / 1.1) * (amount * size), 75),
          MediaQuery.of(context).size.width - 145),
      child: Center(
        child: Text(
          currencyFormat.format(amount),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  List<Color> _getGradient() {
    if (type != null) {
      return [
        type == TransactionType.expense ? Colors.red[900] as Color : Colors.green[900] as Color,
        type == TransactionType.expense ? Colors.red : Colors.green,
      ];
    }
    assert(color != null);
    return [
      color!.withAlpha(150),
      color!,
    ];
  }
}

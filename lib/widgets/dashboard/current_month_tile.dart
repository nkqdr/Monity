import 'package:finance_buddy/widgets/dashboard_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class CurrentMonthTile extends StatelessWidget {
  const CurrentMonthTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var currencyFormat =
        NumberFormat.currency(locale: "de_DE", decimalDigits: 2, symbol: "€");
    var language = AppLocalizations.of(context)!;
    return DashboardTile(
      title: language.currentMonthOverview,
      width: DashboardTileWidth.half,
      child: Padding(
        padding: const EdgeInsets.only(top: 60, left: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              language.remainingDays,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              _getCurrentDaysRemaining(),
              style: TextStyle(
                color: Theme.of(context).secondaryHeaderColor,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              language.remainingBudget,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "+" + currencyFormat.format(352.31),
              style: const TextStyle(
                color: Colors.green,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCurrentDaysRemaining() {
    DateTime currentDate = DateTime.now();
    int numberOfDays =
        DateUtils.getDaysInMonth(currentDate.year, currentDate.month);
    int daysRemaining = numberOfDays - currentDate.day + 1;
    return daysRemaining.toString();
  }
}

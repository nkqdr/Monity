import 'package:monity/backend/finances_database.dart';
import 'package:monity/backend/key_value_database.dart';
import 'package:monity/backend/models/transaction_model.dart';
import 'package:monity/helper/config_provider.dart';
import 'package:monity/widgets/dashboard/current_month_context_menu.dart';
import 'package:monity/widgets/dashboard_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CurrentMonthTile extends StatelessWidget {
  const CurrentMonthTile({Key? key}) : super(key: key);

  Widget currentMonthContextMenu(BuildContext context, double? remainingAmount, double? monthlyLimit) {
    Locale locale = Localizations.localeOf(context);
    var currencyFormat = NumberFormat.simpleCurrency(locale: locale.toString(), decimalDigits: 2);
    var language = AppLocalizations.of(context)!;
    return CurrentMonthContextMenu(
      daysRemaining: int.parse(_getCurrentDaysRemaining()),
      remainingAmount: remainingAmount,
      monthlyLimit: monthlyLimit,
      child: DashboardTile(
        title: language.currentMonthOverview,
        width: DashboardTileWidth.half,
        child: Padding(
          padding: const EdgeInsets.only(top: 60, left: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: remainingAmount != null
                ? [
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
                      remainingAmount >= 0
                          ? "+" + currencyFormat.format(remainingAmount)
                          : currencyFormat.format(remainingAmount),
                      style: TextStyle(
                        color: remainingAmount >= 0 ? Colors.green : Colors.red,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]
                : [
                    Text(
                      language.needToSetLimit,
                      style: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor,
                      ),
                    )
                  ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double? monthlyLimit = Provider.of<ConfigProvider>(context).monthlyLimit;
    bool budgetOverflowEnabled = Provider.of<ConfigProvider>(context).budgetOverflowEnabled;
    Future<double?> remainingAmount = _getRemainingAmount(budgetOverflowEnabled, monthlyLimit);
    return FutureBuilder<double?>(
        future: remainingAmount,
        builder: (context, remaining) {
          return currentMonthContextMenu(context, remaining.data, monthlyLimit);
        });
  }

  double _getThisMonthSpentAmount(allTransactions) {
    var currentDate = DateTime.now();
    var thisMonthTransactions = allTransactions
        .where((element) => element.date.month == currentDate.month && element.date.year == currentDate.year);

    double sum = 0;
    for (var month in thisMonthTransactions) {
      if (month.type == TransactionType.expense) {
        sum += month.amount;
      }
    }
    return sum;
  }

  Future<double?> _getRemainingAmount(bool budgetOverflowEnabled, double? monthlyLimit) async {
    var currentDate = DateTime.now();
    var transactions = await FinancesDatabase.instance.readAllTransactions();
    if (transactions.isEmpty) return monthlyLimit;
    double thisMonthSpent = _getThisMonthSpentAmount(transactions);

    var lastTransaction = transactions.last;

    if (lastTransaction.date.isBefore(DateTime(currentDate.year, currentDate.month)) && budgetOverflowEnabled) {
      var previousMonthMonth = currentDate.month == 1 ? 12 : currentDate.month - 1;
      var previousMonthYear = currentDate.month == 1 ? currentDate.year - 1 : currentDate.year;

      var lastMonthTransactions = transactions
          .where((element) => element.date.month == previousMonthMonth && element.date.year == previousMonthYear);

      double lastMonthSum = 0;
      for (var month in lastMonthTransactions) {
        if (month.type == TransactionType.expense) {
          lastMonthSum += month.amount;
        }
      }
      await KeyValueDatabase.setBudgetOverflow(monthlyLimit! - lastMonthSum);
    }

    double? overflow = await KeyValueDatabase.getBudgetOverflow();
    if (overflow != null && budgetOverflowEnabled) {
      return monthlyLimit! - thisMonthSpent + overflow;
    }
    return monthlyLimit == null ? null : monthlyLimit - thisMonthSpent;
  }

  String _getCurrentDaysRemaining() {
    DateTime currentDate = DateTime.now();
    int numberOfDays = DateUtils.getDaysInMonth(currentDate.year, currentDate.month);
    int daysRemaining = numberOfDays - currentDate.day + 1;
    return daysRemaining.toString();
  }
}

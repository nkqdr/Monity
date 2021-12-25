import 'package:finance_buddy/backend/finances_database.dart';
import 'package:finance_buddy/backend/key_value_database.dart';
import 'package:finance_buddy/backend/models/transaction_model.dart';
import 'package:finance_buddy/widgets/adaptive_progress_indicator.dart';
import 'package:finance_buddy/widgets/dashboard/current_month_context_menu.dart';
import 'package:finance_buddy/widgets/dashboard_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class CurrentMonthTile extends StatefulWidget {
  const CurrentMonthTile({Key? key}) : super(key: key);

  @override
  State<CurrentMonthTile> createState() => _CurrentMonthTileState();
}

class _CurrentMonthTileState extends State<CurrentMonthTile> {
  late double? monthlyLimit;
  double? remainingAmount;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _refreshTile();
  }

  Future _refreshTile() async {
    setState(() => isLoading = true);
    monthlyLimit = await KeyValueDatabase.getMonthlyLimit();
    if (monthlyLimit != null) {
      remainingAmount = await _getRemainingAmount();
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    var currencyFormat =
        NumberFormat.currency(locale: "de_DE", decimalDigits: 2, symbol: "€");
    var language = AppLocalizations.of(context)!;
    return CurrentMonthContextMenu(
      daysRemaining: int.parse(_getCurrentDaysRemaining()),
      child: DashboardTile(
        title: language.currentMonthOverview,
        width: DashboardTileWidth.half,
        child: Padding(
          padding: const EdgeInsets.only(top: 60, left: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: isLoading
                ? const [AdaptiveProgressIndicator()]
                : remainingAmount != null
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
                          remainingAmount! >= 0
                              ? "+" + currencyFormat.format(remainingAmount)
                              : currencyFormat.format(remainingAmount),
                          style: TextStyle(
                            color: remainingAmount! >= 0
                                ? Colors.green
                                : Colors.red,
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

  Future<double> _getRemainingAmount() async {
    var currentMonth = DateTime.now().month;
    var transactions = await FinancesDatabase.instance.readAllTransactions();
    var thisMonthTransactions =
        transactions.where((element) => element.date.month == currentMonth);
    double sum = 0;
    for (var month in thisMonthTransactions) {
      if (month.type == TransactionType.expense) {
        sum += month.amount;
      }
    }
    return monthlyLimit! - sum;
  }

  String _getCurrentDaysRemaining() {
    DateTime currentDate = DateTime.now();
    int numberOfDays =
        DateUtils.getDaysInMonth(currentDate.year, currentDate.month);
    int daysRemaining = numberOfDays - currentDate.day + 1;
    return daysRemaining.toString();
  }
}

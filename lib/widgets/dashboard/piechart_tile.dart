import 'package:finance_buddy/backend/finances_database.dart';
import 'package:finance_buddy/backend/models/transaction_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:finance_buddy/widgets/adaptive_progress_indicator.dart';
import 'package:finance_buddy/widgets/dashboard_tile.dart';
import 'package:finance_buddy/widgets/pie_chart.dart';
import 'package:flutter/material.dart';

class PieChartDashboardTile extends StatefulWidget {
  final TransactionType type;
  final String title;
  final List<Color?>? colorTheme;

  const PieChartDashboardTile({
    Key? key,
    this.colorTheme,
    required this.title,
    required this.type,
  }) : super(key: key);

  @override
  State<PieChartDashboardTile> createState() => _PieChartDashboardTileState();
}

class _PieChartDashboardTileState extends State<PieChartDashboardTile> {
  bool isLoading = false;
  int dataIndex = 0; // 0 = This month, 1 = This year, 2 = max
  late List<Transaction> _transactions;
  late List<PieChartDatapoint> _datapoints;

  @override
  void initState() {
    super.initState();
    _refreshTransactions();
  }

  Future _refreshTransactions() async {
    setState(() => isLoading = true);
    _transactions = (await FinancesDatabase.instance.readAllTransactions())
        .where((element) => element.type == widget.type)
        .toList();
    switch (dataIndex) {
      case 0:
        _transactions = _transactions
            .where((element) => element.date.month == DateTime.now().month)
            .toList();
        break;
      case 1:
        _transactions = _transactions
            .where((element) => element.date.year == DateTime.now().year)
            .toList();
        break;
    }
    _datapoints = await _buildDatapoints();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    return DashboardTile(
      title: widget.title,
      subtitle: dataIndex == 0
          ? language.thisMonth
          : (dataIndex == 1 ? language.thisYear : language.maxTime),
      subtitleStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
      height: 250,
      fill: const DashboardTileFillLeaveTitle(),
      child: isLoading
          ? const Center(
              child: AdaptiveProgressIndicator(),
            )
          : PieChart(
              colorScheme: widget.colorTheme,
              dataset: _datapoints,
            ),
      sideWidget: Container(
        margin: const EdgeInsets.only(right: 15),
        child: PopupMenuButton(
          color: Colors.black,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          child: const Icon(Icons.more_horiz),
          itemBuilder: (context) => [
            PopupMenuItem(
              child: Text(language.thisMonth),
              value: 0,
            ),
            PopupMenuItem(
              child: Text(language.thisYear),
              value: 1,
            ),
            PopupMenuItem(
              child: Text(language.maxTime),
              value: 2,
            ),
          ],
          enableFeedback: true,
          onSelected: (index) {
            setState(() {
              dataIndex = index as int;
            });
            _refreshTransactions();
          },
        ),
      ),
    );
  }

  Future<List<PieChartDatapoint>> _buildDatapoints() async {
    Map<int, List<Transaction>> transactionsByCategory = {};
    for (var transaction in _transactions) {
      transactionsByCategory.putIfAbsent(transaction.categoryId, () => []);
      transactionsByCategory[transaction.categoryId]!.add(transaction);
    }
    Map<TransactionCategory, double> datapointMap = {};
    for (var key in transactionsByCategory.keys) {
      var newKey = await FinancesDatabase.instance.readTransactionCategory(key);
      if (newKey == null) continue;
      datapointMap.putIfAbsent(
          newKey,
          () => transactionsByCategory[key]!.fold(
              0, (previousValue, element) => previousValue + element.amount));
    }
    assert(transactionsByCategory.keys.length == datapointMap.keys.length);
    List<PieChartDatapoint> datapoints = [];
    for (var category in datapointMap.keys) {
      datapoints.add(
        PieChartDatapoint(
          name: category.name,
          amount: datapointMap[category]!,
        ),
      );
    }
    return datapoints;
  }
}

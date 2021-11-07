import 'package:finance_buddy/backend/finances_database.dart';
import 'package:finance_buddy/backend/models/transaction_model.dart';
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
    _datapoints = await _buildDatapoints();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return DashboardTile(
      title: widget.title,
      height: 240,
      fill: const DashboardTileFillLeaveTitle(),
      child: isLoading
          ? const Center(
              child: AdaptiveProgressIndicator(),
            )
          : PieChart(
              colorScheme: widget.colorTheme,
              dataset: _datapoints,
            ),
      sideWidget: SizedBox(
        height: 20,
        child: IconButton(
          padding: const EdgeInsets.all(0.0),
          icon: const Icon(
            Icons.more_horiz,
          ),
          onPressed: () {
            print("Works!");
          },
          splashRadius: 10,
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

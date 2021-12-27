import 'package:finance_buddy/backend/finances_database.dart';
import 'package:finance_buddy/helper/types.dart';
import 'package:finance_buddy/widgets/dashboard/performance_context_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../dashboard_tile.dart';

class PerformanceTile extends StatefulWidget {
  const PerformanceTile({Key? key}) : super(key: key);

  @override
  State<PerformanceTile> createState() => _PerformanceTileState();
}

class _PerformanceTileState extends State<PerformanceTile> {
  int dataIndex = 0;
  double currentPerformance = 0;
  List<WealthDataPoint> dataPoints = [];

  @override
  void initState() {
    super.initState();
    _refreshPerformance();
  }

  Future _refreshPerformance() async {
    var dataPointsList =
        await FinancesDatabase.instance.getAllWealthDatapoints();
    setState(() {
      dataPoints = dataPointsList;
    });
    if (dataPoints.isEmpty) {
      return;
    }
    switch (dataIndex) {
      case 0:
        double firstDataPoint = dataPoints
            .where((e) =>
                e.time.year == DateTime.now().year &&
                e.time.month == DateTime.now().month)
            .first
            .value;
        double lastDataPoint = dataPoints
            .where((e) =>
                e.time.year == DateTime.now().year &&
                e.time.month == DateTime.now().month)
            .last
            .value;
        var currentDifference = lastDataPoint - firstDataPoint;
        setState(() {
          currentPerformance = currentDifference / firstDataPoint;
        });
        break;
      case 1:
        double firstDataPoint = dataPoints
            .where((e) => e.time.year == DateTime.now().year)
            .first
            .value;
        double lastDataPoint = dataPoints
            .where((e) => e.time.year == DateTime.now().year)
            .last
            .value;
        var currentDifference = lastDataPoint - firstDataPoint;
        setState(() {
          currentPerformance = currentDifference / firstDataPoint;
        });
        break;
      default:
        var currentDifference = dataPoints.last.value - dataPoints.first.value;
        setState(() {
          currentPerformance = currentDifference / dataPoints.first.value;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    return PerformanceContextMenu(
      child: DashboardTile(
        title: language.performanceTitle,
        subtitle: dataIndex == 0
            ? language.thisMonth
            : (dataIndex == 1 ? language.thisYear : language.maxTime),
        subtitleStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        width: DashboardTileWidth.half,
        sideWidget: Container(
          margin: const EdgeInsets.only(right: 15),
          child: PopupMenuButton(
            color: Theme.of(context).scaffoldBackgroundColor,
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
              _refreshPerformance();
            },
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 80.0, left: 15, bottom: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                currentPerformance >= 0
                    ? Icons.arrow_upward_rounded
                    : Icons.arrow_downward_rounded,
                size: 60,
                color: currentPerformance >= 0 ? Colors.green : Colors.red,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "${currentPerformance >= 0 ? "+" : ""}${(currentPerformance * 100).toStringAsFixed(1)}%",
                style: TextStyle(
                  color: currentPerformance >= 0 ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:finance_buddy/backend/finances_database.dart';
import 'package:finance_buddy/backend/models/transaction_model.dart';
import 'package:finance_buddy/l10n/language_provider.dart';
import 'package:finance_buddy/widgets/dashboard_tile.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CashFlowTile extends StatefulWidget {
  const CashFlowTile({Key? key}) : super(key: key);

  @override
  State<CashFlowTile> createState() => _CashFlowTileState();
}

class _CashFlowTileState extends State<CashFlowTile> {
  int dataIndex = 0;
  late List<Transaction> allTransactions;
  double? titleNum;
  String? subtitle;
  VerticalLine? _indexLine;
  List<FlSpot> dataPoints = [];
  List<DateTime> dates = [];

  @override
  void initState() {
    super.initState();
    _initHelper();
  }

  Future _initHelper() async {
    await _fetchTransactions();
    _refreshDataPoints();
  }

  Future _fetchTransactions() async {
    allTransactions = await FinancesDatabase.instance.readAllTransactions();
  }

  Future _refreshDataPoints() async {
    List<Transaction> transactions;
    switch (dataIndex) {
      case 0:
        transactions = allTransactions
            .where((element) =>
                element.date.month == DateTime.now().month &&
                element.date.year == DateTime.now().year)
            .toList();
        break;
      case 1:
        transactions = allTransactions
            .where((element) => element.date.year == DateTime.now().year)
            .toList();
        break;
      default:
        transactions = allTransactions;
    }
    if (transactions.isEmpty) {
      return;
    }
    DateTime currentTime = transactions.first.date;
    List<double> days = [];
    List<DateTime> newDates = [];
    double currentValue = 0;
    for (var i = 0; i < transactions.length; i++) {
      if (transactions[i].date.day == currentTime.day &&
          transactions[i].date.month == currentTime.month &&
          transactions[i].date.year == currentTime.year) {
        if (transactions[i].type == TransactionType.income) {
          currentValue += transactions[i].amount;
        } else {
          currentValue -= transactions[i].amount;
        }
      } else {
        days.add(currentValue);
        newDates.add(transactions[i - 1].date);
        currentTime = transactions[i].date;
        i--;
      }
    }
    newDates.add(transactions.last.date);
    days.add(currentValue);
    assert(newDates.length == days.length);
    List<FlSpot> newDataPoints = [const FlSpot(0, 0)];
    for (var i = 0; i < days.length; i++) {
      newDataPoints.add(FlSpot((i + 1).toDouble(), days[i]));
    }
    setState(() {
      dataPoints = newDataPoints;
      dates = newDates;
    });
  }

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    final provider = Provider.of<LanguageProvider>(context);
    DateFormat dateFormat;
    if (provider.locale == null) {
      dateFormat =
          DateFormat.yMMMMd(Localizations.localeOf(context).toString());
    } else {
      dateFormat = DateFormat.yMMMMd(provider.locale!.languageCode);
    }
    var currencyFormat =
        NumberFormat.currency(locale: "de_DE", decimalDigits: 2, symbol: "€");
    return DashboardTile(
      subtitle: titleNum != null
          ? currencyFormat.format(titleNum)
          : (dataIndex == 0
              ? language.thisMonth
              : (dataIndex == 1 ? language.thisYear : language.maxTime)),
      title: subtitle ?? language.cashFlow,
      subtitleStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
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
            _refreshDataPoints();
          },
        ),
      ),
      fill: const DashboardTileFillLeaveTitle(),
      height: 250,
      child: Flexible(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: dataPoints.isNotEmpty
              ? CashFlowChart(
                  maxValue: _getMaxValue(),
                  spots: dataPoints,
                  touchHandler: (e, v) => _handleChartTouch(e, v, dateFormat),
                  indexLine: _indexLine,
                )
              : Container(),
        ),
      ),
    );
  }

  double abs(double x) {
    return x < 0 ? -x : x;
  }

  double _getMaxValue() {
    double max = 0;
    for (var dp in dataPoints) {
      if (abs(dp.y) >= max) {
        max = abs(dp.y);
      }
    }
    return max;
  }

  DateTime _getStartForInterval() {
    switch (dataIndex) {
      case 0:
        return DateTime(DateTime.now().year, DateTime.now().month, 1);
      case 1:
        return DateTime(DateTime.now().year, 1, 1);
      default:
        return allTransactions.first.date;
    }
  }

  void _handleChartTouch(
      FlTouchEvent event, LineTouchResponse? response, DateFormat dateFormat) {
    if (event is FlTapUpEvent ||
        event is FlPanCancelEvent ||
        event is FlPanEndEvent ||
        event is FlLongPressEnd) {
      setState(() {
        subtitle = null;
        _indexLine = null;
        titleNum = null;
      });
      return;
    }

    if (response != null && response.lineBarSpots != null) {
      var value = response.lineBarSpots?[0].y;
      if (value != null && value != titleNum) {
        var index = response.lineBarSpots?[0].x.toInt() as int;
        HapticFeedback.mediumImpact();
        setState(() {
          titleNum = value;
          subtitle = index > 0
              ? dateFormat.format(dates[index - 1])
              : dateFormat.format(_getStartForInterval());
          _indexLine = VerticalLine(
            x: response.lineBarSpots?[0].x as double,
            color: Theme.of(context).secondaryHeaderColor,
            strokeWidth: 1,
          );
        });
      }
    }
  }
}

class CashFlowChart extends StatefulWidget {
  final List<FlSpot> spots;
  final double maxValue;
  final VerticalLine? indexLine;
  final void Function(FlTouchEvent, LineTouchResponse?)? touchHandler;

  const CashFlowChart({
    Key? key,
    required this.spots,
    required this.maxValue,
    this.indexLine,
    this.touchHandler,
  })  : assert(maxValue >= 0),
        assert(spots.length > 0),
        super(key: key);

  @override
  _CashFlowChartState createState() => _CashFlowChartState();
}

class _CashFlowChartState extends State<CashFlowChart> {
  final double cutOffYValue = 0.0;
  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        minX: 0,
        maxX: widget.spots.length - 1,
        minY: -widget.maxValue,
        maxY: widget.maxValue,
        backgroundColor: Theme.of(context).cardColor,
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            HorizontalLine(
              y: 0,
              color: Theme.of(context).secondaryHeaderColor,
            )
          ],
          verticalLines: widget.indexLine != null ? [widget.indexLine!] : [],
        ),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: false),
        lineTouchData: LineTouchData(
          enabled: false,
          touchCallback: widget.touchHandler,
        ),
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            preventCurveOverShooting: true,
            belowBarData: BarAreaData(
              show: true,
              colors: [Colors.green.withOpacity(0.4)],
              cutOffY: cutOffYValue,
              applyCutOffY: true,
            ),
            aboveBarData: BarAreaData(
              show: true,
              colors: [Colors.red.withOpacity(0.4)],
              cutOffY: cutOffYValue,
              applyCutOffY: true,
            ),
            dotData: FlDotData(show: false),
            barWidth: 4,
            colors: [_getLineColor()],
            spots: widget.spots,
          )
        ],
      ),
    );
  }

  FlSpot _getLastRelevantSpot() {
    for (var i = 1; i < widget.spots.length; i++) {
      if (widget.spots[i].y == 0) {
        return widget.spots[i - 1];
      }
    }
    return widget.spots.last;
  }

  Color _getLineColor() {
    var spot = _getLastRelevantSpot();

    return spot.y >= 0 ? Colors.green : Colors.red;
  }
}

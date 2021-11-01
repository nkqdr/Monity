import 'package:finance_buddy/controller/wealth_api.dart';
import 'package:finance_buddy/helper/wealth_entry.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WealthChart extends StatefulWidget {
  final VerticalLine? indexLine;
  final void Function(FlTouchEvent, LineTouchResponse?)? touchHandler;
  const WealthChart({
    Key? key,
    this.indexLine,
    this.touchHandler,
  }) : super(key: key);

  @override
  State<WealthChart> createState() => _WealthChartState();
}

class _WealthChartState extends State<WealthChart> {
  List<WealthEntry> wealthEntries = [];

  @override
  void initState() {
    super.initState();
    wealthEntries = WealthApi.getAllEntries();
  }

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        backgroundColor: Theme.of(context).cardColor,
        minX: 0,
        maxX: wealthEntries.length - 1,
        minY: _getMinYValue(),
        maxY: WealthApi.getMaxLineChartValue() + 1,
        extraLinesData: ExtraLinesData(
          verticalLines: widget.indexLine != null
              ? [widget.indexLine as VerticalLine]
              : [],
          horizontalLines:
              _getZeroLine() != null ? [_getZeroLine() as HorizontalLine] : [],
        ),
        titlesData: FlTitlesData(
          show: false,
        ),
        lineTouchData: LineTouchData(
          enabled: false,
          touchCallback: widget.touchHandler,
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: false),
        lineBarsData: [
          LineChartBarData(
              isCurved: true,
              preventCurveOverShooting: true,
              belowBarData: BarAreaData(show: false),
              dotData: FlDotData(show: false),
              barWidth: 4,
              colors: [_getLineColor()],
              spots: wealthEntries.asMap().entries.map((e) {
                return FlSpot(
                  e.key.toDouble(),
                  e.value.amount / WealthApi.getDivisor(),
                );
              }).toList())
        ],
      ),
    );
  }

  Color _getLineColor() {
    return WealthApi.getCurrentWealth() < 0 ? Colors.red : Colors.green;
  }

  HorizontalLine? _getZeroLine() {
    return _getMinYValue() < 0
        ? HorizontalLine(
            y: 0,
            color: Theme.of(context).secondaryHeaderColor,
          )
        : null;
  }

  double _getMinYValue() {
    var minValue = WealthApi.getMinValue();
    return minValue >= 0
        ? 0
        : (minValue + (minValue * 0.1)) / WealthApi.getDivisor();
  }
}

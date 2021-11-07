import 'package:finance_buddy/backend/models/investment_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import 'package:flutter/material.dart';

class WealthChart extends StatefulWidget {
  final VerticalLine? indexLine;
  final void Function(FlTouchEvent, LineTouchResponse?)? touchHandler;
  final num divisor;
  final List<InvestmentSnapshot> snapshots;
  final double currentWealth;
  final List<FlSpot> spots;

  const WealthChart({
    Key? key,
    this.indexLine,
    this.touchHandler,
    required this.spots,
    required this.divisor,
    required this.snapshots,
    required this.currentWealth,
  }) : super(key: key);

  @override
  State<WealthChart> createState() => _WealthChartState();
}

class _WealthChartState extends State<WealthChart> {
  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        backgroundColor: Theme.of(context).cardColor,
        minX: 0,
        maxX: widget.spots.length - 1,
        minY: _getMinYValue(),
        maxY: _getMaxLineChartValue() + 1,
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
            spots: widget.spots, //?? spots,
          )
        ],
      ),
    );
  }

  Color _getLineColor() {
    return widget.currentWealth < 0 ? Colors.red : Colors.green;
  }

  double _getMaxLineChartValue() {
    double max = 0;
    for (var item in widget.spots) {
      if (item.y > max) {
        max = item.y;
      }
    }
    int digits = 0;
    int maxInt = max.ceil();
    while (maxInt > 1) {
      print("Iterating #1");
      maxInt = (maxInt / 10).floor();
      digits++;
    }
    return max / pow(10, digits - 1);
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
    var minValue = _getMinValue();
    return minValue >= 0
        ? minValue / widget.divisor
        : (minValue + (minValue * 0.1)) / widget.divisor;
  }

  double _getMinValue() {
    double min = double.maxFinite;
    for (var item in widget.snapshots) {
      if (item.amount < min) {
        min = item.amount;
      }
    }
    return min;
  }
}

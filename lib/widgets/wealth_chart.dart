import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import 'package:flutter/material.dart';

class WealthChart extends StatefulWidget {
  final VerticalLine? indexLine;
  final void Function(FlTouchEvent, LineTouchResponse?)? touchHandler;
  final num divisor;
  final double currentWealth;
  final List<FlSpot> spots;

  const WealthChart({
    Key? key,
    this.indexLine,
    this.touchHandler,
    required this.spots,
    required this.divisor,
    required this.currentWealth,
  }) : super(key: key);

  @override
  State<WealthChart> createState() => _WealthChartState();
}

class _WealthChartState extends State<WealthChart> {
  late double maxLineChartValue;
  @override
  void initState() {
    super.initState();
    _setMaxLineChartValue();
  }

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        backgroundColor: Colors.transparent,
        minX: 0,
        maxX: widget.spots.length - 1,
        minY: _getMinYValue(),
        maxY: maxLineChartValue + 1,
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
    var firstValue =
        widget.spots.isEmpty ? 0 : widget.spots[0].y * widget.divisor;
    return widget.currentWealth < firstValue ? Colors.red : Colors.green;
  }

  void _setMaxLineChartValue() {
    double max = 0;
    for (var item in widget.spots) {
      if (item.y > max) {
        max = item.y;
      }
    }
    int digits = 0;
    int maxInt = max.ceil();
    while (maxInt > 1) {
      maxInt = (maxInt / 10).floor();
      digits++;
    }
    setState(() {
      maxLineChartValue = max / pow(10, digits - 1);
    });
  }

  HorizontalLine? _getZeroLine() {
    var firstValue = widget.spots.isEmpty ? 0 : widget.spots[0].y;

    return _getMinYValue() < firstValue
        ? HorizontalLine(
            y: widget.spots[0].y,
            color: Theme.of(context).secondaryHeaderColor,
          )
        : null;
  }

  double _getMinYValue() {
    var minValue = _getMinValue();
    var firstValue = widget.spots.isEmpty ? 0.0 : widget.spots[0].y;
    var returnValue = minValue >= firstValue
        ? firstValue //minValue / widget.divisor
        : (minValue + (minValue * 0.5)); // / widget.divisor;
    return returnValue;
  }

  double _getMinValue() {
    double min = double.maxFinite;
    for (var item in widget.spots.skip(1)) {
      if (item.y < min) {
        min = item.y;
      }
    }
    return min;
  }
}

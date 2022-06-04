import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WealthChart extends StatelessWidget {
  final VerticalLine? indexLine;
  final void Function(FlTouchEvent, LineTouchResponse?)? touchHandler;
  final double currentWealth;
  final List<FlSpot> spots;

  const WealthChart({
    Key? key,
    this.indexLine,
    this.touchHandler,
    required this.spots,
    required this.currentWealth,
  }) : super(key: key);

  Color _getLineColor(BuildContext context) {
    var firstValue = spots.isEmpty ? 0 : spots.first.y;
    return currentWealth < firstValue ? Theme.of(context).errorColor : Theme.of(context).hintColor;
  }

  HorizontalLine? _getZeroLine(BuildContext context, double minLineChartValue) {
    var firstValue = spots.isEmpty ? 0 : spots.first.y;
    return minLineChartValue < firstValue
        ? HorizontalLine(
            y: spots.first.y,
            color: Theme.of(context).secondaryHeaderColor,
            strokeWidth: 1,
            dashArray: [5],
          )
        : null;
  }

  @override
  Widget build(BuildContext context) {
    // Calculate min and max
    double minValue = double.maxFinite;
    double maxValue = -double.maxFinite;
    for (var item in spots) {
      if (item.y < minValue) {
        minValue = item.y;
      }
      if (item.y > maxValue) {
        maxValue = item.y;
      }
    }
    assert(minValue <= maxValue);

    var zeroLine = _getZeroLine(context, minValue);
    return LineChart(
      LineChartData(
        backgroundColor: Colors.transparent,
        minX: 0,
        maxX: spots.length - 1,
        minY: minValue,
        maxY: maxValue,
        extraLinesData: ExtraLinesData(
          verticalLines: indexLine != null ? [indexLine as VerticalLine] : [],
          horizontalLines: zeroLine != null ? [zeroLine] : [],
        ),
        titlesData: FlTitlesData(
          show: false,
        ),
        lineTouchData: LineTouchData(
          enabled: false,
          touchCallback: touchHandler,
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: false),
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            preventCurveOverShooting: true,
            belowBarData: BarAreaData(show: false),
            dotData: FlDotData(show: false),
            barWidth: 3,
            colors: [_getLineColor(context)],
            spots: spots,
          )
        ],
      ),
    );
  }
}

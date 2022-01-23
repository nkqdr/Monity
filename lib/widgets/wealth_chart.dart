import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WealthChart extends StatefulWidget {
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

  @override
  State<WealthChart> createState() => _WealthChartState();
}

class _WealthChartState extends State<WealthChart> {
  late double maxLineChartValue;
  late double minLineChartValue;
  @override
  void initState() {
    super.initState();
    _setMinMaxValues();
  }

  @override
  void didUpdateWidget(covariant WealthChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    _setMinMaxValues();
  }

  @override
  Widget build(BuildContext context) {
    // var language = AppLocalizations.of(context)!;
    // if (widget.spots.isEmpty) {
    //   return Center(
    //     child: Text(
    //       language.noDatapointsForSelectedPeriod,
    //       textAlign: TextAlign.center,
    //       style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
    //     ),
    //   );
    // }
    return LineChart(
      LineChartData(
        backgroundColor: Colors.transparent,
        minX: 0,
        maxX: widget.spots.length - 1,
        minY: minLineChartValue,
        maxY: maxLineChartValue,
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

  void _setMinMaxValues() {
    // Calculate min
    double minValue = double.maxFinite;
    for (var item in widget.spots) {
      if (item.y < minValue) {
        minValue = item.y;
      }
    }
    // Calculate max
    double maxValue = -double.maxFinite;
    for (var item in widget.spots) {
      if (item.y > maxValue) {
        maxValue = item.y;
      }
    }
    // var firstValue = widget.spots.isEmpty ? 0.0 : widget.spots.first.y;
    // var returnValue =
    //     minValue >= firstValue ? firstValue : (minValue + (minValue * 0.5));
    assert(minValue <= maxValue);
    setState(() {
      minLineChartValue = minValue;
      maxLineChartValue = maxValue;
    });
  }

  Color _getLineColor() {
    var firstValue = widget.spots.isEmpty ? 0 : widget.spots.first.y;
    return widget.currentWealth < firstValue ? Colors.red : Colors.green;
  }

  HorizontalLine? _getZeroLine() {
    var firstValue = widget.spots.isEmpty ? 0 : widget.spots[0].y;
    return minLineChartValue < firstValue
        ? HorizontalLine(
            y: widget.spots[0].y,
            color: Theme.of(context).secondaryHeaderColor,
          )
        : null;
  }
}

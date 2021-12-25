import 'package:finance_buddy/widgets/custom_cupertino_context_menu_action.dart';
import 'package:finance_buddy/widgets/pie_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class PieChartTileContextMenu extends StatefulWidget {
  final Widget child;
  final String timeInterval;
  final String title;
  final List<PieChartDatapoint> dataPoints;
  const PieChartTileContextMenu({
    Key? key,
    required this.child,
    required this.title,
    required this.timeInterval,
    required this.dataPoints,
  }) : super(key: key);

  @override
  State<PieChartTileContextMenu> createState() =>
      _PieChartTileContextMenuState();
}

class _PieChartTileContextMenuState extends State<PieChartTileContextMenu> {
  double totalSum = 0;

  @override
  void initState() {
    super.initState();
    for (var dp in widget.dataPoints) {
      totalSum += dp.amount;
    }
  }

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    var currencyFormat =
        NumberFormat.simpleCurrency(locale: "de_DE", decimalDigits: 2);
    return CupertinoContextMenu(
      previewBuilder: (context, animation, child) {
        return Material(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 40,
            height: MediaQuery.of(context).size.height / 3,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          widget.timeInterval,
                          style: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ...widget.dataPoints.map(
                      (e) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            e.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                currencyFormat.format(e.amount),
                                style: TextStyle(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(" - (" +
                                  (e.amount / totalSum * 100)
                                      .toStringAsFixed(1) +
                                  "%)"),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
      actions: [
        CustomCupertinoContextMenuAction(
          child: Text(language.hide),
          trailingIcon: CupertinoIcons.eye_slash,
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
      child: SingleChildScrollView(
        child: widget.child,
      ),
    );
  }
}

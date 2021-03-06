import 'package:monity/backend/models/transaction_model.dart';
import 'package:monity/widgets/custom_cupertino_context_menu_action.dart';
import 'package:monity/widgets/horizontal_bar.dart';
import 'package:monity/widgets/pie_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PieChartTileContextMenu extends StatefulWidget {
  final Widget child;
  final String timeInterval;
  final String title;
  final List<PieChartDatapoint> dataPoints;
  final TransactionType transactionType;
  const PieChartTileContextMenu({
    Key? key,
    required this.child,
    required this.title,
    required this.timeInterval,
    required this.dataPoints,
    required this.transactionType,
  }) : super(key: key);

  @override
  State<PieChartTileContextMenu> createState() => _PieChartTileContextMenuState();
}

class _PieChartTileContextMenuState extends State<PieChartTileContextMenu> {
  double totalSum = 0;
  late double barSizeConst; //(e.amount / totalSum);
  double barSize = 0;
  bool showPercentage = false;

  @override
  void initState() {
    super.initState();
    _refreshTotalSum();
  }

  void _refreshTotalSum() {
    double sum = 0;
    for (var dp in widget.dataPoints) {
      sum += dp.amount;
    }
    barSizeConst = 1 / sum;
    setState(() {
      totalSum = sum;
      barSize = barSizeConst;
    });
  }

  @override
  void didUpdateWidget(covariant PieChartTileContextMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    _refreshTotalSum();
  }

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;

    return CupertinoContextMenu(
      previewBuilder: (context, animation, child) {
        animation.addListener(() {
          if (animation.value == 1) {
            setState(() {
              showPercentage = true;
            });
          } else {
            setState(() {
              showPercentage = false;
            });
          }
          setState(() {
            barSize = animation.value * barSizeConst;
          });
        });
        return Material(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(15),
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 40,
            height: MediaQuery.of(context).size.height / 3,
            child: Padding(
              padding: const EdgeInsets.only(
                //top: 20.0,
                left: 20.0,
                right: 20.0,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 20.0),
                      child: Row(
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
                    ),
                    if (widget.dataPoints.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 90.0),
                        child: Center(
                          child: Text(
                            language.noTransactionsPieChart,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor,
                            ),
                          ),
                        ),
                      ),
                    ...widget.dataPoints.map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                HorizontalBar(
                                  amount: e.amount,
                                  size: barSize,
                                  type: widget.transactionType,
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                showPercentage
                                    ? Text(
                                        (e.amount / totalSum * 100).toStringAsFixed(1) + "%",
                                        style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
                                      )
                                    : Container(),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
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

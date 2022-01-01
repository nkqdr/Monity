import 'dart:math';

import 'package:finance_buddy/backend/finances_database.dart';
import 'package:finance_buddy/helper/types.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../custom_cupertino_context_menu_action.dart';

class PerformanceContextMenu extends StatefulWidget {
  final Widget child;
  const PerformanceContextMenu({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  _PerformanceContextMenuState createState() => _PerformanceContextMenuState();
}

class _PerformanceContextMenuState extends State<PerformanceContextMenu> {
  static const double numberFormatThreshold = 1000000000000;
  static const List<int> predictionDistances = [1, 5, 25];
  late List<WealthDataPoint> predictions = [];
  bool showDescription = false;
  bool showTable = true;

  @override
  void initState() {
    super.initState();
    _calculateWealthPredictions();
  }

  Future _calculateWealthPredictions() async {
    List<WealthDataPoint> allDataPoints =
        await FinancesDatabase.instance.getAllWealthDatapoints();
    if (allDataPoints.isEmpty) {
      predictions = [];
      return;
    }
    WealthDataPoint oneYearAgo = allDataPoints.lastWhere(
        (e) => e.time.isBefore(DateTime(
            DateTime.now().year - 1, DateTime.now().month, DateTime.now().day)),
        orElse: () => allDataPoints.isEmpty
            ? WealthDataPoint(time: DateTime.now(), value: 0)
            : allDataPoints.first);
    WealthDataPoint currentWealth = allDataPoints.isEmpty
        ? WealthDataPoint(time: DateTime.now(), value: 0)
        : allDataPoints.last;
    var difference = currentWealth.value - oneYearAgo.value;
    var percentageDiff = difference / oneYearAgo.value;
    for (var distance in predictionDistances) {
      double predictionValue = currentWealth.value *
          pow((100 + (percentageDiff * 100)) / 100, distance);
      predictions.add(WealthDataPoint(
          time: DateTime(DateTime.now().year + distance),
          value: predictionValue));
    }
  }

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    Locale locale = Localizations.localeOf(context);
    NumberFormat currencyFormat;
    if (predictions.isEmpty) {
      currencyFormat = NumberFormat.compactCurrency(
          locale: locale.toString(), decimalDigits: 2);
    } else {
      currencyFormat = predictions.last.value < numberFormatThreshold
          ? NumberFormat.simpleCurrency(
              locale: locale.toString(), decimalDigits: 2)
          : NumberFormat.compactSimpleCurrency(
              locale: locale.toString(), decimalDigits: 2);
    }
    return CupertinoContextMenu(
      previewBuilder: (context, animation, child) {
        animation.addListener(() {
          if (animation.value >= 0.6) {
            setState(() => showDescription = true);
          } else {
            setState(() => showDescription = false);
          }
          if (animation.value <= 0.5) {
            setState(() => showTable = false);
          } else {
            setState(() => showTable = true);
          }
        });
        return Material(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 40,
            height: MediaQuery.of(context).size.height / 3,
            child: Padding(
                padding:
                    const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        language.performanceTitle,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (showDescription)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            language.predictionOfWealth,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context)
                                  .secondaryHeaderColor
                                  .withOpacity(animation.value),
                            ),
                          ),
                        ),
                      if (showTable && predictions.isNotEmpty)
                        ...predictions.map((e) => Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        (e.time.year - DateTime.now().year)
                                                .toString() +
                                            " ${(e.time.year - DateTime.now().year) == 1 ? language.year : language.years}:",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          currencyFormat.format(e.value),
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Theme.of(context)
                                                .hintColor
                                                .withOpacity(animation.value),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Container(
                                //   height: 1,
                                //   color: Theme.of(context).secondaryHeaderColor,
                                // ),
                              ],
                            )),
                      if (predictions.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Center(
                            child: Text(language.notEnoughSnapshots,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Theme.of(context).secondaryHeaderColor,
                                )),
                          ),
                        ),
                    ],
                  ),
                )),
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
        ),
      ],
      child: SingleChildScrollView(
        child: widget.child,
      ),
    );
  }
}

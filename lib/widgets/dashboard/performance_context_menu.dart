import 'dart:math';

import 'package:monity/backend/finances_database.dart';
import 'package:monity/helper/types.dart';
import 'package:monity/widgets/adaptive_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../custom_cupertino_context_menu_action.dart';

class PerformanceContextMenu extends StatelessWidget {
  static const double numberFormatThreshold = 1000000000000;
  static const double maximumAmountOfMoney = 100000000000000;
  static const List<int> predictionDistances = [1, 5, 25];

  final Widget child;
  const PerformanceContextMenu({
    Key? key,
    required this.child,
  }) : super(key: key);

  Future<List<WealthDataPoint>> _calculatePredictions() async {
    List<WealthDataPoint> predictions = [];
    List<WealthDataPoint> allDataPoints = await FinancesDatabase.instance.getAllWealthDatapoints();

    if (allDataPoints.isEmpty) return predictions;

    WealthDataPoint oneYearAgo = allDataPoints.lastWhere(
        (e) => e.time.isBefore(DateTime(DateTime.now().year - 1, DateTime.now().month, DateTime.now().day)),
        orElse: () => allDataPoints.isEmpty ? WealthDataPoint(time: DateTime.now(), value: 0) : allDataPoints.first);
    WealthDataPoint currentWealth =
        allDataPoints.isEmpty ? WealthDataPoint(time: DateTime.now(), value: 0) : allDataPoints.last;
    var difference = currentWealth.value - oneYearAgo.value;
    var percentageDiff = difference / oneYearAgo.value;
    for (var distance in predictionDistances) {
      double predictionValue = currentWealth.value * pow((100 + (percentageDiff * 100)) / 100, distance);
      predictions.add(WealthDataPoint(
          time: DateTime(DateTime.now().year + distance),
          value: predictionValue < maximumAmountOfMoney ? predictionValue : maximumAmountOfMoney));
    }
    return predictions;
  }

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    Locale locale = Localizations.localeOf(context);
    Future<List<WealthDataPoint>> predictions = _calculatePredictions();
    bool showDescription = false;
    bool showTable = true;
    NumberFormat currencyFormat;
    return FutureBuilder<List<WealthDataPoint>>(
      future: predictions,
      builder: (context, predList) {
        if (!predList.hasData) return const AdaptiveProgressIndicator();

        if (predList.data!.isEmpty) {
          currencyFormat = NumberFormat.compactCurrency(locale: locale.toString(), decimalDigits: 2);
        } else {
          currencyFormat = predList.data!.last.value < numberFormatThreshold
              ? NumberFormat.simpleCurrency(locale: locale.toString(), decimalDigits: 2)
              : NumberFormat.compactSimpleCurrency(locale: locale.toString(), decimalDigits: 2);
        }
        return CupertinoContextMenu(
          previewBuilder: (context, animation, child) {
            animation.addListener(() {
              if (animation.value >= 0.6) {
                showDescription = true;
              } else {
                showDescription = false;
              }
              if (animation.value <= 0.5) {
                showTable = false;
              } else {
                showTable = true;
              }
            });
            return Material(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(15),
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 40,
                height: MediaQuery.of(context).size.height / 3,
                child: Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
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
                                  color: Theme.of(context).secondaryHeaderColor.withOpacity(animation.value),
                                ),
                              ),
                            ),
                          if (showTable && predList.data!.isNotEmpty)
                            ...predList.data!.map((e) => Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            (e.time.year - DateTime.now().year).toString() +
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
                                                color: Theme.of(context).hintColor.withOpacity(animation.value),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                          if (predList.data!.isEmpty)
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
                          if (predList.data!.isNotEmpty && predList.data!.last.value == maximumAmountOfMoney)
                            Text(
                              language.richestManOnEarth,
                              style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
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
            child: child,
          ),
        );
      },
    );
  }
}

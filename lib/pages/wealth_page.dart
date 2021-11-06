import 'package:finance_buddy/backend/finances_database.dart';
import 'package:finance_buddy/backend/models/investment_model.dart';
import 'package:finance_buddy/l10n/language_provider.dart';
import 'package:finance_buddy/widgets/adaptive_progress_indicator.dart';
import 'package:finance_buddy/widgets/add_snapshot_bottom_sheet.dart';
import 'package:finance_buddy/widgets/custom_appbar.dart';
import 'package:finance_buddy/widgets/dashboard_tile.dart';
import 'package:finance_buddy/widgets/investment_tile.dart';
import 'package:finance_buddy/widgets/view.dart';
import 'package:finance_buddy/widgets/wealth_chart.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class WealthPage extends StatefulWidget {
  const WealthPage({Key? key}) : super(key: key);

  @override
  _WealthPageState createState() => _WealthPageState();
}

class _WealthPageState extends State<WealthPage> {
  late double displayWealth;
  VerticalLine? _indexLine;
  String? subtitle;
  late List<InvestmentCategory> categories;
  late List<InvestmentSnapshot> snapshots;
  late List<double> yValues;
  late List<DateTime> xValues;
  bool isLoading = false;
  bool wealthChartKey = false;

  @override
  void initState() {
    super.initState();
    _refreshCategories();
  }

  Future _refreshCategories() async {
    setState(() => isLoading = true);
    categories = await FinancesDatabase.instance.readAllInvestmentCategories();
    snapshots = await FinancesDatabase.instance.readAllInvestmentSnapshots();
    _setChartData();
    displayWealth = yValues.last;
    wealthChartKey = !wealthChartKey;
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LanguageProvider>(context);
    DateFormat dateFormatter;
    if (provider.locale == null) {
      dateFormatter =
          DateFormat.yMMMMd(Localizations.localeOf(context).toString());
    } else {
      dateFormatter = DateFormat.yMMMMd(provider.locale!.languageCode);
    }
    var currencyFormat =
        NumberFormat.currency(locale: "de_DE", decimalDigits: 2, symbol: "€");
    var language = AppLocalizations.of(context)!;
    return View(
      appBar: CustomAppBar(
        title: language.wealthTitle,
        right: IconButton(
          icon: const Icon(
            Icons.add,
          ),
          splashRadius: 18,
          onPressed: _handleAddSnapshot,
        ),
      ),
      fixedAppBar: true,
      safeAreaBottomDisabled: true,
      children: [
        isLoading
            ? const Center(
                child: AdaptiveProgressIndicator(),
              )
            : DashboardTile(
                title: currencyFormat.format(displayWealth),
                titleColor: Theme.of(context).colorScheme.onBackground,
                titleSize: 24,
                subtitle: subtitle,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    SizedBox(
                      height: 180,
                      child: WealthChart(
                        key: ValueKey<bool>(wealthChartKey),
                        divisor: _getDivisor(),
                        currentWealth: yValues.last,
                        spots: mapIndexed(xValues, (index, item) {
                          return FlSpot(
                              index.toDouble(), yValues[index] / _getDivisor());
                        }).toList(),
                        snapshots: snapshots,
                        indexLine: _indexLine,
                        touchHandler: (e, v) {
                          _handleChartTouch(e, v, dateFormatter);
                        },
                      ),
                    ),
                  ],
                ),
              ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 15),
          child: Text(
            language.investments,
            style: TextStyle(
              color: Theme.of(context).secondaryHeaderColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        // Render investment categories
        if (isLoading)
          const SizedBox(height: 100, child: AdaptiveProgressIndicator())
        else
          ...categories.map((e) => InvestmentTile(
                category: e,
              )),

        const SizedBox(
          height: 50,
        ),
      ],
    );
  }

  Iterable<E> mapIndexed<E, T>(
      Iterable<T> items, E Function(int index, T item) f) sync* {
    var index = 0;

    for (final item in items) {
      yield f(index, item);
      index = index + 1;
    }
  }

  num _getDivisor() {
    double max = 0;
    for (var item in yValues) {
      if (item > max) {
        max = item;
      }
    }
    int digits = 0;
    int maxInt = max.ceil();
    while (maxInt > 1) {
      maxInt = (maxInt / 10).floor();
      digits++;
    }
    return pow(10, digits - 1);
  }

  void _setChartData() {
    // Get the unique dates as x values
    var uniqueDates = snapshots
        .map((e) => e.date)
        .map((e) => DateTime(e.year, e.month, e.day))
        .toSet()
        .toList();
    // Create a map with category ids as keys and the list of all snapshots for these categories as their values
    Map<int, List<InvestmentSnapshot>> snapshotsInCategories = {};
    for (var e in snapshots) {
      if (snapshotsInCategories.containsKey(e.categoryId)) {
        snapshotsInCategories.update(e.categoryId, (value) => [...value, e]);
      } else {
        snapshotsInCategories.putIfAbsent(e.categoryId, () => [e]);
      }
    }
    List<double> values = List.filled(uniqueDates.length, 0);
    for (var i = 0; i < uniqueDates.length; i++) {
      List<InvestmentSnapshot> relevantList = [];
      for (var list in snapshotsInCategories.values) {
        List<InvestmentSnapshot> listCopy = List.from(list);
        listCopy.removeWhere((e) => e.date.isAfter(uniqueDates[i]));
        if (listCopy.isNotEmpty) {
          relevantList.add(listCopy.last);
        }
      }
      values[i] = relevantList.map((e) => e.amount).reduce((a, b) => a + b);
    }
    setState(() {
      yValues = values;
      xValues = uniqueDates;
    });
  }

  Future _handleAddSnapshot() async {
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: const AddSnapshotBottomSheet(),
          );
        });
    _refreshCategories();
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
        displayWealth = yValues.last;
      });
      return;
    }

    if (response != null && response.lineBarSpots != null) {
      var value = response.lineBarSpots?[0].y;

      if (value != null && value * _getDivisor() != displayWealth) {
        HapticFeedback.mediumImpact();
        setState(() {
          displayWealth = value * _getDivisor();
          subtitle = dateFormat
              .format(xValues[response.lineBarSpots?[0].x.toInt() as int]);
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

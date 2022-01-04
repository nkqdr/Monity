import 'package:finance_buddy/backend/finances_database.dart';
import 'package:finance_buddy/backend/models/investment_model.dart';
import 'package:finance_buddy/helper/types.dart';
import 'package:finance_buddy/l10n/language_provider.dart';
import 'package:finance_buddy/pages/wealth_category_page.dart';
import 'package:finance_buddy/widgets/adaptive_progress_indicator.dart';
import 'package:finance_buddy/widgets/add_snapshot_bottom_sheet.dart';
import 'package:finance_buddy/widgets/custom_appbar.dart';
import 'package:finance_buddy/widgets/dashboard_tile.dart';
import 'package:finance_buddy/widgets/investment_tile.dart';
import 'package:finance_buddy/widgets/tab_switcher.dart';
import 'package:finance_buddy/widgets/view.dart';
import 'package:finance_buddy/widgets/wealth_chart.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

const double sidePadding = 15.0;

class WealthPage extends StatefulWidget {
  const WealthPage({Key? key}) : super(key: key);

  @override
  _WealthPageState createState() => _WealthPageState();
}

class _WealthPageState extends State<WealthPage> {
  late double displayWealth;
  VerticalLine? _indexLine;
  String subtitle = "";
  late List<InvestmentCategory> categories;
  late List<WealthDataPoint> allDataPoints;
  late List<FlSpot> displayedDataPoints;
  int dataIndex = 1;
  bool isLoading = false;
  bool wealthChartKey = false;

  @override
  void initState() {
    super.initState();
    _refreshCategories();
  }

  Future _refreshDataPoints() async {
    var now = DateTime.now();
    List<FlSpot> newDataPoints = [];
    switch (dataIndex) {
      case 0:
        newDataPoints = mapIndexed(
            allDataPoints
                .where((e) =>
                    e.time.isAfter(DateTime(now.year, now.month - 1, now.day)))
                .toList(),
            (index, WealthDataPoint item) =>
                FlSpot(index.toDouble(), item.value)).toList();
        break;
      case 1:
        newDataPoints = mapIndexed(
            allDataPoints
                .where((e) =>
                    e.time.isAfter(DateTime(now.year - 1, now.month, now.day)))
                .toList(),
            (index, WealthDataPoint item) =>
                FlSpot(index.toDouble(), item.value)).toList();
        break;
      case 2:
        newDataPoints = mapIndexed(
            allDataPoints
                .where((e) =>
                    e.time.isAfter(DateTime(now.year - 5, now.month, now.day)))
                .toList(),
            (index, WealthDataPoint item) =>
                FlSpot(index.toDouble(), item.value)).toList();
        break;
      default:
        newDataPoints =
            mapIndexed(allDataPoints, (index, WealthDataPoint item) {
          return FlSpot(index.toDouble(), item.value);
        }).toList();
    }
    setState(() {
      displayedDataPoints = newDataPoints;
    });
  }

  Future _refreshCategories() async {
    setState(() => isLoading = true);
    categories = await FinancesDatabase.instance.readAllInvestmentCategories();
    displayedDataPoints = [];
    allDataPoints = await FinancesDatabase.instance.getAllWealthDatapoints();
    _refreshDataPoints();
    displayWealth = _getCurrentWealth();
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
    Locale locale = Localizations.localeOf(context);
    var currencyFormat = NumberFormat.simpleCurrency(
        locale: locale.toString(), decimalDigits: 2);
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
            ? const DashboardTile(
                child: Center(
                  child: AdaptiveProgressIndicator(),
                ),
              )
            : DashboardTile(
                title: currencyFormat.format(displayWealth),
                titleColor: Theme.of(context).colorScheme.onBackground,
                fill: const DashboardTileFillLeaveTitle(),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                height: 250,
                titleSize: 24,
                subtitle: subtitle,
                child: Expanded(
                  child: WealthChart(
                    key: ValueKey<bool>(wealthChartKey),
                    currentWealth: _getCurrentWealth(),
                    spots: displayedDataPoints,
                    indexLine: _indexLine,
                    touchHandler: (e, v) {
                      _handleChartTouch(e, v, dateFormatter);
                    },
                  ),
                ),
              ),
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: sidePadding, vertical: 15),
          child: TabSwitcher(
            tabs: [
              TabElement(
                title: language.month,
                onPressed: _tabSwitcherCallback,
              ),
              TabElement(
                title: language.year,
                onPressed: _tabSwitcherCallback,
              ),
              TabElement(
                title: "5 " + language.years,
                onPressed: _tabSwitcherCallback,
              ),
              TabElement(
                title: language.maxTime,
                onPressed: _tabSwitcherCallback,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: sidePadding, top: 15),
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
          ...categories.map((e) => GestureDetector(
                onTap: () async {
                  await Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                    return WealthCategoryPage(category: e);
                  }));
                  _refreshCategories();
                },
                child: InvestmentTile(
                  category: e,
                ),
              )),

        const SizedBox(
          height: 50,
        ),
      ],
    );
  }

  void _tabSwitcherCallback(int index) {
    setState(() => dataIndex = index);
    _refreshDataPoints();
  }

  double _getCurrentWealth() {
    return allDataPoints.isEmpty ? 0 : allDataPoints.last.value;
  }

  Iterable<E> mapIndexed<E, T>(
      Iterable<T> items, E Function(int index, T item) f) sync* {
    var index = 0;

    for (final item in items) {
      yield f(index, item);
      index = index + 1;
    }
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
        subtitle = "";
        _indexLine = null;
        displayWealth = _getCurrentWealth();
      });
      return;
    }

    if (response != null && response.lineBarSpots != null) {
      var value = response.lineBarSpots?[0].y;

      if (value != null && value != displayWealth) {
        HapticFeedback.mediumImpact();
        List<DateTime> currentXValues;
        switch (dataIndex) {
          case 0:
            currentXValues = allDataPoints
                .map((e) => e.time)
                .where((element) => element.isAfter(DateTime(
                    DateTime.now().year,
                    DateTime.now().month - 1,
                    DateTime.now().day)))
                .toList();
            break;
          case 1:
            currentXValues = allDataPoints
                .map((e) => e.time)
                .where((element) => element.isAfter(DateTime(
                    DateTime.now().year - 1,
                    DateTime.now().month,
                    DateTime.now().day)))
                .toList();
            break;
          case 2:
            currentXValues = allDataPoints
                .map((e) => e.time)
                .where((element) => element.isAfter(DateTime(
                    DateTime.now().year - 5,
                    DateTime.now().month,
                    DateTime.now().day)))
                .toList();
            break;
          default:
            currentXValues = allDataPoints.map((e) => e.time).toList();
        }
        setState(() {
          displayWealth = value;
          subtitle = dateFormat.format(
              currentXValues[response.lineBarSpots?[0].x.toInt() as int]);
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

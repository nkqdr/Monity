import 'package:monity/backend/finances_database.dart';
import 'package:monity/backend/models/investment_model.dart';
import 'package:monity/helper/category_list_provider.dart';
import 'package:monity/helper/interfaces.dart';
import 'package:monity/helper/types.dart';
import 'package:monity/helper/utils.dart';
import 'package:monity/pages/wealth_category_page.dart';
import 'package:monity/pages/wealth_statistics_page.dart';
import 'package:monity/widgets/adaptive_progress_indicator.dart';
import 'package:monity/widgets/adaptive_text_button.dart';
import 'package:monity/widgets/add_snapshot_bottom_sheet.dart';
import 'package:monity/widgets/custom_appbar.dart';
import 'package:monity/widgets/custom_section.dart';
import 'package:monity/widgets/dashboard_tile.dart';
import 'package:monity/widgets/investment_tile.dart';
import 'package:monity/widgets/tab_switcher.dart';
import 'package:monity/widgets/view.dart';
import 'package:monity/widgets/wealth_chart.dart';
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
  late List<WealthDataPoint> allDataPoints;
  late List<FlSpot> displayedDataPoints;
  DataPointFilterStrategy dataFilter = _LastYearFilterStrategy();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _refreshCategories();
  }

  void _refreshDataPoints() {
    setState(() {
      displayedDataPoints = dataFilter.filterDataPoints(allDataPoints);
    });
  }

  Future _refreshCategories() async {
    setState(() => isLoading = true);
    allDataPoints = await FinancesDatabase.instance.getAllWealthDatapoints();
    _refreshDataPoints();
    displayWealth = _getCurrentWealth();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormatter = Utils.getDateFormatter(context);
    Locale locale = Localizations.localeOf(context);
    var currencyFormat = NumberFormat.simpleCurrency(locale: locale.toString(), decimalDigits: 2);
    var language = AppLocalizations.of(context)!;
    var categories = Provider.of<ListProvider<InvestmentCategory>>(context).list;
    return View(
      appBar: CustomAppBar(
        title: language.wealthTitle,
        right: IconButton(
          icon: Icon(
            Icons.add,
            color: Theme.of(context).primaryColor,
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
                  child: displayedDataPoints.length > 1
                      ? WealthChart(
                          //key: Key("wealth-chart-${displayedDataPoints.length}"),
                          currentWealth: _getCurrentWealth(),
                          spots: displayedDataPoints,
                          indexLine: _indexLine,
                          touchHandler: (e, v) {
                            _handleChartTouch(e, v, dateFormatter);
                          },
                        )
                      : Center(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              language.noDatapointsForSelectedPeriod,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor,
                              ),
                            ),
                          ),
                        ),
                ),
              ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: sidePadding, vertical: 15),
          child: TabSwitcher(
            startIndex: dataFilter.index,
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
        Center(
          child: AdaptiveTextButton(
            text: language.wealthSplitTitle,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return const WealthStatisticsPage();
              }));
            },
          ),
        ),
        CustomSection(
          title: language.investments,
          children: isLoading
              ? []
              : [
                  ...categories.map((e) => GestureDetector(
                        onTap: () async {
                          await Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return WealthCategoryPage(category: e);
                          }));
                          _refreshCategories();
                        },
                        child: InvestmentTile(
                          key: ObjectKey(e),
                          category: e,
                        ),
                      )),
                ],
        ),
        const SizedBox(
          height: 50,
        ),
      ],
    );
  }

  DataPointFilterStrategy _getStrategyFromIndex(int index) {
    switch (index) {
      case 0:
        return _LastMonthFilterStrategy();
      case 1:
        return _LastYearFilterStrategy();
      case 2:
        return _LastFiveYearsFilterStrategy();
      default:
        return _MaxFilterStrategy();
    }
  }

  void _tabSwitcherCallback(int index) {
    setState(() => dataFilter = _getStrategyFromIndex(index));
    _refreshDataPoints();
  }

  double _getCurrentWealth() {
    return allDataPoints.isEmpty ? 0 : allDataPoints.last.value;
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
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: const AddSnapshotBottomSheet(),
        );
      },
    );
    _refreshCategories();
  }

  void _handleChartTouch(FlTouchEvent event, LineTouchResponse? response, DateFormat dateFormat) {
    if (event is FlTapUpEvent || event is FlPanCancelEvent || event is FlPanEndEvent || event is FlLongPressEnd) {
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
        setState(() {
          displayWealth = value;
          subtitle = dateFormat.format(dataFilter.getXValues(allDataPoints)[response.lineBarSpots![0].x.toInt()]);
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

class _LastMonthFilterStrategy extends DataPointFilterStrategy {
  @override
  int get index => 0;

  @override
  DateTime get limitDate {
    var now = DateTime.now();
    return DateTime(now.year, now.month - 1, now.day);
  }
}

class _LastYearFilterStrategy extends DataPointFilterStrategy {
  @override
  int get index => 1;

  @override
  DateTime get limitDate {
    var now = DateTime.now();
    return DateTime(now.year - 1, now.month, now.day);
  }
}

class _LastFiveYearsFilterStrategy extends DataPointFilterStrategy {
  @override
  int get index => 2;

  @override
  DateTime get limitDate {
    var now = DateTime.now();
    return DateTime(now.year - 5, now.month, now.day);
  }
}

class _MaxFilterStrategy extends DataPointFilterStrategy {
  @override
  int get index => 3;

  @override
  DateTime get limitDate => DateTime(1, 1, 1);
}

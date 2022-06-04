import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:monity/backend/finances_database.dart';
import 'package:monity/backend/models/investment_model.dart';
import 'package:monity/helper/config_provider.dart';
import 'package:monity/helper/types.dart';
import 'package:monity/helper/utils.dart';
import 'package:monity/widgets/adaptive_progress_indicator.dart';
import 'package:monity/widgets/custom_appbar.dart';
import 'package:monity/widgets/custom_indicator.dart';
import 'package:monity/widgets/horizontal_bar.dart';
import 'package:monity/widgets/newmorphic_box.dart';
import 'package:monity/widgets/view.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WealthStatisticsPage extends StatefulWidget {
  const WealthStatisticsPage({Key? key}) : super(key: key);

  @override
  State<WealthStatisticsPage> createState() => _WealthStatisticsPageState();
}

class _WealthStatisticsPageState extends State<WealthStatisticsPage> {
  late int touchedIndex;
  late List<_DisplayAssetAllocation> allAllocations = [];
  bool isLoading = false;
  bool noContent = false;

  @override
  void initState() {
    super.initState();
    touchedIndex = -1;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _refreshInvestmentCategories();
  }

  Future _refreshInvestmentCategories() async {
    List<AssetLabel> labelTitles = Provider.of<ConfigProvider>(context).assetAllocationCategories;
    setState(() => isLoading = true);
    var investmentCategories = await FinancesDatabase.instance.readAllInvestmentCategories();
    investmentCategories = investmentCategories.where((e) => e.label != ConfigProvider.noneAssetLabel.title).toList();
    if (investmentCategories.isEmpty) {
      noContent = true;
    }
    List<InvestmentSnapshot> lastSnapshots = [];
    for (var i = 0; i < investmentCategories.length; i++) {
      var snapshot = await FinancesDatabase.instance.readLastSnapshotFor(category: investmentCategories[i]);
      if (snapshot != null && snapshot.amount >= 0) {
        lastSnapshots.add(snapshot);
      }
    }
    double totalSum = 0;
    for (var element in lastSnapshots) {
      totalSum += element.amount;
    }
    List<_DisplayAssetAllocation> newAllocations = [];
    for (var i = 0; i < labelTitles.length; i++) {
      // Find relevant Investments and their last snapshots for this allocation.
      List<_CategoryWithSnapshot> relevantCategoriesWithSnapshot = [];
      List<InvestmentCategory> relevantCategories =
          investmentCategories.where((element) => element.label == labelTitles[i].title).toList();
      for (var j = 0; j < relevantCategories.length; j++) {
        var lastSnapshot = await FinancesDatabase.instance.readLastSnapshotFor(category: relevantCategories[j]);
        if (lastSnapshot != null && lastSnapshot.amount > 0) {
          relevantCategoriesWithSnapshot
              .add(_CategoryWithSnapshot(category: relevantCategories[j], snapshot: lastSnapshot));
        }
      }
      // Calculate total sum
      double sum = 0;
      for (var element in relevantCategoriesWithSnapshot) {
        sum += element.snapshot.amount;
      }
      relevantCategoriesWithSnapshot.sort(((a, b) => b.snapshot.amount.compareTo(a.snapshot.amount)));
      // Set the correct percentage for this allocation
      labelTitles[i].percentage = sum / totalSum * 100;
      // Add this allocation to the list
      var newAllocation = _DisplayAssetAllocation(
          label: labelTitles[i], totalSum: sum, relevantCategories: relevantCategoriesWithSnapshot);
      newAllocations.add(newAllocation);
    }
    setState(() {
      isLoading = false;
      allAllocations = newAllocations;
    });
  }

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    Locale locale = Localizations.localeOf(context);
    var currencyFormat = NumberFormat.simpleCurrency(locale: locale.toString(), decimalDigits: 2);

    return View(
      appBar: CustomAppBar(
        title: language.wealthSplitTitle,
        left: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: Theme.of(context).primaryColor,
          ),
          splashRadius: 18,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        right: IconButton(
          icon: Icon(
            Icons.help_outline_rounded,
            color: Theme.of(context).primaryColor,
          ),
          splashRadius: 18,
          onPressed: () => showHelpDialog(language),
        ),
      ),
      fixedAppBar: true,
      safeAreaBottomDisabled: true,
      children: noContent
          ? [
              SizedBox(
                height: MediaQuery.of(context).size.height / 3,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Center(
                  child: Text(
                    language.noDatapointsForSelectedPeriod,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                  ),
                ),
              ),
            ]
          : isLoading
              ? [
                  const AdaptiveProgressIndicator(),
                ]
              : [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: Utils.mapIndexed(allAllocations, (index, _DisplayAssetAllocation item) {
                      return Indicator(
                        color: item.label.displayColor,
                        text: Utils.getCorrectTitleFromKey(item.label.title, language),
                        isSquare: false,
                        size: touchedIndex == index ? 18 : 16,
                        textColor: touchedIndex == index ? null : Theme.of(context).secondaryHeaderColor,
                      );
                    }).toList(),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: PieChart(
                            PieChartData(
                              pieTouchData: PieTouchData(touchCallback: (FlTouchEvent event, pieTouchResponse) {
                                setState(() {
                                  if (pieTouchResponse == null) {
                                    return;
                                  }
                                  if (pieTouchResponse.touchedSection == null) {
                                    touchedIndex = -1;
                                    return;
                                  }
                                  int newIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                                  if (newIndex > -1 || event is FlTapUpEvent) {
                                    if (newIndex != touchedIndex) {
                                      HapticFeedback.lightImpact();
                                    }
                                    touchedIndex = newIndex;
                                  }
                                });
                              }),
                              borderData: FlBorderData(
                                show: false,
                              ),
                              sectionsSpace: 0,
                              centerSpaceRadius: 60,
                              sections: getSections(allAllocations),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: NewmorphicBox(
                      child: Container(
                        constraints: const BoxConstraints(
                          minHeight: 100.0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        child: touchedIndex == -1
                            ? Center(
                                child: Text(
                                  language.tapChartForDetails,
                                  style: TextStyle(
                                    color: Theme.of(context).secondaryHeaderColor,
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          Utils.getCorrectTitleFromKey(
                                              allAllocations[touchedIndex].label.title, language),
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          currencyFormat.format(allAllocations[touchedIndex].totalSum),
                                          style: TextStyle(
                                            color: allAllocations[touchedIndex].totalSum >= 0
                                                ? Theme.of(context).hintColor
                                                : Theme.of(context).errorColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Column(
                                      children: [
                                        ...Utils.mapIndexed(allAllocations[touchedIndex].relevantCategories,
                                            (i, _CategoryWithSnapshot e) {
                                          return Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                e.category.name,
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
                                                    amount: e.snapshot.amount,
                                                    size: 1 / allAllocations[touchedIndex].totalSum,
                                                    color: allAllocations[touchedIndex].label.displayColor,
                                                  ),
                                                  const SizedBox(
                                                    width: 15,
                                                  ),
                                                  Text(
                                                    (e.snapshot.amount / allAllocations[touchedIndex].totalSum * 100)
                                                            .toStringAsFixed(1) +
                                                        "%",
                                                    style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                            ],
                                          );
                                        })
                                      ],
                                    )
                                  ],
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
    );
  }

  List<PieChartSectionData> getSections(List<_DisplayAssetAllocation> allocations) {
    // If the smallest fraction is too small and would make the chart look bad, give it some of the width of the biggest fraction.
    var labelTitles = allocations.map((e) => e.label);
    double minValue = double.maxFinite;
    double maxValue = 0;
    for (var element in labelTitles) {
      if (element.percentage! < minValue) {
        minValue = element.percentage!;
      }
      if (element.percentage! > maxValue) {
        maxValue = element.percentage!;
      }
    }
    bool adaptPercentages = false;
    double adaptionRange = 3;
    if (minValue < 2) {
      adaptPercentages = true;
    }
    // Return (possibly adapted) sections
    return Utils.mapIndexed(labelTitles, (index, AssetLabel item) {
      final isTouched = index == touchedIndex;
      final fontSize = isTouched ? 22.0 : 16.0;
      final radius = isTouched ? 90.0 : 80.0;
      double percentage = item.percentage == null ? 0 : item.percentage as double;
      return PieChartSectionData(
        color: item.displayColor,
        value: (adaptPercentages && maxValue == item.percentage)
            ? item.percentage! - adaptionRange
            : (adaptPercentages && minValue == item.percentage! ? item.percentage! + adaptionRange : item.percentage),
        title: percentage.toStringAsFixed(1) + "%",
        radius: radius,
        titleStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
      );
    }).toList();
  }

  Future showHelpDialog(AppLocalizations language) async {
    await showOkAlertDialog(
      context: context,
      title: language.help,
      message: language.assetAllocationHelp,
    );
  }
}

class _DisplayAssetAllocation {
  final AssetLabel label;
  final double totalSum;
  final List<_CategoryWithSnapshot> relevantCategories;

  const _DisplayAssetAllocation({
    required this.label,
    required this.totalSum,
    required this.relevantCategories,
  });
}

class _CategoryWithSnapshot {
  final InvestmentCategory category;
  final InvestmentSnapshot snapshot;
  const _CategoryWithSnapshot({
    required this.category,
    required this.snapshot,
  });
}

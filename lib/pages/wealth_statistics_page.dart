import 'package:finance_buddy/backend/finances_database.dart';
import 'package:finance_buddy/backend/models/investment_model.dart';
import 'package:finance_buddy/helper/config.dart';
import 'package:finance_buddy/helper/types.dart';
import 'package:finance_buddy/helper/utils.dart';
import 'package:finance_buddy/widgets/custom_appbar.dart';
import 'package:finance_buddy/widgets/custom_indicator.dart';
import 'package:finance_buddy/widgets/view.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class WealthStatisticsPage extends StatefulWidget {
  const WealthStatisticsPage({Key? key}) : super(key: key);

  @override
  State<WealthStatisticsPage> createState() => _WealthStatisticsPageState();
}

class _WealthStatisticsPageState extends State<WealthStatisticsPage> {
  late int touchedIndex;
  late List<InvestmentCategory> investmentCategories;
  late List<InvestmentSnapshot> lastSnapshotForCategory = [];
  List<AssetLabel> labelTitles = Config.assetAllocationCategories;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    touchedIndex = -1;
    _refreshInvestmentCategories();
  }

  Future _refreshInvestmentCategories() async {
    setState(() => isLoading = true);
    investmentCategories =
        await FinancesDatabase.instance.readAllInvestmentCategories();
    investmentCategories =
        investmentCategories.where((element) => element.label != null).toList();
    var toDeleteCategories = [];
    for (var i = 0; i < investmentCategories.length; i++) {
      var lastSnapshot = await FinancesDatabase.instance
          .readLastSnapshotFor(category: investmentCategories[i]);
      if (lastSnapshot != null) {
        lastSnapshotForCategory.add(lastSnapshot);
      } else {
        toDeleteCategories.add(investmentCategories[i]);
      }
    }
    for (var c in toDeleteCategories) {
      investmentCategories.remove(c);
    }
    assert(investmentCategories.length == lastSnapshotForCategory.length);
    _setPercentages();
    setState(() => isLoading = false);
  }

  void _setPercentages() {
    double total = 0;
    for (var item in lastSnapshotForCategory) {
      total += item.amount;
    }
    List<double> percentages = [];
    for (var label in labelTitles) {
      double labelSum = 0;
      var relevantCategoriesIndices = [];
      for (var i = 0; i < investmentCategories.length; i++) {
        if (investmentCategories[i].label == label.title) {
          relevantCategoriesIndices.add(i);
        }
      }
      for (var index in relevantCategoriesIndices) {
        labelSum += lastSnapshotForCategory[index].amount;
      }
      percentages.add((labelSum / total) * 100);
    }
    assert(percentages.length == labelTitles.length);
    int i = 0;
    for (var label in labelTitles) {
      label.percentage = percentages[i];
      i++;
    }
  }

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context)!;
    return View(
      appBar: CustomAppBar(
        title: language.wealthSplitTitle,
        left: IconButton(
          icon: const Icon(
            Icons.chevron_left,
          ),
          splashRadius: 18,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      fixedAppBar: true,
      safeAreaBottomDisabled: true,
      children: [
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: Utils.mapIndexed(labelTitles, (index, AssetLabel item) {
            return Indicator(
              color: item.displayColor,
              text: item.title,
              isSquare: false,
              size: touchedIndex == index ? 18 : 16,
              textColor: touchedIndex == index
                  ? null
                  : Theme.of(context).secondaryHeaderColor,
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
                      pieTouchData: PieTouchData(touchCallback:
                          (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (pieTouchResponse == null) {
                            return;
                          }
                          if (pieTouchResponse.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          int newIndex = pieTouchResponse
                              .touchedSection!.touchedSectionIndex;
                          if (newIndex > -1 || event is FlTapUpEvent) {
                            touchedIndex = pieTouchResponse
                                .touchedSection!.touchedSectionIndex;
                            HapticFeedback.lightImpact();
                          }
                        });
                      }),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 0,
                      centerSpaceRadius: 60,
                      sections: getSections(labelTitles)),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 800),
            constraints: const BoxConstraints(
              minHeight: 100.0,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).cardColor,
            ),
            child: touchedIndex == -1
                ? Center(
                    child: Text(
                      "Tap the chart for more details.",
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
                        Text(
                          labelTitles[touchedIndex].title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 200,
                          child: Column(
                            children: [
                              ...investmentCategories
                                  .where((element) =>
                                      element.label ==
                                      labelTitles[touchedIndex].title)
                                  .map((e) => Text(e.name +
                                      ", " +
                                      (e.label != null ? e.label! : "")))
                                  .toList(),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> getSections(List<AssetLabel> labeltitles) {
    return Utils.mapIndexed(labeltitles, (index, AssetLabel item) {
      final isTouched = index == touchedIndex;
      final fontSize = isTouched ? 22.0 : 16.0;
      final radius = isTouched ? 90.0 : 80.0;
      double percentage =
          item.percentage == null ? 0 : item.percentage as double;
      return PieChartSectionData(
        color: item.displayColor,
        value: item.percentage,
        title: percentage.toStringAsFixed(1) + "%",
        radius: radius,
        titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xffffffff)),
      );
    }).toList();
  }
}

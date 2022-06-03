import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:monity/helper/types.dart';
import 'package:monity/helper/utils.dart';

abstract class Category {
  final int? id;
  final String name;

  const Category({this.id, required this.name});

  Category copy({int? id, String? name});
  String getDeleteMessage(AppLocalizations language);
  bool equals(Category other);

  Future<int> updateSelf();
  Future<int> deleteSelf();
}

abstract class DataPointFilterStrategy {
  int get index;
  DateTime get limitDate;

  List<FlSpot> filterDataPoints(List<WealthDataPoint> allDataPoints) {
    return Utils.mapIndexed(allDataPoints.where((e) => e.time.isAfter(limitDate)).toList(),
        (index, WealthDataPoint item) => FlSpot(index.toDouble(), item.value)).toList();
  }

  List<DateTime> getXValues(List<WealthDataPoint> allDataPoints) {
    return allDataPoints.where((element) => element.time.isAfter(limitDate)).map((e) => e.time).toList();
  }
}

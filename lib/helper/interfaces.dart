import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:monity/helper/types.dart';

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
  final int index = -1;

  List<FlSpot> filterDataPoints(List<WealthDataPoint> allDataPoints);
  List<DateTime> getXValues(List<WealthDataPoint> allDataPoints);
}

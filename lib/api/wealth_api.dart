import 'dart:math';

import 'package:finance_buddy/helper/wealth_entry.dart';

class WealthApi {
  static List<WealthEntry> getAllEntries() {
    wealthEntries.sort((a, b) => a.date.compareTo(b.date));
    return wealthEntries;
  }

  static double getMaxLineChartValue() {
    double max = 0;
    for (var item in wealthEntries) {
      if (item.amount > max) {
        max = item.amount;
      }
    }
    int digits = 0;
    int maxInt = max.ceil();
    while (maxInt != 0) {
      maxInt = (maxInt / 10).floor();
      digits++;
    }
    return max / pow(10, digits - 1);
  }

  static double getCurrentWealth() {
    var entries = getAllEntries();
    return entries[entries.length - 1].amount;
  }

  static num getDivisor() {
    double max = 0;
    for (var item in wealthEntries) {
      if (item.amount > max) {
        max = item.amount;
      }
    }
    int digits = 0;
    int maxInt = max.ceil();
    while (maxInt != 0) {
      maxInt = (maxInt / 10).floor();
      digits++;
    }
    return pow(10, digits - 1);
  }
}

List<WealthEntry> wealthEntries = [
  WealthEntry(date: DateTime(2021, 8, 1), amount: 1000),
  WealthEntry(date: DateTime(2021, 9, 1), amount: 2000),
  WealthEntry(date: DateTime(2021, 10, 1), amount: 1600),
  WealthEntry(date: DateTime(2021, 11, 1), amount: 2000.5),
  WealthEntry(date: DateTime(2021, 12, 1), amount: 2800.32),
  WealthEntry(date: DateTime(2022, 1, 1), amount: 1000),
  WealthEntry(date: DateTime(2022, 2, 1), amount: 1500),
  WealthEntry(date: DateTime(2022, 3, 1), amount: 1600),
  WealthEntry(date: DateTime(2022, 4, 1), amount: 5398.52),
];

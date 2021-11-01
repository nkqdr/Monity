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

  static double getMinValue() {
    double min = double.maxFinite;
    for (var item in wealthEntries) {
      if (item.amount < min) {
        min = item.amount;
      }
    }
    return min;
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
  WealthEntry(date: DateTime(2021, 1, 12), amount: 800.42),
  WealthEntry(date: DateTime(2021, 2, 1), amount: 1500),
  WealthEntry(date: DateTime(2021, 3, 1), amount: 1600),
  WealthEntry(date: DateTime(2021, 4, 1), amount: 398.52),
  WealthEntry(date: DateTime(2021, 5, 1), amount: 1000),
  WealthEntry(date: DateTime(2021, 6, 1), amount: 2000),
  WealthEntry(date: DateTime(2021, 7, 1), amount: 1560),
  WealthEntry(date: DateTime(2021, 8, 1), amount: 2000),
  WealthEntry(date: DateTime(2021, 9, 1), amount: 3000),
  WealthEntry(date: DateTime(2021, 10, 1), amount: 10600),
  WealthEntry(date: DateTime(2021, 11, 1), amount: 10000.5),
  WealthEntry(date: DateTime(2021, 12, 1), amount: 2800.32),
  WealthEntry(date: DateTime(2022, 1, 12), amount: 800.42),
  WealthEntry(date: DateTime(2022, 2, 1), amount: 1500),
  WealthEntry(date: DateTime(2022, 3, 1), amount: 1600),
  WealthEntry(date: DateTime(2022, 4, 1), amount: 9398.52),
  WealthEntry(date: DateTime(2022, 5, 1), amount: 10000),
  WealthEntry(date: DateTime(2022, 6, 1), amount: 20000),
  WealthEntry(date: DateTime(2022, 7, 1), amount: 15600),
  WealthEntry(date: DateTime(2022, 8, 1), amount: 19000.5),
  WealthEntry(date: DateTime(2022, 9, 1), amount: 28000.32),
  WealthEntry(date: DateTime(2022, 10, 12), amount: 10800.42),
  WealthEntry(date: DateTime(2022, 11, 1), amount: 15000),
  WealthEntry(date: DateTime(2022, 12, 1), amount: 16000),
  WealthEntry(date: DateTime(2023, 2, 1), amount: 20798.52),
  WealthEntry(date: DateTime(2023, 3, 10), amount: -30398.52),
  WealthEntry(date: DateTime(2023, 4, 10), amount: -15398.52),
  WealthEntry(date: DateTime(2023, 5, 10), amount: -398.52),
  WealthEntry(date: DateTime(2023, 6, 10), amount: 3398.52),
];

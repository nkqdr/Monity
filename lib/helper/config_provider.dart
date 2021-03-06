import 'package:monity/backend/key_value_database.dart';
import 'package:monity/helper/types.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigProvider extends ChangeNotifier {
  static final noneAssetLabel = AssetLabel(title: "None", displayColor: Colors.black);
  List<AssetLabel> assetAllocationCategories = [
    AssetLabel(
      title: "Invested",
      displayColor: const Color(0xff0293ee),
    ),
    AssetLabel(
      title: "Saved",
      displayColor: const Color(0xfff8b250),
    ),
    AssetLabel(
      title: "Liquid",
      displayColor: const Color(0xff845bef),
    ),
  ];
  bool budgetOverflowEnabled;
  late bool disableRecurringTransactions;
  double? monthlyLimit;
  DateTime? lastBackupCreated;

  ConfigProvider({
    required this.budgetOverflowEnabled,
    required this.monthlyLimit,
  }) {
    _setUpValues();
  }

  Future _setUpValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dateString = prefs.getString(lastBackupCreatedKey);
    lastBackupCreated = dateString != null ? DateTime.parse(dateString) : null;
    disableRecurringTransactions = prefs.getBool(disableRecurringTransactionsKey) ?? false;
  }

  Future setDisableRecurringTransactions(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    disableRecurringTransactions = value;
    await prefs.setBool(disableRecurringTransactionsKey, value);
    notifyListeners();
  }

  Future setLastBackupCreated(DateTime time) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(lastBackupCreatedKey, time.toIso8601String());
    notifyListeners();
  }

  Future deleteMonthlyLimit() async {
    monthlyLimit = null;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(monthlyLimitKey);
    notifyListeners();
  }

  Future setMonthlyLimit(double value) async {
    monthlyLimit = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(monthlyLimitKey, value);
    notifyListeners();
  }

  Future setBudgetOverflow(bool value) async {
    budgetOverflowEnabled = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(budgetOverflowEnabledKey, value);
    await prefs.remove(budgetOverflowKey);
    notifyListeners();
  }

  void reset() {
    budgetOverflowEnabled = false;
    monthlyLimit = null;
    notifyListeners();
  }
}

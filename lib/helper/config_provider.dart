import 'package:finance_buddy/backend/key_value_database.dart';
import 'package:finance_buddy/helper/types.dart';

import 'package:flutter/material.dart';

class ConfigProvider extends ChangeNotifier {
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
  double? monthlyLimit;

  ConfigProvider({
    required this.budgetOverflowEnabled,
    required this.monthlyLimit,
  });

  deleteMonthlyLimit() async {
    monthlyLimit = null;
    await KeyValueDatabase.deleteMonthlyLimit();
    notifyListeners();
  }

  setMonthlyLimit(double value) async {
    monthlyLimit = value;
    await KeyValueDatabase.setMonthlyLimit(value);
    notifyListeners();
  }

  setBudgetOverflow(bool value) {
    budgetOverflowEnabled = value;
    KeyValueDatabase.setBudgetOverflowEnabled(value);
    KeyValueDatabase.deleteBudgetOverflow();
    notifyListeners();
  }
}

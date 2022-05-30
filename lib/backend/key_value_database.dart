import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String appearanceKey = 'APPEARANCE';
const String languageKey = 'LANGUAGE';
const String monthlyLimitKey = 'MONTHLY_LIMIT';
const String firstStartupKey = 'IS_FIRST_START_UP';
const String budgetOverflowEnabledKey = "BUDGET_OVERFLOW_ENABLED";
const String budgetOverflowKey = "BUDGET_OVERFLOW";

const List<String> keyList = [
  'APPEARANCE',
  'LANGUAGE',
  'MONTHLY_LIMIT',
  'IS_FIRST_START_UP',
  "BUDGET_OVERFLOW_ENABLED",
  "BUDGET_OVERFLOW"
];

class KeyValueDatabase {
  static Future<ThemeMode> getTheme() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var value = prefs.getInt(appearanceKey);
    if (value == null) {
      return ThemeMode.system;
    }
    ThemeMode mode = value == 0
        ? ThemeMode.system
        : (value == 1 ? ThemeMode.light : ThemeMode.dark);
    return mode;
  }

  static Future<Locale?> getLocale() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var languageCode = prefs.getString(languageKey);
    if (languageCode == null) {
      return null;
    }
    return Locale(languageCode);
  }

  static Future<double?> getMonthlyLimit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var limit = prefs.getDouble(monthlyLimitKey);
    if (limit == null) {
      return null;
    }
    return limit;
  }

  static Future<bool?> getFirstStartup() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var limit = prefs.getBool(firstStartupKey);
    if (limit == null) {
      return null;
    }
    return limit;
  }

  static Future<bool?> getBudgetOverflowEnabled() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var value = prefs.getBool(budgetOverflowEnabledKey);
    if (value == null) {
      return null;
    }
    return value;
  }

  static Future<double?> getBudgetOverflow() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var overflow = prefs.getDouble(budgetOverflowKey);
    if (overflow == null) {
      return null;
    }
    return overflow;
  }

  static Future setBudgetOverflow(double overflow) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(budgetOverflowKey, overflow);
  }

  static Future deleteAllData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (var key in keyList) {
      prefs.remove(key);
    }
  }
}

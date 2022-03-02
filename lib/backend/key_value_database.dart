import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String appearanceKey = 'APPEARANCE';
const String languageKey = 'LANGUAGE';
const String monthlyLimitKey = 'MONTHLY_LIMIT';
const String firstStartupKey = 'IS_FIRST_START_UP';
const String budgetOverflowEnabledKey = "BUDGET_OVERFLOW_ENABLED";
const String budgetOverflowKey = "BUDGET_OVERFLOW";

class KeyValueDatabase {
  static Future setTheme(ThemeMode mode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int value =
        mode == ThemeMode.system ? 0 : (mode == ThemeMode.light ? 1 : 2);
    await prefs.setInt(appearanceKey, value);
  }

  static Future<ThemeMode> getTheme() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var value = prefs.getInt(appearanceKey);
    if (value == null) {
      await setTheme(ThemeMode.system);
      return ThemeMode.system;
    }
    ThemeMode mode = value == 0
        ? ThemeMode.system
        : (value == 1 ? ThemeMode.light : ThemeMode.dark);
    return mode;
  }

  static Future setLanguage(String? languageCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (languageCode == null) {
      await prefs.remove(languageKey);
      return;
    }
    await prefs.setString(languageKey, languageCode);
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

  static Future setMonthlyLimit(double limit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(monthlyLimitKey, limit);
  }

  static Future deleteMonthlyLimit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(monthlyLimitKey);
  }

  static Future setFirstStartup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(firstStartupKey, false);
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

  static Future setBudgetOverflowEnabled(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(budgetOverflowEnabledKey, value);
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

  static Future deleteBudgetOverflow() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(budgetOverflowKey);
  }
}

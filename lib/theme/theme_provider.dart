import 'package:monity/backend/key_value_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode;

  ThemeProvider({
    required this.themeMode,
  });

  void setThemeMode(ThemeMode mode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int value = mode == ThemeMode.system ? 0 : (mode == ThemeMode.light ? 1 : 2);
    await prefs.setInt(appearanceKey, value);
    themeMode = mode;
    notifyListeners();
  }

  void reset() {
    themeMode = ThemeMode.system;
    notifyListeners();
  }
}

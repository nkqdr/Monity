import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String appearanceKey = 'APPEARANCE';

class SettingsApi {
  static Future<void> setAppearance(ThemeMode mode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int value =
        mode == ThemeMode.system ? 0 : (mode == ThemeMode.light ? 1 : 2);
    await prefs.setInt(appearanceKey, value);
  }

  static Future<ThemeMode> getAppearance() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var value = prefs.getInt(appearanceKey);
    if (value == null) {
      await setAppearance(ThemeMode.system);
      return ThemeMode.system;
    }
    ThemeMode mode = value == 0
        ? ThemeMode.system
        : (value == 1 ? ThemeMode.light : ThemeMode.dark);
    return mode;
  }
}

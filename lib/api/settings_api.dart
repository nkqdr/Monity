import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String appearanceKey = 'APPEARANCE';
const String languageKey = 'LANGUAGE';

class SettingsApi {
  static Future<void> setTheme(ThemeMode mode) async {
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

  static Future<void> setLanguage(String? languageCode) async {
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
}

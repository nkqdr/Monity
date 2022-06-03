import 'package:monity/backend/key_value_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  Locale? locale;
  LanguageProvider({
    this.locale,
  });

  void setLocale(String? languageCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (languageCode == null) {
      await prefs.remove(languageKey);
      locale = null;
    } else {
      await prefs.setString(languageKey, languageCode);
      locale = Locale(languageCode);
    }
    notifyListeners();
  }

  void reset() async {
    locale = null;
    notifyListeners();
  }
}

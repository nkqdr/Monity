import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  Locale? locale;
  LanguageProvider({
    this.locale,
  });

  void setLocale(Locale? newLocale) {
    locale = newLocale;
    notifyListeners();
  }
}

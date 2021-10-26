import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  ThemeMode getThemeMode() {
    return themeMode;
  }

  void setThemeMode(ThemeMode mode) {
    themeMode = mode;
    notifyListeners();
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomThemes {
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    colorScheme: ColorScheme.dark(primary: Colors.blue[300] as Color),
    secondaryHeaderColor: Colors.grey[500],
    hintColor: Colors.green[300],
    errorColor: Colors.red[300],
    bottomAppBarColor: const Color.fromRGBO(55, 55, 55, 0.6),
    splashColor: Colors.grey[800],
    highlightColor: Colors.grey[900],
    cardColor: Colors.grey[900],
    primaryColor: Colors.blue,
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.green),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
    ),
    cupertinoOverrideTheme: const CupertinoThemeData(
      brightness: Brightness.dark,
      textTheme: CupertinoTextThemeData(), // This is required
    ),
  );

  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    secondaryHeaderColor: Colors.grey[600],
    colorScheme: ColorScheme.light(primary: Colors.blue[600] as Color),
    hintColor: Colors.green[500],
    errorColor: Colors.red[500],
    bottomAppBarColor: const Color.fromRGBO(255, 255, 255, 0.6),
    splashColor: Colors.grey[300],
    highlightColor: Colors.grey[200],
    cardColor: Colors.grey[300],
    primaryColor: Colors.blue,
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.green),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
    ),
  );
}

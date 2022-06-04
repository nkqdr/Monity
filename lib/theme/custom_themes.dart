import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomThemes {
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: const Color(0xff333333),
    shadowColor: const Color(0xff141414),
    highlightColor: const Color(0xff414141),
    colorScheme: ColorScheme.dark(primary: Colors.blue[300] as Color),
    secondaryHeaderColor: Colors.grey[500],
    hintColor: Colors.green[500],
    errorColor: Colors.red[700],
    bottomAppBarColor: const Color.fromRGBO(55, 55, 55, 0.6),
    splashColor: Colors.grey[800],
    cardColor: Colors.grey[800],
    primaryColor: Colors.blue,
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.green),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
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
    scaffoldBackgroundColor: const Color(0xffdddddd),
    shadowColor: const Color(0xffb1b1b1),
    highlightColor: const Color(0xfff3f3f3),
    secondaryHeaderColor: Colors.grey[600],
    colorScheme: ColorScheme.light(primary: Colors.blue[600] as Color),
    hintColor: Colors.green[500],
    errorColor: Colors.red[500],
    bottomAppBarColor: const Color.fromRGBO(255, 255, 255, 0.6),
    splashColor: Colors.grey[300],
    cardColor: Colors.grey[400],
    primaryColor: Colors.blue,
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.green),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
      ),
    ),
  );
}

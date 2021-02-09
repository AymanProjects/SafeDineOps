import 'package:flutter/material.dart';

class AppTheme with ChangeNotifier {
  //--Color palette--//
  final primary = Color(0xff2472c4);
  final white = Color(0xffffffff);
  final darkWhite = Color(0xfff1f3f6);
  final grey = Color(0xff99aab5);

  ThemeData _currentTheme;

  AppTheme() {
    setLightTheme();
  }

  ThemeData currentTheme() => _currentTheme;

  void setLightTheme() {
    _currentTheme = ThemeData(
      appBarTheme: AppBarTheme(brightness: Brightness.light),
      brightness: Brightness.light,
      primaryColor: primary,
      scaffoldBackgroundColor: darkWhite,
      textSelectionHandleColor: primary,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
    );
    notifyListeners();
  }
}

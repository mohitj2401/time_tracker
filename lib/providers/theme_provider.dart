import 'package:flutter/material.dart';

class ThemeProviders extends ChangeNotifier {
  int _theme_number = 0;

  List<ThemeData> themes = [
    ThemeData.dark(useMaterial3: true),
    ThemeData.light(useMaterial3: true),
  ];
  ThemeData get themeData => themes[_theme_number];

  updateTheme(int theme_number) {
    _theme_number = _theme_number == 1 ? 0 : 1;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  var isDarkMode = false.obs;

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    // You can also save the current theme mode to persistent storage (e.g., SharedPreferences) here.
  }

  ThemeData getThemeData() {
    return isDarkMode.value ? ThemeData.dark() : ThemeData.light();
  }
}

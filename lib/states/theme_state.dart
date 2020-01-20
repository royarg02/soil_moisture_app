import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// * Prefs Import
import 'package:soil_moisture_app/prefs/user_prefs.dart';
import 'package:soil_moisture_app/ui/build_theme.dart';

class ThemeState with ChangeNotifier {
  bool isDarkTheme;
  ThemeState() {
    isDarkTheme = getPrefs.getBool('isDarkTheme') ?? false;
    SystemChrome.setSystemUIOverlayStyle(appSystemUiTheme(isDarkTheme));
  }

  void toggleTheme() {
    isDarkTheme = !isDarkTheme;
    SystemChrome.setSystemUIOverlayStyle(appSystemUiTheme(isDarkTheme));
    notifyListeners();
  }
}

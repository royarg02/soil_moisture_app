import 'package:flutter/material.dart';

// * Prefs Import
import 'package:soil_moisture_app/prefs/user_prefs.dart';

// * ui import
import 'package:soil_moisture_app/ui/build_theme.dart';

class ThemeState with ChangeNotifier {
  ThemeData _appTheme;
  bool isDarkTheme = getPrefs.getBool('isDarkTheme') ?? false;
  ThemeState() {
    _appTheme = (isDarkTheme) ? buildDarkTheme() : buildLightTheme();
  }

  ThemeData get getTheme => _appTheme;

  void toggleTheme() {
    if (isDarkTheme) {
      _appTheme = buildLightTheme();
    } else {
      _appTheme = buildDarkTheme();
    }
    isDarkTheme = !isDarkTheme;
    notifyListeners();
    updateThemePrefs();
  }

  void updateThemePrefs() async {
    await getPrefs.setBool('isDarkTheme', isDarkTheme);
  }
}

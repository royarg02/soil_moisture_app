import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// * Prefs Import
import 'package:soif/prefs/user_prefs.dart';

// * ui import
import 'package:soif/ui/build_theme.dart';

class ThemeState with ChangeNotifier {
  bool isDarkTheme = getPrefs.getBool('isDarkTheme') ?? false;
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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// * Prefs Import
import 'package:soif/prefs/user_prefs.dart';

// * ui import
import 'package:soif/ui/build_theme.dart';

class ThemeState with ChangeNotifier {
  ThemeData _appTheme;
  SystemUiOverlayStyle _systemUiTheme;
  bool isDarkTheme = getPrefs.getBool('isDarkTheme') ?? false;
  ThemeState() {
    _appTheme = (isDarkTheme) ? buildDarkTheme() : buildLightTheme();
    _systemUiTheme = (isDarkTheme) ? buildDarkSystemUi() : buildLightSystemUi();
    SystemChrome.setSystemUIOverlayStyle(_systemUiTheme);
  }

  ThemeData get getTheme => _appTheme;
  SystemUiOverlayStyle get getSystemUiTheme => _systemUiTheme;

  void toggleTheme() {
    if (isDarkTheme) {
      _appTheme = buildLightTheme();
      _systemUiTheme = buildLightSystemUi();
    } else {
      _appTheme = buildDarkTheme();
      _systemUiTheme = buildDarkSystemUi();
    }
    isDarkTheme = !isDarkTheme;
    SystemChrome.setSystemUIOverlayStyle(_systemUiTheme);
    notifyListeners();
    updateThemePrefs();
  }

  void updateThemePrefs() async {
    await getPrefs.setBool('isDarkTheme', isDarkTheme);
  }
}

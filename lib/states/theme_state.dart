import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// * Prefs Import
import 'package:soif/prefs/user_prefs.dart';

// * ui import
import 'package:soif/ui/build_theme.dart';

// * utils import
import 'package:soif/utils/constants.dart';


/*
 * ThemeMode is determined by the following
 * 
 * THEMEMODE        | appThemeMode
 * -------------------------------
 * ThemeMode.light  | 0
 * ThemeMode.dark   | 1
 * ThemeMode.system | 2
 */
class ThemeState with ChangeNotifier {
  int appThemeMode;
  ThemeState(BuildContext context) {
    appThemeMode = getPrefs.getInt(soifThemeModePrefsKey) ?? 2;
    SystemChrome.setSystemUIOverlayStyle(
        appSystemUiTheme(isDarkTheme(context)));
  }

  void changeTheme(BuildContext context, int themeMode) {
    if (themeMode == null) return; // don't rebuild if theme dialog is dismissed
    appThemeMode = themeMode;
    SystemChrome.setSystemUIOverlayStyle(
        appSystemUiTheme(isDarkTheme(context)));
    notifyListeners();
  }

  bool isDarkTheme(BuildContext context) {
    return determineThemeMode(appThemeMode) == ThemeMode.dark ||
        (determineThemeMode(appThemeMode) == ThemeMode.system &&
            MediaQuery.platformBrightnessOf(context) == ui.Brightness.dark);
  }
}

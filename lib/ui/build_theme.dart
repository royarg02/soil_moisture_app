/*
* build_theme

* Defines the theme to be used in throughout the app
*/

import 'package:flutter/material.dart';

// * ui import
import 'package:soil_moisture_app/ui/colors.dart';

// * Light Theme
ThemeData buildLightTheme() {
  ThemeData base = ThemeData(
    brightness: Brightness.light,
    fontFamily: 'Ocrb',
  );
  return base.copyWith(
    appBarTheme: base.appBarTheme.copyWith(
      color: appPrimaryColor,
      textTheme: TextTheme(
        title: TextStyle(
          color: appSecondaryDarkColor,
          fontFamily: 'Ocrb',
        ),
      ),
    ),
    // * sets the background color of the `BottomNavigationBar`
    canvasColor: appSecondaryLightColor,
    // * sets the active color of the `BottomNavigationBar` if `Brightness` is light
    primaryColor: appSecondaryLightColor,
    textTheme: base.textTheme.copyWith(
      caption: TextStyle(
        color: appSecondaryColor,
        fontFamily: 'Ocrb',
      ),
    ),
    cardTheme: base.cardTheme.copyWith(
      color: appPrimaryLightColor,
      elevation: 3.0,
    ),
    snackBarTheme: base.snackBarTheme.copyWith(
      backgroundColor: appSecondaryColor,
    ),
    accentColor: appSecondaryColor,
    buttonTheme: base.buttonTheme.copyWith(buttonColor: appSecondaryColor),
    primaryIconTheme: base.iconTheme.copyWith(
      color: appSecondaryDarkColor,
    ),
    floatingActionButtonTheme: base.floatingActionButtonTheme.copyWith(
      backgroundColor: appSecondaryDarkColor,
    ),
  );
}

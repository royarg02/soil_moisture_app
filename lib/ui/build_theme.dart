import 'package:soil_moisture_app/ui/colors.dart';
import 'package:flutter/material.dart';

ThemeData buildLightTheme() {
  ThemeData base = ThemeData(
    brightness: Brightness.light,
    fontFamily: 'Ocrb',
  );
  return base.copyWith(
    appBarTheme: base.appBarTheme.copyWith(
      color: appPrimaryDarkColor,
      textTheme: TextTheme(
        title: TextStyle(
          fontSize: 28.0,
          color: appSecondaryDarkColor,
          fontFamily: 'Ocrb',
        ),
      ),
    ),
    // sets the background color of the `BottomNavigationBar`
    canvasColor: appPrimaryLightColor,
    // sets the active color of the `BottomNavigationBar` if `Brightness` is light
    primaryColor: appSecondaryLightColor,
    textTheme: base.textTheme.copyWith(
      caption: TextStyle(
        color: appSecondaryDarkColor,
        fontFamily: 'Ocrb',
      ),
    ),
    cardTheme: base.cardTheme.copyWith(
      color: appSecondaryLightColor,
      elevation: 5.0,
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

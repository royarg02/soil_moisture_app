import 'package:soil_moisture_app/ui/colors.dart';
import 'package:flutter/material.dart';

ThemeData buildLightTheme() {
  ThemeData base = ThemeData.light();
  return base.copyWith(
    appBarTheme: base.appBarTheme.copyWith(
      color: appPrimaryDarkColor,
      textTheme: TextTheme(
        title: TextStyle(
          fontSize: 28.0,
          color: Colors.black,
          fontFamily: 'Ocrb',
        ),
      ),
    ),
    // sets the background color of the `BottomNavigationBar`
    canvasColor: appPrimaryLightColor,
    // sets the active color of the `BottomNavigationBar` if `Brightness` is light
    primaryColor: appSecondaryLightColor,
    textTheme: base.textTheme.copyWith(
      caption: new TextStyle(
        color: appSecondaryDarkColor,
      ),
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

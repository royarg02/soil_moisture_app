/*
* build_theme

* Defines the theme to be used in throughout the app
*/

import 'package:flutter/material.dart';

// * ui import
import 'package:soil_moisture_app/ui/colors.dart';

// * Text theme to be used throughout the app
TextTheme appTextTheme = TextTheme(
  display4: TextStyle(fontFamily: 'Ocrb'),
  display3: TextStyle(fontFamily: 'Ocrb'),
  display2: TextStyle(fontFamily: 'Ocrb'),
  display1: TextStyle(fontFamily: 'Ocrb'),
  body1: TextStyle(fontFamily: 'Ocrb'),
  body2: TextStyle(fontFamily: 'Ocrb'),
  headline: TextStyle(fontFamily: 'Ocrb'),
  subtitle: TextStyle(fontFamily: 'Ocrb'),
  button: TextStyle(fontFamily: 'Ocrb'),
  caption: TextStyle(fontFamily: 'Ocrb'),
  subhead: TextStyle(fontFamily: 'Ocrb'),
  overline: TextStyle(fontFamily: 'Ocrb'),
  title: TextStyle(fontFamily: 'Ocrb'),
);

// * Light Theme
ThemeData buildLightTheme() {
  ThemeData base = ThemeData.from(
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      background: Colors.white,
      primary: appPrimaryColor,
      secondary: appSecondaryLightColor,
      surface: appPrimaryLightColor,
      error: appErrorDarkColor,
      onBackground: Colors.black,
      onError: Colors.black,
      onPrimary: appSecondaryDarkColor,
      onSecondary: appPrimaryLightColor,
      onSurface: Colors.black,
      primaryVariant: appPrimaryDarkColor,
      secondaryVariant: appSecondaryColor,
    ),
    textTheme: appTextTheme,
  );
  return base.copyWith(
    floatingActionButtonTheme: base.floatingActionButtonTheme.copyWith(
      backgroundColor: appSecondaryDarkColor,
    ),
    bottomSheetTheme: base.bottomSheetTheme.copyWith(
      backgroundColor: appSecondaryLightColor,
    ),
    tabBarTheme: base.tabBarTheme.copyWith(
      labelColor: base.cardColor,
      unselectedLabelColor: appSecondaryDarkColor,
      indicatorSize: TabBarIndicatorSize.label,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(
          width: 3.0,
          color: base.cardColor,
        ),
        insets: EdgeInsets.only(bottom: 1.0),
      ),
    ),
    cardTheme: base.cardTheme.copyWith(
      elevation: 3.0,
    ),
    snackBarTheme: base.snackBarTheme.copyWith(
      backgroundColor: appSecondaryColor,
    ),
    accentTextTheme: appTextTheme,
    primaryTextTheme: appTextTheme,
  );
}
// ThemeData buildLightTheme() {
//   ThemeData base = ThemeData(
//     brightness: Brightness.light,
//     fontFamily: 'Ocrb',
//   );
//   return base.copyWith(
//     appBarTheme: base.appBarTheme.copyWith(
//       brightness: Brightness.light,
//       color: appPrimaryColor,
//       textTheme: TextTheme(
//         title: TextStyle(
//           color: appSecondaryDarkColor,
//           fontFamily: 'Ocrb',
//         ),
//       ),
//     ),
//     // * sets the background color of the `BottomNavigationBar`
//     canvasColor: appSecondaryLightColor,
//     // * sets the active color of the `BottomNavigationBar` if `Brightness` is light
//     primaryColor: appSecondaryLightColor,
//     textTheme: base.textTheme.copyWith(
//       caption: TextStyle(
//         color: appSecondaryColor,
//         fontFamily: 'Ocrb',
//       ),
//     ),
//     tabBarTheme: base.tabBarTheme.copyWith(
//       labelColor: appPrimaryLightColor,
//       unselectedLabelColor: appSecondaryDarkColor,
//       indicatorSize: TabBarIndicatorSize.label,
//     ),
//     cardTheme: base.cardTheme.copyWith(
//       color: appPrimaryLightColor,
//       elevation: 3.0,
//     ),
//     snackBarTheme: base.snackBarTheme.copyWith(
//       backgroundColor: appSecondaryColor,
//     ),
//     accentColor: appSecondaryColor,
//     buttonTheme: base.buttonTheme.copyWith(buttonColor: appSecondaryColor),
//     primaryIconTheme: base.iconTheme.copyWith(
//       color: appSecondaryDarkColor,
//     ),
//     floatingActionButtonTheme: base.floatingActionButtonTheme.copyWith(
//       backgroundColor: appSecondaryDarkColor,
//     ),
//     bottomSheetTheme: base.bottomSheetTheme.copyWith(
//       backgroundColor: appSecondaryLightColor,
//     ),
//   );
// }

ThemeData buildDarkTheme() {
  ThemeData base = ThemeData.from(
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      background: materialDarkGreyColor,
      primary:
          darkAppPrimaryLightColor, // completely useless, use surface instead
      secondary: darkAppPrimaryColor,
      surface: materialDarkGreyColor,
      error: darkAppErrorDarkColor,
      onPrimary: Colors.black, // completely useless, use onSurface instead
      onBackground: Colors.white,
      onError: Colors.black,
      onSecondary: Colors.black,
      onSurface: Colors.white,
      primaryVariant: darkAppPrimaryColor,
      secondaryVariant: darkAppPrimaryColor,
    ),
    textTheme: appTextTheme,
  );
  return base.copyWith(
    tabBarTheme: base.tabBarTheme.copyWith(
      labelColor: base.cardColor,
      unselectedLabelColor: darkAppSecondaryDarkColor,
      indicatorSize: TabBarIndicatorSize.label,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(
          width: 3.0,
          color: base.cardColor,
        ),
        insets: EdgeInsets.only(bottom: 1.0),
      ),
    ),
    cardTheme: base.cardTheme.copyWith(
      elevation: 3.0,
    ),
    snackBarTheme: base.snackBarTheme.copyWith(
      backgroundColor: darkAppPrimaryLightColor,
    ),
    accentTextTheme: appTextTheme,
    primaryTextTheme: appTextTheme,
  );
}

/*
* build_theme

* Defines the theme to be used in throughout the app
*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// * ui import
import 'package:soif/ui/colors.dart';
import 'package:soif/ui/custom_slider_thumb_shape.dart';

// * Helper functions for returning appropriate themes
ThemeMode determineThemeMode(bool isDarkTheme) {
  return isDarkTheme ? ThemeMode.dark : ThemeMode.light;
}

SystemUiOverlayStyle appSystemUiTheme(bool isDarkTheme) {
  return isDarkTheme ? buildDarkSystemUi() : buildLightSystemUi();
}

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
  );
  return base.copyWith(
    textTheme: base.textTheme.apply(fontFamily: 'JetBrains Mono'),
    appBarTheme: base.appBarTheme.copyWith(
      brightness: Brightness.light,
    ),
    floatingActionButtonTheme: base.floatingActionButtonTheme.copyWith(
      backgroundColor: appSecondaryDarkColor,
    ),
    bottomSheetTheme: base.bottomSheetTheme.copyWith(
      backgroundColor: appSecondaryLightColor,
    ),
    buttonBarTheme: base.buttonBarTheme.copyWith(
      buttonTextTheme: ButtonTextTheme.accent,
      alignment: MainAxisAlignment.spaceEvenly,
    ),
    tabBarTheme: base.tabBarTheme.copyWith(
      labelColor: base.cardColor,
      unselectedLabelColor: appSecondaryDarkColor,
      indicatorSize: TabBarIndicatorSize.label,
    ),
    cardTheme: base.cardTheme.copyWith(
      elevation: 3.0,
    ),
    sliderTheme: base.sliderTheme.copyWith(
      thumbShape: CustomSliderThumbShape(thumbRadius: 8.0),
    ),
    snackBarTheme: base.snackBarTheme.copyWith(
      backgroundColor: appSecondaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(14.0),
        ),
      ),
    ),
    accentTextTheme: base.accentTextTheme.apply(
      fontFamily: 'JetBrains Mono',
    ),
    primaryTextTheme: base.accentTextTheme.apply(
      fontFamily: 'JetBrains Mono',
      bodyColor: appSecondaryDarkColor,
      displayColor: appSecondaryDarkColor,
    ),
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder()
      },
    ),
  );
}

ThemeData buildDarkTheme() {
  ThemeData base = ThemeData.from(
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      background: materialDarkGreyColor,
      primary:
          darkAppPrimaryLightColor, // completely useless, use surface instead
      secondary: darkAppPrimaryColor,
      surface: materialDarkGreyColor,
      error: darkAppErrorLightColor,
      onPrimary: Colors.black, // completely useless, use onSurface instead
      onBackground: Colors.white,
      onError: Colors.black,
      onSecondary: Colors.black,
      onSurface: Colors.white,
      primaryVariant: darkAppPrimaryColor,
      secondaryVariant: darkAppPrimaryColor,
    ),
  );
  return base.copyWith(
    textTheme: base.textTheme.apply(fontFamily: 'JetBrains Mono'),
    appBarTheme: base.appBarTheme.copyWith(
      brightness: Brightness.dark,
    ),
    tabBarTheme: base.tabBarTheme.copyWith(
      labelColor: base.cardColor,
      unselectedLabelColor: darkAppSecondaryDarkColor,
      indicatorSize: TabBarIndicatorSize.label,
    ),
    cardTheme: base.cardTheme.copyWith(
      elevation: 3.0,
    ),
    sliderTheme: base.sliderTheme.copyWith(
      thumbShape: CustomSliderThumbShape(thumbRadius: 8.0),
    ),
    snackBarTheme: base.snackBarTheme.copyWith(
      backgroundColor: darkAppPrimaryLightColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(14.0),
        ),
      ),
    ),
    buttonBarTheme: base.buttonBarTheme.copyWith(
      buttonTextTheme: ButtonTextTheme.accent,
      alignment: MainAxisAlignment.spaceEvenly,
    ),
    accentTextTheme: base.accentTextTheme.apply(
      fontFamily: 'JetBrains Mono',
    ),
    primaryTextTheme: base.accentTextTheme.apply(
      fontFamily: 'JetBrains Mono',
      bodyColor: base.accentColor,
      displayColor: base.accentColor,
    ),
    toggleableActiveColor: darkAppPrimaryColor,
    iconTheme: base.iconTheme.copyWith(
      color: base.accentColor,
    ),
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder()
      },
    ),
  );
}

SystemUiOverlayStyle buildLightSystemUi() => SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
    );

SystemUiOverlayStyle buildDarkSystemUi() => SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
    );

/*
* Colors

* Colour values to be used throughout the app
*/

import 'package:flutter/material.dart';

// * Converts hexadecimal color string to Material Color
Color hexToColor(String code) {
  return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

final appPrimaryColor = hexToColor('#e6ee9c');
final appPrimaryLightColor = hexToColor('#ffffce');
final appPrimaryDarkColor = hexToColor('#b3bc6d');

final appSecondaryColor = hexToColor('#827717');
final appSecondaryLightColor = hexToColor('#b4a647');
final appSecondaryDarkColor = hexToColor('#524c00');

final appProgressIndicatorBackgroundColor = Colors.grey[300];
final appErrorDarkColor = hexToColor('#FF8282');
final appErrorLightColor = Colors.red[100];

final moreThanNormalPlantColor = Colors.blue;
final criticalPlantColor = Colors.red;
final normalPlantColor = Colors.green;

final subtleBlackTextColor = Colors.black54;
final subtleWhiteTextColor = Colors.white54;

final materialDarkGreyColor = hexToColor('#121212');
final materialBlackColor = Colors.black;

final darkAppPrimaryColor = appPrimaryColor;
final darkAppPrimaryLightColor = appPrimaryLightColor;
final darkAppSecondaryDarkColor = appSecondaryDarkColor;

final darkAppProgressIndicatorBackgroundColor = materialDarkGreyColor;

final darkAppErrorDarkColor = Colors.red[300];
final darkAppErrorLightColor = Colors.red[200];

// * brand colors
final twitterBlue = hexToColor('#38A1F3');
final githubBlack = Colors.black;
final githubWhite = Colors.white;

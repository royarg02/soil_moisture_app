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

// * brand colors
final twitterBlue = hexToColor('#38A1F3');  
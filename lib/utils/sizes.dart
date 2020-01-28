/* 
* sizes

* Determines the sizes of the widgets depending on screen size and orientation
*/

import 'package:flutter/material.dart';
import 'package:soif/utils/constants.dart';

bool isPortrait(context) =>
    MediaQuery.of(context).orientation == Orientation.portrait;

double appHeight(context) => (isPortrait(context))
    ? MediaQuery.of(context).size.height
    : MediaQuery.of(context).size.width;

double appWidth(context) => (isPortrait(context))
    ? MediaQuery.of(context).size.width
    : MediaQuery.of(context).size.height;

double appChartHeight(context) =>
    (appHeight(context) < 700) ? soifChartHeightSmall : soifChartHeightBig;

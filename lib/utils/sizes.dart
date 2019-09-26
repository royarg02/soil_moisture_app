/* 
* sizes

* Determines the sizes of the widgets depending on screen size
*/

import 'package:flutter/material.dart';

MediaQueryData appQuery;

getQuery(MediaQueryData mediaQuery) {
  appQuery = mediaQuery;
}

double appWidth = appQuery.size.width;
double appHeight = appQuery.size.height;

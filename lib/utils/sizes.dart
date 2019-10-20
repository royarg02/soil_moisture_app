/* 
* sizes

* Determines the sizes of the widgets depending on screen size and orientation
*/

import 'package:flutter/material.dart';

bool isPortrait(context) =>
    MediaQuery.of(context).orientation == Orientation.portrait;

double appHeight(context) => (isPortrait(context))
    ? MediaQuery.of(context).size.height
    : MediaQuery.of(context).size.width;

double appWidth(context) => (isPortrait(context))
    ? MediaQuery.of(context).size.width
    : MediaQuery.of(context).size.height;

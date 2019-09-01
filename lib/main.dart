import 'package:flutter/material.dart';
import 'package:soil_moisture_app/ui/build_theme.dart';
import 'package:soil_moisture_app/ui/colors.dart';
import 'package:flutter/services.dart';
// Pages Import

import 'pages/Analysis.dart';
import 'pages/Overview.dart';

import 'dart:math' as math; //! Remove this when refresh implemented

var rnd = math.Random(69); //! Remove this when refresh implemented

void main() {
  String title = 'Soil App';
  runApp(
    MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      home: new HomeApp(title),
      theme: buildLightTheme(),
    ),
  );
}

class HomeApp extends StatefulWidget {
  final String title;
  HomeApp(this.title);
  @override
  _HomeAppState createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    Overview(),
    Analysis(),
  ];
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.black, //top bar color
        systemNavigationBarColor: Colors.black, //bottom bar color

        statusBarIconBrightness: Brightness.light, //top icon color
        systemNavigationBarIconBrightness:
            Brightness.light, //bottom icons color
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: new BottomNavigationBar(
        onTap: onTabTapped,
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.remove_red_eye,
              color: _currentIndex == 0
                  ? appSecondaryDarkColor
                  : appPrimaryDarkColor,
            ),
            title: new Text(
              "Overview",
              style: TextStyle(
                fontFamily: 'Ocrb',
                color: _currentIndex == 0
                    ? appSecondaryDarkColor
                    : appPrimaryDarkColor,
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.linear_scale,
              color: _currentIndex == 1
                  ? appSecondaryDarkColor
                  : appPrimaryDarkColor,
            ),
            title: new Text(
              "Analysis",
              style: TextStyle(
                fontFamily: 'Ocrb',
                color: _currentIndex == 1
                    ? appSecondaryDarkColor
                    : appPrimaryDarkColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

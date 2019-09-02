import 'package:flutter/material.dart';
import 'package:soil_moisture_app/ui/build_theme.dart';
import 'package:soil_moisture_app/ui/colors.dart';
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
      home: new Home(title),
      theme: buildLightTheme(),
    ),
  );
}

class Home extends StatefulWidget {
  final String title;
  Home(this.title);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    Overview(),
    Analysis(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: Theme.of(context)
              .appBarTheme
              .textTheme
              .title
              .copyWith(fontSize: MediaQuery.of(context).size.height * 0.03),
        ),
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

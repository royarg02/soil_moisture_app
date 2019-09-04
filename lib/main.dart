import 'package:flutter/material.dart';
import 'package:soil_moisture_app/ui/build_theme.dart';
import 'package:soil_moisture_app/ui/colors.dart';
import 'package:soil_moisture_app/utils/gettingJson.dart';
// Pages Import

import 'pages/Analysis.dart';
import 'pages/Overview.dart';

import 'dart:math' as math; //! Remove this when refresh implemented

var rnd = math.Random(69); //! Remove this when refresh implemented

void main() async {
  String title = 'Soil App';
  await fetchTotalData().then((onValue) {
    addPlantData(onValue['records']);
  });
  // * implement onError here
  print('from main: ${data[0].moisture}');
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
        title: Container(
          margin: const EdgeInsets.all(6.0),
          child: Image.asset('./assets/images/Soif_sk.png'),
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
              size: _currentIndex == 0 ? 32.0 : 24.0,
              color: _currentIndex == 0
                  ? appPrimaryLightColor
                  : appSecondaryDarkColor,
            ),
            title: new Text(
              "Overview",
              style: TextStyle(
                color: _currentIndex == 0
                    ? appPrimaryLightColor
                    : appSecondaryDarkColor,
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.linear_scale,
              size: _currentIndex == 1 ? 32.0 : 24.0,
              color: _currentIndex == 1
                  ? appPrimaryLightColor
                  : appSecondaryDarkColor,
            ),
            title: new Text(
              "Analysis",
              style: TextStyle(
                color: _currentIndex == 1
                    ? appPrimaryLightColor
                    : appSecondaryDarkColor,
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

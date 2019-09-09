import 'package:flutter/material.dart';
import 'package:soil_moisture_app/pages/Analysis.dart';
import 'package:soil_moisture_app/pages/Overview.dart';
import 'package:soil_moisture_app/pages/ThresholdPump.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:soil_moisture_app/ui/colors.dart';

class SoifDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: appPrimaryLightColor,
      ),
      child: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              // padding: EdgeInsets.all(10.0),
              // // child: Image.asset('./assets/images/Soif_sk.png'),
              // child: Image.asset(
              //   'assets/images/plant.png',
              // ),
              child: Row(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      "assets/images/plant.png",
                      color: appPrimaryDarkColor,
                      height: 70.0,
                      width: 70.0,
                    ),
                  ),
                  SizedBox(height: 20.0,width: 20.0,),
                  Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      "assets/images/Soif_sk.png",
                      color: appPrimaryDarkColor,
                      height: 80.0,
                      width: 80.0,
                    ),
                  ),
                ],
              ),
              margin: EdgeInsets.only(left: 10.0),
              padding: EdgeInsets.all(0.0),
            ),
            ListTile(
              title: Text('Overview'),
              leading: Icon(FontAwesomeIcons.eye),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => Overview()));
              },
            ),
            ListTile(
              title: Text('Analysis'),
              leading: Icon(FontAwesomeIcons.chartLine),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => Analysis()));
              },
            ),
            ListTile(
              title: Text('Settings'),
              leading: Icon(Icons.settings),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => ThresholdPump()));
              },
            )
          ],
        ),
      ),
    );
  }
}

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
                child: Image.asset('./assets/images/Soif_sk.png'),
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

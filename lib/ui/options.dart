/* 
* options

* Displays a bottom options menu for 'Pump Threshold Control' and 'About', for now.
*/

import 'package:flutter/material.dart';

// * External packages import
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

// * Pages Import
import 'package:soil_moisture_app/pages/Credits.dart';
import 'package:soil_moisture_app/pages/ThresholdPump.dart';
import 'package:soil_moisture_app/states/theme_state.dart';

class Options extends StatelessWidget {
  void showOptions(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: (Provider.of<ThemeState>(context).isDarkTheme)
                ? Icon(FontAwesomeIcons.solidLightbulb)
                : Icon(FontAwesomeIcons.lightbulb),
            title: Text('Dark Theme'),
            trailing: Switch(
              value: Provider.of<ThemeState>(context).isDarkTheme,
              onChanged: (_) => Provider.of<ThemeState>(context).toggleTheme(),
            ),
            onTap: () => Provider.of<ThemeState>(context).toggleTheme(),
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.slidersH),
            title: Text('Pump Threshold Control'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ThresholdPump()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Credits()),
              );
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.more_vert),
      onPressed: () => showOptions(context),
    );
  }
}

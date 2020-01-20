/* 
* options

* Displays a bottom options menu for 'Dark Theme', 'Pump Threshold Control' and 'About'.
*/

import 'package:flutter/material.dart';

// * External packages import
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

// * UI import
import 'package:soil_moisture_app/ui/colors.dart';

// * Pages Import
import 'package:soil_moisture_app/pages/Credits.dart';
import 'package:soil_moisture_app/pages/ThresholdPump.dart';

// * State Import
import 'package:soil_moisture_app/states/theme_state.dart';

class Options extends StatelessWidget {
  void showOptions(BuildContext context) {
    var _themeState = Provider.of<ThemeState>(context);
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: (_themeState.isDarkTheme)
                ? Icon(FontAwesomeIcons.solidLightbulb)
                : Icon(FontAwesomeIcons.lightbulb),
            title: Text('Dark Theme'),
            trailing: Switch(
              value: _themeState.isDarkTheme,
              onChanged: (_) => _themeState.toggleTheme(),
            ),
            onTap: () => _themeState.toggleTheme(),
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
      icon: Icon(
        Icons.more_vert,
        color: (Provider.of<ThemeState>(context).isDarkTheme)
            ? materialDarkGreyColor
            : Theme.of(context).iconTheme.color,
      ),
      onPressed: () => showOptions(context),
    );
  }
}

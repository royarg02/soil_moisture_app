/* 
* options

* Displays a bottom options menu for 'Dark Theme', 'Pump Threshold Control' and 'About'.
*/

import 'package:flutter/material.dart';

// * External packages import
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

// * UI import
import 'package:soif/ui/build_theme.dart';
import 'package:soif/ui/colors.dart';

// * Pages Import
import 'package:soif/pages/Credits.dart';
import 'package:soif/pages/ThresholdPump.dart';

// * State Import
import 'package:soif/states/theme_state.dart';

// * Widgets Import
import 'package:soif/widgets/theme_dialog.dart';

class OptionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.more_vert,
        color: (Provider.of<ThemeState>(context).isDarkTheme(context))
            ? materialDarkGreyColor
            : Theme.of(context).iconTheme.color,
      ),
      onPressed: () => showOptions(context),
    );
  }
}

// * Extension to get ThemeMode name
extension on ThemeMode {
  String get name {
    switch (this) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      default:
        return 'System Default';
    }
  }
}

void showOptions(BuildContext context) {
  showModalBottomSheet(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(14.0)),
    ),
    isScrollControlled: true,
    context: context,
    builder: (context) => Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: Icon(FontAwesomeIcons.palette),
          title: Text('Theme'),
          trailing: Text(
            determineThemeMode(Provider.of<ThemeState>(context).appThemeMode)
                .name,
          ),
          onTap: () => showThemeDialog(context).then(
            (newTheme) => Provider.of<ThemeState>(context, listen: false)
                .changeTheme(context, newTheme),
          ),
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

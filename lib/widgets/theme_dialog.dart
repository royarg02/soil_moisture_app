import 'package:flutter/material.dart';

// * External packages import
import 'package:provider/provider.dart';

// * State import
import 'package:soif/states/theme_state.dart';

Future<int> showThemeDialog(BuildContext context){
  return showDialog<int>(
    context: context,
    builder: (context) {
      return SimpleDialog(
        title: Text('Theme'),
        children: <Widget>[
          ListTile(
            leading: Radio<int>(
              value: 0,
              groupValue: Provider.of<ThemeState>(context).appThemeMode,
              onChanged: (value) => Navigator.pop<int>(context, 0),
            ),
            title: Text('Light'),
            onTap: () => Navigator.pop<int>(context, 0),
          ),
          ListTile(
            leading: Radio<int>(
              value: 1,
              groupValue: Provider.of<ThemeState>(context).appThemeMode,
              onChanged: (value) => Navigator.pop<int>(context, 1),
            ),
            title: Text('Dark'),
            onTap: () => Navigator.pop<int>(context, 1),
          ),
          ListTile(
            leading: Radio<int>(
              value: 2,
              groupValue: Provider.of<ThemeState>(context).appThemeMode,
              onChanged: (value) => Navigator.pop<int>(context, 2),
            ),
            title: Text('System Default'),
            onTap: () => Navigator.pop<int>(context, 2),
          ),
          ButtonBar(
            children: <Widget>[
              FlatButton(
                child: Text('CANCEL'),
                onPressed: () => Navigator.pop(context, null),
              )
            ],
          )
        ],
      );
    },
  );
}

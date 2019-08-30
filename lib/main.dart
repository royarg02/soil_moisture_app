import 'package:flutter/material.dart';
import 'ui/colors.dart';

void main() {
  final String title = 'Soil Moisture control';
  runApp(
    MaterialApp(
      title: title,
      home: Home(
        title: title,
      ),
      theme: _lightTheme,
    ),
  );
}

final ThemeData _lightTheme = _buildLightTheme();

ThemeData _buildLightTheme() {
  ThemeData base = ThemeData.light();
  return base.copyWith(
    accentColor: appComplementaryLightColor,
    primaryColor: appPrimaryColor,
    buttonTheme: ThemeData.light().buttonTheme.copyWith(
          buttonColor: appPrimaryColor,
          textTheme: ButtonTextTheme.normal,
        ),
    scaffoldBackgroundColor: appBackgroundColor,
    textTheme: _buildTextThemeLight(base.textTheme),
    primaryTextTheme: _buildTextThemeLight(base.primaryTextTheme),
    accentTextTheme: _buildTextThemeLight(base.accentTextTheme),
    primaryIconTheme: base.iconTheme.copyWith(
      color: appComplementaryLightColor,
    ) 
  );
}

TextTheme _buildTextThemeLight(TextTheme base) {
  return base
      .copyWith(
        headline: base.headline.copyWith(fontWeight: FontWeight.w500),
        title: base.title.copyWith(fontSize: 18.0),
        caption: base.caption.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 14.0,
        ),
      )
      .apply(
        displayColor: appComplementaryLightColor,
        bodyColor: appComplementaryLightColor,
      );
}

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.cake),
            onPressed: () => print('Test'),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

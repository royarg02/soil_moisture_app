import 'package:flutter/material.dart';
import 'package:soil_moisture_app/ui/colors.dart';

void main() => runApp(MaterialApp(
      title: "Soli App",
      debugShowCheckedModeBanner: false,
      home: new HomeApp(),
    ));

class HomeApp extends StatefulWidget {
  @override
  _HomeAppState createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: appPrimaryDarkColor,
        title: new Text("Soli App"),
      ),
      body: Container(),
      bottomNavigationBar: new Theme(
        data: Theme.of(context).copyWith(
            // sets the background color of the `BottomNavigationBar`
            canvasColor: appPrimaryLightColor,
            // sets the active color of the `BottomNavigationBar` if `Brightness` is light
            primaryColor: appSecondaryLightColor,
            textTheme: Theme.of(context).textTheme.copyWith(
                caption: new TextStyle(
                    color:
                        appSecondaryDarkColor))), // sets the inactive color of the `BottomNavigationBar`
        child: new BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: 0,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.remove_red_eye,
              ),
              title: new Text(
                "Overview",
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.linear_scale,
              ),
              title: new Text(
                "Analysis",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

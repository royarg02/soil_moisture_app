import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // * For SystemChrome

// * ui import
import 'package:soil_moisture_app/ui/build_theme.dart';
import 'package:soil_moisture_app/ui/colors.dart';
import 'package:soil_moisture_app/ui/options.dart';

// * utils import
import 'package:soil_moisture_app/utils/sizes.dart';

// * Pages Import
import 'pages/Analysis.dart';
import 'pages/Overview.dart';

void main() async {
  String title = 'Soif';
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: appPrimaryColor,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: appSecondaryLightColor,
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  runApp(MaterialApp(
    title: title,
    debugShowCheckedModeBanner: false,
    home: DefaultTabController(length: 2, child: Home()),
    theme: buildLightTheme(),
  ));
}

class Home extends StatelessWidget {
  final List<Widget> _children = [
    Overview(),
    Analysis(),
  ];

  @override
  Widget build(BuildContext context) {
    print(appWidth(context));
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          './assets/images/Soif_sk.png',
          height: appWidth(context) * 0.08,
        ),
        centerTitle: true,
      ),
      body: TabBarView(
        children: _children,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: Container(
        color: Theme.of(context).canvasColor,
        child: Row(
          children: <Widget>[
            Flexible(
              child: TabBar(
                tabs: <Widget>[
                  Tab(
                    icon: Icon(
                      Icons.remove_red_eye,
                    ),
                    text: 'Overview',
                  ),
                  Tab(
                    icon: Icon(
                      Icons.timeline,
                    ),
                    text: 'Analysis',
                  )
                ],
                indicatorPadding: EdgeInsets.all(appWidth(context) * 0.01),
                indicatorColor: appPrimaryLightColor,
                unselectedLabelStyle: TextStyle(
                  fontSize: appWidth(context) * 0.025,
                  fontFamily: 'Ocrb',
                ),
                labelStyle: TextStyle(
                  fontSize: appWidth(context) * 0.035,
                  fontFamily: 'Ocrb',
                ),
              ),
            ),
            Options()
          ],
        ),
      ),
    );
  }
}

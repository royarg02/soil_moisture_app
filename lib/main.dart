import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // * For SystemChrome

// * external packages import
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// * ui import
import 'package:soil_moisture_app/ui/build_theme.dart';
import 'package:soil_moisture_app/ui/colors.dart';
import 'package:soil_moisture_app/utils/sizes.dart';

// * Pages Import
import 'pages/Credits.dart';
import 'pages/Analysis.dart';
import 'pages/Overview.dart';
import 'pages/ThresholdPump.dart';

void main() async {
  String title = 'Soif';
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: appPrimaryColor,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: appSecondaryLightColor,
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  // * Lock orientation to only portrait
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) => runApp(MaterialApp(
        title: title,
        debugShowCheckedModeBanner: false,
        home: Startup(),
        theme: buildLightTheme(),
      )));
}

/*
* A peculiar bug with MediaQuery which gives a zero size upon startup. This causes problems in release
* mode of the app where the widgets are not rendered with zero size. This widget launches in between to
* ensure the MediaQuery gives a non - zero value. Negligible effect in performance.
*/

class Startup extends StatefulWidget {
  @override
  _StartupState createState() => _StartupState();
}

class _StartupState extends State<Startup> {
  Future<MediaQueryData> whenNotZero(Stream<MediaQueryData> source) async {
    await for (MediaQueryData value in source) {
      print("Width: ${value.size.width}");
      // * Return only when MediaQuery has non - zero value
      if (value.size.width > 0) {
        return value;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: whenNotZero(Stream<MediaQueryData>.periodic(
          Duration(milliseconds: 50), (_) => MediaQuery.of(context))),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          getQuery(snapshot.data);
          return DefaultTabController(length: 2, child: Home());
        } else {
          return FetchingQuery();
        }
      },
    );
  }
}

class Home extends StatelessWidget {
  final List<Widget> _children = [
    Overview(),
    Analysis(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ! Implement Credits Here
      // drawer: Drawer(
      //   child: Credits(),
      // ),
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.info),
              iconSize: appWidth * 0.05,
              tooltip: 'About',
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
        title: Image.asset(
          './assets/images/Soif_sk.png',
          height: appWidth * 0.08,
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(FontAwesomeIcons.slidersH),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => ThresholdPump())),
            tooltip: 'Pump Threshold Control',
            iconSize: appWidth * 0.05,
          )
        ],
      ),
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: appWidth * 0.03),
        child: TabBarView(
          children: _children,
          physics: NeverScrollableScrollPhysics(),
        ),
      ),
      bottomNavigationBar: Container(
        color: Theme.of(context).canvasColor,
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
                Icons.linear_scale,
              ),
              text: 'Analysis',
            )
          ],
          indicatorPadding: EdgeInsets.all(appWidth * 0.01),
          indicatorColor: appPrimaryLightColor,
          unselectedLabelStyle: TextStyle(
            fontSize: appWidth * 0.025,
            fontFamily: 'Ocrb',
          ),
          labelStyle: TextStyle(
            fontSize: appWidth * 0.035,
            fontFamily: 'Ocrb',
          ),
        ),
      ),
    );
  }
}

class FetchingQuery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Image.asset('assets/images/soif_launch.png'),
          ),
          SizedBox(
            width: 192.0,
            child: LinearProgressIndicator(),
          ),
        ],
      ),
      backgroundColor: appPrimaryColor,
    );
  }
}

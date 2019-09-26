import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // * For SystemChrome

// * external packages import
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// * ui import
import 'package:soil_moisture_app/ui/build_theme.dart';
import 'package:soil_moisture_app/ui/colors.dart';
import 'package:soil_moisture_app/utils/sizes.dart';

// * Pages Import
import 'pages/Analysis.dart';
import 'pages/Overview.dart';
import 'pages/ThresholdPump.dart';

void main() async {
  String title = 'Soif';
  // * Lock orientation to only portrait
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) => runApp(MaterialApp(
        title: title,
        debugShowCheckedModeBanner: false,
        home: Startup(title),
        theme: buildLightTheme(),
      )));
}

/*
* A peculiar bug with MediaQuery which gives a zero size upon startup. This causes problems in release
* mode of the app where the widgets are not rendered with zero size. This widget launches in between to
* ensure the MediaQuery gives a non - zero value. Negligible effect in performance.
*/

class Startup extends StatefulWidget {
  final String title;
  Startup(this.title);
  @override
  _StartupState createState() => _StartupState();
}

class _StartupState extends State<Startup> {
  Future<MediaQueryData> whenNotZero(Stream<MediaQueryData> source) async {
    await for (MediaQueryData value in source) {
      print("Width: ${value.size.width}");
      // * Return only whhen MediaQuery has non - zero value
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
          return DefaultTabController(length: 2, child: Home(widget.title));
        } else {
          return Scaffold(
            body: Center(
              child: LinearProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}

class Home extends StatelessWidget {
  final String title;
  Home(this.title);

  final List<Widget> _children = [
    Overview(),
    Analysis(),
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black, //top bar color
      systemNavigationBarColor: Colors.black, //bottom bar color

      statusBarIconBrightness: Brightness.light, //top icon color
      systemNavigationBarIconBrightness: Brightness.light, //bottom icons color
    ));
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appWidth * 0.12),
        child: AppBar(
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
      ),
      body: TabBarView(
        children: _children,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: PreferredSize(
        preferredSize: Size.fromHeight(appWidth * 0.18),
        child: Container(
          height: appWidth * 0.18,
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
            indicatorColor: appSecondaryLightColor,
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
      ),
      backgroundColor: Theme.of(context).canvasColor,
    );
  }
}

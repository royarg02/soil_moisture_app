import 'package:flutter/material.dart';
import 'package:soil_moisture_app/pages/ThresholdPump.dart';
import 'package:soil_moisture_app/ui/build_theme.dart';
import 'package:soil_moisture_app/ui/colors.dart';
import 'package:soil_moisture_app/utils/displayError.dart';
import 'package:soil_moisture_app/utils/gettingJson.dart';
import 'package:soil_moisture_app/utils/all_data.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// Pages Import

import 'pages/Analysis.dart';
import 'pages/Overview.dart';

void main() async {
  String title = 'Soil App';
  // * Latest data fetch
  addLatestData().then(
    (_) => runApp(
      MaterialApp(
        title: title,
        debugShowCheckedModeBanner: false,
        home: Home(title),
        theme: buildLightTheme(),
      ),
    ),
    // onError: (_) => runApp(
    //   MaterialApp(
    //     title: 'Error',
    //     debugShowCheckedModeBanner: false,
    //     home: Scaffold(
    //       body: ShowError(),
    //     ),
    //   ),
    // ),
  );
  fetchTotalData();
  // * implement onError here
  //print('from main: ${plantList[0].getLastMoisture}');
  // runApp(
  //   MaterialApp(
  //     title: title,
  //     debugShowCheckedModeBanner: false,
  //     home: DefaultTabController(
  //       length: 2,
  //       child: Home(title),
  //     ),
  //     theme: buildLightTheme(),
  //   ),
  // );
}

//To check the Slider Page
// void main(){
//   runApp(
//     new MaterialApp(
//       home: ThresholdPump(),
//     ),
//   );
// }

class Home extends StatefulWidget {
  final String title;
  Home(this.title);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Widget> _children = [
    Overview(),
    Analysis(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Overview(),
      // drawer: Theme(
      //   data: Theme.of(context).copyWith(
      //     canvasColor: appPrimaryLightColor,
      //   ),
      //   child: Drawer(
      //     child: ListView(
      //       children: <Widget>[
      //         DrawerHeader(
      //           child: Image.asset('./assets/images/Soif_sk.png'),
      //         ),
      //         ListTile(
      //           title: Text('Overview'),
      //           leading: Icon(FontAwesomeIcons.eye),
      //           onTap: () {
      //             Navigator.of(context).pop();
      //             Navigator.of(context).push(MaterialPageRoute(
      //                 builder: (BuildContext context) => Analysis()));
      //           },
      //         ),
      //         ListTile(
      //           title: Text('Analysis'),
      //           leading: Icon(FontAwesomeIcons.chartLine),
      //           onTap: () {
      //             Navigator.of(context).pop();
      //             Navigator.of(context).push(MaterialPageRoute(
      //                 builder: (BuildContext context) => Analysis()));
      //           },
      //         ),
      //         ListTile(
      //           title: Text('Settings'),
      //           leading: Icon(Icons.settings),
      //           onTap: null,
      //         )
      //       ],
      //     ),
      //   ),
      // ),
      // appBar: AppBar(
      //   title: Container(
      //     margin: const EdgeInsets.all(6.0),
      //     child: Image.asset('./assets/images/Soif_sk.png'),
      //   ),
      //   centerTitle: true,
      // ),
      // body: TabBarView(
      //   children: _children,
      //   physics: NeverScrollableScrollPhysics(),
      // ),
      // bottomNavigationBar: TabBar(
      //   tabs: <Widget>[
      //     Tab(
      //       icon: Icon(Icons.remove_red_eye),
      //       text: 'Overview',
      //     ),
      //     Tab(
      //       icon: Icon(Icons.linear_scale),
      //       text: 'Analysis',
      //     )
      //   ],
      //   labelColor: appPrimaryLightColor,
      //   unselectedLabelColor: appSecondaryDarkColor,
      //   indicatorSize: TabBarIndicatorSize.label,
      //   indicatorPadding: EdgeInsets.all(5.0),
      //   indicatorColor: appSecondaryLightColor,
      // ),
      // backgroundColor: Theme.of(context).canvasColor,
    );
  }

  void _onOpTapped(int index) {
    setState(() {
      //_currentIndex = index;
    });
  }
}

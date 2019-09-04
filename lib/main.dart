import 'package:flutter/material.dart';
import 'package:soil_moisture_app/ui/build_theme.dart';
import 'package:soil_moisture_app/ui/colors.dart';
import 'package:soil_moisture_app/utils/gettingJson.dart';
// Pages Import

import 'pages/Analysis.dart';
import 'pages/Overview.dart';

void main() async {
  String title = 'Soil App';
  await fetchTotalData().then((onValue) {
    print(onValue);
    addPlantData(onValue['records']);
  });
  // * implement onError here
  print('from main: ${data[0].moisture}');
  runApp(
    MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Home(title),
      ),
      theme: buildLightTheme(),
    ),
  );
}

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
      appBar: AppBar(
        title: Container(
          margin: const EdgeInsets.all(6.0),
          child: Image.asset('./assets/images/Soif_sk.png'),
        ),
        centerTitle: true,
      ),
      body: TabBarView(
        children: _children,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: TabBar(
        tabs: <Widget>[
          Tab(
            icon: Icon(Icons.remove_red_eye),
            text: 'Overview',
          ),
          Tab(
            icon: Icon(Icons.linear_scale),
            text: 'Analysis',
          )
        ],
        labelColor: appPrimaryLightColor,
        unselectedLabelColor: appSecondaryDarkColor,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorPadding: EdgeInsets.all(5.0),
        indicatorColor: appSecondaryLightColor,
      ),
      backgroundColor: Theme.of(context).canvasColor,
    );
  }
}

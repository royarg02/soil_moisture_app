import 'package:flutter/material.dart';

// * External Packages import
import 'package:provider/provider.dart';

// * Prefs import
import 'package:soil_moisture_app/prefs/user_prefs.dart';
import 'package:soil_moisture_app/states/selected_card_state.dart';

// * State import
import 'package:soil_moisture_app/states/theme_state.dart';

// * ui import
import 'package:soil_moisture_app/ui/options.dart';

// * utils import
import 'package:soil_moisture_app/utils/sizes.dart';

// * Pages Import
import 'pages/Analysis.dart';
import 'pages/Overview.dart';

void main() async {
  await loadPrefs();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<ThemeState>(
        builder: (context) => ThemeState(),
      ),
      ChangeNotifierProvider<SelectedCardState>(
        builder: (context) => SelectedCardState(),
      ),
    ],
    child: Root(),
  ));
}

class Root extends StatelessWidget {
  final String title = 'Soif';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(length: 2, child: Home()),
      theme: Provider.of<ThemeState>(context).getTheme,
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
    print(appWidth(context));
    return Scaffold(
      // appBar: AppBar(
      //   title: Image.asset(
      //     (Provider.of<ThemeState>(context).isDarkTheme)
      //         ? './assets/images/Soif_sk_dark.png'
      //         : './assets/images/Soif_sk.png',
      //     height: appWidth(context) * 0.08,
      //   ),
      //   centerTitle: true,
      // ),
      body: TabBarView(
        children: _children,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: Container(
        color: Theme.of(context).accentColor,
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

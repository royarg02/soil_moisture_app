import 'package:flutter/material.dart';

// * External Packages import
import 'package:provider/provider.dart';

// * Prefs import
import 'package:soif/prefs/user_prefs.dart';
import 'package:soif/states/selected_card_state.dart';

// * State import
import 'package:soif/states/theme_state.dart';
import 'package:soif/ui/custom_tab_indicator.dart';

// * ui import
import 'package:soif/ui/custom_tab_label.dart';
import 'package:soif/ui/options.dart';

// * utils import
import 'package:soif/utils/sizes.dart';

// * Pages Import
import 'pages/Analysis.dart';
import 'pages/Overview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //for awaiting
  await loadPrefs();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeState>(
          create: (context) => ThemeState(),
        ),
        ChangeNotifierProvider<SelectedCardState>(
          create: (context) => SelectedCardState(),
        ),
      ],
      child: Root(),
    ),
  );
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
      body: TabBarView(
        children: _children,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).accentColor,
        child: Row(
          children: <Widget>[
            Flexible(
              child: TabBar(
                tabs: <Widget>[
                  AppTab(
                    icon: Icon(
                      Icons.remove_red_eye,
                    ),
                    text: 'OVERVIEW',
                  ),
                  AppTab(
                    icon: Icon(
                      Icons.timeline,
                    ),
                    text: 'ANALYSIS',
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
                indicator: RoundedRectTabIndicator(
                  radius: appWidth(context) * 0.1,
                  width: 2.0,
                  color: Theme.of(context).cardColor,
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

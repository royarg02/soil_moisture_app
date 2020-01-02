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
      home: Home(),
      theme: Provider.of<ThemeState>(context).getTheme,
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final List<Widget> _children = [
    Overview(),
    Analysis(),
  ];
  TabController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, initialIndex: 0, length: 2);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<bool> _popScopeInvoke() {
    if (this._controller.index == 1) {
      this._controller.index = 0;
      return Future<bool>.value(false);
    } else {
      return Future<bool>.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Screenwidth: ${appWidth(context)}');
    print('Screenheight: ${appHeight(context)}');
    return WillPopScope(
      onWillPop: _popScopeInvoke,
      child: Scaffold(
        body: TabBarView(
          controller: _controller,
          children: _children,
          physics: NeverScrollableScrollPhysics(),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).accentColor,
          child: Row(
            children: <Widget>[
              Flexible(
                child: TabBar(
                  controller: _controller,
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
      ),
    );
  }
}

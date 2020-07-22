import 'package:flutter/material.dart';

// * External Packages import
import 'package:provider/provider.dart';

// * Data providers import
import 'package:soil_moisture_app/data_providers/analysis_data_provider.dart';

// * Prefs import
import 'package:soil_moisture_app/prefs/user_prefs.dart';

// * State import
import 'package:soil_moisture_app/states/selected_card_state.dart';
import 'package:soil_moisture_app/states/theme_state.dart';

// * ui import
import 'package:soil_moisture_app/ui/build_theme.dart';
import 'package:soil_moisture_app/ui/options.dart';

// * utils import
import 'package:soil_moisture_app/utils/app_info.dart';
import 'package:soil_moisture_app/utils/sizes.dart';

// * Pages Import
import 'pages/Analysis.dart';
import 'pages/Overview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //for awaiting
  await loadPrefs();
  await loadAppInfo();
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
    var _themeState = Provider.of<ThemeState>(context);
    return MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      home: Home(),
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      themeMode: determineThemeMode(_themeState.isDarkTheme),
    );
  }
}

class Home extends StatefulWidget {
  final List<Widget> _tabPages = [
    Overview(),
    ChangeNotifierProxyProvider<SelectedCardState, AnalysisDataProvider>(
      create: (context) => AnalysisDataProvider(),
      update: (context, selCard, dataProvider) => dataProvider..update(),
      child: Analysis(),
    ),
  ];
  @override
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController _controller;
  void initState() {
    super.initState();
    _controller = TabController(
      vsync: this,
      initialIndex: 0,
      length: widget._tabPages.length,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<bool> _popScopeInvoke() async {
    if (this._controller.index == 1) {
      this._controller.index = 0;
      return Future<bool>.value(false);
    } else {
      await getPrefs.setBool(
          'isDarkTheme', Provider.of<ThemeState>(context).isDarkTheme);
      return Future<bool>.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    print(appWidth(context));
    return WillPopScope(
      onWillPop: _popScopeInvoke,
      child: Scaffold(
        appBar: AppBar(
          title: Image.asset(
            (Provider.of<ThemeState>(context).isDarkTheme)
                ? './assets/images/Soif_sk_dark.png'
                : './assets/images/Soif_sk.png',
            height: appWidth(context) * 0.08,
          ),
          centerTitle: true,
        ),
        body: TabBarView(
          controller: this._controller,
          children: widget._tabPages,
          physics: NeverScrollableScrollPhysics(),
        ),
        bottomNavigationBar: Container(
          color: Theme.of(context).accentColor,
          child: Row(
            children: <Widget>[
              Flexible(
                child: TabBar(
                  controller: this._controller,
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
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

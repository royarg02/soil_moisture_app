import 'package:flutter/material.dart';

// * External Packages import
import 'package:provider/provider.dart';

// * Pages Import
import 'pages/Analysis.dart';
import 'pages/Overview.dart';

// * Prefs import
import 'package:soif/prefs/user_prefs.dart';

// * State import
import 'package:soif/states/selected_card_state.dart';
import 'package:soif/states/theme_state.dart';

// * ui import
import 'package:soif/ui/build_theme.dart';

// * utils import
import 'package:soif/utils/app_info.dart';
import 'package:soif/utils/constants.dart';
import 'package:soif/utils/sizes.dart';

// * widgets import
import 'package:soif/widgets/custom_tab_label.dart';
import 'package:soif/widgets/options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //for awaiting
  await loadAppInfo();
  await loadPrefs();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeState>(
          create: (context) => ThemeState(context),
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
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      themeMode:
          determineThemeMode(Provider.of<ThemeState>(context).appThemeMode),
    );
  }
}

class Home extends StatefulWidget {
  final List<Widget> _tabPages = [
    Overview(),
    Analysis(),
  ];
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController _controller;
  @override
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
      await getPrefs.setInt(soifThemeModePrefsKey,
          Provider.of<ThemeState>(context, listen: false).appThemeMode);
      return Future<bool>.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    print('Screenwidth: ${appWidth(context)}');
    print('Screenheight: ${appHeight(context)}');
    return WillPopScope(
      onWillPop: _popScopeInvoke,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        body: TabBarView(
          controller: _controller,
          children: widget._tabPages,
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
                  unselectedLabelStyle:
                      Theme.of(context).primaryTextTheme.body2.copyWith(
                            fontSize: appWidth(context) * 0.025,
                          ),
                  labelStyle: Theme.of(context).primaryTextTheme.body2.copyWith(
                        fontSize: appWidth(context) * 0.035,
                      ),
                  indicator: RoundedRectTabIndicator(
                    radius: appWidth(context) * 0.1,
                    width: 2.0,
                    color: Theme.of(context).cardColor,
                  ),
                ),
              ),
              OptionButton()
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

/*
* Analysis

* This page displays the plant moisture, lumination(light), humidity, and temperature throughout the day
* in hourly basis. Of these parameters, only the moisture varies depending upon the plant. The page
* consists of an interactive graph that displays the same data visually in depth.
* The user can access this data for multiple days and switch between them, depending upon the availabiity 
* of required data at the REST API server.
*/

import 'package:flutter/material.dart';

// * External packages import
import 'package:provider/provider.dart';

// * Data import
import 'package:soif/data/all_data.dart';
import 'package:soif/data/environment_data.dart';

// * State import
import 'package:soif/states/selected_card_state.dart';

// * ui import
import 'package:soif/ui/analysis_graph.dart';

// * utils import
import 'package:soif/utils/constants.dart';
import 'package:soif/utils/date_func.dart';
import 'package:soif/utils/json_post_get.dart';
import 'package:soif/utils/sizes.dart';

// * widgets import
import 'package:soif/widgets/custom_tab_label.dart';
import 'package:soif/widgets/chart_view_card.dart';
import 'package:soif/widgets/date_selector.dart';
import 'package:soif/widgets/display_error.dart';
import 'package:soif/widgets/plant_grid_view.dart';
import 'package:soif/widgets/refresh_snackbar.dart';
import 'package:soif/widgets/soif_app_bar.dart';

class Analysis extends StatefulWidget {
  @override
  _AnalysisState createState() => _AnalysisState();
}

class _AnalysisState extends State<Analysis>
    with AutomaticKeepAliveClientMixin {
  Future<void> _refresh() async {
    totData = fetchTotalData();
    await totData.then((_) {
      Scaffold.of(context).removeCurrentSnackBar();
      // Scaffold.of(context).showSnackBar(SuccessOnRefresh().build(context));
      if (isNow()) {
        latData = fetchLatestData();
      }
    }, onError: (_) {
      Scaffold.of(context).removeCurrentSnackBar();
      Scaffold.of(context).showSnackBar(FailureOnRefresh().build(context));
    });
  }

  void refreshWithImmediateEffect() {
    totData = _refresh();
    setState(() {});
  }

  Future<void> refreshWithEffectAfterDone() {
    return _refresh().then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      top: false,
      child: DefaultTabController(
        length: 4,
        initialIndex: 0,
        child: RefreshIndicator(
          displacement: soifAppBarHeight + MediaQuery.of(context).padding.top,
          onRefresh: refreshWithEffectAfterDone,
          child: CustomScrollView(
            physics:
                AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            slivers: <Widget>[
              SoifAppBar(
                title: ChartTabs(),
                titleSpacing: 0.0,
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(48.0),
                  child:
                      DateSelector(invokeFunction: refreshWithImmediateEffect),
                ),
                expandedHeight: appHeight(context) * 0.35 + 96.0,
                backgroundWidgetPadding:
                    const EdgeInsets.symmetric(vertical: 48.0),
                backgroundWidget: FutureBuilder(
                  future: totData,
                  builder: (context, AsyncSnapshot snapshot) {
                    print(snapshot);
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return _SkeletonWidget();
                    } else if (allData != null) {
                      return _PageWidget();
                    } else {
                      return _ErrorWidget();
                    }
                  },
                ),
              ),
              FutureBuilder(
                future: totData,
                builder: (context, AsyncSnapshot snapshot) {
                  // print(snapshot);
                  // print(allData);
                  if (snapshot.connectionState != ConnectionState.waiting &&
                      allData != null) {
                    return PlantGridView(
                      plantlist: allData.plantList,
                    );
                  } else {
                    return SliverToBoxAdapter();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _ErrorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChartViewCard(content: NoNowDataOrNoInternet(haveInternet: false));
  }
}

class _SkeletonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChartViewCard(content: Center(child: CircularProgressIndicator()));
  }
}

class _PageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return (allData.plantList.isEmpty)
        ? ChartViewCard(content: NoData())
        : ChartView();
  }
}

class ChartTabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        tabBarTheme: Theme.of(context).tabBarTheme.copyWith(
              labelColor: Theme.of(context).accentColor,
              unselectedLabelColor:
                  Theme.of(context).accentColor.withOpacity(0.8),
            ),
      ),
      child: Card(
        color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
        margin: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 4.0),
        child: TabBar(
          tabs: ['MOISTURE', 'LIGHT', 'HUMIDITY', 'TEMPERATURE']
              .map<Widget>((label) => AppTab(text: label))
              .toList(),
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
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}

class ChartViewContent extends StatelessWidget {
  final EnvironmentData chartData;
  final String graphToString;
  ChartViewContent({@required this.chartData, @required this.graphToString});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: appHeight(context) * 0.06),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '${(chartData.lastValue * ((graphToString.toUpperCase() == 'MOISTURE') ? 100 : 1)).toStringAsFixed(1)}${chartData.unit}',
                  style: Theme.of(context).textTheme.body2.copyWith(
                        color: Theme.of(context).accentColor,
                        fontSize: appHeight(context) * 0.025,
                      ),
                ),
                Text(
                  graphToString.toUpperCase(),
                  style: Theme.of(context).textTheme.overline,
                ),
              ],
            ),
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: appHeight(context) * 0.25),
          child: displayChart(chartData, graphToString.toUpperCase(), context),
        ),
      ],
    );
  }
}

class ChartView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TabBarView(
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        ChartViewCard(
          content: ChartViewContent(
            graphToString: 'Moisture',
            chartData: allData
                .plantList[Provider.of<SelectedCardState>(context).selCard]
                .moisture,
          ),
        ),
        ChartViewCard(
          content: ChartViewContent(
            graphToString: 'Light',
            chartData: allData.light,
          ),
        ),
        ChartViewCard(
          content: ChartViewContent(
            graphToString: 'Humidity',
            chartData: allData.humidity,
          ),
        ),
        ChartViewCard(
          content: ChartViewContent(
            graphToString: 'Temperature',
            chartData: allData.temp,
          ),
        ),
      ],
    );
  }
}

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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

// * State import
import 'package:soif/states/selected_card_state.dart';
import 'package:soif/states/theme_state.dart';

// * ui import
import 'package:soif/ui/analysis_graph.dart';
import 'package:soif/ui/colors.dart';
import 'package:soif/ui/custom_tab_indicator.dart';
import 'package:soif/ui/custom_tab_label.dart';
import 'package:soif/ui/date_selector.dart';
import 'package:soif/ui/plant_grid_view.dart';
import 'package:soif/ui/refresh_snackbar.dart';
import 'package:soif/ui/soif_app_bar.dart';

// * utils import
import 'package:soif/utils/display_error.dart';
import 'package:soif/utils/json_post_get.dart';
import 'package:soif/utils/date_func.dart';
import 'package:soif/utils/sizes.dart';

// * Data import
import 'package:soif/data/all_data.dart';

class Analysis extends StatefulWidget {
  @override
  _AnalysisState createState() => _AnalysisState();
}

class _AnalysisState extends State<Analysis> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () {},
        child: FutureBuilder(
          future: totData,
          builder: (context, AsyncSnapshot snapshot) {
            print(snapshot);
            if (snapshot.hasError) {
              return _ErrorPage();
            } else if (snapshot.connectionState == ConnectionState.done) {
              return _Page();
            } else {
              return _Skeleton();
            }
          },
        ),
      ),
    );
  }
}

class _ErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('No Connection.'),
    );
  }
}

class _Skeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Loading..'),
    );
  }
}

class _Page extends StatefulWidget {
  @override
  __PageState createState() => __PageState();
}

class __PageState extends State<_Page> {
  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      headerSliverBuilder: (BuildContext context, bool isScrolled) {
        return <Widget>[
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            child: DefaultTabController(
              length: 4,
              initialIndex: 0,
              child: SliverPersistentHeader(
                pinned: true,
                delegate: _SliverPersistentHeaderDelegate(
                  maxExpanded: appHeight(context) * 0.45,
                ),
              ),
            ),
          )
        ];
      },
      body: ListView.builder(
        itemCount: 50,
        itemBuilder: (_, index) {
          return ListTile(
            title: Text('$index'),
          );
        },
      ),
      // body: (allData.plantList.isNotEmpty)
      //     ? CustomScrollView(
      //         slivers: <Widget>[
      //           PlantGridView(
      //             plantlist: allData.plantList,
      //           )
      //         ],
      //       )
      //     : SizedBox.shrink(),
    );
  }
}

class ChartTabs extends StatelessWidget {
  @override
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
      child: TabBar(
        // controller: _tabController,
        tabs: <Widget>[
          AppTab(
            text: 'MOISTURE',
          ),
          AppTab(
            text: 'LIGHT',
          ),
          AppTab(
            text: 'HUMIDITY',
          ),
          AppTab(
            text: 'TEMPERATURE',
          )
        ],
        indicator: RoundedRectTabIndicator(
          radius: appWidth(context) * 0.1,
          width: 2.0,
          color: Theme.of(context).accentColor,
        ),
      ),
    );
  }
}

class ChartView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: appHeight(context) * 0.35),
      child: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          Card(
            margin: const EdgeInsets.all(8.0),
            elevation: 6.0,
            child: SizedBox(
              height: appHeight(context) * 0.35,
            ),
          ),
          Card(
            margin: const EdgeInsets.all(8.0),
            elevation: 6.0,
            child: SizedBox(
              height: appHeight(context) * 0.35,
            ),
          ),
          Card(
            margin: const EdgeInsets.all(8.0),
            elevation: 6.0,
            child: SizedBox(
              height: appHeight(context) * 0.35,
            ),
          ),
          Card(
            margin: const EdgeInsets.all(8.0),
            elevation: 6.0,
            child: SizedBox(
              height: appHeight(context) * 0.35,
            ),
          )
        ],
      ),
    );
  }
}

class _SliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double maxExpanded;
  double minExpanded;
  _SliverPersistentHeaderDelegate({@required this.maxExpanded}) {
    minExpanded = maxExpanded - (maxExpanded * 0.1);
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    double normalizedShrinkOffset = shrinkOffset / maxExtent;
    // print(normalizedShrinkOffset);
    return Material(
      elevation: normalizedShrinkOffset * 4.0,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ChartTabs(),
          DateSelector(),
          Text(
            'Latest data',
            style: Theme.of(context).textTheme.body2.copyWith(
                  fontSize: appHeight(context) *
                      (0.035 - normalizedShrinkOffset * 0.015),
                ),
          ),
          Flexible(child: ChartView()),
        ],
      ),
    );
  }

  @override
  double get maxExtent => maxExpanded;

  double get minExtent => minExpanded;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

// class AnalysiS extends StatefulWidget {
//   @override
//   _AnalysiSState createState() => _AnalysiSState();
// }

// class _AnalysiSState extends State<AnalysiS> {
//   String _measure;
//   dynamic _chartObj;

//   void initState() {
//     _measure = 'Moisture';
//     super.initState();
//   }

//   void _initChart(String newMeasure) {
//     this._measure = newMeasure;
//     if (allData.plantList.isNotEmpty) {
//       switch (_measure) {
//         case 'Humidity':
//           _chartObj = allData.humidity;
//           break;
//         case 'Light':
//           _chartObj = allData.light;
//           break;
//         case 'Temperature':
//           _chartObj = allData.temp;
//           break;
//         case 'Moisture':
//           _chartObj = allData
//               .plantList[Provider.of<SelectedCardState>(context).selCard]
//               .moisture;
//           break;
//       }
//       // Debug Print
//       print(_chartObj.allValues);
//       print(_measure);
//     }
//   }

//   void _fetchForDate() {
//     totData = _refresh();
//     setState(() {});
//   }

//   Future<void> _pickDate(BuildContext context) async {
//     final DateTime picked = await showDatePicker(
//       context: context,
//       initialDate: date,
//       firstDate: DateTime(date.year),
//       lastDate: now,
//     );
//     if (picked != null && picked != date) {
//       date = picked;
//       _fetchForDate();
//     }
//   }

//   Future<void> _refresh() async {
//     totData = fetchTotalData();
//     await totData.then((_) {
//       if (mounted) {
//         setState(() {
//           _initChart(_measure);
//         });
//       }
//       if (isNow()) {
//         latData = fetchLatestData();
//       }
//     }, onError: (_) {
//       Scaffold.of(context).removeCurrentSnackBar();
//       Scaffold.of(context).showSnackBar(FailureOnRefresh().build(context));
//     });
//     // Debug Print
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       minimum: EdgeInsets.symmetric(horizontal: appWidth(context) * 0.03),
//       child: RefreshIndicator(
//         onRefresh: _refresh,
//         child: ListView(
//           physics:
//               AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
//           children: [
//             Container(
//               margin: EdgeInsets.symmetric(vertical: appWidth(context) * 0.03),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   FutureBuilder(
//                     future: totData,
//                     builder: (context, AsyncSnapshot snapshot) {
//                       if (snapshot.connectionState == ConnectionState.done) {
//                         _initChart(this._measure);
//                         return (allData.plantList.isNotEmpty)
//                             ? Container(
//                                 height: appWidth(context) * 0.215,
//                                 alignment: Alignment.center,
//                                 child: Column(
//                                   mainAxisSize: MainAxisSize.min,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: <Widget>[
//                                     Row(
//                                       children: <Widget>[
//                                         Text(
//                                           (_chartObj.lastValue *
//                                                   ((_measure == 'Moisture')
//                                                       ? 100
//                                                       : 1))
//                                               .toStringAsFixed(1),
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .display2
//                                               .copyWith(
//                                                 color: (Provider.of<ThemeState>(
//                                                             context)
//                                                         .isDarkTheme)
//                                                     ? Theme.of(context)
//                                                         .accentColor
//                                                     : appSecondaryDarkColor,
//                                                 fontSize:
//                                                     appWidth(context) * 0.09,
//                                               ),
//                                         ),
//                                         Text(
//                                           '${_chartObj.unit}',
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .body1
//                                               .copyWith(
//                                                 fontSize:
//                                                     appWidth(context) * 0.06,
//                                               ),
//                                         ),
//                                       ],
//                                     ),
//                                     Text(
//                                       'On $fetchDateEEEMMMd',
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .body2
//                                           .copyWith(
//                                             fontSize: appWidth(context) * 0.025,
//                                           ),
//                                     ),
//                                   ],
//                                 ),
//                               )
//                             : SizedBox(
//                                 height: appWidth(context) * 0.215,
//                               );
//                       } else {
//                         return SizedBox(
//                           height: appWidth(context) * 0.215,
//                         );
//                       }
//                     },
//                   ),
//                   Container(
//                     padding: EdgeInsets.only(right: appWidth(context) * 0.02),
//                     height: appWidth(context) * 0.1,
//                     child: Theme(
//                       data: Theme.of(context).copyWith(
//                         canvasColor: Theme.of(context).primaryColor,
//                       ),
//                       child: DropdownButtonHideUnderline(
//                         child: DropdownButton<String>(
//                           icon: Icon(FontAwesomeIcons.chevronDown),
//                           iconSize: appWidth(context) * 0.03,
//                           value: _measure,
//                           onChanged: (String measure) {
//                             setState(() {
//                               _initChart(measure);
//                             });
//                           },
//                           items: <String>[
//                             'Moisture',
//                             'Light',
//                             'Humidity',
//                             'Temperature'
//                           ].map<DropdownMenuItem<String>>((String option) {
//                             return DropdownMenuItem<String>(
//                               value: option,
//                               child: Container(
//                                 alignment: Alignment.center,
//                                 width: appWidth(context) * 0.31,
//                                 child: Text(
//                                   option,
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .body2
//                                       .copyWith(
//                                           fontSize: appWidth(context) * 0.035),
//                                   textAlign: TextAlign.center,
//                                 ),
//                               ),
//                             );
//                           }).toList(),
//                         ),
//                       ),
//                     ),
//                     decoration: BoxDecoration(
//                       border: Border.all(
//                         width: 2.0,
//                         color: appPrimaryDarkColor,
//                       ),
//                       borderRadius:
//                           BorderRadius.circular(appWidth(context) * 0.1),
//                       shape: BoxShape.rectangle,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               height: appWidth(context) * 0.6,
//               child: Card(
//                 child: FutureBuilder(
//                     future: totData,
//                     builder: (context, AsyncSnapshot snapshot) {
//                       // Debug Print
//                       print(snapshot);
//                       if (snapshot.hasError) {
//                         return NoNowDataOrNoInternet(isScrollable: false);
//                       } else if (snapshot.connectionState ==
//                           ConnectionState.done) {
//                         return (_chartObj.allValues.isNotEmpty)
//                             ? displayChart(_chartObj, _measure, context)
//                             : NoData();
//                       } else {
//                         return Center(
//                           child: CircularProgressIndicator(),
//                         );
//                       }
//                     }),
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: <Widget>[
//                 IconButton(
//                   icon: Icon(Icons.chevron_left),
//                   onPressed: () {
//                     prevDate();
//                     _fetchForDate();
//                   },
//                 ),
//                 Tooltip(
//                   message: 'Jump to date',
//                   child: FlatButton(
//                     onPressed: () => _pickDate(context),
//                     child: Text(
//                       '$fetchDateEEEMMMd',
//                       style: Theme.of(context).textTheme.body2.copyWith(
//                             fontSize: appWidth(context) * 0.05,
//                           ),
//                     ),
//                     shape: RoundedRectangleBorder(
//                       borderRadius:
//                           BorderRadius.circular(appWidth(context) * 0.1),
//                       side: BorderSide(
//                         width: 2.0,
//                         color: appPrimaryDarkColor,
//                       ),
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.chevron_right),
//                   onPressed: (isNow())
//                       ? null
//                       : () {
//                           nextDate();
//                           _fetchForDate();
//                         },
//                 )
//               ],
//             ),
//             SizedBox(
//               height: appWidth(context) * 0.01,
//             ),
//             FutureBuilder(
//               future: totData,
//               builder: (context, AsyncSnapshot snapshot) {
//                 if (snapshot.connectionState == ConnectionState.done &&
//                     allData.plantList.isNotEmpty) {
//                   // return PlantGridView(
//                   //   plantlist: plantList,
//                   // );
//                   return Text('Data Got');
//                 } else {
//                   return SizedBox();
//                 }
//               },
//             ),
//             SizedBox(
//               height: appWidth(context) * 0.03,
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

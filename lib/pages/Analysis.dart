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
import 'package:soil_moisture_app/states/selected_card_state.dart';

// * ui import
import 'package:soil_moisture_app/ui/analysis_graph.dart';
import 'package:soil_moisture_app/ui/colors.dart';
import 'package:soil_moisture_app/ui/plant_grid_view.dart';
import 'package:soil_moisture_app/ui/refresh_snackbar.dart';

// * utils import
import 'package:soil_moisture_app/utils/display_error.dart';
import 'package:soil_moisture_app/utils/json_post_get.dart';
import 'package:soil_moisture_app/utils/date_func.dart';
import 'package:soil_moisture_app/utils/sizes.dart';

// * Data import
import 'package:soil_moisture_app/data/all_data.dart';

class Analysis extends StatefulWidget {
  @override
  _AnalysisState createState() => _AnalysisState();
}

class _AnalysisState extends State<Analysis> {
  String _measure;
  dynamic _chartObj;

  void initState() {
    _measure = 'Moisture';
    super.initState();
  }

  void _initChart(String newMeasure) {
    this._measure = newMeasure;
    if (isDataGot) {
      switch (_measure) {
        case 'Humidity':
          _chartObj = dayHumid;
          break;
        case 'Light':
          _chartObj = dayLight;
          break;
        case 'Temperature':
          _chartObj = dayTemp;
          break;
        case 'Moisture':
          _chartObj =
              plantList[Provider.of<SelectedCardState>(context).selCard];
          break;
      }
      // Debug Print
      print(_chartObj.getAllValues);
      print(_measure);
    }
  }

  void _fetchForDate() {
    totData = _refresh();
    setState(() {});
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(date.year),
      lastDate: now,
    );
    if (picked != null && picked != date) {
      date = picked;
      _fetchForDate();
    }
  }

  Future<void> _refresh() async {
    totData = fetchTotalData();
    await totData.then((_) {
      if (mounted) {
        setState(() {
          _initChart(_measure);
        });
      }
      if (isNow()) {
        latData = fetchLatestData();
      }
    }, onError: (_) {
      Scaffold.of(context).showSnackBar(FailureOnRefresh().build(context));
    });
    // Debug Print
    if (isDataGot) {
      print('analysis refresh got: ${plantList[0].getLastValue}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: EdgeInsets.symmetric(horizontal: appWidth(context) * 0.03),
      child: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          physics:
              AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: appWidth(context) * 0.03),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FutureBuilder(
                    future: totData,
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        _initChart(this._measure);
                        return (isDataGot)
                            ? Container(
                                height: appWidth(context) * 0.215,
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          (_chartObj.getLastValue *
                                                  ((_measure == 'Moisture')
                                                      ? 100
                                                      : 1))
                                              .toStringAsFixed(1),
                                          style: Theme.of(context)
                                              .textTheme
                                              .display2
                                              .copyWith(
                                                color: appSecondaryDarkColor,
                                                fontSize:
                                                    appWidth(context) * 0.09,
                                              ),
                                        ),
                                        Text(
                                          '${_chartObj.getUnit}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .body1
                                              .copyWith(
                                                fontSize:
                                                    appWidth(context) * 0.06,
                                              ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'On $fetchDateEEEMMMd',
                                      style: Theme.of(context)
                                          .textTheme
                                          .body2
                                          .copyWith(
                                            fontSize: appWidth(context) * 0.025,
                                          ),
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox(
                                height: appWidth(context) * 0.215,
                              );
                      } else {
                        return SizedBox(
                          height: appWidth(context) * 0.215,
                        );
                      }
                    },
                  ),
                  Container(
                    padding: EdgeInsets.only(right: appWidth(context) * 0.02),
                    height: appWidth(context) * 0.1,
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        canvasColor: Theme.of(context).primaryColor,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          icon: Icon(FontAwesomeIcons.chevronDown),
                          iconSize: appWidth(context) * 0.03,
                          value: _measure,
                          onChanged: (String measure) {
                            setState(() {
                              _initChart(measure);
                            });
                          },
                          items: <String>[
                            'Moisture',
                            'Light',
                            'Humidity',
                            'Temperature'
                          ].map<DropdownMenuItem<String>>((String option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Container(
                                alignment: Alignment.center,
                                width: appWidth(context) * 0.31,
                                child: Text(
                                  option,
                                  style: Theme.of(context)
                                      .textTheme
                                      .body2
                                      .copyWith(
                                          fontSize: appWidth(context) * 0.035),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2.0,
                        color: appPrimaryDarkColor,
                      ),
                      borderRadius:
                          BorderRadius.circular(appWidth(context) * 0.1),
                      shape: BoxShape.rectangle,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: appWidth(context) * 0.6,
              child: Card(
                child: FutureBuilder(
                    future: totData,
                    builder: (context, AsyncSnapshot snapshot) {
                      // Debug Print
                      print(snapshot);
                      if (snapshot.hasError) {
                        return NoNowData(isScrollable: false);
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        return (isDataGot)
                            ? displayChart(_chartObj, _measure, context)
                            : NoData();
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.chevron_left),
                  onPressed: () {
                    prevDate();
                    _fetchForDate();
                  },
                ),
                Tooltip(
                  message: 'Jump to date',
                  child: FlatButton(
                    onPressed: () => _pickDate(context),
                    child: Text(
                      '$fetchDateEEEMMMd',
                      style: Theme.of(context).textTheme.body2.copyWith(
                            fontSize: appWidth(context) * 0.05,
                          ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(appWidth(context) * 0.1),
                      side: BorderSide(
                        width: 2.0,
                        color: appPrimaryDarkColor,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.chevron_right),
                  onPressed: (isNow())
                      ? null
                      : () {
                          nextDate();
                          _fetchForDate();
                        },
                )
              ],
            ),
            SizedBox(
              height: appWidth(context) * 0.01,
            ),
            FutureBuilder(
              future: totData,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    isDataGot) {
                  return PlantGridView();
                } else {
                  return SizedBox();
                }
              },
            ),
            SizedBox(
              height: appWidth(context) * 0.03,
            )
          ],
        ),
      ),
    );
  }
}

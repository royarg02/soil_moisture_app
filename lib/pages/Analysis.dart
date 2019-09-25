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

// * ui import
import 'package:soil_moisture_app/ui/analysis_graph.dart';
import 'package:soil_moisture_app/ui/colors.dart';
import 'package:soil_moisture_app/ui/plant_card.dart';
import 'package:soil_moisture_app/ui/refresh_snackbar.dart';

// * utils import
import 'package:soil_moisture_app/utils/display_error.dart';
import 'package:soil_moisture_app/utils/json_post_get.dart';
import 'package:soil_moisture_app/utils/date_func.dart';

// * Data import
import 'package:soil_moisture_app/data/all_data.dart';

class Analysis extends StatefulWidget {
  @override
  _AnalysisState createState() => _AnalysisState();
}

class _AnalysisState extends State<Analysis> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: totData,
        builder: (context, AsyncSnapshot snapshot) {
          // Debug print
          print(snapshot);
          if (snapshot.hasError) {
            return Scaffold(
              body: NoInternet(),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            return Page();
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}

class Page extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<Page> {
  int _cardCount;
  int _selCard;
  Future _loadState;
  String _measure;
  dynamic _chartObj;

  void initState() {
    _cardCount = plantList.length;
    _selCard = 0;
    _loadState = totData;
    _changeMeasure('Moisture');
    super.initState();
  }

  void _changeMeasure(String newMeasure) {
    setState(() {
      _cardCount = plantList.length;
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
            _chartObj = plantList[_selCard];
            break;
        }
        // Debug Print
        print(_chartObj.getAllValues);
        print(_measure);
      }
    });
  }

  void _fetchForDate() {
    _loadState = _refresh();
    setState(() {});
  }

  Future<Null> _refresh() async {
    await fetchTotalData().then((_) {}, onError: (_) {
      Scaffold.of(context).showSnackBar(FailureOnRefresh().build(context));
    });
    _changeMeasure(_measure);
    // Debug Print
    if (isDataGot) {
      print('analysis refresh got: ${plantList[0].getLastValue}');
    }
  }

  void _selectPlant(int value) {
    setState(() {
      _selCard = value;
    });
    _changeMeasure(_measure);
    // Debug Print
    print('Selected -> $_selCard');
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: ListView(
            physics:
                AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FutureBuilder(
                      future: _loadState,
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return (isDataGot)
                              ? Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          '${_chartObj.getLastValue.toDouble() * ((_measure == 'Moisture') ? 100 : 1)}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .display3
                                              .copyWith(
                                                color: appSecondaryDarkColor,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.1,
                                              ),
                                        ),
                                        Text(
                                          '${_chartObj.getUnit}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .body1
                                              .copyWith(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.07,
                                              ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'Latest recorded $_measure on $fetchDateEEE_MMM_d',
                                      style: Theme.of(context).textTheme.body2,
                                    ),
                                  ],
                                )
                              : Container(
                                  height: MediaQuery.of(context).size.height *
                                      0.087,
                                );
                        } else {
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.087,
                          );
                        }
                      },
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 10.0),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          canvasColor: appPrimaryLightColor,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            icon: Icon(FontAwesomeIcons.chevronDown),
                            iconSize: 18.0,
                            value: _measure,
                            onChanged: _changeMeasure,
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  child: Text(
                                    option,
                                    style: Theme.of(context)
                                        .textTheme
                                        .body2
                                        .copyWith(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.035),
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
                        borderRadius: BorderRadius.circular(25.0),
                        shape: BoxShape.rectangle,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.35,
                child: Card(
                    child: FutureBuilder(
                        future: _loadState,
                        builder: (context, AsyncSnapshot snapshot) {
                          // Debug Print
                          print(snapshot);
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return (isDataGot)
                                ? displayChart(_chartObj, _measure, context)
                                : NoData();
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        })),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.chevron_left),
                    onPressed: () async {
                      prevDate();
                      _fetchForDate();
                    },
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    alignment: Alignment.center,
                    child: Text(
                      '$fetchDateEEE_MMM_d',
                      style: Theme.of(context).textTheme.body2.copyWith(
                            fontSize: MediaQuery.of(context).size.width * 0.05,
                          ),
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2.0,
                        color: appPrimaryDarkColor,
                      ),
                      borderRadius: BorderRadius.circular(25.0),
                      shape: BoxShape.rectangle,
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
                height: 10.0,
              ),
              FutureBuilder(
                future: _loadState,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return (isDataGot)
                        ? GridView.builder(
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing:
                                  MediaQuery.of(context).size.height * 0.005,
                              mainAxisSpacing:
                                  MediaQuery.of(context).size.height * 0.005,
                            ),
                            itemCount: _cardCount,
                            itemBuilder: (context, position) {
                              return PlantCard(
                                plant: plantList[position],
                                isSelected: (position == _selCard),
                                onTap: () => _selectPlant(position),
                              );
                            },
                          )
                        : SizedBox();
                  } else {
                    return SizedBox();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*
* Overview

* The first page upon which the user lands on launching the app, this page displays
* the CURRENT DATA of moisture of all plants, humidity, lumination(light), and temperature
* depending upon the availability of such data at the REST API server.
*/

import 'package:flutter/material.dart';

// * external packages import
import 'package:percent_indicator/circular_percent_indicator.dart';

// * utils import
import 'package:soil_moisture_app/utils/display_error.dart';
import 'package:soil_moisture_app/utils/json_post_get.dart';
import 'package:soil_moisture_app/utils/sizes.dart';

// * Data import
import 'package:soil_moisture_app/data/all_data.dart';

// * ui import
import 'package:soil_moisture_app/ui/plant_card.dart';
import 'package:soil_moisture_app/ui/refresh_snackbar.dart';

class Overview extends StatefulWidget {
  @override
  _OverviewState createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  Future<Null> _refresh() async {
    await fetchLatestData().then((_) {
      Scaffold.of(context).showSnackBar(SuccessOnRefresh().build(context));
    }, onError: (_) {
      Scaffold.of(context).showSnackBar(FailureOnRefresh().build(context));
    });
    // Debug Print
    if (isCurrentDataGot) {
      print('Overview refresh got: ${nowPlantList[0].getLastValue}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder(
          future: latData,
          builder: (context, AsyncSnapshot snapshot) {
            // Debug print
            print(snapshot);
            if (snapshot.hasError) {
              return Scaffold(
                body: NoInternet(),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              // * async load threshold data
              threshData = threshData ?? fetchThresholdData();
              // * async load full data for Analysis
              totData = totData ?? fetchTotalData();
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

  void initState() {
    _cardCount = nowPlantList.length;
    _selCard = 0;
    super.initState();
  }

  void _selectPlant(int value) {
    setState(() {
      _selCard = value;
    });
    // Debug print
    print('Selected -> $_selCard');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: appWidth * 0.03),
        child: (isCurrentDataGot)
            // * would show only if today's data is available
            ? ListView(
                physics: AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics()),
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: appWidth * 0.03),
                    child: CircularPercentIndicator(
                      addAutomaticKeepAlive: false,
                      animationDuration: 600,
                      radius: appWidth * 0.6,
                      animation: true,
                      percent: nowPlantList[_selCard].getLastValue,
                      circularStrokeCap: CircularStrokeCap.round,
                      backgroundColor: Colors.grey[300],
                      progressColor: (nowPlantList[_selCard].isCritical())
                          ? Colors.red
                          : (nowPlantList[_selCard].isMoreThanNormal()
                              ? Colors.blue
                              : Colors.green),
                      lineWidth: appWidth * 0.02,
                      footer: Text(
                        'Current Moisture',
                        style: Theme.of(context).textTheme.caption.copyWith(
                              fontSize: appWidth * 0.03,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      center: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '${nowPlantList[_selCard].getLabel}',
                            style: Theme.of(context).textTheme.body2.copyWith(
                                  fontSize: appWidth * 0.03,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            '${(nowPlantList[_selCard].getLastValue * 100).toInt()}${nowPlantList[_selCard].getUnit}',
                            style:
                                Theme.of(context).textTheme.display4.copyWith(
                                      fontSize: appWidth * 0.2,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: appWidth * 0.12,
                    margin: EdgeInsets.symmetric(horizontal: appWidth * 0.07),
                    child: Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Tooltip(
                            message: 'Current Humidity',
                            child: Text(
                              '💧${nowHumid.getLastValue}${nowHumid.getUnit}',
                              style: Theme.of(context)
                                  .textTheme
                                  .body2
                                  .copyWith(fontSize: appWidth * 0.04),
                            ),
                          ),
                          Tooltip(
                            message: 'Current Light',
                            child: Text(
                              '💡${(nowLight.getLastValue < 1000) ? nowLight.getLastValue.toInt() : (nowLight.getLastValue ~/ 1000).toString() + 'K'} ${nowLight.getUnit}',
                              style: Theme.of(context)
                                  .textTheme
                                  .body2
                                  .copyWith(fontSize: appWidth * 0.04),
                            ),
                          ),
                          Tooltip(
                            message: 'Current Temperature',
                            child: Text(
                              '🌡${nowTemp.getLastValue}${nowTemp.getUnit}',
                              style: Theme.of(context)
                                  .textTheme
                                  .body2
                                  .copyWith(fontSize: appWidth * 0.04),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: appWidth * 0.02,
                  ),
                  GridView.builder(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: (appWidth < 600) ? 3 : 5,
                      crossAxisSpacing: appWidth * 0.005,
                      mainAxisSpacing: appWidth * 0.005,
                    ),
                    itemCount: _cardCount,
                    itemBuilder: (context, position) {
                      return PlantCard(
                        plant: nowPlantList[position],
                        isSelected: position == _selCard,
                        onTap: () => _selectPlant(position),
                      );
                    },
                  ),
                ],
              )
            : NoDataToday(),
      ),
    );
  }
}

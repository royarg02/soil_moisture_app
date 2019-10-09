/*
* Overview

* The first page upon which the user lands on launching the app, this page displays
* the CURRENT DATA of moisture of all plants, humidity, lumination(light), and temperature
* depending upon the availability of such data at the REST API server.
*/

import 'package:flutter/material.dart';

// * external packages import
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// * utils import
import 'package:soil_moisture_app/utils/date_func.dart';
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
  Future<void> _refresh() async {
    latData = fetchLatestData();
    await latData.then((_) {
      Scaffold.of(context).showSnackBar(SuccessOnRefresh().build(context));
      // * Async load all data
      if (isNow()) {
        totData = fetchTotalData();
      }
    }, onError: (_) {
      Scaffold.of(context).showSnackBar(FailureOnRefresh().build(context));
    });
    setState(() {});
    // Debug Print
    if (isCurrentDataGot) {
      print('Overview refresh got: ${nowPlantList[0].getLastValue}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: FutureBuilder(
        future: latData,
        builder: (context, AsyncSnapshot snapshot) {
          // Debug print
          print(snapshot);
          if (snapshot.hasError) {
            return NoNowData();
          } else if (snapshot.connectionState == ConnectionState.done) {
            // * async load threshold data
            threshData = threshData ?? fetchThresholdData();
            // * async load full data for Analysis
            totData = totData ?? fetchTotalData();
            return Page();
          } else {
            return Skeleton();
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
  int _selCard;

  void initState() {
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
    return ListView(
      physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: appWidth * 0.03),
          child: (isCurrentDataGot)
              // * would show only if today's data is available
              ? CircularPercentIndicator(
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
                        '${(nowPlantList[_selCard].getLastValue * 100).toStringAsFixed(0)}${nowPlantList[_selCard].getUnit}',
                        style: Theme.of(context).textTheme.display4.copyWith(
                              fontSize: appWidth * 0.2,
                            ),
                      ),
                    ],
                  ),
                )
              : NoNowData(haveInternet: true),
        ),
        Container(
          height: appWidth * 0.12,
          margin: EdgeInsets.symmetric(horizontal: appWidth * 0.07),
          child: Card(
            child: (isCurrentDataGot)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      AvatarData(
                          'Current Humidity',
                          nowHumid.getLastValue,
                          nowHumid.getUnit,
                          FontAwesomeIcons.tint,
                          Colors.blue[300]),
                      AvatarData(
                          'Current Illuminance',
                          nowLight.getLastValue,
                          nowLight.getUnit,
                          FontAwesomeIcons.lightbulb,
                          Colors.amber[400]),
                      AvatarData(
                          'Current Temperature',
                          nowTemp.getLastValue,
                          nowTemp.getUnit,
                          FontAwesomeIcons.thermometerHalf,
                          Colors.red[400])
                    ],
                  )
                : SizedBox(),
          ),
        ),
        SizedBox(
          height: appWidth * 0.02,
        ),
        (isCurrentDataGot)
            ? GridView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: (appWidth < 600) ? 3 : 5,
                  crossAxisSpacing: appWidth * 0.005,
                  mainAxisSpacing: appWidth * 0.005,
                ),
                itemCount: nowPlantList.length,
                itemBuilder: (context, position) {
                  return PlantCard(
                    plant: nowPlantList[position],
                    isSelected: position == _selCard,
                    onTap: () => _selectPlant(position),
                  );
                },
              )
            : SizedBox(),
      ],
    );
  }
}

class Skeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: appWidth * 0.03),
          child: CircularPercentIndicator(
            radius: appWidth * 0.6,
            backgroundColor: Colors.grey[300],
            center: CircularProgressIndicator(),
            footer: SizedBox(
              height: appWidth * 0.03,
            ),
          ),
        ),
        Container(
          height: appWidth * 0.12,
          margin: EdgeInsets.symmetric(horizontal: appWidth * 0.07),
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(appWidth * 0.07),
              child: LinearProgressIndicator(),
            ),
          ),
        )
      ],
    );
  }
}

class AvatarData extends StatelessWidget {
  final String _tooltipMsg;
  final num _value;
  final String _unit;
  final IconData _icon;
  final Color _bkgrndColor;
  AvatarData(
      this._tooltipMsg, this._value, this._unit, this._icon, this._bkgrndColor);
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: this._tooltipMsg,
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(appWidth * 0.01),
            child: CircleAvatar(
              backgroundColor: this._bkgrndColor,
              child: Icon(
                this._icon,
                size: appWidth * 0.05,
              ),
              radius: appWidth * 0.035,
            ),
          ),
          Text(
            '${(this._value > 1000) ? (this._value ~/ 1000).toString() + 'K' : this._value} ${this._unit}',
            style: Theme.of(context)
                .textTheme
                .body2
                .copyWith(fontSize: appWidth * 0.03),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

// * external packages import
import 'package:percent_indicator/circular_percent_indicator.dart';

// * utils import
import 'package:soil_moisture_app/utils/displayError.dart';
import 'package:soil_moisture_app/utils/date_func.dart';
import 'package:soil_moisture_app/utils/gettingJson.dart';

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
  int _cardCount;
  int _selCard;

  void initState() {
    _cardCount = plantList.length;
    _selCard = 0;
    super.initState();
  }

  Future<Null> _refresh() async {
    await fetchTotalData().then((_) {
      Scaffold.of(context).showSnackBar(SuccessOnRefresh().build(context));
    }, onError: (_) {
      Scaffold.of(context).showSnackBar(FailureOnRefresh().build(context));
    });
    // Debug Print
    if (isDataGot) {
      print('Overview refresh got: ${nowData.lastMoistures.last}');
    }
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
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: (isNow() && isDataGot)
                // * would show only if today's data is available
                ? ListView(
                    physics: AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics()),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 35.0),
                        child: CircularPercentIndicator(
                          addAutomaticKeepAlive: false,
                          animationDuration: 600,
                          radius: MediaQuery.of(context).size.width * 0.55,
                          animation: true,
                          percent: nowData.lastMoistures[_selCard],
                          circularStrokeCap: CircularStrokeCap.round,
                          backgroundColor: Colors.grey[300],
                          progressColor: (plantList[_selCard].isCritical())
                              ? Colors.red
                              : (plantList[_selCard].isMoreThanNormal()
                                  ? Colors.blue
                                  : Colors.green),
                          lineWidth: MediaQuery.of(context).size.width * 0.02,
                          center: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                '${(nowData.lastMoistures[_selCard] * 100).toInt()}${plantList[_selCard].getUnit}',
                                style: Theme.of(context)
                                    .textTheme
                                    .display4
                                    .copyWith(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.2,
                                    ),
                              ),
                              Text(
                                '${plantList[_selCard].getLabel}',
                                style: Theme.of(context)
                                    .textTheme
                                    .display1
                                    .copyWith(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.05,
                                    ),
                              ),
                              Text(
                                'Current Moisture',
                                style: Theme.of(context)
                                    .textTheme
                                    .display1
                                    .copyWith(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.035,
                                    ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.width * 0.12,
                        margin: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.07),
                        child: Card(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text(
                                '💧${nowData.lastHumidity}${dayHumid.getUnit}', // ! Get API Fix
                                style: Theme.of(context)
                                    .textTheme
                                    .body2
                                    .copyWith(
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.025),
                              ),
                              Text(
                                '💡${(nowData.lastLight < 1000) ? nowData.lastLight.toInt() : (nowData.lastLight ~/ 1000).toString() + 'K'} ${dayLight.getUnit}',
                                style: Theme.of(context)
                                    .textTheme
                                    .body2
                                    .copyWith(
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.025),
                              ),
                              Text(
                                '🌡${nowData.lastTemp}${dayTemp.getUnit}',
                                style: Theme.of(context)
                                    .textTheme
                                    .body2
                                    .copyWith(
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.025),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      GridView.builder(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                            isSelected: position == _selCard,
                            onTap: () => _selectPlant(position),
                          );
                        },
                      ),
                    ],
                  )
                : NoDataToday(),
          ),
        ),
      ),
    );
  }
}

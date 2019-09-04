import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:soil_moisture_app/ui/plant_card.dart';

import 'package:soil_moisture_app/utils/gettingJson.dart';
import 'package:soil_moisture_app/utils/plant_class.dart';

class Overview extends StatefulWidget {
  @override
  _OverviewState createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  int _cardCount;
  int _selCard;

  void initState() {
    super.initState();
    _cardCount = data.length;
    _selCard = 0;
  }

  Future<Null> _refresh() {
    return fetchTotalData().then((onValue) {
      addPlantData(onValue['records']);
      print(data.length);
      setState(() {
        _cardCount = data.length;
      });
      for (Plant v in data) {
        print('${data.indexOf(v)} -> ${v.moisture}');
      }
    });
  }

  void _selectPlant(int value) {
    setState(() {
      _selCard = value;
    });
    print('Selected -> $_selCard');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: ListView(
              physics: AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics()),
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                CircularPercentIndicator(
                  animationDuration: 600,
                  radius: MediaQuery.of(context).size.width * 0.55,
                  animation: true,
                  percent: data[_selCard].moisture,
                  circularStrokeCap: CircularStrokeCap.round,
                  backgroundColor: Colors.grey[300],
                  progressColor: (data[_selCard].isCritical())
                      ? Colors.red
                      : (data[_selCard].isMoreThanNormal()
                          ? Colors.blue
                          : Colors.green),
                  lineWidth: 10.0,
                  center: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '${(data[_selCard].moisture * 100).toInt()}%',
                        style: Theme.of(context).textTheme.display4.copyWith(
                              fontSize: MediaQuery.of(context).size.width * 0.2,
                            ),
                      ),
                      Text(
                        'Plant $_selCard',
                        style: Theme.of(context).textTheme.display1.copyWith(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.035,
                            ),
                      ),
                      Text(
                        'Weather',
                        style: Theme.of(context).textTheme.body2.copyWith(
                            fontSize: MediaQuery.of(context).size.width * 0.04),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Card(
                  child: Text(
                    'Some Info Here',
                    style: Theme.of(context).textTheme.display2,
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
                    mainAxisSpacing: MediaQuery.of(context).size.height * 0.005,
                  ),
                  itemCount: _cardCount,
                  itemBuilder: (context, position) {
                    return PlantCard(
                      position: position,
                      plant: data[position],
                      selected: _selCard,
                      onTap: () => _selectPlant(position),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () {
          fetchTotalData().then(
            (onValue) {
              addPlantData(onValue['records']);
              print(data.length);
              setState(() {
                _cardCount = data.length;
              });
              for (Plant v in data) {
                print('${data.indexOf(v)} -> ${v.moisture}');
              }
              // The way to get the data
              // onValue['records'][index of the list]['moisutre']
              // onValue['records'][index of the list]['timestamp']
              //print(_data[0].moisture);
            },
          );
        },
      ),
    );
  }
}

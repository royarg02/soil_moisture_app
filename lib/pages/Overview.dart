import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:soil_moisture_app/ui/plant_card.dart';

import 'package:soil_moisture_app/utils/gettingJson.dart';
import 'package:soil_moisture_app/utils/all_data.dart';

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
    _cardCount = plantList.length;
    _selCard = 0;
  }

  Future<Null> _refresh() async {
     await fetchTotalData();
    // * implement onError here
    print('from main: ${plantList[0].getLastMoisture}');
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
                  percent: plantList[_selCard].getLastMoisture,
                  circularStrokeCap: CircularStrokeCap.round,
                  backgroundColor: Colors.grey[300],
                  progressColor: (plantList[_selCard].isCritical())
                      ? Colors.red
                      : (plantList[_selCard].isMoreThanNormal()
                          ? Colors.blue
                          : Colors.green),
                  lineWidth: 10.0,
                  center: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '${(plantList[_selCard].getLastMoisture * 100).toInt()}%',
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
                      plant: plantList[position],
                      isSelected: position == _selCard,
                      onTap: () => _selectPlant(position),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

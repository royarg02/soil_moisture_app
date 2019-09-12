import 'package:flutter/material.dart';

// * external packages import
import 'package:percent_indicator/circular_percent_indicator.dart';

// * utils import
import 'package:soil_moisture_app/ui/plant_card.dart';

// * ui import
import 'package:soil_moisture_app/utils/gettingJson.dart';
import 'package:soil_moisture_app/ui/refresh_snackbar.dart';
import 'package:soil_moisture_app/utils/all_data.dart';

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
    await addLatestData().then((_) {
      Scaffold.of(context).showSnackBar(SuccessOnRefresh().build(context));
    }, onError: (_) {
      Scaffold.of(context).showSnackBar(FailureOnRefresh().build(context));
    });
    // Debug Print
    print('Overview refresh got: ${plantList[0].getLastValue}');
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
            child: ListView(
              physics: AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics()),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 35.0),
                  child: CircularPercentIndicator(
                    animationDuration: 600,
                    radius: MediaQuery.of(context).size.width * 0.55,
                    animation: true,
                    percent: plantList[_selCard].getLastValue,
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
                          '${(plantList[_selCard].getLastValue * 100).toInt()}${plantList[_selCard].getUnit}',
                          style: Theme.of(context).textTheme.display4.copyWith(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.2,
                              ),
                        ),
                        Text(
                          'Plant $_selCard',
                          style: Theme.of(context).textTheme.display1.copyWith(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                              ),
                        ),
                        Text(
                          'Current Moisture',
                          style: Theme.of(context).textTheme.display1.copyWith(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.035,
                              ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(
                            '💧${dayHumid.getLastValue}${dayHumid.getUnit}', // ! Get API Fix
                            style: Theme.of(context).textTheme.body2.copyWith(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.03),
                          ),
                          Text(
                            '💡${(dayLight.getLastValue < 1000) ? dayLight.getLastValue.toInt() : (dayLight.getLastValue ~/ 1000).toString() + 'K'} ${dayLight.getUnit}',
                            style: Theme.of(context).textTheme.body2.copyWith(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.03),
                          ),
                          Text(
                            '🌡${dayTemp.getLastValue}${dayTemp.getUnit}',
                            style: Theme.of(context).textTheme.body2.copyWith(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.03),
                          ),
                        ],
                      ),
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

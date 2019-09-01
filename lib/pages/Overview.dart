import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:soil_moisture_app/ui/plant_card.dart';

import 'dart:math' as math; //! Remove this when refresh implemented

var rnd = math.Random(69); //! Remove this when refresh implemented

class Overview extends StatefulWidget {
  @override
  _OverviewState createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  int _counter = 0;

// * Dummy pull to refresh implemented, remove when done
  Future<void> dummyWait() {
    return Future.delayed(Duration(seconds: 5), null);
  }

  Future<Null> _refresh() {
    return dummyWait().then((_) {
      setState(() => _counter = rnd.nextInt(101));
    });
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
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                SizedBox(
                  height: 5.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    CircularPercentIndicator(
                      animationDuration: 600,
                      radius: MediaQuery.of(context).size.width * 0.6,
                      animation: true,
                      percent: _counter / 100,
                      circularStrokeCap: CircularStrokeCap.round,
                      backgroundColor: Colors.grey[300],
                      progressColor:
                          (_counter < 15) ? Colors.red : Colors.green,
                      lineWidth: 10.0,
                      center: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '$_counter%',
                            style: Theme.of(context)
                                .textTheme
                                .display4
                                .copyWith(
                                  fontFamily: 'Ocrb',
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.15,
                                ),
                          ),
                          Text(
                            'Current Moisture',
                            style: Theme.of(context)
                                .textTheme
                                .display1
                                .copyWith(
                                  fontFamily: 'Ocrb',
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.045,
                                ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                //
                // Enter the weather Shit here!!
                //
                SizedBox(
                  height: 20.0,
                ),
                Card(
                  child: ListTile(
                    title: Text(
                      'You have pushed the button this many times:(Some Info Here)',
                    ),
                    subtitle: Text(
                      '$_counter',
                      style: Theme.of(context).textTheme.display1,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  runSpacing: 5.0,
                  children: <Widget>[
                    PlantCard(
                      title: 'Plant 1',
                      img: '',
                      onTap: () => print('Plant1'),
                      crit: 0.15,
                      percent: _counter / 100,
                    ),
                    PlantCard(
                      title: 'Plant 2',
                      img: '',
                    ),
                    PlantCard(
                      title: 'Plant 3',
                      img: '',
                    ),
                    PlantCard(
                      title: 'Plant 4',
                      img: '',
                    ),
                    PlantCard(
                      title: 'Plant 5',
                      img: '',
                    ),
                    PlantCard(
                      title: 'Plant 6',
                      img: '',
                    ),
                    PlantCard(
                      title: 'Plant 7',
                      img: '',
                    ),
                    PlantCard(
                      title: 'Plant 8',
                      img: '',
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
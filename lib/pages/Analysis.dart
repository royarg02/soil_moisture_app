import 'package:flutter/material.dart';
import 'package:soil_moisture_app/ui/analysis_graph.dart';
import 'package:soil_moisture_app/ui/colors.dart';
import 'package:soil_moisture_app/utils/gettingJson.dart';
import 'package:soil_moisture_app/utils/plant_class.dart';

import 'package:soil_moisture_app/ui/plant_card.dart';

class Analysis extends StatefulWidget {
  @override
  _AnalysisState createState() => _AnalysisState();
}

class _AnalysisState extends State<Analysis> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  int _cardCount;
  int _selCard;
  String _measure;

  void _changeMeasure(String newMeasure) {
    setState(() {
      this._measure = newMeasure;
    });
    print(_measure);
  }

  void initState() {
    super.initState();
    _cardCount = data.length;
    _selCard = 0;
    _measure = 'Humidity';
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
              children: [
                Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                      decoration: BoxDecoration(
                          color: appPrimaryColor,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: appSecondaryLightColor,
                            width: 3.0,
                          )),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Text(
                              '${(data[_selCard].moisture * 100).toInt()}%',
                              style:
                                  Theme.of(context).textTheme.display3.copyWith(
                                        color: (data[_selCard].isCritical())
                                            ? Colors.red
                                            : (data[_selCard].isMoreThanNormal()
                                                ? Colors.blue
                                                : Colors.green),
                                      ),
                            ),
                          ),
                          DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _measure,
                              onChanged: _changeMeasure,
                              items: <String>[
                                'Moisture',
                                'Humidity'
                              ].map<DropdownMenuItem<String>>((String option) {
                                return DropdownMenuItem<String>(
                                    value: option,
                                    child: new Text(
                                      option,
                                      style: Theme.of(context)
                                          .textTheme
                                          .display1
                                          .copyWith(fontSize: 24.0),
                                    ));
                              }).toList(),
                            ),
                          ),
                          Text(
                            'Today',
                            style: Theme.of(context).textTheme.body2,
                          ),
                          Spacer(),
                          Text(
                            'Weather',
                            style: Theme.of(context).textTheme.display1,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      padding: EdgeInsets.symmetric(vertical: 3.0),
                      child: Card(
                        child: Container(
                          child: SimpleTimeSeriesChart.withRandomData(),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.chevron_left),
                          onPressed: null,
                        ),
                        Text(
                          'Sun, 1 Sep',
                          style: Theme.of(context).textTheme.body2.copyWith(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                              ),
                        ),
                        IconButton(
                          icon: Icon(Icons.chevron_right),
                          onPressed: null,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: _cardCount,
                  itemBuilder: (context, position) {
                    return PlantCard(
                      position: position,
                      plant: data[position],
                      selected: _selCard,
                      onTap: () => _selectPlant(position),
                      extended: true,
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

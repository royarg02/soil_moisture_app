import 'package:flutter/material.dart';

import 'package:soil_moisture_app/ui/analysis_graph.dart';
import 'package:soil_moisture_app/ui/colors.dart';
import 'package:soil_moisture_app/ui/drawer.dart';
import 'package:soil_moisture_app/utils/displayError.dart';
import 'package:soil_moisture_app/utils/gettingJson.dart';
import 'package:soil_moisture_app/utils/all_data.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
  List<dynamic> _chartsData;

  void _changeMeasure(String newMeasure) {
    setState(() {
      this._measure = newMeasure;
      switch (_measure) {
        case 'Humidity':
          _chartsData = dayHumid.getHumidity;
          break;
        case 'Light':
          _chartsData = dayLight.getLight;
          break;
        case 'Temp':
          _chartsData = dayTemp.getTemp;
          break;
        case 'Moisture':
        _chartsData = plantList[_selCard].getAllMoisture;
        break;
      }
    });
    print(_chartsData);
    print(_measure);
  }

  void initState() {
    super.initState();
    _cardCount = plantList.length;
    _selCard = 0;
    _chartsData = plantList[_selCard].getAllMoisture;
    _measure = 'Moisture';
  }

  Future<Null> _refresh() async {
    await refreshTotalData();
    // * implement onError here
    print('from main: ${plantList[0].getLastMoisture}');
    setState(() {
     _chartsData = plantList[_selCard].getAllMoisture; 
    });
  }

  void _selectPlant(int value) {
    setState(() {
      _selCard = value;
    });
    print('Selected -> $_selCard');
    _changeMeasure(_measure);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SoifDrawer(),
      appBar: AppBar(
        title: Container(
          margin: const EdgeInsets.all(6.0),
          child: Image.asset('./assets/images/Soif_sk.png'),
        ),
        centerTitle: true,
      ),
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
                      margin: EdgeInsets.symmetric(vertical: 20.0),
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          canvasColor: appPrimaryLightColor,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _measure,
                            onChanged: _changeMeasure,
                            items: <String>['Moisture','Light', 'Humidity', 'Temp']
                                .map<DropdownMenuItem<String>>((String option) {
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
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Text(
                            '${(plantList[_selCard].getLastMoisture * 100).toInt()}%',
                            style: Theme.of(context)
                                .textTheme
                                .display3
                                .copyWith(
                                  color: (plantList[_selCard].isCritical())
                                      ? Colors.red
                                      : (plantList[_selCard].isMoreThanNormal()
                                          ? Colors.blue
                                          : Colors.green),
                                ),
                          ),
                        ),
                        Text(
                          'Current Moisture',
                          style: Theme.of(context).textTheme.body2,
                        ),
                        Spacer(),
                      ],
                    ),
                    (plantList[0].getAllMoisture == null ||
                            plantList[1].getAllMoisture == null ||
                            dayLight.getLight == null ||
                            dayTemp.getTemp == null ||
                            dayHumid.getHumidity == null)
                        ? ShowError()
                        : Container(
                            height: MediaQuery.of(context).size.height * 0.35,
                            padding: EdgeInsets.symmetric(vertical: 3.0),
                            child: Card(
                              child: Container(
                                child: (_chartsData == null)
                                    ? Container()
                                    : displayChart(_chartsData, _measure),
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
                          'Thu, 5 Sep',
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
                GridView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
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
                      isSelected: (position == _selCard),
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

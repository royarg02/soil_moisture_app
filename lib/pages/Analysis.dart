import 'package:flutter/material.dart';

// * ui import
import 'package:soil_moisture_app/ui/analysis_graph.dart';
import 'package:soil_moisture_app/ui/colors.dart';
import 'package:soil_moisture_app/ui/plant_card.dart';
import 'package:soil_moisture_app/ui/refresh_snackbar.dart';

// * utils import
import 'package:soil_moisture_app/utils/displayError.dart';
import 'package:soil_moisture_app/utils/gettingJson.dart';
import 'package:soil_moisture_app/utils/date_func.dart';

// * Data import
import 'package:soil_moisture_app/data/all_data.dart';

class Analysis extends StatefulWidget {
  @override
  _AnalysisState createState() => _AnalysisState();
}

class _AnalysisState extends State<Analysis> {
  int _cardCount;
  int _selCard;
  bool _isLoading;
  String _measure;
  dynamic _chartObj;

  void initState() {
    _cardCount = plantList.length;
    _selCard = 0;
    _isLoading = false;
    _changeMeasure('Moisture');

    super.initState();
  }

  void _changeMeasure(String newMeasure) {
    setState(() {
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

  Future<Null> _fetchForDate() async {
    setState(() {
      _isLoading = true;
    });
    Scaffold.of(context).removeCurrentSnackBar();
    await _refresh();
    setState(() {
      _cardCount = plantList.length;
      _isLoading = false;
      // Debug Print
      print(_cardCount);
    });
  }

  Future<Null> _refresh() async {
    await fetchTotalData().then((_) {
      Scaffold.of(context).showSnackBar(SuccessOnRefresh().build(context));
    }, onError: (_) {
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
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: ListView(
              physics: AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics()),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Row(
                    children: <Widget>[
                      (isDataGot && !_isLoading)
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
                              height:
                                  MediaQuery.of(context).size.height * 0.087,
                            ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            canvasColor: appPrimaryLightColor,
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
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
                                    child: new Text(
                                      option,
                                      style: Theme.of(context)
                                          .textTheme
                                          .display1
                                          .copyWith(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.035),
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
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.35,
                  child: Card(
                    child: (_isLoading)
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : (isDataGot)
                            ? displayChart(_chartObj, _measure, context)
                            : NoData(),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.chevron_left),
                      onPressed: () async {
                        prevDate();
                        await _fetchForDate();
                      },
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      alignment: Alignment.center,
                      child: Text(
                        '$fetchDateEEE_MMM_d',
                        style: Theme.of(context).textTheme.body2.copyWith(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05,
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
                          : () async {
                              nextDate();
                              await _fetchForDate();
                            },
                    )
                  ],
                ),
                SizedBox(
                  height: 10.0,
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

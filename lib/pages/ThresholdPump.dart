/*
* ThresholdPump (Pump Threshold Control)

* //TODO: Aritra please add details

* Currently, the availability of controls depends on whether there is any data available
* for today or not. If not, this will display an empty page.
* This feature could be expanded to save the set values(and POST to API)to be instantly got(GET from API)
* next time this page is brought up.
*/

import 'package:flutter/material.dart';

// * ui import
import 'package:soil_moisture_app/ui/threshold_slider.dart';
import 'package:soil_moisture_app/ui/colors.dart';

// * utils import
import 'package:soil_moisture_app/utils/json_post_get.dart';
import 'package:soil_moisture_app/utils/display_error.dart';

// * data import
import 'package:soil_moisture_app/data/all_data.dart';

class ThresholdPump extends StatefulWidget {
  @override
  _ThresholdPumpState createState() => _ThresholdPumpState();
}

class _ThresholdPumpState extends State<ThresholdPump> {
  Map<String, dynamic> postData;
  Map<String, dynamic> status;
  bool _isLoading;

  void initState() {
    // ! Replace with current threshold fetch when implemented
    thresholdVal = List.filled(nowPlantList.length, 0.0);
    _isLoading = false;
    super.initState();
  }

  void _setThreshold({int position, num value}) {
    setState(() {
      thresholdVal[position] = value;
    });
  }

  void _postThreshold() async {
    setState(() {
      _isLoading = true;
    });
    postData = {};
    for (var i = 0; i < thresholdVal.length; ++i) {
      postData['pump$i'] = thresholdVal[i];
    }
    status = await postThreshold(postData);
    if (status['success']) {
      _showStatus(context, 'Threshold successfully set.');
    } else {
      _showStatus(context, 'Error Occurred');
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text(
          'Pump threshold Control',
          style: Theme.of(context).textTheme.title,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: (isCurrentDataGot)
              ? ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics()),
                  itemCount: thresholdVal.length,
                  itemBuilder: (context, position) {
                    return ThresholdSlider(
                      label: '${nowPlantList[position].getLabel}',
                      threshold: thresholdVal[position],
                      position: position,
                      thresholdChanger: _setThreshold,
                    );
                  })
              : NoDataToday(),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        label: (_isLoading)
            ? CircularProgressIndicator(
                backgroundColor: appPrimaryLightColor,
              )
            : Text(
                'Set',
                style: Theme.of(context).textTheme.button.copyWith(
                      color: appPrimaryLightColor,
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                    ),
              ),
        onPressed:
            (isCurrentDataGot) ? (_isLoading) ? null : _postThreshold : null,
      ),
    );
  }

  void _showStatus(BuildContext context, String status) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Threshold Set Status'),
            actions: <Widget>[
              FlatButton(
                color: appSecondaryDarkColor,
                textTheme: ButtonTextTheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(14.0)),
                ),
                child: Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
                padding: EdgeInsets.all(12.0),
              )
            ],
            content: Text(status),
          );
        });
  }
}

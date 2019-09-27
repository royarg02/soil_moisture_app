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
import 'package:soil_moisture_app/utils/sizes.dart';

// * data import
import 'package:soil_moisture_app/data/all_data.dart';

class ThresholdPump extends StatefulWidget {
  @override
  _ThresholdPumpState createState() => _ThresholdPumpState();
}

class _ThresholdPumpState extends State<ThresholdPump> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text(
          'Pump threshold Control',
          style: Theme.of(context).textTheme.title.copyWith(
                fontSize: appWidth * 0.055,
              ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: latData,
        builder: (context, AsyncSnapshot snapshot) {
          // Debug print
          print(snapshot);
          if (snapshot.hasError) {
            return Scaffold(
              body: NoInternet(),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            return Page();
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
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
  Map<String, dynamic> postData;
  Map<String, dynamic> status;
  bool _isLoading;

  void initState() {
    _isLoading = false;

    // ! Replace with current threshold fetch when implemented
    thresholdVal = List.filled(nowPlantList.length, 0.0);
    super.initState();
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

  void _setThreshold({int position, num value}) {
    setState(() {
      thresholdVal[position] = value;
    });
  }

  void _showStatus(BuildContext context, String status) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Threshold Set Status',
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              FlatButton(
                color: appSecondaryDarkColor,
                textTheme: ButtonTextTheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.all(Radius.circular(appWidth * 0.1)),
                ),
                child: Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
                padding: EdgeInsets.all(appWidth * 0.02),
              )
            ],
            content: Text(status),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: appWidth * 0.03),
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
      floatingActionButton: Visibility(
        visible: isCurrentDataGot,
        child: FloatingActionButton.extended(
          label: (_isLoading)
              ? CircularProgressIndicator(
                  backgroundColor: appPrimaryLightColor,
                )
              : Text(
                  'Set',
                  style: Theme.of(context).textTheme.button.copyWith(
                        color: appPrimaryLightColor,
                        fontSize: appWidth * 0.04,
                      ),
                ),
          onPressed: (_isLoading) ? null : _postThreshold,
        ),
      ),
    );
  }
}

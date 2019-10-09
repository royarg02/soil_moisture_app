/*
* ThresholdPump (Pump Threshold Control)

* This page provides the controls to set the threshold of the pumps which in turn, control the
* availability of water and moisture of the plant.
* The availability of current data from overview determines the presence of any new entry for
* controlling the threshold in case the API for storing threshold values has not been updated
* to include the new entry.
* 'Setting' the values saves the values to be posted to API and can be instantly obtained(GET from API)
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
    return FutureBuilder(
      future: threshData,
      builder: (context, AsyncSnapshot snapshot) {
        // Debug print
        print(snapshot);
        if (snapshot.hasError) {
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
            body: NoNowData(),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          return Page();
        } else {
          return Skeleton();
        }
      },
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
    super.initState();
  }

  void _postThreshold() async {
    setState(() {
      _isLoading = true;
    });
    postData = Map.fromIterable(pumpList,
        key: (item) => item.getLabel, value: (item) => item.getVal);
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
      pumpList[position].setVal = value;
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
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: appWidth * 0.03),
        child: (pumpList.length != 0)
            ? ListView.builder(
                physics: AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics()),
                itemCount: pumpList.length,
                itemBuilder: (context, position) {
                  return ThresholdSlider(
                    label: pumpList[position].getLabel,
                    threshold: pumpList[position].getVal,
                    position: position,
                    thresholdChanger: _setThreshold,
                  );
                })
            : NoNowData(
                haveInternet: true,
              ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Visibility(
        visible: (pumpList.length != 0),
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

class Skeleton extends StatelessWidget {
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
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: appWidth * 0.03),
        child: ListView.builder(
            physics:
                AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            itemCount: 2,
            itemBuilder: (context, position) {
              return Card(
                margin: EdgeInsets.only(top: appWidth * 0.03),
                child: Padding(
                  padding: EdgeInsets.all(appWidth * 0.045),
                  child: LinearProgressIndicator(),
                ),
              );
            }),
      ),
    );
  }
}

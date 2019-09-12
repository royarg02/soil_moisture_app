import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:soil_moisture_app/ui/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

class ThresholdPump extends StatefulWidget {
  @override
  _ThresholdPumpState createState() => _ThresholdPumpState();
}

class _ThresholdPumpState extends State<ThresholdPump> {
  num val0 = 0.0;
  num val1 = 0.0;
  Map<String, dynamic> status;
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
          child: ListView(
            //mainAxisAlignment: MainAxisAlignment.spaceAround,
            physics:
                AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: Text(
                      'Plant0',
                      style: Theme.of(context).textTheme.display1,
                    ),
                  ),
                  Slider(
                    value: val0,
                    onChanged: (val) {
                      setState(() {
                        val0 = val;
                        // print(val0.round());
                      });
                    },
                    min: 0,
                    max: 1,
                    divisions: 20,
                    activeColor: appSecondaryLightColor,
                    inactiveColor: appPrimaryColor,
                    label: "$val0",
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: Text(
                      'Plant1',
                      style: Theme.of(context).textTheme.display1,
                    ),
                  ),
                  Slider(
                    value: val1,
                    onChanged: (val) {
                      setState(() {
                        val1 = val;
                        // print(val1.round());
                      });
                    },
                    min: 0,
                    max: 1,
                    divisions: 20,
                    activeColor: appSecondaryLightColor,
                    inactiveColor: appPrimaryColor,
                    label: "$val1",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        label: Text(
          'Set',
          style: Theme.of(context).textTheme.button.copyWith(
                color: appPrimaryLightColor,
              ),
        ),
        onPressed: () async {
          print(
              'Plant 1 Pump: ${(val0 * pow(10.0, 2)).round().toDouble() / pow(10.0, 2)}');
          print(
              'Plant 2 Pump: ${(val1 * pow(10.0, 2)).round().toDouble() / pow(10.0, 2)}');
          String url = "http://drip-io.herokuapp.com/setthreshold";
          String postBody = json.encode({
            "pump0": (val0 * pow(10.0, 2)).round().toDouble() / pow(10.0, 2),
            "pump1": (val1 * pow(10.0, 2)).round().toDouble() / pow(10.0, 2),
          });
          http
              .post(url,
                  headers: {
                    "Content-Type": "application/json",
                  },
                  body: postBody,
                  encoding: Encoding.getByName('utf-8'))
              .then((_) {
            print("${_.statusCode}");
            print("${json.decode(_.body)}");
            status = json.decode(_.body);
            //print(status['success'].runtimeType);
            if (status['success']) {
              _showStatus(context, 'Threshold successfully set.');
            } else {
              _showStatus(context, 'Error Occurred');
            }
          });
        },
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
              content: Text(status));
        });
  }
}


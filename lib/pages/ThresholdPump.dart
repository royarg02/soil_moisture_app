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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
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
            activeColor: appSecondaryLightColor,
            inactiveColor: appPrimaryColor,
            label: "$val0",
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
            activeColor: appSecondaryLightColor,
            inactiveColor: appPrimaryColor,
            label: "$val1",
          ),
          MaterialButton(
            onPressed: () async {
              print(
                  'Plant 1 Pump: ${(val0 * pow(10.0, 2)).round().toDouble() / pow(10.0, 2)}');
              print(
                  'Plant 2 Pump: ${(val1 * pow(10.0, 2)).round().toDouble() / pow(10.0, 2)}');
              String url = "http://drip-io.herokuapp.com/waterthreshold";
              http
                  .post(
                url,
                body: json.encode({
                  "pump0":
                      (val0 * pow(10.0, 2)).round().toDouble() / pow(10.0, 2),
                  "pump1":
                      (val1 * pow(10.0, 2)).round().toDouble() / pow(10.0, 2),
                }),
              )
                  .then((_) {
                print("${_.statusCode}");
                print("${json.decode(_.body)}");
              });
            },
            color: appSecondaryDarkColor,
          ),
        ],
      ),
    );
  }
}

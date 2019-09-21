import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

// * ui import
import 'package:soil_moisture_app/ui/thresholdSlider.dart';
import 'package:soil_moisture_app/ui/colors.dart';

// * data import
import 'package:soil_moisture_app/data/all_data.dart';

class ThresholdPump extends StatefulWidget {
  @override
  _ThresholdPumpState createState() => _ThresholdPumpState();
}

class _ThresholdPumpState extends State<ThresholdPump> {
  List<num> val;
  String url = "$baseUrl/setthreshold";
  Map<String, dynamic> status;

  void initState() {
    val = List.filled(2, 0.0);
    super.initState();
  }

  void _setThreshold({int position, num value}) {
    setState(() {
       val[position] = value;
    });
  }

  void _postThreshold() async {
    print(
        'Plant 1 Pump: ${(val[0] * pow(10.0, 2)).round().toDouble() / pow(10.0, 2)}');
    print(
        'Plant 2 Pump: ${(val[1] * pow(10.0, 2)).round().toDouble() / pow(10.0, 2)}');
    String postBody = json.encode({
      "pump0": (val[0] * pow(10.0, 2)).round().toDouble() / pow(10.0, 2),
      "pump1": (val[1] * pow(10.0, 2)).round().toDouble() / pow(10.0, 2),
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
      if (status['success']) {
        _showStatus(context, 'Threshold successfully set.');
      } else {
        _showStatus(context, 'Error Occurred');
      }
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
          child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics()),
              itemCount: val.length,
              itemBuilder: (context, position) {
                return ThresholdSlider(
                  label: 'Plant $position',
                  threshold: val[position],
                  position: position,
                  thresholdChanger: _setThreshold,
                );
              }),
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
        onPressed: _postThreshold,
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

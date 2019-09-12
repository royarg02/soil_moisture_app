import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // * For formatting date
import 'dart:convert';
import 'dart:async';

// * utils import
import 'package:soil_moisture_app/utils/humidity_data.dart';
import 'package:soil_moisture_app/utils/light_data.dart';
import 'package:soil_moisture_app/utils/plant_class.dart';
import 'package:soil_moisture_app/utils/temp_data.dart';
import 'package:soil_moisture_app/utils/all_data.dart';

var _formatter = DateFormat('dd-MM-yyyy');
String _currDay = '05-09-2019'; //_formatter.format(DateTime.now());

Future<Map<String, dynamic>> fetchJsonData({bool current = false}) async {
  String url =
      "https://drip-io.herokuapp.com/getdata/${(current) ? 'now' : _currDay}";
  print(url);
  final response = await http.get(url);
  var parsed = json.decode(response.body);
  return parsed;
}

Future<Null> addData(Map<String, dynamic> data) {
  print(data);
  plantList = [];
  data['records'][0]['moisture']
      .forEach((k, v) => plantList.add(Plant.createElement(k, v.cast<num>())));
  dayHumid = Humidity.fromJson(data['records'][0]);
  dayTemp = Temp.fromJson(data['records'][0]);
  dayLight = Light.fromJson(data['records'][0]);
  return null;
}

Future<Null> fetchTotalData() async {
  print(_currDay);
  fetchJsonData().then((onValue) => addData(onValue));
}

Future<Null> refreshTotalData() async {
  print(_currDay);
  await fetchJsonData().then((onValue) => addData(onValue));
}

Future<Null> addLatestData() async {
  await fetchJsonData(current: true).then((onValue) {
    print(onValue);
    plantList = [];
    onValue['moisture']
        .forEach((k, v) => plantList.add(Plant.createWithLast(k, v)));
    dayHumid = Humidity.addLatest(onValue['humidity']);
    dayTemp = Temp.addLatest(onValue['temparature']);
    dayLight = Light.addLatest(onValue['light']); // ! gives int API fix
  });
  fetchTotalData();
}

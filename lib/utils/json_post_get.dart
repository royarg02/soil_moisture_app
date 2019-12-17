/*
* json_post_get

* Defines functions for fetching from/ posting to REST API.
*/

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

// * utils import
import 'package:soil_moisture_app/utils/date_func.dart';

// * Data import
import 'package:soil_moisture_app/data/humidity_class.dart';
import 'package:soil_moisture_app/data/light_class.dart';
import 'package:soil_moisture_app/data/plant_class.dart';
import 'package:soil_moisture_app/data/temp_class.dart';
import 'package:soil_moisture_app/data/threshold_class.dart';
import 'package:soil_moisture_app/data/all_data.dart';

// * determines if any data is got from the API
bool isDataGot = false;
bool isCurrentDataGot = false;

// * variables for caching response
Future latData = fetchLatestData();
Future totData = fetchTotalData();
Future threshData = fetchThresholdData();

// * Fetch from API
Future<Map<String, dynamic>> fetchJsonData(
    {String altUrl, bool latest = false}) async {
  /*
      * 'altUrl' is invoked for requesting data if provided (used for fetching threshold values)
      * otherwise, the default url is invoked with the route determined by the
      * 'latest' boolean by fetching the current data (now) if true, full data if false
      */
  String url =
      altUrl ?? "$baseUrl/getdata/${(latest) ? 'now' : fetchDateddmmyyyy}";
  // Debug print
  print(url);
  final response = await http.get(url);
  var parsed = json.decode(response.body);
  // Debug print

  print(response.statusCode);
  return parsed;
}

// * Threshold Post to API
Future<Map<String, dynamic>> postThreshold(Map<String, dynamic> data) async {
  String url = '$baseUrl/setpump';
  Map<String, dynamic> postResult;
  // Debug print
  print(data);
  print(url);
  await http
      .post(url,
          headers: {
            "Content-Type": "application/json",
          },
          body: json.encode(data),
          encoding: Encoding.getByName('utf-8'))
      .then((onValue) {
    // Debug print
    print(onValue.statusCode);
    postResult = json.decode(onValue.body);
  });
  return postResult;
}

// * Add total data for a day received from API
void addData(Map<String, dynamic> data) {
  isDataGot = false;
  // Debug print
  print(data);
  plantList = [];
  if (data['records'].isEmpty) {
    return null;
  }
  isDataGot = true;
  data['records'][0]['moisture'].forEach((k, v) {
    plantList.add(Plant.createElement(k, v.cast<num>()));
  });
  dayHumid = Humidity.fromJson(data['records'][0]);
  dayTemp = Temp.fromJson(data['records'][0]);
  dayLight = Light.fromJson(data['records'][0]);
}

// * Add current data received from API
void addLatestData(Map<String, dynamic> data) {
  isCurrentDataGot = false;
  // Debug print
  print(data);
  nowPlantList = [];
  if (data == null) {
    return null;
  }
  isCurrentDataGot = true;
  data['moisture'].forEach((k, v) {
    nowPlantList.add(Plant.createLatest(k, double.parse(v.toString())));
  });
  nowLight = Light.createLatest(data['light']);
  nowHumid = Humidity.createLatest(data['humidity']);
  nowTemp = Temp.createLatest(data['temparature']);
}

void addThresholdData(Map<String, dynamic> data) {
  // Debug Print
  print(data);
  pumpList = [];
  /*
  * Compares the lengths of 'nowPlantList' and fetched threshold map to determine if there are any new entries.
  * If the threshold value API has not been updated and the current data includes a new entry/ plant, then a new
  * entry(object) is appended to the 'pumpList' with a value of '0.0'. If current data is not available, the
  * fetched threshold data itself is used.
  */
  var length = (isCurrentDataGot && (nowPlantList.length > data.length))
      ? nowPlantList.length
      : data.length;
  for (var i = 0; i < length; i++) {
    pumpList.add(Threshold(i, data['settings']['pump$i']));
  }
}

// * fetch total data from API
Future<void> fetchTotalData() async {
  print(fetchDateddmmyyyy);
  return fetchJsonData().then((onValue) => addData(onValue));
}

// * fetch current data from API
Future<void> fetchLatestData() async {
  print('Fetching Now');
  return fetchJsonData(latest: true).then((onValue) => addLatestData(onValue));
}

// * get Threshold values from API
Future<void> fetchThresholdData() async {
  print('Fetching Threshold Values');
  return fetchJsonData(altUrl: '$baseUrl/getpump')
      .then((onValue) => addThresholdData(onValue));
}

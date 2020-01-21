/*
* json_post_get

* Defines functions for fetching from/ posting to REST API.
*/

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

// * utils import
import 'package:soif/utils/date_func.dart';
import 'package:soif/utils/json_post_get_test.dart';

// * Data import
import 'package:soif/data/plant_data.dart';
import 'package:soif/data/threshold_class.dart';
import 'package:soif/data/all_data.dart';
import 'package:soif/data/static_data.dart';

// * variables for caching response
Future latData = fetchLatestData();
Future totData = fetchTotalData();
Future threshData = fetchThresholdData();

// * Fetch from API
Future<Map<String, dynamic>> fetchJsonData(
    {String url, bool latest = false}) async {
  /*
      * 'altUrl' is invoked for requesting data if provided (used for fetching threshold values)
      * otherwise, the default url is invoked with the route determined by the
      * 'latest' boolean by fetching the current data (now) if true, full data if false
      */
  url ??= "$baseUrl/getdata/${(latest) ? 'now' : fetchDateddmmyyyy}";
  http.Response _response;
  // Debug print
  print(url);
  _response = await http.get(url);
  print(_response.statusCode);
  return json.decode(_response.body);
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
void addTotalData(Map<String, dynamic> data) {
  // Debug print
  printData(data, 'All');
  allData = AllData.fromJson(data);
  print(allData);
}

// * Add current data received from API
void addLatestData(Map<String, dynamic> data) {
  // Debug print
  printData(data, 'Now');
  nowData = NowData.fromJson(data);
  print(nowData);
}

void addThresholdData(Map<String, dynamic> data) {
  // Debug Print
  printData(data, 'Threshold');
  /*
  * If the threshold value API has not been updated and the current data includes a 
  * new entry/ plant, then a new entry(object) is appended to the 'pumpList' with a
  * value of '0.0'. If current data is not available, the fetched threshold data itself is used.
  */
  final maxLength = nowData?.plantList?.length ?? data["settings"].length;
  pumpList = Iterable<Threshold>.generate(
      maxLength, ((i) => Threshold(i, data["settings"]["pump$i"]))).toList();
  print(pumpList);
}

// * fetch total data from API
Future<void> fetchTotalData() async {
  print('Fetching data for: $fetchDateddmmyyyy');
  return await fetchJsonData().then((onValue) => addTotalData(onValue));
}

// * fetch current data from API
Future<void> fetchLatestData() async {
  print('Fetching Now');
  return await fetchJsonData(latest: true)
      .then((onValue) => addLatestData(onValue));
}

// * get Threshold values from API
Future<void> fetchThresholdData() async {
  print('Fetching Threshold Values');
  return await fetchJsonData(url: '$baseUrl/getpump')
      .then((onValue) => addThresholdData(onValue));
}

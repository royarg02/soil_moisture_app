import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

// * utils import
import 'package:soil_moisture_app/utils/date_func.dart';

// * Data import
import 'package:soil_moisture_app/data/humidity_data.dart';
import 'package:soil_moisture_app/data/light_data.dart';
import 'package:soil_moisture_app/data/plant_class.dart';
import 'package:soil_moisture_app/data/temp_data.dart';
import 'package:soil_moisture_app/data/all_data.dart';

// * determines if any data is got from the API
bool isDataGot;
bool isCurrentDataGot;

// * variables for caching response
Future latData = fetchLatestData();
Future totData = fetchTotalData();

Future<Map<String, dynamic>> fetchJsonData({bool latest = false}) async {
  String url = "$baseUrl/getdata/${(latest) ? 'now' : fetchDatedd_mm_yyyy}";
  print(url);
  final response = await http.get(url);
  var parsed = json.decode(response.body);
  print(response.statusCode);
  return parsed;
}

Future<Map<String, dynamic>> postThreshold(Map<String, dynamic> data) async {
  String url = "$baseUrl/setthreshold";
  Map<String, dynamic> postResult;
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
    print(onValue.statusCode);
    postResult = json.decode(onValue.body);
  });
  return postResult;
}

void addData(Map<String, dynamic> data) {
  isDataGot = true;
  print(data);
  plantList = [];
  if (data['records'].isEmpty) {
    isDataGot = false;
    return null;
  }
  data['records'][0]['moisture'].forEach((k, v) {
    plantList.add(Plant.createElement(k, v.cast<num>()));
  });
  dayHumid = Humidity.fromJson(data['records'][0]);
  dayTemp = Temp.fromJson(data['records'][0]);
  dayLight = Light.fromJson(data['records'][0]);
}

void addLatestData(Map<String, dynamic> data) {
  isCurrentDataGot = true;
  print(data);
  nowPlantList = [];
  if (data == null) {
    isCurrentDataGot = false;
    return null;
  }
  data['moisture'].forEach((k, v) {
    nowPlantList.add(Plant.createLatest(k, double.parse(v.toString())));
  });
  print(nowPlantList.last.getLastValue);
  nowLight = Light.createLatest(data['light']);
  nowHumid = Humidity.createLatest(data['humidity']);
  nowTemp = Temp.createLatest(data['temparature']);
}

Future<Null> fetchTotalData() async {
  print(fetchDatedd_mm_yyyy);
  await fetchJsonData().then((onValue) => addData(onValue));
}

Future<Null> fetchLatestData() async {
  print('Fetching Now');
  await fetchJsonData(latest: true).then((onValue) => addLatestData(onValue));
}

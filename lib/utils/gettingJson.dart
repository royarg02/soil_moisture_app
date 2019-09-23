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

Future<Map<String, dynamic>> fetchJsonData({bool latest = false}) async {
  String url = "$baseUrl/getdata/${(latest) ? 'now' : fetchDatedd_mm_yyyy}";
  print(url);
  final response = await http.get(url);
  var parsed = json.decode(response.body);
  print(response.statusCode);
  return parsed;
}

Future<Null> addData(Map<String, dynamic> data) {
  isDataGot = true;
  print(data);
  plantList = [];
  if (data['records'].isEmpty) {
    isDataGot = false;
    return null;
  }
  data['records'][0]['moisture'].forEach((k, v) {
    plantList.add(Plant.createElement(k, v.cast<num>()));
    // if (isNow()) {
    //   nowData.lastMoistures.add(v.cast<num>().last);
    //   print(nowData.lastMoistures);
    // }
  });
  dayHumid = Humidity.fromJson(data['records'][0]);
  dayTemp = Temp.fromJson(data['records'][0]);
  dayLight = Light.fromJson(data['records'][0]);
  // if (isNow()) {
  //   nowData.lastHumidity = dayHumid.getAllValues.last;
  //   nowData.lastLight = dayLight.getAllValues.last;
  //   nowData.lastTemp = dayLight.getAllValues.last;
  // }
}

Future<Null> addLatestData(Map<String, dynamic> data) {
  isCurrentDataGot = true;
  isDataGot = true;
  print(data);
  nowPlantList = [];
  if(data == null){
    isCurrentDataGot = false;
    return null;
  }
  data['moisture'].forEach((k, v){
    nowPlantList.add(Plant.createLatest(k, double.parse(v.toString())));
    // nowData.createElement(k, double.parse(v.toString()));
    //nowData.latPlantList.add(SmallPlant()double.parse(v.toString()));
  });
  print(nowData.latPlantList);
  nowLight = Light.createLatest(data['light']);
  nowHumid = Humidity.createLatest(data['humidity']);
  nowTemp = Temp.createLatest(data['temparature']);
  // nowData.lastLight = data['light'];
  // nowData.lastHumidity = data['humidity'];
  // nowData.lastTemp = data['temparature'];
}

Future<Null> fetchTotalData() async {
  print(fetchDatedd_mm_yyyy);
  await fetchJsonData().then((onValue) => addData(onValue));
}

Future<Null> fetchLatestData() async {
  print('Fetching Now');
  await fetchJsonData(latest: true).then((onValue) => addLatestData(onValue));
}

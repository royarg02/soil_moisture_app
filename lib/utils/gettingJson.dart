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

Future<Map<String, dynamic>> fetchJsonData() async {
  String url = "$baseUrl/getdata/$fetchDatedd_mm_yyyy";
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
    if (isNow()) {
      nowData.lastMoistures.add(v.cast<num>().last);
      print(nowData.lastMoistures);
    }
  });
  dayHumid = Humidity.fromJson(data['records'][0]);
  dayTemp = Temp.fromJson(data['records'][0]);
  dayLight = Light.fromJson(data['records'][0]);
  if (isNow()) {
    nowData.lastHumidity = dayHumid.getAllValues.last;
    nowData.lastLight = dayLight.getAllValues.last;
    nowData.lastTemp = dayLight.getAllValues.last;
  }
}

Future<Null> fetchTotalData() async {
  print(fetchDatedd_mm_yyyy);
  await fetchJsonData().then((onValue) => addData(onValue));
}

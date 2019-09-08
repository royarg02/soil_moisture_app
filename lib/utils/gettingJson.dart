import 'package:http/http.dart' as http;
import 'package:soil_moisture_app/utils/humidity_data.dart';
import 'package:soil_moisture_app/utils/light_data.dart';
import 'dart:convert';
import 'dart:async';
import 'package:soil_moisture_app/utils/plant_class.dart';
import 'package:soil_moisture_app/utils/temp_data.dart';
import 'package:soil_moisture_app/utils/all_data.dart';
import 'package:intl/intl.dart';

var _formatter = DateFormat('dd-MM-yyyy');
String _currDay = '05-09-2019';//_formatter.format(DateTime.now());

Future<Null> fetchTotalData() async{
  print(_currDay);
  await fetchJsonData().then((onValue){
    print(onValue);
    plantList = [];
    onValue['records'][0]['moisture'].forEach((k,v) => plantList.add(Plant.createElement(k, v)));
    dayHumid = Humidity.fromJson(onValue['records'][0]);
    dayTemp = Temp.fromJson(onValue['records'][0]);
    dayLight = Light.fromJson(onValue['records'][0]);
  });
  // // * Get and add Plant Data
  // await addPlantData();
  // // * Get and add Light Data
  // await addLightData();
  // // * Get and add Temperature Data 
  // await addTempData();
  // // * Get and add Humidity Data
  // await addHumidData();
}
// Future<Map<String, dynamic>> fetchLatestData() async{
//   String url = "https://drip-io.herokuapp.com/getdata/now";
//   final response = await http.get(url);
//   var parsed = json.decode(response.body);
//   return parsed;
// }

Future<Map<String, dynamic>> fetchJsonData({bool current = false}) async {
  String url = "https://drip-io.herokuapp.com/getdata/${(current)?'now':_currDay}";
  print(url);
  final response = await http.get(url);
  var parsed = json.decode(response.body);
  return parsed;
}

Future<Null> addLatestData() async{
  await fetchJsonData(current: true).then((onValue){
    print(onValue);
    plantList = [];
    onValue['moisture'].forEach((k,v) => plantList.add(Plant.createWithLast(k, v)));
    dayHumid = Humidity.addLatest(onValue['humidity']);
    dayTemp = Temp.addLatest(onValue['temparature']);
    dayLight = Light.addLatest(onValue['light']);
  });
}

// Future<Null> addPlantData() async {
//   await fetchJsonData('moisture').then((onValue){
//     print(onValue);
//     plantList = [];
//     onValue['records'][0]['moisture'].forEach((k,v) => plantList.add(Plant.createElement(k, v)));
//   });
// }

// Future<Null> addLightData()async{
//   await fetchJsonData('light').then((onValue){
//     print(onValue);
//     dayLight = Light.fromJson(onValue['records'][0]);
//   });
// }

// Future<Null> addTempData()async{
//   await fetchJsonData('temparature').then((onValue){
//     print(onValue);
//     dayTemp = Temp.fromJson(onValue['records'][0]);
//   });
// }

// Future<Null> addHumidData()async{
//   await fetchJsonData('humidity').then((onValue){
//     print(onValue);
//     dayHumid = Humidity.fromJson(onValue['records'][0]);
//   });
// }
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:soil_moisture_app/utils/plant_class.dart';

List<Plant> data = [];

Future<Map<String, dynamic>> fetchTotalData() async {
  String url = "https://drip-io.herokuapp.com/getdata";
  final response = await http.get(url);
  var parsed = json.decode(response.body);
  return parsed;
}

void addPlantData(List<dynamic> fromApi) {
  data = [];
  for (var d in fromApi) {
    data.add(Plant.fromJson(d));
  }
}

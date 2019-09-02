import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

Future<Map<String, dynamic>> fetchTotalData() async {
  String url = "https://drip-io.herokuapp.com/getdata";
  final response = await http.get(url);
  var parsed = json.decode(response.body);
  return parsed;
}

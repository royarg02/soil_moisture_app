// * Import all Data Classes
import 'package:soil_moisture_app/data/plant_class.dart';
import 'package:soil_moisture_app/data/temp_data.dart';
import 'package:soil_moisture_app/data/humidity_data.dart';
import 'package:soil_moisture_app/data/light_data.dart';
import 'package:soil_moisture_app/data/threshold_data.dart';

// * Define Data Objects to be used throughout the app
List<Plant> plantList = [];
Light dayLight;
Temp dayTemp;
Humidity dayHumid;

// * Latest Data objects to be used in Overview
List<Plant> nowPlantList = [];
Light nowLight;
Temp nowTemp;
Humidity nowHumid;

// * for threshold
List<Threshold> pumpList = [];

// * base url for application get/post
final baseUrl = "https://drip-io.herokuapp.com";
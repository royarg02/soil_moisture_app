// * Import all Data Classes
import 'package:soif/data/plant_class.dart';
import 'package:soif/data/plant_data.dart';
import 'package:soif/data/temp_class.dart';
import 'package:soif/data/humidity_class.dart';
import 'package:soif/data/light_class.dart';
import 'package:soif/data/threshold_class.dart';

// * Define Data Objects to be used throughout the app
AllData allData;
// List<Plant> plantList;
// Light dayLight;
// Temp dayTemp;
// Humidity dayHumid;

// * Latest Data objects to be used in Overview
NowData nowData;
// List<Plant> nowPlantList;
// Light nowLight;
// Temp nowTemp;
// Humidity nowHumid;

// * for threshold
List<Threshold> pumpList = [];
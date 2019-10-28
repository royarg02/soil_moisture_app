// * Import all Data Classes
import 'package:soil_moisture_app/data/plant_class.dart';
import 'package:soil_moisture_app/data/temp_class.dart';
import 'package:soil_moisture_app/data/humidity_class.dart';
import 'package:soil_moisture_app/data/light_class.dart';
import 'package:soil_moisture_app/data/threshold_class.dart';

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
final baseUrl = "https://soif.herokuapp.com";

// * Url for github repo
final repoUrl = 'https://github.com/RoyARG02/soil_moisture_app';

// * Uri for API
final apiUrl = 'https://github.com/forkbomb-666/drip_irrigation_server';

// * Developer Details
final List<Map<String, dynamic>> devDetails = [
  {
    'Name': 'ANURAG ROY',
    'Github': 'RoyARG02',
    'Bio': 'Programming language nomad | Flutter noob',
    'Twitter': '_royarg'
  },
  {
    'Name': 'AYUSH THAKUR',
    'Github': 'ayulockin',
    'Bio': 'Deep Learning for Computer Vision | Computer Vision for Robotics',
    'Twitter': 'ayushthakur0'
  },
  {
    'Name': 'SNEHANGSHU BHATTACHARYA',
    'Github': 'forkbomb-666',
    'Bio': 'Linux | Bigdata(Hadoop) | DIY Electronics | Robotics',
    'Twitter': 'snehangshu_'
  },
  {
    'Name': 'ARITRA ROY GOSTHIPATY',
    'Github': 'ariG23498',
    'Bio': '| Flutter | Android | Algorithms | Digital Signal Processing |',
    'Twitter': 'ariG23498'
  }
];

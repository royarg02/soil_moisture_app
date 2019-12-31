import 'package:soif/data/environment_data.dart';
import 'package:soif/data/plant_class.dart';

abstract class PlantData {
  List<Plant> _plantlist;
  Humidity _humidity;
  Light _light;
  Temp _temp;

  List<Plant> get plantList => this._plantlist;
  Humidity get humidity => this._humidity;
  Light get light => this._light;
  Temp get temp => this._temp;

  @override
  String toString() {
    return 'Plantlist: ${this._plantlist}\nHumidity: ${this._humidity}\nLight: ${this._light}\nTemp: ${this._temp}';
  }
}

class NowData extends PlantData {
  static NowData _nowData;
  NowData() {
    _humidity = Humidity.latest();
    _light = Light.latest();
    _temp = Temp.latest();
  }
  factory NowData.fromJson(Map<String, dynamic> data) {
    if (data != null) {
      print(
          '==============================[New Now Data]==============================');
      _nowData = NowData._parse(data);
    }
    return _nowData;
  }

  NowData._parse(Map<String, dynamic> data) {
    this._humidity = Humidity.latest()..setLatestValue = data["humidity"];
    this._temp = Temp.latest()..setLatestValue = data["temparature"];
    this._light = Light.latest()..setLatestValue = data["light"];
    this._plantlist = data.isEmpty
        ? []
        : data["moisture"]
            .entries
            .map<Plant>((entry) => Plant.latest(entry.key, entry.value))
            .toList();
  }
  @override
  String toString() {
    return '==============================[Parsed Now data]==============================\n${super.toString()}\n\n';
  }
}

class AllData extends PlantData {
  static AllData _allData;
  AllData() {
    _humidity = Humidity();
    _light = Light();
    _temp = Temp();
  }
  factory AllData.fromJson(Map<String, dynamic> data) {
    if (data != null) {
      print(
          '==============================[New All Data]==============================');
      _allData = AllData._parse(data);
    }
    return _allData;
  }
  AllData._parse(Map<String, dynamic> data) {
    if (data["records"].isEmpty) {
      this._humidity = Humidity()..setAllValues = [];
      this._temp = Temp()..setAllValues = [];
      this._light = Light()..setAllValues = [];
      this._plantlist = [];
    } else {
      this._humidity = Humidity()
        ..setAllValues = data["records"][0]["humidity"]
            .map<num>((v) => double.parse(v.toString()))
            .toList();
      this._light = Light()
        ..setAllValues = data["records"][0]["light"]
            .map<num>((v) => double.parse(v.toString()))
            .toList();
      this._temp = Temp()
        ..setAllValues = data["records"][0]["temparature"]
            .map<num>((v) => double.parse(v.toString()))
            .toList();
      this._plantlist = data["records"][0]["moisture"]
          .entries
          .map<Plant>((entry) => Plant(entry.key, entry.value))
          .toList();
    }
  }
  @override
  String toString() {
    return '==============================[Parsed All data]==============================\n${super.toString()}\n\n';
  }
}

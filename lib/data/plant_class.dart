import 'package:soif/data/environment_data.dart';

/*
* Plant Class
* This class contains the 24 hr values of moisture of a plant in any day
*/

class Plant {
  static const double _moreThanNormal = 0.75;
  static const double _critMoisture = 0.35;
  String _name;
  Moisture _moisture;
  Plant(this._name, List<dynamic> values) {
    this._moisture = Moisture()
      ..setAllValues =
          values.map<num>((v) => double.parse(v.toString())).toList();
  }
  Plant.latest(this._name, num value) {
    this._moisture = Moisture.latest()..setLatestValue = value;
  }

  String get name => this._name;
  Moisture get moisture => this._moisture;

  bool isCritical([double check]) {
    check = check ?? this._moisture.lastValue;
    return (check <= _critMoisture);
  }

  bool isMoreThanNormal([double check]) {
    check = check ?? this._moisture.lastValue;
    return (check >= _moreThanNormal);
  }

  @override
  String toString() {
    return '${this._name} => ${this._moisture}';
  }
}

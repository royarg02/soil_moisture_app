// /*
// * Plant Class
// * This class contains the 24 hr values of moisture of a plant in any day
// */
// class Plant {
//   // * Plant name
//   String _label = 'Plant';

//   // * List containing the values of moisture for every hour
//   List<num> _values;

//   // * Moisture of last hour/ latest hour
//   num _latestVal;

//   // * Unit to be displayed alongside the value
//   final String _unit = '%';

//   // * Moisture percentage above which the plant is assumed to have sufficient moisture
//   final double _moreThanNormal = 0.75;
//   // * Moisture percentage below which the plant is assumed to have low moisture
//   final double _critMoisture = 0.35;

//   // * Determines if 'this' plant (or any given moisture value) is low or not
//   bool isCritical([double check]) {
//     check = check ?? this.getLastValue;
//     return (check <= _critMoisture);
//   }

//   // * Determines if 'this' plant (or any given moisture value) is sufficient or not
//   bool isMoreThanNormal([double check]) {
//     check = check ?? this.getLastValue;
//     return (check >= _moreThanNormal);
//   }

//   Plant(this._values);

//   // * Creates object with all values given(used in fetching total data)
//   Plant.createElement(this._label, this._values);

//   // * Creates object with only the latest value given(used in fetching current data)
//   Plant.createLatest(this._label, this._latestVal);

//   String get getLabel => _label;
//   List<num> get getAllValues => _values;
//   num get getLastValue => (this._values == null) ? _latestVal : _values.last;
//   String get getUnit => this._unit;
// }

// // * Create a list of plant objects from a single json object depicting current data
// List<Plant> nowListFromJson(Map<String, dynamic> jsonData) {
//   List<Plant> temp = [];
//   jsonData.forEach((k, v) {
//     temp.add(Plant.createLatest(k, double.parse(v.toString())));
//   });
//   return temp;
// }

// // * Create a list of plant objects from a single json object depicting total data
// List<Plant> totalListFromJson(Map<String, dynamic> jsonData) {
//   List<Plant> temp = [];
//   jsonData.forEach((k, v) {
//     temp.add(Plant.createElement(k, v.cast<num>()));
//   });
//   return temp;
// }

import 'package:soif/data/environment_data.dart';

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

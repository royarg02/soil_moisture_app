/*
* Humidity Class
* This class contains the 24 hr values of the humidity of any day
*/
class Humidity {
  // * List containing the values of humidity for every hour
  List<num> _values;

  // * Humidity of last hour/ latest hour
  num _latestVal;

  // * Unit to be displayed alongside the value
  final String _unit = '%';

  Humidity() {
    this._values = [];
  }

  /* 
  * Creates object from a Map given (used in fetching total data)
  * .cast<num>() casts each of the values to the respective num datatype
  */
  Humidity.fromJson(Map<String, dynamic> data) {
    this._values = data['humidity'].cast<num>();
  }

  // * Creates object with only the latest value given(used in fetching current data)
  Humidity.createLatest(this._latestVal);

  List<num> get getAllValues => _values;
  num get getLastValue => (_values == null) ? this._latestVal : _values.last;
  String get getUnit => this._unit;
}

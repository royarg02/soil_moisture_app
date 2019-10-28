/*
* Temp(temperature) Class
* This class contains the 24 hr values of the temperature of any day
*/
class Temp {
  // * List containing the values of temperature for every hour
  List<num> _values;

  // * Temperature of last hour/ latest hour
  num _latestVal;

  // * Unit to be displayed alongside the value
  final String _unit = '°C';

  Temp() {
    this._values = [];
  }

  /* 
  * Creates object from a Map given (used in fetching total data)
  * .cast<num>() casts each of the values to the respective num datatype
  */
  Temp.fromJson(Map<String, dynamic> data) {
    this._values = data['temparature'].cast<num>();
  }

  // * Creates object with only the latest value given(used in fetching current data)
  Temp.createLatest(this._latestVal);

  List<num> get getAllValues => _values;
  num get getLastValue => (_values == null) ? this._latestVal : _values.last;
  String get getUnit => _unit;
}

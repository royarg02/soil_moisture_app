/*
* Light Class
* This class contains the 24 hr values of the lumination of any day
*/
class Light {
  // * List containing the values of lumination for every hour
  List<num> _values;

  // * Lumination of last hour/ latest hour
  num _latestVal;

  // * Unit to be displayed alongside the value
  final String _unit = 'Lux';

  Light() {
    this._values = [];
  }

  /* 
  * Creates object from a Map given (used in fetching total data)
  * .cast<num>() casts each of the values to the respective num datatype
  */
  Light.fromJson(Map<String, dynamic> data) {
    this._values = data['light'].cast<num>();
  }

  // * Creates object with only the latest value given(used in fetching current data)
  Light.createLatest(this._latestVal);

  List<num> get getAllValues => _values;
  num get getLastValue =>
      (this._values == null) ? this._latestVal : this._values.last;
  String get getUnit => this._unit;
}

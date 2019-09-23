class Temp {
  List<num> _values;
  num _latestVal;
  final String _unit = '°C';

  Temp() {
    this._values = [];
  }
  Temp.fromJson(Map<String, dynamic> data) {
    this._values = data['temparature'].cast<num>();
  }
  Temp.createLatest(this._latestVal);

  List<num> get getAllValues => _values;
  num get getLastValue => (_values == null) ? this._latestVal : _values.last;
  String get getUnit => _unit;
}

class Humidity {
  List<num> _values;
  num _latestVal;
  final String _unit = '%';
  Humidity() {
    this._values = [];
  }
  Humidity.fromJson(Map<String, dynamic> data) {
    this._values = data['humidity'].cast<num>();
  }

  Humidity.createLatest(this._latestVal);

  List<num> get getAllValues => _values;
  num get getLastValue => (_values == null) ? this._latestVal : _values.last;
  String get getUnit => this._unit;
}

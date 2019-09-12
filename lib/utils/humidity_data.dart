class Humidity {
  List<num> _values;
  num _lastVal;
  String _unit = '%';
  Humidity() {
    this._values = [];
  }
  Humidity.fromJson(Map<String, dynamic> data) {
    this._values = data['humidity'].cast<num>();
  }

  Humidity.addLatest(num data) {
    this._lastVal = data;
  }

  List<num> get getAllValues => _values;
  num get getLastValue => (_values == null) ? _lastVal : _values.last;
  String get getUnit => _unit;
}

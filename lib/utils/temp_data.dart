class Temp {
  List<num> _values;
  num _lastVal;
  String _unit = '°C';
  Temp() {
    this._values = [];
  }
  Temp.fromJson(Map<String, dynamic> data) {
    this._values = data['temparature'].cast<num>();
  }

  Temp.addLatest(num data) {
    this._lastVal = data;
  }

  List<num> get getAllValues => _values;
  num get getLastValue => (_values == null) ? _lastVal : _values.last;
  String get getUnit => _unit;
}

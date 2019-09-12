class Light {
  List<num> _values;
  num _lastVal;
  String _unit = 'Lux';
  Light() {
    this._values = [];
  }

  Light.fromJson(Map<String, dynamic> data) {
    this._values = data['light'].cast<num>();
  }

  Light.addLatest(num data) {
    this._lastVal = data;
  }

  List<num> get getAllValues => _values;
  num get getLastValue => (_values == null) ? _lastVal : _values.last;
  String get getUnit => _unit;
}

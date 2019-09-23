class Light {
  List<num> _values;
  num _latestVal;

  final String _unit = 'Lux';

  Light() {
    this._values = [];
  }

  Light.fromJson(Map<String, dynamic> data) {
    this._values = data['light'].cast<num>();
  }
  Light.createLatest(this._latestVal);

  List<num> get getAllValues => _values;
  num get getLastValue =>
      (this._values == null) ? this._latestVal : this._values.last;
  String get getUnit => this._unit;
}

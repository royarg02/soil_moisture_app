class Light {
  List<num> _values;
  String _unit = 'Lux';
  Light() {
    this._values = [];
  }

  Light.fromJson(Map<String, dynamic> data) {
    this._values = data['light'].cast<num>();
  }

  List<num> get getAllValues => _values;
  num get getLastValue => _values.last;
  String get getUnit => _unit;
}

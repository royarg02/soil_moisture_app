class Humidity {
  List<num> _values;
  String _unit = '%';
  Humidity() {
    this._values = [];
  }
  Humidity.fromJson(Map<String, dynamic> data) {
    this._values = data['humidity'].cast<num>();
  }

  List<num> get getAllValues => _values;
  num get getLastValue => _values.last;
  String get getUnit => _unit;
}

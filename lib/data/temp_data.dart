class Temp {
  List<num> _values;
  String _unit = '°C';
  Temp() {
    this._values = [];
  }
  Temp.fromJson(Map<String, dynamic> data) {
    this._values = data['temparature'].cast<num>();
  }

  List<num> get getAllValues => _values;
  num get getLastValue => _values.last;
  String get getUnit => _unit;
}

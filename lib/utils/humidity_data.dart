class Humidity {
  List<dynamic> _values;
  Humidity() {
    this._values = [];
  }
  Humidity.fromJson(Map<String, dynamic> data) {
    this._values = data['humidity'];
  }

  List<dynamic> get getHumidity => _values;
}

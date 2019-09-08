class Humidity {
  List<dynamic> _values;
  dynamic _lastVal;
  Humidity() {
    this._values = [];
  }
  Humidity.fromJson(Map<String, dynamic> data) {
    this._values = data['humidity'];
  }

  Humidity.addLatest(dynamic data){
    this._lastVal = data;
  }

  List<dynamic> get getHumidity => _values;
  dynamic get getLastHumidity => (_values == null)? _lastVal: _values.last;
}

class Light{
  List<dynamic> _values;
  dynamic _lastVal;
  Light(){
    this._values = [];
  }
  Light.fromJson(Map<String,dynamic> data){
    this._values = data['light'];
  }
  Light.addLatest(dynamic data){
    this._lastVal = data;
  }
  
  List<dynamic> get getLight => _values;
  dynamic get getLastLight => (_values == null)? _lastVal: _values.last;
}
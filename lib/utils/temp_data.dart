class Temp{
  List<dynamic> _values;
  dynamic _lastVal;
  Temp(){
    this._values = [];
  }
  Temp.fromJson(Map<String,dynamic> data){
    this._values = data['temparature'];
  }

  Temp.addLatest(dynamic data){
    this._lastVal = data;
  }
  
  List<dynamic> get getTemp => _values;
  dynamic get getLastTemp => (_values == null)? _lastVal: _values.last;
}
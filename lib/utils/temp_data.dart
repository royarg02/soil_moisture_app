class Temp{
  List<dynamic> _values;
  Temp(){
    this._values = [];
  }
  Temp.fromJson(Map<String,dynamic> data){
    this._values = data['temparature'];
  }
  
  List<int> get getTemp => _values;
}
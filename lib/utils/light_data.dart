class Light{
  List<dynamic> _values;
  Light(){
    this._values = [];
  }
  Light.fromJson(Map<String,dynamic> data){
    this._values = data['light'];
  }
  
  List<double> get getLight => _values;
}
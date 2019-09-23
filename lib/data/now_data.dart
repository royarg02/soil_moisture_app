// * Contains the latest data to be used in Overview page

class DataNow{
  List<SmallPlant> latPlantList;
  num lastHumidity;
  num lastTemp;
  num lastLight;
  DataNow(){
    this.latPlantList = [];
  }
  void createElement(String label, num value){
    latPlantList.add(SmallPlant(label, value));
  }

  String getlabel(int position) => latPlantList[position]._label;
  num getLastMoisture(int position) => latPlantList[position]._lastMoisture;
}

class SmallPlant{
  final String _label;
  final num _lastMoisture;
  SmallPlant(this._label, this._lastMoisture);
}
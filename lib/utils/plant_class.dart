class Plant {
  String _label = 'Plant';
  List<dynamic> _values;
  double _critMoisture = 0.35;
  double _moreThanNormal = 0.75;
  String _imgAsset = '';

  Plant(this._values);
  Plant.createElement(this._label, this._values);

  bool isCritical([double check]) {
    check = (check == null)? this.getLastMoisture : check;
    return (check <= this._critMoisture);
  }

  bool isMoreThanNormal([double check]) {
    check = (check == null)? this.getLastMoisture : check;
    return (check >= this._moreThanNormal);
  }

  String get getLabel => _label;
  String get getImage => _imgAsset;
  List<dynamic> get getAllMoisture => _values;
  double get getLastMoisture => (_values.isEmpty)? 0.5 : _values.last;
}

class Plant {
  String _label = 'Plant';
  List<num> _values;
  double _critMoisture = 0.35;
  double _moreThanNormal = 0.75;
  num _lastVal;
  String _unit = '%';

  Plant(this._values);
  Plant.createElement(this._label, this._values);
  Plant.createWithLast(this._label, this._lastVal);

  bool isCritical([double check]) {
    check = check ?? this.getLastValue;
    return (check <= this._critMoisture);
  }

  bool isMoreThanNormal([double check]) {
    check = check ?? this.getLastValue;
    return (check >= this._moreThanNormal);
  }

  String get getLabel => _label;
  List<num> get getAllValues => _values;
  num get getLastValue => (_values == null) ? this._lastVal : _values.last;
  String get getUnit => _unit;
}

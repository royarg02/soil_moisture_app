class Plant {
  String _label = 'Plant';
  List<num> _values;
  num _latestVal;
  final String _unit = '%';

  final double _moreThanNormal = 0.75;
  final double _critMoisture = 0.35;

  bool isCritical([double check]) {
    check = check ?? this.getLastValue;
    return (check <= _critMoisture);
  }

  bool isMoreThanNormal([double check]) {
    check = check ?? this.getLastValue;
    return (check >= _moreThanNormal);
  }

  Plant(this._values);
  Plant.createElement(this._label, this._values);
  Plant.createLatest(this._label, this._latestVal);

  String get getLabel => _label;
  List<num> get getAllValues => _values;
  num get getLastValue => (this._values == null) ? _latestVal : _values.last;
  String get getUnit => this._unit;
}

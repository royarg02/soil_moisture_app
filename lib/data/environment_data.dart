abstract class EnvironmentData {
  static const INVALID_VALUE = -999; //for data fields not consisting of lists
  List<num> _values;
  num _latest;
  String _unit;

  set setAllValues(List<num> values) {
    this._values = values;
    this._latest = values.isEmpty ? INVALID_VALUE : values.last;
  }

  set setLatestValue(num value) {
    this._latest = value ?? INVALID_VALUE;
  }

  set setUnit(String unit) => this._unit = unit;

  List<num> get allValues => this._values;
  num get lastValue => this._latest;
  String get unit => this._unit;

  @override
  String toString() {
    return '${this._latest}${this._unit}: ${this._values}';
  }
}

class Moisture extends EnvironmentData {
  Moisture() {
    this._unit = '%';
  }

  Moisture.latest() {
    this._unit = '%';
    this._values = null;
  }
}

class Humidity extends EnvironmentData {
  Humidity() {
    this._unit = '%';
  }

  Humidity.latest() {
    this._unit = '%';
    this._values = null;
  }
}

class Temp extends EnvironmentData {
  Temp() {
    this._unit = '°C';
  }

  Temp.latest() {
    this._unit = '°C';
    this._values = null;
  }
}

class Light extends EnvironmentData {
  Light() {
    this._unit = 'Lx';
  }

  Light.latest() {
    this._unit = 'Lx';
    this._values = null;
  }
}

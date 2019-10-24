/*
* threshold_class
* This class stores the threshold set for pump controlling the moisture of each plant
*/

class Threshold {
  String _label;
  num _val;

  // * Creates object with data provided
  Threshold(int position, num value) {
    this._label = 'pump$position';
    // * For new entries which have not been included, defaults the value to 0.0
    this._val = value ?? 0.0;
  }

  get getLabel => this._label;
  get getVal => this._val;

  set setVal(num value) => this._val = value;
}

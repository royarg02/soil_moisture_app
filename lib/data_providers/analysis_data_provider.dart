import 'package:flutter/foundation.dart';

/// Contains the current values alongwith its unit to be displayed
/// in [AnalysisGraph].
class AnalysisDataProvider with ChangeNotifier {
  List<dynamic> data;
  String unit;

  AnalysisDataProvider();

  /// Initializes the provider given some data and its unit.
  void init(List<dynamic> newData, String unit) {
    data = newData;
    this.unit = unit;
  }

  /// Same as [AnalysisDataProvider.init] but notifies dependant widgets.
  void changeData(List<dynamic> newData, String unit) {
    data = newData;
    this.unit = unit;
    notifyListeners();
  }

  /// "Updates", which isn't saying much considering it only notifies dependant
  /// widgets. Used in conjunction with [SelectedCardState] as a [ProxyProvider].
  void update() {
    notifyListeners();
  }
}

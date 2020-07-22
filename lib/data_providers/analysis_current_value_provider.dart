import 'package:flutter/foundation.dart';

import 'package:soil_moisture_app/ui/analysis_graph.dart';
import 'package:soil_moisture_app/utils/date_func.dart';

/// Provides the current value selected in the [AnalysisGraph].
class AnalysisCurrentValueProvider with ChangeNotifier {
  DataPoint current;

  AnalysisCurrentValueProvider();

  /// Initailizes the provider, with a list of data values.
  /// 
  /// Calculates the current value taking the last value of the
  /// list.
  AnalysisCurrentValueProvider.init(List<dynamic> data)
      : current = DataPoint(
          DateTime(date.year, date.month, date.day, data.length - 1),
          data.last,
        );

  /// Updates the current value.
  /// 
  /// Used in conjunction with [DataProvider] as [ProxyProvider].
  void update(List<dynamic> data) {
    current = DataPoint(
      DateTime(date.year, date.month, date.day, data.length - 1),
      data.last,
    );
    notifyListeners();
  }

  /// Changes the currently selected value.
  changeValue(DataPoint current) {
    this.current = current;
    notifyListeners();
  }
}

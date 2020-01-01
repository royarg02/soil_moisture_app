import 'package:flutter/material.dart';
import 'package:soif/ui/refresh_snackbar.dart';
import 'package:soif/utils/date_func.dart';
import 'package:soif/utils/json_post_get.dart';

class AnalysisUiLoadingState with ChangeNotifier {
  Future<void> _refresh(BuildContext context) async {
    totData = fetchTotalData();
    await totData.then((_) {
      notifyListeners();
      Scaffold.of(context).removeCurrentSnackBar();
      Scaffold.of(context).showSnackBar(SuccessOnRefresh().build(context));
      if (isNow()) {
        latData = fetchLatestData();
      }
    }, onError: (_) {
      Scaffold.of(context).removeCurrentSnackBar();
      Scaffold.of(context).showSnackBar(FailureOnRefresh().build(context));
    });
  }

  AnalysisUiLoadingState();
  void refreshWithImmediateEffect(BuildContext context) {
    totData = this._refresh(context);
    notifyListeners();
  }

  Future<void> refreshWithEffectAfterDone(BuildContext context) {
    return this._refresh(context).then((_) {
      notifyListeners();
    });
  }
}

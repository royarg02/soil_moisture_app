/*
* display_error

* Widgets to be displayed upon unsuccessful/ empty fetching data from REST API.
*/

import 'package:flutter/material.dart';

// * utils import
import 'package:soil_moisture_app/utils/date_func.dart';
import 'package:soil_moisture_app/utils/sizes.dart';

// * No Latest Data Available upon Startup (due to actually no data or no internet)
class NoNowData extends StatelessWidget {
  final bool haveInternet;
  NoNowData({this.haveInternet = false});
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      children: [
        Container(
          padding: EdgeInsets.all(appWidth * 0.03),
          alignment: Alignment.center,
          child: Text(
            (this.haveInternet)
                ? 'No Data for $fetchNowDate'
                : 'Couldn\'t connect.\nCheck your internet connection and refresh.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.display1.copyWith(
                  fontSize: appWidth * 0.04,
                ),
          ),
        ),
      ],
    );
  }
}

// * No Data/ Empty Data
class NoData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(appWidth * 0.01),
      alignment: Alignment.center,
      child: Text(
        'No Data Found.\nRefresh to try again or choose another date.',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.display1.copyWith(
              fontSize: appWidth * 0.04,
            ),
      ),
    );
  }
}
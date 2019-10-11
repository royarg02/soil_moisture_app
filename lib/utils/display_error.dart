/*
* display_error

* Widgets to be displayed upon unsuccessful/ empty fetching data from REST API.
*/

import 'package:flutter/material.dart';

// * utils import
import 'package:soil_moisture_app/utils/date_func.dart';
import 'package:soil_moisture_app/utils/sizes.dart';

// * No Latest Data Available upon Startup (due to empty data or no internet)
class NoNowData extends StatelessWidget {
  final bool haveInternet;
  final bool isScrollable;
  NoNowData({this.isScrollable = true, this.haveInternet = false});
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: (isScrollable)
          ? AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics())
          : NeverScrollableScrollPhysics(),
      shrinkWrap: (haveInternet) ? true : false,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
              vertical: appWidth * 0.1, horizontal: appWidth * 0.01),
          alignment: Alignment.center,
          child: Text(
            (this.haveInternet)
                ? 'No Data for $fetchNowDate'
                : 'Couldn\'t connect to Internet.\nRefresh to try again.',
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

// * No Data/ Empty detailed Data
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

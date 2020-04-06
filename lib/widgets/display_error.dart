/*
* display_error

* Widgets to be displayed upon unsuccessful/ empty fetching data from REST API.
*/

import 'package:flutter/material.dart';

// * External packages import
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// * utils import
import 'package:soif/utils/date_func.dart';
import 'package:soif/utils/sizes.dart';

// * No Latest Data Available upon Startup (due to empty data or no internet)
class NoNowDataOrNoInternet extends StatelessWidget {
  final bool haveInternet;
  NoNowDataOrNoInternet({this.haveInternet = false});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: appWidth(context) * 0.1,
          horizontal: appWidth(context) * 0.01),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Icon(
            (this.haveInternet)
                ? FontAwesomeIcons.question
                : Icons.signal_cellular_connected_no_internet_4_bar,
            size: kToolbarHeight,
          ),
          Text(
            (this.haveInternet)
                ? 'No Data available for $fetchNowDate.'
                : 'Couldn\'t connect to Internet.\nRefresh to try again.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.display1.copyWith(
                  fontSize: appWidth(context) * 0.04,
                ),
          ),
        ],
      ),
    );
  }
}

// * No Data/ Empty detailed Data
class NoData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(appWidth(context) * 0.01),
      alignment: Alignment.center,
      child: Text(
        'No Data Found.\nRefresh to try again or choose another date.',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.display1.copyWith(
              fontSize: appWidth(context) * 0.04,
            ),
      ),
    );
  }
}

/*
* Overview

* The first page upon which the user lands on launching the app, this page displays
* the CURRENT DATA of moisture of all plants, humidity, lumination(light), and temperature
* depending upon the availability of such data at the REST API server.
*/

import 'package:flutter/material.dart';

// * external packages import
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

// * States import
import 'package:soif/states/selected_card_state.dart';
import 'package:soif/states/theme_state.dart';
import 'package:soif/ui/colors.dart';

// * utils import
import 'package:soif/utils/date_func.dart';
import 'package:soif/utils/display_error.dart';
import 'package:soif/utils/json_post_get.dart';
import 'package:soif/utils/sizes.dart';

// * Data import
import 'package:soif/data/all_data.dart';
import 'package:soif/data/plant_class.dart';

// * ui import
import 'package:soif/ui/loading_plant_grid_view.dart';
import 'package:soif/ui/plant_grid_view.dart';
import 'package:soif/ui/refresh_snackbar.dart';

class Overview extends StatefulWidget {
  @override
  _OverviewState createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  Future<void> _refresh() async {
    latData = fetchLatestData();
    await latData.then((_) {
      Scaffold.of(context).removeCurrentSnackBar();
      Scaffold.of(context).showSnackBar(SuccessOnRefresh().build(context));
      if (isNow()) {
        totData = fetchTotalData();
      }
    }, onError: (_) {
      Scaffold.of(context).removeCurrentSnackBar();
      Scaffold.of(context).showSnackBar(FailureOnRefresh().build(context));
    });
    setState(() {});
    // Debug Print
    if (isCurrentDataGot) {
      print('Overview refresh got: ${nowPlantList[0].getLastValue}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder(
          future: latData,
          builder: (context, AsyncSnapshot snapshot) {
            // Debug print
            print(snapshot);
            if (snapshot.hasError) {
              return NoNowData();
            } else if (snapshot.connectionState == ConnectionState.done) {
              // * async load threshold data
              threshData = threshData ?? fetchThresholdData();
              // * async load full data for Analysis
              totData = totData ?? fetchTotalData();
              return Page();
            } else {
              return Skeleton();
            }
          },
        ),
      ),
    );
  }
}

class Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      slivers: <Widget>[
        SliverAppBar(
          primary: true,
          forceElevated: false,
          pinned: true,
          floating: true,
          snap: true,
          title: Image.asset(
            (Provider.of<ThemeState>(context).isDarkTheme)
                ? './assets/images/Soif_sk_dark.png'
                : './assets/images/Soif_sk.png',
            height: appWidth(context) * 0.08,
          ),
          expandedHeight: appHeight(context) * 0.45,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: (nowPlantList.isNotEmpty)
                  // * would show only if today's data is available
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MoistureRadialIndicator(),
                        OtherInfoRow(),
                      ],
                    )
                  : SizedBox.shrink(),
            ),
          ),
        ),
        // Padding(
        //   padding: EdgeInsets.symmetric(vertical: appWidth(context) * 0.03),
        //   child: (nowPlantList.isNotEmpty)
        //       // * would show only if today's data is available
        //       ? MoistureRadialIndicator()
        //       : NoNowData(haveInternet: true),
        // ),

        // Container(
        //   height: appWidth(context) * 0.12,
        //   child: (isCurrentDataGot)
        //       ? Card(
        //           margin: EdgeInsets.symmetric(
        //               horizontal: appWidth(context) * 0.07),
        //           child: Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceAround,
        //             children: <Widget>[
        //               AvatarData(
        //                   'Current Humidity',
        //                   nowHumid.getLastValue,
        //                   nowHumid.getUnit,
        //                   FontAwesomeIcons.tint,
        //                   Colors.blue[300]),
        //               AvatarData(
        //                   'Current Illuminance',
        //                   nowLight.getLastValue,
        //                   nowLight.getUnit,
        //                   FontAwesomeIcons.lightbulb,
        //                   Colors.amber[400]),
        //               AvatarData(
        //                   'Current Temperature',
        //                   nowTemp.getLastValue,
        //                   nowTemp.getUnit,
        //                   FontAwesomeIcons.thermometerHalf,
        //                   Colors.red[400])
        //             ],
        //           ),
        //         )
        //       : SizedBox(),
        // ),
        // SizedBox(
        //   height: appWidth(context) * 0.02,
        // ),
        if (isCurrentDataGot)
          PlantGridView(
            plantlist: nowPlantList,
          ),
        // SizedBox(
        //   height: appWidth(context) * 0.03,
        // )
      ],
    );
  }
}

class OtherInfoRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        AvatarData('Current Humidity', nowHumid.getLastValue, nowHumid.getUnit,
            FontAwesomeIcons.tint, Colors.blue[300]),
        AvatarData('Current Illuminance', nowLight.getLastValue,
            nowLight.getUnit, FontAwesomeIcons.lightbulb, Colors.amber[400]),
        AvatarData('Current Temperature', nowTemp.getLastValue, nowTemp.getUnit,
            FontAwesomeIcons.thermometerHalf, Colors.red[400])
      ],
    );
  }
}

class MoistureRadialIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int _selCard = Provider.of<SelectedCardState>(context).selCard;
    Plant _selPlant = nowPlantList[_selCard];
    return CircularPercentIndicator(
      // addAutomaticKeepAlive: false,
      animationDuration: 600,
      radius: appWidth(context) * 0.55,
      animation: true,
      percent: _selPlant.getLastValue,
      circularStrokeCap: CircularStrokeCap.round,
      backgroundColor: (Provider.of<ThemeState>(context).isDarkTheme)
          ? darkAppProgressIndicatorBackgroundColor
          : appProgressIndicatorBackgroundColor,
      progressColor: (_selPlant.isCritical())
          ? criticalPlantColor
          : (_selPlant.isMoreThanNormal()
              ? moreThanNormalPlantColor
              : normalPlantColor),
      lineWidth: 6.0,
      footer: Text(
        'Current Moisture',
        style: Theme.of(context).textTheme.caption.copyWith(
              fontSize: appWidth(context) * 0.03,
            ),
        textAlign: TextAlign.center,
      ),
      center: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '${_selPlant.getLabel}',
            style: Theme.of(context).textTheme.body2.copyWith(
                  fontSize: appWidth(context) * 0.03,
                ),
            textAlign: TextAlign.center,
          ),
          RichText(
            text: TextSpan(
              text: '${(_selPlant.getLastValue * 100).toStringAsFixed(0)}',
              style: Theme.of(context).textTheme.display4.copyWith(
                    fontSize: appWidth(context) * 0.2,
                  ),
              children: [
                if (_selPlant.getLastValue < 0.99)
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    baseline: TextBaseline.alphabetic,
                    child: Text(
                      _selPlant.getUnit,
                      style: Theme.of(context)
                          .textTheme
                          .display4
                          .copyWith(fontSize: appWidth(context) * 0.1),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Skeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      slivers: <Widget>[
        SliverAppBar(
          primary: true,
          forceElevated: false,
          pinned: true,
          floating: true,
          snap: true,
          title: Image.asset(
            (Provider.of<ThemeState>(context).isDarkTheme)
                ? './assets/images/Soif_sk_dark.png'
                : './assets/images/Soif_sk.png',
            height: appWidth(context) * 0.08,
          ),
          expandedHeight: appHeight(context) * 0.45,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    child: SizedBox(
                      height: appWidth(context) * 0.55,
                      width: appWidth(context) * 0.55,
                      child: CircularProgressIndicator(
                        backgroundColor:
                            Provider.of<ThemeState>(context).isDarkTheme
                                ? darkAppProgressIndicatorBackgroundColor
                                : appProgressIndicatorBackgroundColor,
                        strokeWidth: 6.0,
                      ),
                    ),
                  ),
                  Text(
                    'Getting Data...',
                    style: Theme.of(context).textTheme.caption.copyWith(
                          fontSize: appWidth(context) * 0.03,
                        ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
        ),
        LoadingPlantGridView()
      ],
      // children: [
      //   Column(
      //     children: <Widget>[
      //       Center(
      //         child: SizedBox(
      //           height: appWidth(context) * 0.54,
      //           width: appWidth(context) * 0.54,
      //           child: CircularProgressIndicator(
      //             strokeWidth: 6.0,
      //           ),
      //         ),
      //       ),
      //       Padding(
      //         padding: const EdgeInsets.only(top: 6.0),
      //         child: Text(
      //           'Getting Data...',
      //           style: Theme.of(context).textTheme.caption.copyWith(
      //                 fontSize: appWidth(context) * 0.03,
      //               ),
      //           textAlign: TextAlign.center,
      //         ),
      //       )
      //     ],
      //   ),
      // ],
    );
    // return ListView(
    //   physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
    //   children: <Widget>[
    //     Container(
    //       height: 300.0,
    //       width: 300.0,
    //       padding: EdgeInsets.symmetric(vertical: appWidth(context) * 0.03),
    //       alignment: Alignment.center,
    //       child: CircularProgressIndicator(
    //         strokeWidth: 6.0,
    //       ),
    //     ),
    // Padding(
    //   child: SizedBox(
    //     height: appWidth(context) * 0.6,
    //     width: appWidth(context) * 0.6,
    //     child: CircularProgressIndicator(
    //       strokeWidth: 6.0,
    //     ),
    //   ),
    // child: CircularPercentIndicator(
    //   radius: appWidth(context) * 0.6,
    //   backgroundColor: (Provider.of<ThemeState>(context).isDarkTheme)
    //       ? darkAppProgressIndicatorBackgroundColor
    //       : appProgressIndicatorBackgroundColor,
    //   center: CircularProgressIndicator(),
    //   footer: SizedBox(
    //     height: appWidth(context) * 0.05,
    //   ),
    //   lineWidth: appWidth(context) * 0.02,
    // ),
    // ),
    // Container(
    //   height: appWidth(context) * 0.12,
    //   child: Card(
    //     margin: EdgeInsets.symmetric(horizontal: appWidth(context) * 0.07),
    //     child: Padding(
    //       padding: EdgeInsets.all(appWidth(context) * 0.055),
    //       child: LinearProgressIndicator(
    //         backgroundColor: (Provider.of<ThemeState>(context).isDarkTheme)
    //             ? darkAppProgressIndicatorBackgroundColor
    //             : appProgressIndicatorBackgroundColor,
    //       ),
    //     ),
    //   ),
    // )
//       ],
//     );
  }
}

class AvatarData extends StatelessWidget {
  final String _tooltipMsg;
  final num _value;
  final String _unit;
  final IconData _icon;
  final Color _bkgrndColor;
  AvatarData(
      this._tooltipMsg, this._value, this._unit, this._icon, this._bkgrndColor);
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: this._tooltipMsg,
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(appWidth(context) * 0.01),
            child: CircleAvatar(
              backgroundColor: this._bkgrndColor,
              child: Icon(
                this._icon,
                size: appWidth(context) * 0.05,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              radius: appWidth(context) * 0.035,
            ),
          ),
          Text(
            '${(this._value > 1000) ? (this._value ~/ 1000).toString() + 'K' : this._value} ${this._unit}',
            style: Theme.of(context)
                .textTheme
                .body2
                .copyWith(fontSize: appWidth(context) * 0.03),
          )
        ],
      ),
    );
  }
}

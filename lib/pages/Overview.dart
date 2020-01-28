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

// * ui import
import 'package:soif/ui/colors.dart';

// * utils import
import 'package:soif/utils/date_func.dart';
import 'package:soif/utils/json_post_get.dart';
import 'package:soif/utils/sizes.dart';

// * Data import
import 'package:soif/data/all_data.dart';
import 'package:soif/data/plant_class.dart';

// * widgets import
import 'package:soif/widgets/loading_plant_grid_view.dart';
import 'package:soif/widgets/soif_app_bar.dart';
import 'package:soif/widgets/display_error.dart';
import 'package:soif/widgets/plant_grid_view.dart';
import 'package:soif/widgets/refresh_snackbar.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: RefreshIndicator(
        onRefresh: _refresh,
        displacement: 40.0 + MediaQuery.of(context).padding.top,
        child: FutureBuilder(
          future: latData,
          builder: (context, AsyncSnapshot snapshot) {
            // Debug print
            print(snapshot);
            if (snapshot.hasError && nowData == null) {
              return _ErrorPage();
            } else if (snapshot.connectionState == ConnectionState.done) {
              // * async load threshold data
              threshData = threshData ?? fetchThresholdData();
              // * async load full data for Analysis
              totData = totData ?? fetchTotalData();
              return _Page();
            } else {
              return _Skeleton();
            }
          },
        ),
      ),
    );
  }
}

class _ErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      slivers: <Widget>[
        SoifAppBar(
          backgroundWidget: NoNowDataOrNoInternet(),
        ),
        LoadingPlantGridView(animation: false),
      ],
    );
  }
}

class _Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      slivers: <Widget>[
        SoifAppBar(
          backgroundWidget: (nowData.plantList.isNotEmpty)
              // * would show only if today's data is available
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: MoistureRadialIndicator(),
                    ),
                    OtherInfoRow(),
                  ],
                )
              : NoNowDataOrNoInternet(haveInternet: true), //No,
        ),
        PlantGridView(
          plantlist: nowData.plantList,
        ),
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
        AvatarData('Current Humidity', nowData.humidity.lastValue,
            nowData.humidity.unit, FontAwesomeIcons.tint, Colors.blue[300]),
        AvatarData('Current Illuminance', nowData.light.lastValue,
            nowData.light.unit, FontAwesomeIcons.lightbulb, Colors.amber[400]),
        AvatarData(
            'Current Temperature',
            nowData.temp.lastValue,
            nowData.temp.unit,
            FontAwesomeIcons.thermometerHalf,
            Colors.red[400])
      ],
    );
  }
}

class MoistureRadialIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int _selCard = Provider.of<SelectedCardState>(context).selCard;
    Plant _selPlant = nowData.plantList[_selCard];
    return CircularPercentIndicator(
      animationDuration: 600,
      radius: appWidth(context) * 0.55,
      animation: true,
      animateFromLastPercent: true,
      percent: _selPlant.moisture.lastValue,
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
            '${_selPlant.name}',
            style: Theme.of(context).textTheme.body2.copyWith(
                  fontSize: appWidth(context) * 0.03,
                ),
            textAlign: TextAlign.center,
          ),
          RichText(
            text: TextSpan(
              text:
                  '${(_selPlant.moisture.lastValue * 100).toStringAsFixed(0)}',
              style: Theme.of(context).textTheme.display4.copyWith(
                    fontSize: appWidth(context) * 0.2,
                  ),
              children: [
                if (_selPlant.moisture.lastValue < 0.99)
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    baseline: TextBaseline.alphabetic,
                    child: Text(
                      _selPlant.moisture.unit,
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

class _Skeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      slivers: <Widget>[
        SoifAppBar(
          backgroundWidget: Column(
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
        LoadingPlantGridView()
      ],
    );
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

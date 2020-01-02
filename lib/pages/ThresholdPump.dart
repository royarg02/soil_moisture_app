/*
* ThresholdPump (Pump Threshold Control)

* This page provides the controls to set the threshold of the pumps which in turn, control the
* availability of water and moisture of the plant.
* The availability of current data from overview determines the presence of any new entry for
* controlling the threshold, in case the API for storing threshold values has not been updated
* to include the new entry.
* 'Setting' the values saves the values to be posted to API and can be instantly obtained(GET from API)
* next time this page is brought up.
*/

import 'package:flutter/material.dart';

// * Externa Packages Import
import 'package:provider/provider.dart';

// * State Import
import 'package:soif/states/theme_state.dart';
import 'package:soif/ui/refresh_snackbar.dart';

// * ui import
import 'package:soif/ui/threshold_slider.dart';
import 'package:soif/ui/colors.dart';
import 'package:soif/utils/date_func.dart';

// * utils import
import 'package:soif/utils/json_post_get.dart';
import 'package:soif/utils/display_error.dart';
import 'package:soif/utils/loading_plant_card_animation.dart';
import 'package:soif/utils/sizes.dart';

// * data import
import 'package:soif/data/all_data.dart';

class ThresholdPump extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Provider.of<ThemeState>(context).isDarkTheme
            ? Brightness.dark
            : Brightness.light,
        leading: BackButton(),
        title: Text(
          'Pump threshold Control',
          style: Theme.of(context).textTheme.title.copyWith(
                fontSize: appWidth(context) * 0.055,
              ),
        ),
        centerTitle: true,
      ),
      body: ThresholdPumpBody(),
    );
  }
}

class ThresholdPumpBody extends StatefulWidget {
  @override
  _ThresholdPumpBodyState createState() => _ThresholdPumpBodyState();
}

class _ThresholdPumpBodyState extends State<ThresholdPumpBody> {
  Future<void> _refresh() async {
    threshData = fetchThresholdData();
    await threshData.then((_) {
      latData = fetchLatestData();

      Scaffold.of(context).removeCurrentSnackBar();
      Scaffold.of(context).showSnackBar(SuccessOnRefresh().build(context));
      if (isNow()) {
        totData = fetchTotalData();
      }
    }, onError: (_) {
      Scaffold.of(context).removeCurrentSnackBar();
      Scaffold.of(context).showSnackBar(FailureOnRefresh().build(context));
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _refresh().then((_) {
        setState(() {});
      }),
      child: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: appWidth(context) * 0.03),
        child: Stack(
          children: <Widget>[
            FutureBuilder(
              future: threshData,
              builder: (context, AsyncSnapshot snapshot) {
                // Debug print
                print(snapshot);
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _Skeleton();
                } else if (pumpList != null) {
                  return _Page();
                } else {
                  return _Error();
                }
              },
            ),
            Align(
              alignment: Alignment(0.0, 0.9),
              child: FutureBuilder(
                future: threshData,
                builder: (context, AsyncSnapshot snapshot) {
                  if (pumpList == null) {
                    return SizedBox.shrink();
                  } else {
                    return ThresholdSetButton();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Error extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      children: [
        NoNowDataOrNoInternet(),
      ],
    );
  }
}

class _Page extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<_Page> {
  void _setThreshold({int position, num value}) {
    setState(() {
      pumpList[position].setVal = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return (pumpList.length != 0)
        ? ListView.builder(
            physics:
                AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            itemCount: pumpList.length,
            itemBuilder: (context, position) {
              return ThresholdSlider(
                label: pumpList[position].getLabel,
                threshold: pumpList[position].getVal,
                position: position,
                thresholdChanger: _setThreshold,
              );
            })
        : NoNowDataOrNoInternet(haveInternet: true);
  }
}

class ThresholdSetButton extends StatefulWidget {
  @override
  _ThresholdSetButtonState createState() => _ThresholdSetButtonState();
}

class _ThresholdSetButtonState extends State<ThresholdSetButton> {
  Map<String, dynamic> postData;
  Map<String, dynamic> status;
  bool _isLoading;

  void initState() {
    _isLoading = false;
    super.initState();
  }

  void _postThreshold() async {
    setState(() {
      _isLoading = true;
    });
    postData = Map.fromIterable(pumpList,
        key: (item) => item.getLabel, value: (item) => item.getVal);
    status = await postThreshold(postData);
    if (status['success']) {
      _showStatus(context, 'Threshold successfully set.');
    } else {
      _showStatus(context, 'Error Occurred');
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _showStatus(BuildContext context, String status) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Threshold Set Status',
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              FlatButton(
                color: (Provider.of<ThemeState>(context).isDarkTheme)
                    ? Theme.of(context).accentColor
                    : appSecondaryDarkColor,
                textTheme: ButtonTextTheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                      Radius.circular(appWidth(context) * 0.1)),
                ),
                child: Text(
                  'OK',
                  style: Theme.of(context).accentTextTheme.button,
                ),
                onPressed: () => Navigator.of(context).pop(),
                padding: EdgeInsets.all(appWidth(context) * 0.02),
              )
            ],
            content: Text(status),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: (pumpList.length != 0),
      child: FloatingActionButton.extended(
        label: (_isLoading)
            ? CircularProgressIndicator(
                backgroundColor: Theme.of(context).cardColor,
              )
            : Text(
                'Set',
                style: Theme.of(context).textTheme.button.copyWith(
                      color: Theme.of(context).cardColor,
                      fontSize: appWidth(context) * 0.04,
                    ),
              ),
        onPressed: (_isLoading) ? null : _postThreshold,
      ),
    );
  }
}

class _Skeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      itemCount: 2,
      itemBuilder: (context, position) {
        return Container(
          margin: EdgeInsets.only(top: appWidth(context) * 0.03),
          child: ConstrainedBox(
            constraints: BoxConstraints.expand(height: 52),
            child: DiagonallyLoadingAnimation(),
          ),
        );
      },
    );
  }
}

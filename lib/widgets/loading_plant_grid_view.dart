import 'package:flutter/material.dart';

// * Utils import
import 'package:soif/utils/sizes.dart';

// * widgets import
import 'package:soif/widgets/animated_loading_card.dart';

class LoadingPlantGridView extends StatelessWidget {
  final bool animation;
  LoadingPlantGridView({this.animation = true});
  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(
        appWidth(context) * 0.03,
        0.0,
        appWidth(context) * 0.03,
        appWidth(context) * 0.03,
      ),
      sliver: SliverGrid.count(
        crossAxisCount:
            (appWidth(context) < 600 && isPortrait(context)) ? 3 : 5,
        crossAxisSpacing: appWidth(context) * 0.005,
        mainAxisSpacing: appWidth(context) * 0.005,
        children: (this.animation)
            ? <Widget>[
                AnimatedLoadingCard(),
                AnimatedLoadingCard(),
              ]
            : <Widget>[
                Card(color: Colors.grey),
                Card(color: Colors.grey),
              ],
      ),
    );
  }
}

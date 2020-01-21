import 'package:flutter/material.dart';

// * Utils import
import 'package:soif/utils/loading_plant_card_animation.dart';
import 'package:soif/utils/sizes.dart';

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
                DiagonallyLoadingAnimation(),
                DiagonallyLoadingAnimation(),
              ]
            : <Widget>[
                Card(color: Colors.grey),
                Card(color: Colors.grey),
              ],
      ),
    );
  }
}

class LoadingCard extends AnimatedWidget {
  LoadingCard({Key key, Animation animation})
      : super(key: key, listenable: animation);
  @override
  Widget build(BuildContext context) {
    Animation _animation = listenable;
    return Container(
      margin: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(4.0)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey,
            Colors.grey[300],
            Colors.grey,
          ],
          stops: [
            _animation.value,
            (_animation.value + 0.15) % 1.0,
            (_animation.value + 0.3) % 1.0
          ],
        ),
      ),
    );
  }
}

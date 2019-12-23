import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

// * ui import
import 'package:soil_moisture_app/ui/loading_plant_grid_view.dart';

class LoadingPlantCardAnimation extends StatefulWidget {
  @override
  LoadingPlantCardAnimationState createState() => LoadingPlantCardAnimationState();
}

class LoadingPlantCardAnimationState extends State<LoadingPlantCardAnimation>
    with SingleTickerProviderStateMixin {
  Animation _animation;
  AnimationController _controller;
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.repeat();
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return LoadingPlantCard(animation: _animation);
  }
}

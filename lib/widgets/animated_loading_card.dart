import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

// * widgets import
import 'package:soif/widgets/loading_card.dart';

class AnimatedLoadingCard extends StatefulWidget {
  @override
  AnimatedLoadingCardState createState() => AnimatedLoadingCardState();
}

class AnimatedLoadingCardState extends State<AnimatedLoadingCard>
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
    return LoadingCard(animation: _animation);
  }
}

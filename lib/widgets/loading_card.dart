import 'package:flutter/material.dart';

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

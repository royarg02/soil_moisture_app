/*
 * Custom Tab Indicator
 * 
 * Implements the custom made tab indicator.
 */

import 'package:flutter/material.dart';

class RoundedRectTabIndicator extends Decoration {
  final Color color;
  final double width;
  final double radius;
  RoundedRectTabIndicator({this.color, this.width, this.radius});
  @override
  BoxPainter createBoxPainter([onChanged]) {
    return _BoxPainter(this, onChanged, this.color, this.width, this.radius);
  }
}

class _BoxPainter extends BoxPainter {
  final Color color;
  final double width;
  double radius;
  final RoundedRectTabIndicator decoration;
  _BoxPainter(this.decoration, VoidCallback onChanged, this.color, this.width,
      this.radius)
      : assert(decoration != null),
        super(onChanged) {
    radius ??= 56.0; // Value conforming to Material Guidelines
  }

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final paint = Paint()
      ..color = this.color
      ..strokeWidth = this.width
      ..style = PaintingStyle.stroke;
    final Rect rect = Offset(offset.dx, (configuration.size.height / 5)) &
        Size(configuration.size.width, 26.0);
    canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(this.radius)), paint);
  }
}

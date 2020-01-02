import 'package:flutter/material.dart';

class CustomSliderThumbShape extends SliderComponentShape {
  final double thumbRadius;

  const CustomSliderThumbShape({
    this.thumbRadius = 6.0,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    Animation<double> activationAnimation,
    Animation<double> enableAnimation,
    bool isDiscrete,
    TextPainter labelPainter,
    RenderBox parentBox,
    SliderThemeData sliderTheme,
    TextDirection textDirection,
    double value,
  }) {
    final Canvas canvas = context.canvas;

    final rect = Rect.fromCircle(center: center, radius: thumbRadius);

    final rrect = RRect.fromRectAndRadius(
      Rect.fromPoints(
        Offset(rect.left - 3, rect.top),
        Offset(rect.right + 3, rect.bottom),
      ),
      Radius.circular(2 * thumbRadius),
    );

    final fillPaint = Paint()
      ..color = sliderTheme.activeTrackColor
      ..style = PaintingStyle.fill;

    canvas.drawRRect(rrect, fillPaint);
  }
}

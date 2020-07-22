import 'dart:math' show Rectangle;

import 'package:charts_flutter/flutter.dart';

class CustomCircleSymbolRenderer extends CircleSymbolRenderer {
  final Color fillColor;
  final Color strokeColor;
  double strokeWidth;
  CustomCircleSymbolRenderer({
    this.fillColor,
    this.strokeColor,
    this.strokeWidth,
  });
  @override
  void paint(
    ChartCanvas canvas,
    Rectangle<num> bounds, {
    List<int> dashPattern,
    Color fillColor,
    FillPatternType fillPattern,
    Color strokeColor,
    double strokeWidthPx,
  }) {
    super.paint(
      canvas,
      bounds,
      dashPattern: dashPattern,
      fillColor: this.fillColor,
      fillPattern: fillPattern,
      strokeColor: this.strokeColor,
      strokeWidthPx: this.strokeWidth,
    );
  }
}

/*
* analyis_graph

* The graph which is displayed at the Analysis page.
* This graph has zoom, pan and tooltip features.
*/

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math'; // * For max() and min()

// * External packages import
import 'package:syncfusion_flutter_charts/charts.dart';

// * utils Import
import 'package:soil_moisture_app/utils/sizes.dart';
import 'package:soil_moisture_app/utils/date_func.dart';

// * This function defines the behaviour and formatting of the chart
SfCartesianChart displayChart(
    dynamic chartObj, String graph, BuildContext context) {
  num dataMinValue = chartObj.getAllValues.reduce((num a, num b) => min(a, b));
  num dataMaxValue = chartObj.getAllValues.reduce((num a, num b) => max(a, b));
  return SfCartesianChart(
    zoomPanBehavior: ZoomPanBehavior(
      enablePinching: true,
      enablePanning: true,
      zoomMode: ZoomMode.x,
    ),
    plotAreaBorderWidth: 0,
    primaryXAxis: DateTimeAxis(
      minimum: DateTime(date.year, date.month, date.day, 0),
      maximum: DateTime(date.year, date.month, date.day, 23),
      axisLine: AxisLine(width: 1),
      interval: 3,
      dateFormat: DateFormat.jm(),
      majorGridLines: MajorGridLines(width: 1),
      labelStyle: ChartTextStyle(
        fontFamily: 'Ocrb',
        fontSize: appWidth(context) * 0.027,
      ),
    ),
    primaryYAxis: NumericAxis(
      minimum: (dataMinValue < 0) ? dataMinValue - 100.0 : 0,
      maximum: (dataMaxValue > 100) ? dataMaxValue + 100.0 : 100,
      interval: 20,
      axisLine: AxisLine(width: 1),
      labelFormat: '{value}${chartObj.getUnit}',
      isVisible: true,
      labelStyle: ChartTextStyle(
        fontSize: appWidth(context) * 0.027,
        fontFamily: 'Ocrb',
      ),
    ),
    series: getLineSeries(chartObj.getAllValues, graph, context),
    tooltipBehavior: TooltipBehavior(
      enable: true,
      animationDuration: 200,
      canShowMarker: false,
      header: '',
    ),
  );
}

// * This function returns the series(List) to be displayed in the graph
// * The graph displays mapped x and y values from Class defined below
List<LineSeries<dynamic, DateTime>> getLineSeries(
    List<dynamic> chartData, String graph, BuildContext context) {
  // Debug Print
  print(chartData);
  List<_ChartData> data = [];
  for (var i = 0; i < chartData.length; ++i) {
    data.add(
        _ChartData(chartData[i], DateTime(date.year, date.month, date.day, i)));
  }
  return <LineSeries<_ChartData, DateTime>>[
    LineSeries<_ChartData, DateTime>(
      enableTooltip: true,
      animationDuration: 150,
      dataSource: data,
      xValueMapper: (point, _) => point.index,
      yValueMapper: (point, _) {
        return (graph == 'Moisture') ? point.value * 100 : point.value;
      },
      pointColorMapper: (x, _) => Theme.of(context).accentColor,
      width: 2,
      markerSettings: MarkerSettings(
        isVisible: true,
        color: Theme.of(context).cardColor,
        height: appWidth(context) * 0.015,
        width: appWidth(context) * 0.015,
      ),
    ),
  ];
}

// * Class for mapping x and y values for the Graph
class _ChartData {
  dynamic value;
  DateTime index;
  _ChartData(this.value, this.index);
}

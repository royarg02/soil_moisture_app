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

// * ui import
import 'package:soil_moisture_app/ui/colors.dart';

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
      axisLine: AxisLine(width: 1),
      interval: 3,
      dateFormat: DateFormat.jm(),
      majorGridLines: MajorGridLines(width: 1),
      labelStyle: ChartTextStyle(
        fontFamily: 'Ocrb',
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
    // * Datetime provided here is arbitary, actually the hour is required
    data.add(_ChartData(chartData[i], DateTime(2019, 09, 05, i)));
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
      pointColorMapper: (x, _) => appSecondaryColor,
      width: 2,
      markerSettings: MarkerSettings(
        isVisible: true,
        color: appPrimaryLightColor,
        height: MediaQuery.of(context).size.width * 0.015,
        width: MediaQuery.of(context).size.width * 0.015,
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

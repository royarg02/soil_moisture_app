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

// * Data import
import 'package:soif/data/environment_data.dart';

// * utils Import
import 'package:soif/utils/sizes.dart';
import 'package:soif/utils/date_func.dart';

// * This function defines the behaviour and formatting of the chart
SfCartesianChart displayChart(
    EnvironmentData chartObj, String graph, BuildContext context) {
  num dataMinValue = chartObj.allValues.reduce((num a, num b) => min(a, b));
  num dataMaxValue = chartObj.allValues.reduce((num a, num b) => max(a, b));
  double minYAxisValue = (dataMinValue < 0.0) ? dataMinValue - 50.0 : 0.0;
  double maxYAxisValue = (dataMaxValue > 100.0) ? dataMaxValue + 50.0 : 100.0;
  return SfCartesianChart(
    margin: EdgeInsets.all(4.0),
    zoomPanBehavior: ZoomPanBehavior(
      enablePinching: true,
      enablePanning: true,
      zoomMode: ZoomMode.x,
    ),
    plotAreaBorderWidth: 0,
    primaryXAxis: DateTimeAxis(
      intervalType: DateTimeIntervalType.hours,
      minimum: DateTime(date.year, date.month, date.day, 0),
      maximum: DateTime(date.year, date.month, date.day, 23),
      axisLine: AxisLine(width: 1, color: Theme.of(context).accentColor),
      interval: 3,
      majorGridLines: MajorGridLines(width: 0.0),
      dateFormat: DateFormat('ha'),
      labelStyle: ChartTextStyle(
        fontFamily: 'Ocrb',
        fontSize: appWidth(context) * 0.023,
      ),
    ),
    primaryYAxis: NumericAxis(
      minimum: minYAxisValue,
      maximum: maxYAxisValue,
      interval:
          (((maxYAxisValue - minYAxisValue) / 100) * 20).round().toDouble(),
      axisLine: AxisLine(width: 0.0),
      labelFormat: '{value}${chartObj.unit}',
      isVisible: true,
      labelStyle: ChartTextStyle(
        fontSize: appWidth(context) * 0.023,
        fontFamily: 'Ocrb',
      ),
    ),
    series: getLineSeries(chartObj.allValues, graph, context),
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
List<LineSeries<_ChartData, DateTime>> getLineSeries(
    List<num> allValues, String graph, BuildContext context) {
  List<_ChartData> data = Iterable<_ChartData>.generate(
      allValues.length,
      (i) => _ChartData(
          allValues[i], DateTime(date.year, date.month, date.day, i))).toList();

  // for (var i = 0; i < allValues.length; ++i) {
  //   data.add(
  //       _ChartData(allValues[i], DateTime(date.year, date.month, date.day, i)));
  // }
  return <LineSeries<_ChartData, DateTime>>[
    LineSeries<_ChartData, DateTime>(
      enableTooltip: true,
      animationDuration: 150,
      dataSource: data,
      xValueMapper: (point, _) => point.index,
      yValueMapper: (point, _) {
        return (graph == 'MOISTURE') ? point.value * 100.0 : point.value;
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
  num value;
  DateTime index;
  _ChartData(this.value, this.index);
}

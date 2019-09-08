import 'package:soil_moisture_app/ui/colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:soil_moisture_app/utils/all_data.dart';
import 'package:intl/intl.dart';
import 'dart:math';

SfCartesianChart displayChart(List<dynamic> data, String graph) {
  print(data);
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
      minimum: (graph == 'Light')? -100 : 0,
      maximum: (graph == 'Light')? 1400 : 100,
      interval: 20,
      axisLine: AxisLine(width: 1),
      labelFormat: (graph == 'Temp')
          ? '{value}°C'
          : (graph == 'Light') ? '{value} Lux' : '{value}%',
      isVisible: true,
      labelStyle: ChartTextStyle(
        fontFamily: 'Ocrb',
      ),
    ),
    series: getLineSeries(data, graph),
    tooltipBehavior: TooltipBehavior(
      enable: true,
      animationDuration: 200,
      canShowMarker: false,
      header: '',
    ),
  );
}

List<LineSeries<dynamic, DateTime>> getLineSeries(
    List<dynamic> chartData, String graph) {
  print(chartData);
  //chartData = dayLight.getLight;
  List<_ChartData> data = [];
  if (plantList != null) {
    for (var i = 0; i < chartData.length; ++i) {
      data.add(_ChartData(chartData[i], DateTime(2019, 09, 05, i)));
    }
  }
  return <LineSeries<_ChartData, DateTime>>[
    LineSeries<_ChartData, DateTime>(
      enableTooltip: true,
      animationDuration: 150,
      dataSource: data,
      xValueMapper: (point, _) {
        //print(point.index);
        return point.index;
      },
      yValueMapper: (point, _) {
        return (graph == 'Moisture') ? point.value * 100 : point.value;
      },
      pointColorMapper: (x, _) => appSecondaryColor,
      width: 2,
      markerSettings:
          MarkerSettings(isVisible: true, color: appPrimaryLightColor),
    ),
  ];
}

class _ChartData {
  dynamic value;
  DateTime index;
  _ChartData(this.value, this.index);
}

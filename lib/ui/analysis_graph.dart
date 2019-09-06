import 'package:soil_moisture_app/ui/colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:soil_moisture_app/utils/all_data.dart';
import 'package:intl/intl.dart';

SfCartesianChart moistureChart() {
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
      majorGridLines: MajorGridLines(width: 1)
    ),
    primaryYAxis: NumericAxis(
      minimum: 0,
      maximum: 100,
      interval: 20,
      axisLine: AxisLine(width: 1),
      labelFormat: '{value}%',
      isVisible: true,
    ),
    series: getLineSeries(),
    tooltipBehavior: TooltipBehavior(
      enable: true,
      animationDuration: 200,
      canShowMarker: false,
      header: '',
    ),
  );
}

List<LineSeries<dynamic, DateTime>> getLineSeries() {
  List<_ChartData> data = [];
  for (var i = 0; i < plantList[1].getAllMoisture.length; ++i) {
    data.add(_ChartData(plantList[1].getAllMoisture[i], DateTime(2019, 09, 05, i)));
  }
  return <LineSeries<_ChartData, DateTime>>[
    LineSeries<_ChartData, DateTime>(
      enableTooltip: true,
      animationDuration: 150,
      dataSource: data,
      xValueMapper: (point, _) {
        print(point.index);
        return point.index;
      },
      yValueMapper: (point, _) => point.value * 100,
      pointColorMapper: (x, _) => appSecondaryDarkColor,
      width: 2,
      markerSettings: MarkerSettings(isVisible: true,color: appPrimaryLightColor),
    ),
  ];
}

class _ChartData {
  dynamic value;
  DateTime index;
  _ChartData(this.value, this.index);
}

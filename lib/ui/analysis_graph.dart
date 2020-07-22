/*
* analyis_graph

* The graph which is displayed at the Analysis page.
* This graph has zoom, pan and tooltip features.
*/

import 'dart:math' as math; // * For max() and min()
import 'package:flutter/material.dart';

// * External packages import
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_common/common.dart' as common;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// * data providers import
import 'package:soil_moisture_app/data_providers/analysis_current_value_provider.dart';
import 'package:soil_moisture_app/data_providers/analysis_data_provider.dart';

// * State import
import 'package:soil_moisture_app/states/theme_state.dart';

// * ui import
import 'package:soil_moisture_app/ui/colors.dart';

// * utils Import
import 'package:soil_moisture_app/utils/custom_datetimespec.dart';
import 'package:soil_moisture_app/utils/custom_renderer.dart';
import 'package:soil_moisture_app/utils/date_func.dart';
import 'package:soil_moisture_app/utils/sizes.dart';

/// The behaviour and formatting of the chart shown in the Analysis page.
class AnalysisGraph extends StatelessWidget {
  AnalysisGraph({
    this.animate,
    this.graph,
  });

  final bool animate;
  final String graph;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CurrentPointerValue(
          unit: Provider.of<AnalysisDataProvider>(context).unit,
          graph: graph,
        ),
        Flexible(
          child: Container(
            margin: const EdgeInsets.only(left: 8.0, bottom: 8.0),
            child: charts.TimeSeriesChart(
              _createSeries(Provider.of<AnalysisDataProvider>(context).data,
                  graph, context),
              behaviors: [
                charts.LinePointHighlighter(
                  showVerticalFollowLine:
                      charts.LinePointHighlighterFollowLineType.nearest,
                  showHorizontalFollowLine:
                      charts.LinePointHighlighterFollowLineType.nearest,
                  dashPattern: [4, 3],
                  drawFollowLinesAcrossChart: false,
                  symbolRenderer: CustomCircleSymbolRenderer(
                    fillColor: materialColorToCommonChartsColor(Colors.white),
                    strokeColor: materialColorToCommonChartsColor(
                      Theme.of(context).accentColor,
                    ),
                    strokeWidth: 3.0,
                  ),
                ),
                charts.PanAndZoomBehavior(),
              ],
              selectionModels: [
                charts.SelectionModelConfig(
                  changedListener: (charts.SelectionModel model) {
                    if (model.hasDatumSelection)
                      Provider.of<AnalysisCurrentValueProvider>(context,
                              listen: false)
                          .changeValue(model.selectedDatum[0].datum);
                  },
                )
              ],
              animate: animate ?? false,
              customSeriesRenderers: [
                charts.LineRendererConfig(
                  includePoints: true,
                  customRendererId: 'point',
                )
              ],
              primaryMeasureAxis: charts.NumericAxisSpec(
                tickFormatterSpec: _analysisGraphMeasureTickFormatter,
                tickProviderSpec: charts.StaticNumericTickProviderSpec(
                  _createStaticTicks(
                      Provider.of<AnalysisDataProvider>(context).data, graph),
                ),
                renderSpec: charts.GridlineRendererSpec(
                  labelStyle: charts.TextStyleSpec(
                    color: materialColorToCommonChartsColor(
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                    fontFamily: 'Ocrb',
                  ),
                ),
              ),
              domainAxis: CustomDateTimeAxisSpec(
                tickFormatterSpec:
                    common.BasicDateTimeTickFormatterSpec.fromDateFormat(
                  DateFormat('h:mma'),
                ),
                renderSpec: charts.SmallTickRendererSpec(
                    labelStyle: charts.TextStyleSpec(
                      color: charts.MaterialPalette.gray.shadeDefault,
                      fontFamily: 'Ocrb',
                    ),
                    lineStyle: charts.LineStyleSpec(
                        color: charts.MaterialPalette.gray.shadeDefault)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// The tick formatter used in the measure axis(y-axis) of the [AnalysisGraph].
///
/// Converts values greater than 1000 in the form of 'K' and values greater than
/// 1000000 in the form of 'M'.
///
/// 237.5 => 237.5
/// 1013.4 => 1.0K
/// 91142069.1 => 91.1M
final _analysisGraphMeasureTickFormatter = charts.BasicNumericTickFormatterSpec(
  (num value) {
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    } else if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else {
      return value.toString();
    }
  },
);

/// The widget showing the currently selected value in the [Analysis] graph.
/// Rapidly changes value with animation from zero to the selected value.
/// The text will change from this value to the next value selected.
class CurrentPointerValue extends StatefulWidget {
  final String unit;
  final String graph;
  CurrentPointerValue({this.unit, this.graph});
  @override
  _CurrentPointerValueState createState() => _CurrentPointerValueState();
}

class _CurrentPointerValueState extends State<CurrentPointerValue> {
  num _begin;
  num _end;

  @override
  void initState() {
    super.initState();
    _begin = 0.0;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _end = Provider.of<AnalysisCurrentValueProvider>(context).current.value;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        TweenAnimationBuilder<num>(
          duration: Duration(milliseconds: 500),
          tween: Tween<num>(begin: _begin, end: _end),
          builder: (context, value, _) => RichText(
            text: TextSpan(children: [
              TextSpan(
                text:
                    '${(value * ((widget.graph == "Moisture") ? 100 : 1)).toStringAsFixed(1)}',
                style: Theme.of(context).textTheme.headline3.copyWith(
                      color: (Provider.of<ThemeState>(context).isDarkTheme)
                          ? Theme.of(context).accentColor
                          : appSecondaryDarkColor,
                      fontSize: appWidth(context) * 0.09,
                    ),
              ),
              TextSpan(
                text: widget.unit,
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      fontSize: appWidth(context) * 0.06,
                    ),
              ),
            ]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            'at ${DateFormat('ha').format(Provider.of<AnalysisCurrentValueProvider>(context).current.time)}',
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                  fontSize: appWidth(context) * 0.025,
                ),
          ),
        )
      ],
    );
  }
}

List<charts.Series<DataPoint, DateTime>> _createSeries(
    List<dynamic> data, String graph, BuildContext context) {
  final chartData = Iterable.generate(
    data.length,
    (i) => DataPoint(DateTime(date.year, date.month, date.day, i), data[i]),
  ).toList();
  return <charts.Series<DataPoint, DateTime>>[
    charts.Series<DataPoint, DateTime>(
      id: 'Data',
      colorFn: (_, __) =>
          materialColorToCommonChartsColor(Theme.of(context).accentColor),
      domainFn: (DataPoint point, _) => point.time,
      measureFn: (DataPoint point, _) =>
          (graph == 'Moisture') ? point.value * 100 : point.value,
      data: chartData,
    )..setAttribute(charts.rendererIdKey, 'point'),
  ];
}

/// Converts a [Color] to the type of [charts.Color].
charts.Color materialColorToCommonChartsColor(Color materialColor) {
  return charts.Color(
    r: materialColor.red,
    b: materialColor.blue,
    g: materialColor.green,
    a: materialColor.alpha,
  );
}

/// Creates static ticks for the chart.
///
/// The chart bt default changes its ticks whenever zoomed or panned to always
/// fit the visible data values throughout the vertical axis. Explicitly
/// providing the ticks prevents the chart to adjust the vertical zoom by itself.
///
/// In this case, we disable the vertical zoom.
List<charts.TickSpec<int>> _createStaticTicks(List<num> data, String graph) {
  num dataMinValue = data.reduce((num a, num b) => math.min(a, b));
  num dataMaxValue = data.reduce((num a, num b) => math.max(a, b));
  double minYAxisValue = (dataMinValue < 0.0) ? dataMinValue - 50.0 : 0.0;
  double maxYAxisValue = (dataMaxValue > 100.0) ? dataMaxValue + 50.0 : 100.0;
  final double interval =
      (((maxYAxisValue - minYAxisValue) / 100) * 20).round().toDouble();
  List<charts.TickSpec<int>> ticks = [];
  print('$minYAxisValue $maxYAxisValue');
  while (minYAxisValue - maxYAxisValue < interval) {
    ticks.add(charts.TickSpec(minYAxisValue.toInt()));
    minYAxisValue += interval;
  }
  return ticks;
}

/// Class representing each of the data point of the graph.
class DataPoint {
  final DateTime time;
  final dynamic value;

  DataPoint(this.time, this.value);

  @override
  String toString() => 'DataPoint: ${this.time},${this.value}';
}

import 'package:charts_flutter/flutter.dart' as charts;

class CustomDateTimeAxisSpec extends charts.DateTimeAxisSpec {
  const CustomDateTimeAxisSpec({
    charts.RenderSpec<DateTime> renderSpec,
    charts.DateTimeTickProviderSpec tickProviderSpec,
    charts.DateTimeTickFormatterSpec tickFormatterSpec,
    bool showAxisLine,
  }) : super(
            renderSpec: renderSpec,
            tickProviderSpec: tickProviderSpec,
            tickFormatterSpec: tickFormatterSpec,
            showAxisLine: showAxisLine);

  @override
  configure(charts.Axis<DateTime> axis, charts.ChartContext context,
      charts.GraphicsFactory graphicsFactory) {
    super.configure(axis, context, graphicsFactory);
    axis.autoViewport = false;
  }
}

import 'package:flutter/material.dart';
import 'package:soil_moisture_app/ui/colors.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';

void main() => runApp(MaterialApp(
      title: "Soli App",
      debugShowCheckedModeBanner: false,
      home: new HomeApp(),
    ));

class HomeApp extends StatefulWidget {
  @override
  _HomeAppState createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  final GlobalKey<AnimatedCircularChartState> _chartKey =
      new GlobalKey<AnimatedCircularChartState>();
  final _chartSize = const Size(300.0, 300.0);
  double value = 50.0;
  Color labelColor = Colors.blue[200];
  void _increment() {
    setState(() {
      value += 10;
      List<CircularStackEntry> data = _generateChartData(value);
      _chartKey.currentState.updateData(data);
    });
  }

  void _decrement() {
    setState(() {
      value -= 10;
      List<CircularStackEntry> data = _generateChartData(value);
      _chartKey.currentState.updateData(data);
    });
  }

  List<CircularStackEntry> _generateChartData(double value) {
    Color dialColor = Colors.blue[200];
    if (value < 0) {
      dialColor = Colors.red[200];
    } else if (value < 50) {
      dialColor = Colors.yellow[200];
    }
    labelColor = dialColor;

    List<CircularStackEntry> data = <CircularStackEntry>[
      new CircularStackEntry(
        <CircularSegmentEntry>[
          new CircularSegmentEntry(
            value,
            dialColor,
            rankKey: 'percentage',
          )
        ],
        rankKey: 'percentage',
      ),
    ];

    if (value > 100) {
      labelColor = Colors.green[200];

      data.add(new CircularStackEntry(
        <CircularSegmentEntry>[
          new CircularSegmentEntry(
            value - 100,
            Colors.green[200],
            rankKey: 'percentage',
          ),
        ],
        rankKey: 'percentage2',
      ));
    }

    return data;
  }

  @override
  Widget build(BuildContext context) {
    TextStyle _labelStyle = Theme.of(context)
        .textTheme
        .title
        .merge(new TextStyle(color: labelColor));

    return Scaffold(
      appBar: new AppBar(
        backgroundColor: appPrimaryDarkColor,
        title: new Text("Soli App"),
      ),
      body: new Column(
        children: <Widget>[
          new Container(
            child: new AnimatedCircularChart(
              key: _chartKey,
              size: _chartSize,
              initialChartData: _generateChartData(value),
              chartType: CircularChartType.Radial,
              edgeStyle: SegmentEdgeStyle.round,
              percentageValues: true,
              holeLabel: '$value%',
              labelStyle: _labelStyle,
            ),
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              new RaisedButton(
                onPressed: _decrement,
                child: const Icon(Icons.remove),
                shape: const CircleBorder(),
                color: Colors.red[200],
                textColor: Colors.white,
              ),
              new RaisedButton(
                onPressed: _increment,
                child: const Icon(Icons.add),
                shape: const CircleBorder(),
                color: Colors.blue[200],
                textColor: Colors.white,
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: new Theme(
        data: Theme.of(context).copyWith(
            // sets the background color of the `BottomNavigationBar`
            canvasColor: appPrimaryLightColor,
            // sets the active color of the `BottomNavigationBar` if `Brightness` is light
            primaryColor: appSecondaryLightColor,
            textTheme: Theme.of(context).textTheme.copyWith(
                caption: new TextStyle(
                    color:
                        appSecondaryDarkColor))), // sets the inactive color of the `BottomNavigationBar`
        child: new BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: 0,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.remove_red_eye,
              ),
              title: new Text(
                "Overview",
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.linear_scale,
              ),
              title: new Text(
                "Analysis",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:soil_moisture_app/ui/build_theme.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

void main() {
  String title = 'Soil App';
  runApp(
    MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      home: new HomeApp(title),
      theme: buildLightTheme(),
    ),
  );
}

class HomeApp extends StatefulWidget {
  final String title;
  HomeApp(this.title);
  @override
  _HomeAppState createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Row(
              children: <Widget>[
                CircularPercentIndicator(
                  animationDuration: 600,
                  radius: 300.0,
                  animation: true,
                  percent: _counter.toDouble() / 100,
                  circularStrokeCap: CircularStrokeCap.round,
                  backgroundColor: Colors.grey[300],
                  progressColor: (_counter < 15) ? Colors.red : Colors.green,
                  lineWidth: 10.0,
                  center: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '$_counter%',
                        style: Theme.of(context).textTheme.display4.copyWith(
                              fontSize: 130.0,
                            ),
                      ),
                      Text(
                        'Current Moisture',
                        style: Theme.of(context).textTheme.display1.copyWith(
                              fontSize: 24.0,
                            ),
                      )
                    ],
                  ),
                )
              ],
            ),
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      bottomNavigationBar: new BottomNavigationBar(
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
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

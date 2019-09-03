import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:soil_moisture_app/ui/colors.dart';

class PlantTile extends StatelessWidget {
  final String label;
  final double percent;
  final double crit;
  PlantTile({this.label, this.percent = 0.15, this.crit = 0.15});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.14,
      child: Theme(
        data: Theme.of(context).copyWith(
          cardTheme: Theme.of(context).cardTheme.copyWith(
                color: (percent <= crit)
                    ? Colors.red[200]
                    : appPrimaryLightColor,
              ),
        ),
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 6.0, bottom: 8.0),
                          child: Text(
                            this.label,
                            style: Theme.of(context).textTheme.body2.copyWith(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.035,
                                ),
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.04,
                          width: MediaQuery.of(context).size.height * 0.04,
                          child: Placeholder(), //*- Image Asset here
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Info here',
                      style: Theme.of(context).textTheme.caption.copyWith(
                            fontSize: MediaQuery.of(context).size.width * 0.045,
                          ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: LinearPercentIndicator(
                  animateFromLastPercent: true,
                  animationDuration: 600,
                  animation: true,
                  trailing: Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: Text(
                      '${(this.percent * 100).toInt()}%',
                      style: Theme.of(context).textTheme.button.copyWith(
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                          ),
                    ),
                  ),
                  percent: this.percent,
                  progressColor:
                      (percent <= crit) ? Colors.red : Colors.green[900],
                  backgroundColor: Colors.blueGrey[200],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

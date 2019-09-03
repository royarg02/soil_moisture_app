import 'package:flutter/material.dart';
import 'package:soil_moisture_app/ui/colors.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class PlantCard extends StatelessWidget {
  final String title;
  final String img;
  Function onTap;
  final double percent;
  final double crit;

  PlantCard(
      {this.title,
      this.img,
      this.onTap,
      this.percent = 0.15,
      this.crit = 0.15}) {
    if (this.onTap == null) {
      this.onTap = () => print(this.title);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Theme(
        data: Theme.of(context).copyWith(
          cardTheme: Theme.of(context).cardTheme.copyWith(
                color: (percent <= crit)
                    ? Colors.red[200]
                    : appPrimaryLightColor,
              ),
        ),
        child: Card(
          child: InkWell(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  this.title,
                  style: Theme.of(context).textTheme.body2.copyWith(
                        fontSize: MediaQuery.of(context).size.width * 0.035,
                      ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.height * 0.05,
                  child: Placeholder(), //* Place Image Asset Here
                ),
                percent < 0.35
                    ? LinearPercentIndicator(
                        percent: this.percent,
                        progressColor: Colors.red,
                        animateFromLastPercent: true,
                        animationDuration: 600,
                        animation: true,
                        backgroundColor: Colors.blueGrey[200],
                      )
                    : percent < 0.75
                        ? LinearPercentIndicator(
                            percent: this.percent,
                            animateFromLastPercent: true,
                            animationDuration: 600,
                            animation: true,
                            linearGradient: LinearGradient(
                              tileMode: TileMode.clamp,
                              colors: [Colors.red, Colors.green],
                              stops: [0.25, 1.0],
                            ),
                            backgroundColor: Colors.blueGrey[200],
                          )
                        : LinearPercentIndicator(
                            percent: this.percent,
                            animateFromLastPercent: true,
                            animationDuration: 600,
                            animation: true,
                            linearGradient: LinearGradient(
                              tileMode: TileMode.clamp,
                              colors: [Colors.red, Colors.green, Colors.blue],
                              stops: [0.25, 0.75, 1.0],
                            ),
                            backgroundColor: Colors.blueGrey[200],
                          ),
              ],
            ),
            onTap: this.onTap,
          ),
        ),
      ),
    );
  }
}

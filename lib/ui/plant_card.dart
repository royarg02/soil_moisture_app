import 'package:flutter/material.dart';
import 'package:soil_moisture_app/ui/colors.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:soil_moisture_app/utils/plant_class.dart';

class PlantCard extends StatelessWidget {
  Function onTap;
  final Plant plant;
  bool isSelected;
  bool extended;

  PlantCard(
      {this.plant,
      this.onTap,
      this.isSelected,
      this.extended = false}) {
    if (this.onTap == null) {
      this.onTap = () => print(plant.getLabel);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        cardTheme: Theme.of(context).cardTheme.copyWith(
              color: (isSelected)
                  ? this.plant.isCritical()
                      ? Color(0xffff8282)
                      : appPrimaryColor
                  : this.plant.isCritical()
                      ? Colors.red[100]
                      : appPrimaryLightColor,
              elevation: (isSelected) ? 8.0 : 3.0,
            ),
      ),
      child: Card(
        child: InkWell(
          child: (extended)
              ? // ****** Rectangular Long Card ******
              Container(
                  height: MediaQuery.of(context).size.height * 0.14,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 6.0, bottom: 8.0),
                                  child: Text(
                                    '${this.plant.getLabel}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .body2
                                        .copyWith(
                                          fontSize: (isSelected)
                                              ? MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.045
                                              : MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.035,
                                        ),
                                  ),
                                ),
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.04,
                                  width:
                                      MediaQuery.of(context).size.height * 0.04,
                                  child: Placeholder(), //*- Image Asset here
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Info here',
                              style:
                                  Theme.of(context).textTheme.caption.copyWith(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.045,
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
                              '${(this.plant.getLastMoisture * 100).toInt()}%',
                              style:
                                  Theme.of(context).textTheme.button.copyWith(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.035,
                                      ),
                            ),
                          ),
                          percent: this.plant.getLastMoisture,
                          progressColor: plant.isCritical()
                              ? Colors.red
                              : plant.isMoreThanNormal()
                                  ? Colors.blue
                                  : Colors.green,
                          backgroundColor: Colors.blueGrey[200],
                        ),
                      ),
                    ],
                  ),
                )
              : // ****** Square Small Card ******
              Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '${this.plant.getLabel}',
                      style: Theme.of(context).textTheme.body2.copyWith(
                            fontSize: (isSelected)
                                ? MediaQuery.of(context).size.width * 0.05
                                : MediaQuery.of(context).size.width * 0.035,
                          ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.height * 0.05,
                      child: Placeholder(), //* Place Image Asset Here
                    ),
                    LinearPercentIndicator(
                      percent: this.plant.getLastMoisture,
                      progressColor: plant.isCritical()
                          ? Colors.red
                          : plant.isMoreThanNormal()
                              ? Colors.blue
                              : Colors.green,
                      animateFromLastPercent: true,
                      animationDuration: 600,
                      animation: true,
                      backgroundColor: Colors.blueGrey[200],
                    )
                  ],
                ),
          onTap: this.onTap,
        ),
      ),
    );
  }
}

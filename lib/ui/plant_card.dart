/*
* plant_card

* Cards displayed around the bottom of the Overview/ Analysis page which displays
* the name and the moisture of the plant depending on context.
* Also includes a common fancy plant image.
* 'Selecting'the card shows the corresponding moisture value for the respective plant.
*/

import 'package:flutter/material.dart';

// * External Packages Import
import 'package:percent_indicator/linear_percent_indicator.dart';

// * ui import
import 'package:soil_moisture_app/ui/colors.dart';

// * utils import
import 'package:soil_moisture_app/utils/sizes.dart';

// * Data import
import 'package:soil_moisture_app/data/plant_class.dart';

class PlantCard extends StatelessWidget {
  Function onTap;
  final Plant plant;
  bool isSelected;

  PlantCard({
    this.plant,
    this.onTap,
    this.isSelected,
  }) {
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
              elevation: (isSelected) ? 15.0 : 2.0,
            ),
      ),
      child: Card(
        child: InkWell(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                '${this.plant.getLabel}',
                style: Theme.of(context).textTheme.body2.copyWith(
                      fontSize: appWidth * 0.05,
                    ),
                    textAlign: TextAlign.center,
              ),
              Image.asset(
                './assets/images/plant.png',
                height: appWidth * 0.1,
                width: appWidth * 0.1,
              ),
              LinearPercentIndicator(
                addAutomaticKeepAlive: false,
                percent: this.plant.getLastValue,
                progressColor: plant.isCritical()
                    ? Colors.red
                    : plant.isMoreThanNormal() ? Colors.blue : Colors.green,
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

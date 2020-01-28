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
import 'package:provider/provider.dart';

// * States import
import 'package:soif/states/theme_state.dart';

// * ui import
import 'package:soif/ui/colors.dart';

// * utils import
import 'package:soif/utils/sizes.dart';

// * Data import
import 'package:soif/data/plant_class.dart';

class PlantCard extends StatelessWidget {
  final Function onTap;
  final Plant plant;
  final bool isSelected;
  final bool isEnabled;

  PlantCard({
    this.plant,
    @required this.onTap,
    this.isSelected,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        cardTheme: Theme.of(context).cardTheme.copyWith(
              color: (isSelected)
                  ? this.plant.isCritical()
                      ? Theme.of(context).errorColor
                      : Theme.of(context).primaryColor
                  : this.plant.isCritical()
                      ? (Provider.of<ThemeState>(context).isDarkTheme(context))
                          ? darkAppErrorDarkColor
                          : appErrorLightColor
                      : Theme.of(context).cardColor,
              elevation:
                  (isSelected) ? 20.0 : Theme.of(context).cardTheme.elevation,
            ),
      ),
      child: Card(
        child: InkWell(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                '${this.plant.name}',
                style: Theme.of(context).textTheme.body2.copyWith(
                      fontSize: appWidth(context) * 0.045,
                    ),
                textAlign: TextAlign.center,
              ),
              Image.asset(
                (Provider.of<ThemeState>(context).isDarkTheme(context))
                    ? './assets/images/plant_dark.png'
                    : './assets/images/plant.png',
                height: appWidth(context) * 0.1,
                width: appWidth(context) * 0.1,
              ),
              LinearPercentIndicator(
                percent: this.plant.moisture.lastValue,
                progressColor: plant.isCritical()
                    ? criticalPlantColor
                    : plant.isMoreThanNormal()
                        ? moreThanNormalPlantColor
                        : normalPlantColor,
                animateFromLastPercent: true,
                animationDuration: 600,
                animation: true,
                backgroundColor: (Provider.of<ThemeState>(context).isDarkTheme(context))
                    ? darkAppProgressIndicatorBackgroundColor
                    : appProgressIndicatorBackgroundColor,
              )
            ],
          ),
          onTap: (this.isEnabled) ? this.onTap : null,
        ),
      ),
    );
  }
}

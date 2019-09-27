/*
* threshold_slider

* //TODO: Aritra please add details
* The controls for controlling the moisture threshold for each pump/ plant.
*/

import 'package:flutter/material.dart';

// * ui import
import 'package:soil_moisture_app/ui/colors.dart';

// * utils import
import 'package:soil_moisture_app/utils/sizes.dart';

class ThresholdSlider extends StatefulWidget {
  final String label;
  final num threshold;
  final int position;
  final Function thresholdChanger;
  ThresholdSlider(
      {this.label, this.threshold, this.position, this.thresholdChanger});

  @override
  _ThresholdSliderState createState() => _ThresholdSliderState();
}

class _ThresholdSliderState extends State<ThresholdSlider> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: appWidth * 0.01),
      child: Card(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: appWidth * 0.02),
              child: Text(
                this.widget.label,
                style: Theme.of(context).textTheme.body2.copyWith(
                      fontSize: appWidth * 0.045,
                    ),
              ),
            ),
            Expanded(
              flex: 12,
              child: Slider(
                value: widget.threshold,
                onChanged: (val) => widget.thresholdChanger(
                    position: widget.position, value: val),
                min: 0,
                max: 1,
                divisions: 20,
                activeColor: appSecondaryLightColor,
                inactiveColor: appPrimaryColor,
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                '${widget.threshold}',
                style: Theme.of(context).textTheme.caption.copyWith(
                      fontSize: appWidth * 0.03,
                    ),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

// * ui import
import 'package:soil_moisture_app/ui/colors.dart';

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
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Card(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                this.widget.label,
                style: Theme.of(context).textTheme.body2.copyWith(
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                    ),
              ),
            ),
            Expanded(
              flex: 9,
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
              flex: 1,
              //margin: EdgeInsets.only(right: 15.0),
              child: Text(
                '${widget.threshold}',
                style: Theme.of(context).textTheme.caption.copyWith(
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                    ),
                textAlign: TextAlign.start,
              ),
            )
          ],
        ),
      ),
    );
  }
}

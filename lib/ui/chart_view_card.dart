import 'package:flutter/material.dart';

// * Utils import
import 'package:soif/utils/sizes.dart';

class ChartViewCard extends StatelessWidget {
  final Widget content;
  ChartViewCard({@required this.content});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
        border: Border.all(color: Theme.of(context).accentColor),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: appHeight(context) * 0.35),
        child: this.content,
      ),
    );
  }
}

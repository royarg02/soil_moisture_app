import 'package:flutter/material.dart';

// * Utils import
import 'package:soif/utils/sizes.dart';

class ChartViewCard extends StatelessWidget {
  final Widget content;
  ChartViewCard({@required this.content});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 2.0,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: appHeight(context) * 0.35),
        child: this.content,
      ),
    );
  }
}

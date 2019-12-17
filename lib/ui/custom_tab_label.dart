import 'package:flutter/material.dart';

/*
 * Custom Tab Label
 * 
 * Builds the custom tab lables for the app
 */

class AppTab extends StatelessWidget {
  AppTab({
    this.text,
    this.icon,
  });
  final String text;
  final Widget icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46.0,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            child: icon,
            margin: const EdgeInsets.only(right: 10.0),
          ),
          Flexible(
            child: Text(
              text,
              softWrap: false,
              overflow: TextOverflow.fade,
            ),
          )
        ],
      ),
    );
  }
}

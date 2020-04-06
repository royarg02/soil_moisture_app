/*
 * Date Selector
 * 
 * Provides controls for choosing the date in Analysis page. 
 */

import 'package:flutter/material.dart';

// * Ui Import
import 'package:soif/ui/colors.dart';

// * Utils import
import 'package:soif/utils/date_func.dart';
import 'package:soif/utils/sizes.dart';

class DateSelector extends StatefulWidget {
  final Function invokeFunction;
  DateSelector({@required this.invokeFunction});
  @override
  _DateSelectorState createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  Future<void> _pickDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: oldestDate,
      lastDate: now,
    );
    if (picked != null && picked != date) {
      setState(() {
        date = picked;
      });
      widget.invokeFunction();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: () {
              setState(() {
                prevDate();
              });
              widget.invokeFunction();
            }),
        Tooltip(
          message: 'Jump to date',
          child: FlatButton(
            onPressed: () => _pickDate(context),
            child: Text(
              '$fetchDateEEEMMMd',
              style: Theme.of(context).textTheme.body2.copyWith(
                    fontSize: appWidth(context) * 0.04,
                  ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(appWidth(context) * 0.1),
              side: BorderSide(
                width: 2.0,
                color: appPrimaryDarkColor,
              ),
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.chevron_right),
          onPressed: (isNow())
              ? null
              : () {
                  setState(() {
                    nextDate();
                  });
                  widget.invokeFunction();
                },
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:soif/utils/date_func.dart';
import 'package:soif/utils/sizes.dart';

import 'colors.dart';

class DateSelector extends StatefulWidget {
  @override
  _DateSelectorState createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  Future<void> _pickDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(date.year),
      lastDate: now,
    );
    if (picked != null && picked != date) {
      date = picked;
      // _fetchForDate();
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
            prevDate();
            // _fetchForDate();
          },
        ),
        Tooltip(
          message: 'Jump to date',
          child: FlatButton(
            onPressed: () => _pickDate(context),
            child: Text(
              '$fetchDateEEEMMMd',
              style: Theme.of(context).textTheme.body2.copyWith(
                    fontSize: appWidth(context) * 0.05,
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
                  nextDate();
                  // _fetchForDate();
                },
        )
      ],
    );
  }
}

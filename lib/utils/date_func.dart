/*
* date_func

* Manipulations and functions to be performed on Date values. 
*/

import 'package:intl/intl.dart';

final DateTime oldestDate = DateTime(2019, 08, 01);
final DateTime now = DateTime.now();
DateTime date = now;

var _formatter = DateFormat('dd-MM-yyyy');
var _showFormatter = DateFormat('EEE, MMM d');

String get fetchDateddmmyyyy => _formatter.format(date);
String get fetchDateEEEMMMd => _showFormatter.format(date);
String get fetchNowDate => _showFormatter.format(now);

void prevDate() {
  date = date.subtract(Duration(days: 1));
}

void nextDate() {
  date = date.add(Duration(days: 1));
}

bool isNow() => now.difference(date) < Duration(days: 1);

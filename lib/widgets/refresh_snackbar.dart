/*
* refresh_snackbar

* Snackbars to be displyed upon successful/ unsuccessful loading/ refreshing of data from API.
*/

import 'package:flutter/material.dart';

class SuccessOnRefresh extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SnackBar(
      content: Text('Data Updated.'),
      duration: Duration(
        seconds: 2,
      ),
    );
  }
}

class FailureOnRefresh extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SnackBar(
      content: Text('Couldn\'t fetch data. Check your Internet Connection.'),
      duration: Duration(
        seconds: 2,
      ),
    );
  }
}

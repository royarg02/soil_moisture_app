import 'package:flutter/material.dart';

class ShowError extends StatelessWidget {
  final int type;
  ShowError({this.type = 0});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        (this.type == 0)
            ? 'Refresh to update data.'
            : 'Couldn\'t connect to internet.\nCheck your internet connection and restart the App.',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.display1.copyWith(
              fontSize: 20.0,
            ),
      ),
    );
  }
}

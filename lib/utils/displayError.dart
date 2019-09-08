import 'package:flutter/material.dart';

class ShowError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'No Data Available\nEither pull to refresh\ror check your Internet Connection',
        textAlign: TextAlign.center,
      ),
    );
  }
}

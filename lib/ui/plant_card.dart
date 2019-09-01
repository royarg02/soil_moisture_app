import 'package:flutter/material.dart';

class PlantCard extends StatelessWidget {
  final String title;
  final String img;
  final Function ontap;

  PlantCard({this.title, this.img, this.ontap = null});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150.0,
      width: 150.0,
      child: Card(
        child: InkWell(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(this.title),
              Container(
                height: 50.0,
                width: 50.0,
                child: Placeholder(),//* Place Image Asset Here
              )
            ],
          ),
          onTap: this.ontap,
        ),
      ),
    );
  }
}

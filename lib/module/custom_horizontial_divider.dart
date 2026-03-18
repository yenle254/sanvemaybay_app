import 'package:flutter/material.dart';

class CustomHorizontialDivider extends StatelessWidget {
  final double length;
  final double marginTop;

  CustomHorizontialDivider(this.length, this.marginTop);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        new Padding(
          padding: new EdgeInsets.only(top: marginTop),
        ),
        new Container(
          width: length,
          height: 1.0,
          decoration: new BoxDecoration(
              border: Border(top: BorderSide(color: Colors.black, width: 1.5))),
        ),
        new Padding(
          padding: new EdgeInsets.only(top: marginTop),
        ),
      ],
    );
  }
}

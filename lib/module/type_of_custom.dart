import 'package:flutter/material.dart';

class TypeOfCustom extends StatelessWidget {
  final String image;
  final String type;
  final String rule;

  TypeOfCustom(this.image, this.type, this.rule);

  @override
  Widget build(BuildContext context) {
    return TypeOfCustomSupport(image, type, rule);
  }
}

class TypeOfCustomSupport extends StatefulWidget {
  final String image;
  final String type;
  final String rule;

  TypeOfCustomSupport(this.image, this.type, this.rule);

  @override
  _TypeOfCustomSupportState createState() => _TypeOfCustomSupportState();
}

class _TypeOfCustomSupportState extends State<TypeOfCustomSupport> {

  @override
  Widget build(BuildContext context) {
    
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Image.asset(
              widget.image,
              color: Colors.grey[600],
              width: MediaQuery.of(context).size.width*0.05,
              height: MediaQuery.of(context).size.width*0.085,
            ),
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  widget.type,
                  style: new TextStyle(
                    fontFamily: "Roboto Medium",
                     
                    fontSize: MediaQuery.of(context).size.width*0.04,
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.width*0.0143),),
                new Text(
                  widget.rule,
                  style: new TextStyle(
                    fontFamily: "Roboto Medium",
                     
                    fontSize: MediaQuery.of(context).size.width*0.03,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

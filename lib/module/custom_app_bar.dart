import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String textOfTitle;
  final bool isHomePage;
  final double justify;

  CustomAppBar(this.textOfTitle, this.isHomePage, this.justify);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: new Text(
        textOfTitle,
        style: new TextStyle(
          fontFamily: "Roboto Medium",
           
          fontSize: MediaQuery.of(context).size.width*0.05,
        ),
      ),
    );
  }
}

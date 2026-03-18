import 'package:flutter/material.dart';

class DetailedContact extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DetailedContactSupport();
  }
}

class DetailedContactSupport extends StatefulWidget {
  @override
  _DetailedContactSupportState createState() => _DetailedContactSupportState();
}

class _DetailedContactSupportState extends State<DetailedContactSupport> {
  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Container(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.0314),
          decoration: new BoxDecoration(
            color: Colors.teal[700],
          ),
          child: new Center(
            child: new Text(
              "Sanvemaybay.vn",
              style: new TextStyle(
                color: Colors.white,
                fontSize: MediaQuery.of(context).size.width*0.0457,
                 
                fontFamily: "Roboto Medium",
              ),
            ),
          ),
        ),
        new Padding(padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.0143),),
        Padding(
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width*0.0171, 
            right: MediaQuery.of(context).size.width*0.0171),
          child: new Container(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.0171),
            decoration: new BoxDecoration(
              color: Colors.teal[400],
            ),
            child: new Row(
              children: <Widget>[
                new Icon(Icons.location_on, color: Colors.white, size: MediaQuery.of(context).size.width*0.06,),
                FittedBox(
                  child: new Text(
                    "47A Lê Trọng Tấn, Phường Tân Sơn Nhì, TP. HCM",
                    style: new TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width*0.0371,
                       
                      fontFamily: "Roboto Medium",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        new Padding(padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.0143),),
        Padding(
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width*0.0171, 
            right: MediaQuery.of(context).size.width*0.0171),
          child: new Container(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.0171),
            decoration: new BoxDecoration(
              color: Colors.teal[400],
            ),
            child: new Row(
              children: <Widget>[
                new Icon(Icons.mail, color: Colors.white, size: MediaQuery.of(context).size.width*0.06,),
                new Text(
                  " info@sanvemaybay.vn",
                  style: new TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width*0.04,
                     
                    fontFamily: "Roboto Medium",
                  ),
                ),
              ],
            ),
          ),
        ),

        new Padding(padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.0143),),
        Padding(
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width*0.0171, 
            right: MediaQuery.of(context).size.width*0.0171),
          child: new Container(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.0171),
            decoration: new BoxDecoration(
              color: Colors.teal[50],
            ),
            child: new Row(
              children: <Widget>[
                new Icon(Icons.phone, color: Colors.teal[700], size: MediaQuery.of(context).size.width*0.0743,),
                new Padding(padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.0171),),
                new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.0171),
                      child: new Text(
                        "- 02871 065 065",
                        style: new TextStyle(
                          color: Colors.black,
                          fontSize: MediaQuery.of(context).size.width*0.04,
                           
                          fontFamily: "Roboto Medium",
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.0171),
                      child: new Text(
                        "- 0903 413 254",
                        style: new TextStyle(
                          color: Colors.black,
                          fontSize: MediaQuery.of(context).size.width*0.04,
                           
                          fontFamily: "Roboto Medium",
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.0171),
                      child: new Text(
                        "- 0903 413 264",
                        style: new TextStyle(
                          color: Colors.black,
                          fontSize: MediaQuery.of(context).size.width*0.04,
                           
                          fontFamily: "Roboto Medium",
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.0171),
                      child: new Text(
                        "- 0948 111 228",
                        style: new TextStyle(
                          color: Colors.black,
                          fontSize: MediaQuery.of(context).size.width*0.04,
                           
                          fontFamily: "Roboto Medium",
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        
        new Padding(padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.0143),),
        Padding(
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width*0.0171, 
            right: MediaQuery.of(context).size.width*0.0171),
          child: new Container(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.0171),
            decoration: new BoxDecoration(
              color: Colors.teal[400],
            ),
            child: new Row(
              children: <Widget>[
                new Icon(Icons.timer, color: Colors.white, size: MediaQuery.of(context).size.width*0.06,),
                new Text(
                  " Khung giờ làm việc: 08:00 đến 21g00",
                  style: new TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width*0.04,
                     
                    fontFamily: "Roboto Medium",
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

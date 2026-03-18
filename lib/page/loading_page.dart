import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sanvemaybay_app_fixed/page/home_page.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Sanvemaybay.vn",
      theme: ThemeData(
        primaryColor: Colors.red[700],
        //accentColor: Colors.grey[700],
        textTheme: TextTheme(
          titleMedium: TextStyle(
            fontFamily: "Roboto Medium",
          ),
          labelLarge: TextStyle(
            fontFamily: "Roboto Medium",
             
          ),
          bodyMedium: TextStyle(
            fontFamily: "Roboto Medium",
          ),
          headlineSmall: TextStyle(
            fontFamily: "Roboto Medium",
          ),
          bodyLarge: TextStyle(
            fontFamily: "Roboto Medium",
          ),
        ),
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 2),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => new HomePage())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.white),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 6,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        "assets/load_new.jpg",
                        width: MediaQuery.of(context).size.width*0.9,),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    Text(
                      "Sanvemaybay.vn",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: MediaQuery.of(context).size.width*0.03,
                          height: 1.5,
                          fontFamily: "Roboto Medium",
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

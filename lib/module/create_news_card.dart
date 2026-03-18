import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:sanvemaybay_app_fixed/module/custom_horizontial_divider.dart';

Future<DateTime?> _confirmDialog(BuildContext context, String content) {
  return showDialog<DateTime>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          titlePadding: EdgeInsets.all(0.0),
          title: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.0457),
            child: new Center(
              child: new Text(
                content,
                textAlign: TextAlign.justify,
                style: new TextStyle(
                    color: Colors.black,
                    height: 1.5,
                    fontFamily: "Roboto Medium",
                    fontSize: MediaQuery.of(context).size.width * 0.04),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: new Text("Quay lại"),
            ),
          ],
        );
      });
}

createCard(String image, String title, String routeName, BuildContext context) {
  return Column(
    children: <Widget>[
      new Padding(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.0229,
            right: MediaQuery.of(context).size.width * 0.0229),
        child: new Container(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.0171),
          margin: EdgeInsets.only(top: 0.0),
          height: MediaQuery.of(context).size.width * 0.18,
          width: double.infinity,
          decoration: new BoxDecoration(
            borderRadius: BorderRadiusDirectional.only(
              topStart: Radius.circular(12),
              topEnd: Radius.circular(12),
            ),
            gradient: RadialGradient(
              center: Alignment.topLeft,
              tileMode: TileMode.mirror,
              radius: MediaQuery.of(context).size.width * 0.0143,
              colors: [
                Colors.red[700]!,
                Colors.red[600]!,
                Colors.red[500]!,
                Colors.orange[800]!.withValues(alpha: 0.7),
                Colors.orange[700]!.withValues(alpha: 0.7),
              ],
            ),
          ),
          child: new Center(
            child: new Text(
              title,
              style: new TextStyle(
                  color: Colors.white,
                  height: MediaQuery.of(context).size.width * 0.003,
                  fontFamily: "Roboto Medium",
                  fontSize: MediaQuery.of(context).size.width * 0.04),
            ),
          ),
        ),
      ),
      new Padding(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.0229,
            right: MediaQuery.of(context).size.width * 0.0229),
        child: new Card(
          margin: EdgeInsets.all(0.0),
          elevation: 0.0,
          child: new Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadiusDirectional.only(
                  bottomStart: Radius.circular(12),
                  bottomEnd: Radius.circular(12),
                ),
                child: new Image.network(
                  image,
                  width: double.infinity,
                  // height: MediaQuery.of(context).size.height * 0.35,
                  fit: BoxFit.fitWidth,
                ),
              ),
              new SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.width * 0.177,
                child: new Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadiusDirectional.only(
                      bottomStart: Radius.circular(12),
                      bottomEnd: Radius.circular(12),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(alpha: 1.0),
                        Colors.black.withValues(alpha: 0.9),
                        Colors.black.withValues(alpha: 0.7),
                        Colors.black.withValues(alpha: 0.5),
                        Colors.black.withValues(alpha: 0.3),
                        Colors.black.withValues(alpha: 0.1),
                        Colors.black.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),
              new Positioned(
                bottom: MediaQuery.of(context).size.width * 0.0343,
                //left: MediaQuery.of(context).size.width*0.7,
                right: MediaQuery.of(context).size.width * 0.03,
                child: new ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                  ),
                  onPressed: () async {
                    var connectivityResult =
                        await new Connectivity().checkConnectivity();
                    // print(connectivityResult.toString());
                    // if (connectivityResult != ConnectivityResult.mobile &&
                    //     connectivityResult != ConnectivityResult.wifi) {
                    //   _confirmDialog(context,
                    //       "Không có kết nối mạng. Vui lòng kiểm tra lại.");
                    // } else {
                    //   Navigator.of(context).pushNamed(routeName);
                    // }
                    print("[createCard] Connectivity result: ${connectivityResult.toString()} (type=${connectivityResult.runtimeType})");
                    bool isOnline = false;
                    try {
                      if (connectivityResult is ConnectivityResult) {
                        isOnline = ConnectivityResult.mobile == connectivityResult ||
                            ConnectivityResult.wifi == connectivityResult ||
                            ConnectivityResult.ethernet == connectivityResult ||
                            ConnectivityResult.vpn == connectivityResult ||
                            ConnectivityResult.other == connectivityResult;
                      }
                      else if (connectivityResult is Iterable) {
                        final results = connectivityResult.cast<ConnectivityResult>().toSet();
                        print("[createCard] Flattened connectivity set: ${results}");
                        isOnline = results.contains(ConnectivityResult.mobile) ||
                            results.contains(ConnectivityResult.wifi) ||
                            results.contains(ConnectivityResult.ethernet) ||
                            results.contains(ConnectivityResult.vpn) ||
                            results.contains(ConnectivityResult.other);
                      }
                      else {
                        print("[createCard][WARN] Unexpected connectivity result type");
                      }
                    } catch (error) {
                      print("[createCard][ERROR] Parsing connectivity result failed: ${error}");
                    }

                    if (!isOnline) {
                      print("[createCard] Treating as OFFLINE based on connectivity result. Showing dialog.");
                      _confirmDialog(context, "Không có kết nối mạng. Vui lòng kiểm tra lại.");
                    } else {
                      print("[createCard] Online detected. Navigating to route: ${routeName}");
                      Navigator.of(context).pushNamed(routeName);
                    } 

                  },
                  child: new Text(
                    "CHI TIẾT",
                    style: new TextStyle(
                      fontFamily: "Roboto Medium",
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width * 0.0343,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.0286,
            right: MediaQuery.of(context).size.width * 0.0286),
        child: new CustomHorizontialDivider(
            double.infinity, MediaQuery.of(context).size.width * 0.0314),
      )
    ],
  );
}

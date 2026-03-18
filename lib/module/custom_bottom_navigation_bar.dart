import 'dart:async';
import 'package:sanvemaybay_app_fixed/page/book_ticket_page.dart';
import 'package:sanvemaybay_app_fixed/page/sale_ticket_in_month.dart';
import 'package:flutter/material.dart';
import 'package:sanvemaybay_app_fixed/customize_object/flight_info_object.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int _current;

  CustomBottomNavigationBar(this._current);

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _currentTab = 0;

  Future<DateTime?> _confirmDialog(BuildContext context, String content) {
    return showDialog<DateTime>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            titlePadding: EdgeInsets.all(0.0),
            title: Padding(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.width * 0.0457),
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

  createBottomNavigationItem(
      String content, Icon iconOfItem, double sizeOfText) {
    return new BottomNavigationBarItem(
      icon: iconOfItem,
      label: content,
    );
  }

  @override
  Widget build(BuildContext context) {
    _currentTab = widget._current;
    return Container(
      decoration: new BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.red[700]!, width: 1.5),
          bottom: BorderSide(color: Colors.red[700]!, width: 1.5),
          )
      ),
      child: new BottomNavigationBar(
        currentIndex: _currentTab,
        onTap: (int index) async {
          if (index == 0) {
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (context) => new BookTicketPage(new FlightInfoObject(
                    depart: "Hồ Chí Minh", destination: "Hà Nội"))));
          } else if (index == 1) {
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (context) =>
                    new SaleTicketInMonth(new FlightInfoObject())));

          // Zalo 
          } else if (index == 2) {
             final zaloUrl = "https://zalo.me/1810291471230407996";
              try {
                await launchUrl(
                  Uri.parse(zaloUrl),
                  mode: LaunchMode.externalApplication,
                );
             } catch (e) {
                await _confirmDialog(context, "Không thể mở Zalo. Vui lòng kiểm tra lại.");
            }


            // var connectivityResult =
            //     await new Connectivity().checkConnectivity();
            // print("[BottomNav] Connectivity result: ${connectivityResult.toString()} (type=${connectivityResult.runtimeType})");

            // bool isOnline = false;
            // try {
            //   if (connectivityResult is ConnectivityResult) {
            //     isOnline = connectivityResult == ConnectivityResult.mobile ||
            //         connectivityResult == ConnectivityResult.wifi ||
            //         connectivityResult == ConnectivityResult.ethernet ||
            //         connectivityResult == ConnectivityResult.vpn ||
            //         connectivityResult == ConnectivityResult.other;
            //   } else if (connectivityResult is Iterable) {
            //     final results = connectivityResult.cast<ConnectivityResult>().toSet();
            //     print("[BottomNav] Flattened connectivity set: ${results}");
            //     isOnline = results.contains(ConnectivityResult.mobile) ||
            //         results.contains(ConnectivityResult.wifi) ||
            //         results.contains(ConnectivityResult.ethernet) ||
            //         results.contains(ConnectivityResult.vpn) ||
            //         results.contains(ConnectivityResult.other);
            //   } else {
            //     print("[BottomNav][WARN] Unexpected connectivity result type");
            //   }
            // } catch (e) {
            //   print("[BottomNav][ERROR] Parsing connectivity result failed: ${e}");
            // }

            // if (!isOnline) {
            //   print(
            //       "[BottomNav] Treating as OFFLINE based on connectivity result. Showing dialog.");
            //   _confirmDialog(
            //       context, "Không có kết nối mạng. Vui lòng kiểm tra lại.");
            // } else {
            //   print("[BottomNav] Online detected. Navigating to SaleNews page.");
            //   Navigator.of(context).push(
            //       new MaterialPageRoute(builder: (context) => new SaleNews()));
            // }


          }
          setState(() {
            _currentTab = index;
          });
        },
        selectedItemColor: Colors.red[700],
        unselectedItemColor: Colors.red[700],
        selectedLabelStyle: TextStyle(
          fontFamily: "Roboto Medium",
          height: 1.2,
          fontSize: MediaQuery.of(context).size.width * 0.03,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: "Roboto Medium",
          height: 1.2,
          fontSize: MediaQuery.of(context).size.width * 0.03,
        ),
        items: [
          createBottomNavigationItem(
              "Đặt vé",
              Icon(
                Icons.local_airport,
                size: 28.0,
                color: Colors.red[700],
              ),
              MediaQuery.of(context).size.width * 0.03),
          createBottomNavigationItem(
              "Săn vé rẻ",
              Icon(
                Icons.calendar_today,
                size: 25.0,
                color: Colors.red[700],
              ),
              MediaQuery.of(context).size.width * 0.0371),
          createBottomNavigationItem(
              "Chat Zalo",
              Icon(
                Icons.chat_bubble,
                size: 25.0,
                color: Colors.red[700],
              ),
              MediaQuery.of(context).size.width * 0.0371),
        ],
      ),
    );
  }
}

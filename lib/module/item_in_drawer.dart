import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sanvemaybay_app_fixed/page/home_page.dart';
import 'package:sanvemaybay_app_fixed/page/sale_news.dart';
import 'package:sanvemaybay_app_fixed/page/sale_ticket_in_month.dart';
import 'package:flutter/material.dart';
import 'package:sanvemaybay_app_fixed/page/book_ticket_page.dart';
import 'package:sanvemaybay_app_fixed/page/business_rule_page.dart';
import 'package:sanvemaybay_app_fixed/page/contact_page.dart';
import 'package:sanvemaybay_app_fixed/page/news.dart';
import 'package:sanvemaybay_app_fixed/customize_object/flight_info_object.dart';
import 'package:sanvemaybay_app_fixed/page/paymeny_page.dart';
import 'package:url_launcher/url_launcher.dart';

class ItemInDrawer extends StatelessWidget {
  final String title;
  final Icon icons;
  final String type;

  ItemInDrawer(this.title, this.icons, this.type);

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

  bool _isOnline(dynamic connectivityResult) {

    bool isOnline = false;

    if (connectivityResult is ConnectivityResult) {
      isOnline = connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi ||
          connectivityResult == ConnectivityResult.ethernet ||
          connectivityResult == ConnectivityResult.vpn ||
          connectivityResult == ConnectivityResult.other;
    } else if (connectivityResult is Iterable) {
      final results = connectivityResult.cast<ConnectivityResult>().toSet();
      isOnline = results.contains(ConnectivityResult.mobile) ||
          results.contains(ConnectivityResult.wifi) ||
          results.contains(ConnectivityResult.ethernet) ||
          results.contains(ConnectivityResult.vpn) ||
          results.contains(ConnectivityResult.other);
    }

    return isOnline;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.0429),
      child: InkResponse(
        onTap: () async {
          if (type.contains("home_page")) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => HomePage()));
          } else if (type.contains("sale_news") || type.contains("announce")) {
            var connectivityResult = await Connectivity().checkConnectivity();

            if (!_isOnline(connectivityResult)) {
              _confirmDialog(
                  context, "Không có kết nối mạng. Vui lòng kiểm tra lại.");
            } else {
              if (type.contains("sale_news")) {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => SaleNews()));
              } else if (type.contains("announce")) {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => News()));
              }
            }
          } else if (type.contains("sale_ticket_in_month")) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => SaleTicketInMonth(FlightInfoObject())));
          } else if (type.contains("book_ticket_page")) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => BookTicketPage(FlightInfoObject())));
          } else if (type.contains("business_rule_page")) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => BusinessRulePage()));
          } else if (type.contains("contact_page")) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => ContactPage()));
          } else if (type.contains("payment_page")) {
            var connectivityResult = await Connectivity().checkConnectivity();

            if (!_isOnline(connectivityResult)) {
              _confirmDialog(
                  context, "Không có kết nối mạng. Vui lòng kiểm tra lại.");
            } else {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => PaymentPage()));
            }
          } else if (type.contains("chat_zalo")) {
            final zaloUrl = Uri.parse("https://zalo.me/1810291471230407996");
            try {
              await launchUrl(
                zaloUrl,
                mode: LaunchMode.externalApplication,
              );
            } catch (e) {
              _confirmDialog(
                context,
                "Không thể mở Zalo. Vui lòng kiểm tra lại.",
              );
            }
          }
        },
        child: Row(
          children: <Widget>[
            icons,
            Padding(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.width * 0.0286),
            ),
            Container(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.width * 0.0143),
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: "Roboto Medium",
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

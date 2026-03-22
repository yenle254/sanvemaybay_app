import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:sanvemaybay_app_fixed/module/custom_app_bar.dart';
import 'package:sanvemaybay_app_fixed/module/custom_drawer.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:sanvemaybay_app_fixed/module/detailed_contact.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:sanvemaybay_app_fixed/customize_object/flight_info_object.dart';

String url = "";

class ContactPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // FlightInfoObject flightObj = new FlightInfoObject();
    //
    url = "https://sanvemaybay.vn/lien-he";
    return new MaterialApp(
        title: "Sanvemaybay.vn",
        theme: new ThemeData(
          primaryColor: Colors.red[700],
        ),
        routes: {
          "/": (_) => ContactPageSupport(),
          "/webview": (_) => Scaffold(
                appBar: AppBar(
                  title: new CustomAppBar("THÔNG TIN LIÊN HỆ", false, 85.0),
                  actions: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.0171),
                      child: new InkResponse(
                        child: new Icon(
                          Icons.phone,
                          size: MediaQuery.of(context).size.width * 0.071,
                        ),
                        onTap: () {
                          launchUrl(Uri.parse("tel://19002690"));
                        },
                      ),
                    ),
                  ],
                ),
                body: WebViewWidget(
                  controller: WebViewController()
                    ..setJavaScriptMode(JavaScriptMode.unrestricted)
                    ..setBackgroundColor(const Color(0x00000000))
                    ..loadRequest(Uri.parse(url)),
                ),
              ),
        });
  }
}

class ContactPageSupport extends StatefulWidget {
  @override
  _ContactPageSupportState createState() => _ContactPageSupportState();
}

class _ContactPageSupportState extends State<ContactPageSupport> {

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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: new CustomDrawer(),
        appBar: AppBar(
          title: new CustomAppBar("THÔNG TIN LIÊN HỆ", false, 85.0),
          actions: <Widget>[
            Padding(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.width * 0.0171),
              child: new InkResponse(
                child: new Icon(
                  Icons.phone,
                  size: MediaQuery.of(context).size.width * 0.071,
                ),
                onTap: () {
                  launchUrl(Uri.parse("tel://19002690"));
                },
              ),
            ),
          ],
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelStyle: new TextStyle(
              fontFamily: "Roboto Medium",
              fontSize: MediaQuery.of(context).size.width * 0.04,
            ),
            unselectedLabelStyle: new TextStyle(
              fontFamily: "Roboto Medium",
              fontSize: MediaQuery.of(context).size.width * 0.04,
            ),
            tabs: <Widget>[
              Tab(
                icon: new Icon(Icons.contact_phone),
                text: "Thông tin hỗ trợ",
              ),
              Tab(
                icon: new Icon(Icons.contacts),
                text: "Liên hệ trực tuyến",
              )
            ],
          ),
        ),
        body: new TabBarView(
          children: <Widget>[
            new DetailedContact(),
            new Column(
              children: <Widget>[
                new Card(
                  margin: EdgeInsets.all(
                      MediaQuery.of(context).size.width * 0.0457),
                  child: Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.0171),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                          "Bạn cần chúng tôi hỗ trợ trực tuyến? Hãy liên lạc ngay với chúng tôi",
                          style: new TextStyle(
                            height:
                                MediaQuery.of(context).size.width * 0.004286,
                            fontSize:
                                MediaQuery.of(context).size.width * 0.0457,
                            fontFamily: "Roboto Medium",
                          ),
                        ),
                        new Padding(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 0.0171),
                        ),
                        new ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal[600],
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.22,
                                right:
                                    MediaQuery.of(context).size.width * 0.22),
                            child: FittedBox(
                              child: Text(
                                "Liên hệ trực tuyến",
                                style: new TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
                                   
                                  fontFamily: "Roboto Medium",
                                ),
                              ),
                            ),
                          ),
                            onPressed: () async {
                              // Hiển thị thông báo SnackBar ở dưới cùng màn hình
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Tính năng chọn ảnh từ thư viện đang được phát triển',
                                    style: TextStyle(color: Colors.white), // Chữ màu trắng
                                  ),
                                  backgroundColor: Colors.black87, // Màu nền đen mờ giống trong ảnh
                                  duration: Duration(seconds: 2), // Hiển thị trong 2 giây
                                  behavior: SnackBarBehavior.floating, // Hiển thị dạng nổi (nếu muốn giống ảnh)
                                ),
                              );
                            },
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sanvemaybay_app_fixed/module/custom_app_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:sanvemaybay_app_fixed/customize_object/flight_info_object.dart';

// FlightInfoObject flightObj = new FlightInfoObject();

String url = "";

class PaymentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    url = "https://sanvemaybay.vn/huong-dan-thanh-toan";
    return new MaterialApp(
        title: "Sanvemaybay.vn",
        theme: new ThemeData(
          primaryColor: Colors.red[700],
        ),
        routes: {
          "/": (_) => Scaffold(
                appBar: AppBar(
                  leading: new IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  title: new CustomAppBar("HƯỚNG DẪN THANH TOÁN", false, 85.0),
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

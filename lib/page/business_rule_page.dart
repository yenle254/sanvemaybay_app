import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:sanvemaybay_app_fixed/module/custom_app_bar.dart';
import 'package:sanvemaybay_app_fixed/module/custom_drawer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sanvemaybay_app_fixed/customize_object/flight_info_object.dart';

String url = "";

class BusinessRulePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FlightInfoObject flightObj = new FlightInfoObject();
    url = "https://sanvemaybay.vn/dieu-khoan-su-dung";
    return new MaterialApp(
        title: "Sanvemaybay.vn",
        theme: new ThemeData(
          primaryColor: Colors.red[700],
        ),
        routes: {
          "/": (_) => BusinessRulePageSupport(),
          "/webview": (_) => Scaffold(
                appBar: AppBar(
                  title: new CustomAppBar("ĐIỀU KHOẢN SỬ DỤNG", false, 60.0),
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

class BusinessRulePageSupport extends StatefulWidget {
  @override
  _BusinessRulePageSupportState createState() =>
      _BusinessRulePageSupportState();
}

class _BusinessRulePageSupportState extends State<BusinessRulePageSupport> {
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
    return Scaffold(
        drawer: new CustomDrawer(),
        appBar: AppBar(
          title: new CustomAppBar("ĐIỀU KHOẢN SỬ DỤNG", false, 60.0),
          actions: <Widget>[
          Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.0171),
            child: new InkResponse(
              child: new Icon(Icons.phone, size: MediaQuery.of(context).size.width * 0.071,),
              onTap: () {
                launchUrl(Uri.parse("tel://19002690"));
              },
            ),
          ),
        ],
        ),

        body: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Container(
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.only(top: 0.0),
                height: MediaQuery.of(context).size.width*0.17,
                width: double.infinity,
                decoration: new BoxDecoration(
                  color: Colors.teal[600],
                ),
                child: new Center(
                  child: new Text(
                    "CHÍNH SÁCH VÀ QUY ĐỊNH CHUNG",
                    style: new TextStyle(
                        color: Colors.white,
                        height: 1.5,
                         
                        fontFamily: "Roboto Medium",
                        fontSize: MediaQuery.of(context).size.width*0.045),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Container(
                padding: EdgeInsets.all(10.0),
                decoration: new BoxDecoration(
                  color: Colors.grey[100],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Center(
                      child: new Text(
                      //  "Phần mềm này thuộc quyền sở hữu và quản lý của công ty Công Ty TNHH ĐTTM và DV Liên Việt. Việc quý khách truy cập và sử dụng phần mềm này có nghĩa là quý khách đã chấp thuận các điều khoản và điều kiện đề ra sau đây. Do vậy đề nghị quý khách đọc và nghiên cứu kỹ trước khi sử dụng tiếp.",
                      "Phần mềm này thuộc quyền sở hữu và quản lý của công ty Công Ty Cổ Phần Đầu Tư Công Nghệ GeekTek. Việc quý khách truy cập và sử dụng phần mềm này có nghĩa là quý khách đã chấp thuận các điều khoản và điều kiện đề ra sau đây. Do vậy đề nghị quý khách đọc và nghiên cứu kỹ trước khi sử dụng tiếp.",
                        textAlign: TextAlign.justify,
                        style: new TextStyle(
                            height: 1.5,
                            fontFamily: "Roboto Medium",
                            fontSize: MediaQuery.of(context).size.width*0.04,
                      ),
                    )),
                    new Padding(padding: EdgeInsets.only(top: 20.0),),
                    new Text(
                      "A. Khái Quát",
                      textAlign: TextAlign.start,
                      style: new TextStyle(
                          height: 1.5,
                           
                          fontFamily: "Roboto Medium",
                          fontSize: MediaQuery.of(context).size.width*0.045),
                    ),
                    new Center(
                      child: new Text(
                        "1. Tất cả những điều khoản về việc sử dụng SANVEMAYBAY.vn để đặt, thanh toán, thanh toán nhanh vé máy bay và các dịch vụ khác (“Điều khoản sử dụng SANVEMAYBAY.vn và/hoặc “Điều khoản sử dụng”) được đăng tải trên trên trang website www.SANVEMAYBAY.vn và được cung cấp bởi đội ngũ hỗ trợ của SANVEMAYBAY.vn (trung tâm hỗ trợ SANVEMAYBAY.vn).\n2. Các quản trị viên của trang website SANVEMAYBAY.vn (“trang web SANVEMAYBAY.vn”) và trung tâm hỗ trợ SANVEMAYBAY.vn trực thuộc Công Ty Cổ Phần Đầu Tư Công Nghệ GeekTek, trụ sở tại Hồ Chí Minh, Việt nam. Thông tin chi tiết về Công ty có trong mục “Liên hệ” trên trang web www.SANVEMAYBAY.vn.\n3. SANVEMAYBAY.vn cung cấp dịch vụ vé máy bay cho khách hàng với tư cách là đại lý của các đại lý đã được Hiệp hội vận tải hàng không quốc tế (IATA) công nhận và có hợp đồng đại lý với các hãng hàng không thuộc IATA (Hãng hàng không truyền thống). Riêng với dịch vụ vé máy bay trên các Hãng hàng không giá rẻ (LCC) và không phải là thành viên của IATA, SANVEMAYBAY.vn cung cấp dịch vụ cho khách hàng với tư cách là người đại diện cho khách hàng trong việc ký hợp đồng mua vé với các LCC.\n4. Với vai trò là đại lý của các đại lý đã được IATA công nhận, SANVEMAYBAY.vn là đại diện cho các Hãng hàng không thuộc IATA trong việc bán vé máy bay cho khách hàng. Trách nhiệm của SANVEMAYBAY.vn là thay mặt các Hãng hàng không ký hợp đồng vận chuyển với khách hàng.",
                        textAlign: TextAlign.justify,
                        style: new TextStyle(
                            height: 1.5,
                            fontFamily: "Roboto Medium",
                            fontSize: MediaQuery.of(context).size.width*0.04),
                      ),
                    ),
                     new Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.width*0.05),),
                    new Text(
                      "B. Điều kiện chung của dịch vụ điện tử",
                      textAlign: TextAlign.start,
                      style: new TextStyle(
                          height: 1.5,
                           
                          fontFamily: "Roboto Medium",
                          fontSize: MediaQuery.of(context).size.width*0.045),
                    ),
                    new Center(
                      child: new Text(
                        "1. Chấp nhận Điều khoản sử dụng SANVEMAYBAY.vn là điều kiện cần thiết để sử dụng các dịch vụ của SANVEMAYBAY.vn và trung tâm hỗ trợ SANVEMAYBAY.vn. Điều khoản sử dụng SANVEMAYBAY.vn được đăng tải trên trang www.SANVEMAYBAY.vn/dieu-khoan-su-dung và ở phần footer của trang web www.SANVEMAYBAY.vn. Người sử dụng cần tuân theo các điều khoản này từ thời điểm bắt đầu sử dụng trang web của SANVEMAYBAY.vn và các dịch vụ của trung tâm hỗ trợ SANVEMAYBAY.vn.\n2. ĐẶT CHỖ (BOOKING): là việc người sử dụng vào trang web của SANVEMAYBAY.vn hoặc gọi điện thoại hoặc đến văn phòng công ty SANVEMAYBAY để mua vé máy bay theo các tiêu chí (ví dụ: đường bay, ngày bay) do người sử dụng lựa chọn.\n3. YÊU CẦU ĐẶT VÉ (ORDERING): là việc người sử dụng vào trang web của SANVEMAYBAY.vn hoặc thông qua Trung tâm hỗ trợ SANVEMAYBAY.vn để mua vé máy bay trên các LCC. Các ĐẶT CHỖ trên các Hãng hàng không truyền thống cũng được coi là các YÊU CẦU ĐẶT VÉ nếu vì một lý do nào đó ngoài tầm kiểm soát của SANVEMAYBAY.vn, mà việc ĐẶT CHỖ trên các Hãng hàng không truyền thống không thể thực hiện được.\n4. Người dùng cần đọc và chấp nhận các điều kiện liên quan tới ĐẶT CHỖ, YÊU CẦU ĐẶT VÉ vé máy bay và các dịch vụ khác trên trang web của SANVEMAYBAY.vn.",
                        textAlign: TextAlign.justify,
                        style: new TextStyle(
                            height: 1.5,
                            fontFamily: "Roboto Medium",
                            fontSize: MediaQuery.of(context).size.width*0.04),
                      ),
                    ),
                    new TextButton(
                      onPressed: () async {
                        var connectivityResult =
                                await new Connectivity().checkConnectivity();
                            // if (connectivityResult !=
                            //         ConnectivityResult.mobile &&
                            //     connectivityResult != ConnectivityResult.wifi) {
                            //   _confirmDialog(context,
                            //       "Không có kết nối mạng. Vui lòng kiểm tra lại.");
                            // } else {
                            //   Navigator.of(context).pushNamed("/webview");
                            // }
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
                            isOnline = results.contains(ConnectivityResult.mobile) ||
                                results.contains(ConnectivityResult.wifi) ||
                                results.contains(ConnectivityResult.ethernet) ||
                                results.contains(ConnectivityResult.vpn) ||
                                results.contains(ConnectivityResult.other);
                          }
                          else {
                            print("[BusinessRulePage][WARN] Unexpected connectivity result type");
                          }
                        } catch (error) {
                          print("[BusinessRulePage][ERROR] Parsing connectivity result failed: ${error}");
                        }

                        if (!isOnline) {
                          print("[BusinessRulePage] Treating as OFFLINE based on connectivity result. Showing dialog.");
                          _confirmDialog(context, "Không có kết nối mạng. Vui lòng kiểm tra lại.");
                        } else {
                          print("[BusinessRulePage] Online detected. Navigating to webview page.");
                          Navigator.of(context).pushNamed("/webview");
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width*0.9,
                        child: Center(
                          child: new Text(
                            "Xem chi tiết",
                            style: new TextStyle(
                                height: 1.5,
                                color: Colors.blue,
                                fontFamily: "Roboto Medium",
                                fontSize: MediaQuery.of(context).size.width*0.04),),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
  }
}

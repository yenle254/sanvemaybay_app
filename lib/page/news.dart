import 'dart:async';
// import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:sanvemaybay_app_fixed/module/custom_app_bar.dart';
import 'package:sanvemaybay_app_fixed/module/custom_drawer.dart';
import 'package:sanvemaybay_app_fixed/module/create_news_card.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:xml/xml.dart' as xml;
import 'package:sanvemaybay_app_fixed/customize_object/flight_info_object.dart';


List<String> url = [
  "https://sanvemaybay.vn/vietjet-air-khuyen-mai-700000-ve-may-bay-chi-tu-0-dong",
  "https://sanvemaybay.vn/vietjet-khuyen-mai-hon-1-trieu-ve-may-bay-chi-tu-0-dong",
  "https://sanvemaybay.vn/sieu-khuyen-mai-mua-he-voi-ve-may-bay-chi-tu-48k"
];

List<String> listImage = [
  "assets/news1.png",
  "assets/news2.jpg",
  "assets/news3.jpg"
];

List<String> imageUrl = [];

var temp;

FlightInfoObject flightObj = new FlightInfoObject();

List<String> listTitle = [
  "Vietjet Air khuyến mãi 700000 vé máy bay chỉ từ 0 đồng",
  "Vietjet khuyến mãi hơn 1 triệu vé máy bay chỉ từ 0 đồng",
  "Siêu khuyến mãi mùa hè với vé máy bay chỉ từ 48k"
];

class News extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new NewsSupport();
  }
}

class NewsSupport extends StatefulWidget {
  @override
  _NewsSupportState createState() => _NewsSupportState();
}

class _NewsSupportState extends State<NewsSupport> {
  Map<String, WidgetBuilder> listRoute = new Map();

  late String urlGetXml;
  Future<Null> _getXmlFileFuture() async {
    // urlGetXml = flightObj.storage["NewsLink"]!;
    // var res = await Future.wait([http.get(Uri.parse(urlGetXml))]);
    // listTitle = [];
    // imageUrl = [];
    // if (res[0].statusCode == 200) {
    //   var document = xml.XmlDocument.parse(res[0].body);
    //   var titles = document.findAllElements('title');
    //   listTitle = [];
    //   // titles.map((node) => node.value).forEach((value) {
    //   //   listTitle.add(value!);
    //   // });
    //   for (final node in titles) {
    //     final t = node.text.trim();
    //     if (t.isNotEmpty) listTitle.add(t);
    //   }
    //   if (listTitle.length > 1) {
    //     listTitle.removeAt(0);
    //   }
    //
    //   var links = document.findAllElements('link');
    //   url = [];
    //   // links.map((node) => node.value).forEach((value) {
    //   //   url.add(value!);
    //   // });
    //   for (final node in links) {
    //     final l = node.text.trim();
    //     if (l.isNotEmpty) url.add(l);
    //   }
    //   if (url.length > 1) {
    //     url.removeAt(0);
    //   }
    //
    //   var imgs = document.findAllElements('content:encoded');
    //   // imgs.map((node) => node.value).forEach((value) {
    //   //   int beginIndex =
    //   //       value!.indexOf(flightObj.storage["UploadLink"]!);
    //   //   int endIndex = value.indexOf(" alt=");
    //   //   imageUrl.add(value.substring(beginIndex, endIndex - 1));
    //   // });
    //   if (imgs.isEmpty) {
    //     imgs = document.findAllElements('description');
    //   }
    //   int uploadLinkMiss = 0;
    //   final uploadLink = flightObj.storage["UploadLink"] ?? "";
    //   for (final node in imgs) {
    //     final content = node.text;
    //     final beginIndex = uploadLink.isEmpty ? -1 : content.indexOf(uploadLink);
    //     final endIndex = content.indexOf(" alt=");
    //     if (beginIndex >= 0 && endIndex > beginIndex) {
    //       imageUrl.add(content.substring(beginIndex, endIndex - 1));
    //     } else {
    //       uploadLinkMiss++;
    //     }
    //   }
    // }

    await Future.delayed(Duration(milliseconds: 500));

    // Danh sách 7 tin tức giả lập để UI có thể cuộn (scroll) đẹp mắt
    listTitle = [
      "Vietjet Air khuyến mãi 700,000 vé máy bay chỉ từ 0 đồng",
      "Vietjet khuyến mãi hơn 1 triệu vé máy bay chỉ từ 0 đồng",
      "Siêu khuyến mãi mùa hè với vé máy bay chỉ từ 48k",
      "Vietnam Airlines tung ưu đãi \"Chào Thu\" giảm đến 50%",
      "Khám phá đảo ngọc Phú Quốc với combo vé & khách sạn",
      "Bamboo Airways mở đường bay thẳng mới đến Điện Biên",
      "Cập nhật quy định hành lý xách tay mới nhất năm nay"
    ];

    imageUrl = [
      "https://sanvemaybay.vn/wp-content/uploads/2021/01/ve-may-bay-di-da-lat-2.jpg",
      "https://sanvemaybay.vn/wp-content/uploads/2020/12/vé-máy-bay-đi-hà-nội-khuyến-mãi.jpg",
      "https://sanvemaybay.vn/wp-content/uploads/2020/12/ve-may-bay-di-phu-quoc.jpg",
      "https://sanvemaybay.vn/wp-content/uploads/2020/10/ve-may-bay-di-da-nang-gia-re.jpg",
      "https://sanvemaybay.vn/wp-content/uploads/2020/11/ve-may-bay-di-nha-trang.jpg",
      "https://sanvemaybay.vn/wp-content/uploads/2020/09/ve-may-bay-di-hue.jpg",
      "https://sanvemaybay.vn/wp-content/uploads/2020/08/ve-may-bay-di-quy-nhon.jpg"
    ];

    url = [
      "https://sanvemaybay.vn/vietjet-air-khuyen-mai-700000-ve-may-bay-chi-tu-0-dong",
      "https://sanvemaybay.vn/vietjet-khuyen-mai-hon-1-trieu-ve-may-bay-chi-tu-0-dong",
      "https://sanvemaybay.vn/sieu-khuyen-mai-mua-he-voi-ve-may-bay-chi-tu-48k",
      "https://sanvemaybay.vn/ve-may-bay-vietnam-airlines",
      "https://sanvemaybay.vn/ve-may-bay-di-phu-quoc",
      "https://sanvemaybay.vn/ve-may-bay-bamboo-airways",
      "https://sanvemaybay.vn/quy-dinh-hanh-ly"
    ];
  }

  @override
  void initState() {
    super.initState();
    temp = _getXmlFileFuture();
  }

  @override
  Widget build(BuildContext context) {
    listRoute.putIfAbsent("/", () => (_) => new MainPage());
    for (var i = 0; i < url.length; i++) {
      listRoute.putIfAbsent(
          "/$i",
          () => (_) => new Scaffold(
                appBar: AppBar(
                  title: new CustomAppBar("TIN TỨC", false, 110.0),
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
                    ..loadRequest(Uri.parse(url[i])),
                ),
              ));
    }
    return new MaterialApp(
      title: "Sanvemaybay.vn",
      theme: new ThemeData(
        primaryColor: Colors.red[700],
      ),
      routes: listRoute,
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainPageSupport();
  }
}

class MainPageSupport extends StatefulWidget {
  @override
  _MainPageSupportState createState() => _MainPageSupportState();
}

class _MainPageSupportState extends State<MainPageSupport> {

  printCreatedNewsCard(BuildContext context) {
    List<Widget> listCard = [];
    for (var i = 0; i < imageUrl.length; i++) {
      listCard.add(createCard(imageUrl[i], listTitle[i], "/$i", context));
    }
    return Column(
      children: listCard,
    );
    }

  // @override
  // void initState() {
  //   super.initState();
  //   webView.close();
  // }

  // @override
  // void dispose() {
  //   webView.dispose();
  //   super.dispose();
  // }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    return new ListView(
      children: <Widget>[
        new Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.0171),
        ),
        printCreatedNewsCard(context),
      ],
    );
  }

  create(String warning) {
    return new Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Icon(
            Icons.cloud_off,
            color: Colors.grey,
            size: MediaQuery.of(context).size.width * 0.2,
          ),
          new Text(
            warning,
            style: new TextStyle(
              fontFamily: "Roboto Medium",
              color: Colors.grey,
              fontSize: MediaQuery.of(context).size.width * 0.038,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var futureBuilder = new FutureBuilder(
      future: temp,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            {
              return new Center(child: new CircularProgressIndicator());
            }
          default:
            if (snapshot.hasError) {
              return create("Lỗi kết nối mạng. Bạn vui lòng thử lại.");
            } else {
              if (listTitle.length > 0) {
                return createListView(context, snapshot);
              } else {
                return create("Lỗi kết nối với máy chủ. Bạn vui lòng thử lại.");
              }
            }
        }
      },
    );

    return Scaffold(
      drawer: new CustomDrawer(),
      appBar: AppBar(
        title: new CustomAppBar("TIN TỨC", false, 110.0),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.0171),
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
      body: futureBuilder,
    );
  }
}

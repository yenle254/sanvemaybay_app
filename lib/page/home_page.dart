import 'dart:async';
// import 'dart:io';
// import 'dart:convert';
// import 'package:path_provider/path_provider.dart';
// import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sanvemaybay_app_fixed/module/create_image_card.dart';
import 'package:sanvemaybay_app_fixed/module/custom_bottom_navigation_bar.dart';
import 'package:sanvemaybay_app_fixed/module/custom_app_bar.dart';
import 'package:sanvemaybay_app_fixed/module/custom_drawer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:sanvemaybay_app_fixed/customize_object/flight_info_object.dart';

List imageUrl = [];
List depCities = [];
List arvCities = [];
List basePrice = [];
List promoTypes = [];
List<FlightInfoObject> listFlighObj = [];

FlightInfoObject tmpF = new FlightInfoObject();

late String url;

late String urlAPI;

NumberFormat f = new NumberFormat("###,###,###");

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // FlightInfoObject flightObj = new FlightInfoObject();
    // url = flightObj.storage["PromoNew"]!;
    // urlAPI = flightObj.storage["GenKeyLink"]!;
    return new MaterialApp(
      title: "Sanvemaybay.vn",
      theme: ThemeData(
        primaryColor: Colors.red[700],
      ),
      home: HomePageStateful(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'),
      ],
    );
  }
}

class HomePageStateful extends StatefulWidget {
  @override
  _HomePageStatefulState createState() => _HomePageStatefulState();
}

class _HomePageStatefulState extends State<HomePageStateful> {
  int currentTab = 0;
  Future<Null>? tmp;

  // Future<Null> _getPromoItemFuture() async {
  //   // Giả lập thời gian tải dữ liệu 1 giây
  //   await Future.delayed(Duration(seconds: 1));
  //
  //   listFlighObj = [];
  //   // Giả lập 2 banner khuyến mãi cho đẹp giao diện
  //   imageUrl = [
  //     "https://sanvemaybay.vn/wp-content/uploads/2021/01/ve-may-bay-di-da-lat-2.jpg",
  //     "https://sanvemaybay.vn/wp-content/uploads/2020/12/vé-máy-bay-đi-hà-nội-khuyến-mãi.jpg"
  //   ];
  //   depCities = ["Hồ Chí Minh", "Hồ Chí Minh"];
  //   arvCities = ["Đà Lạt", "Hà Nội"];
  //   basePrice = [99000, 199000];
  //   promoTypes = ["Khuyến mãi mùa thu", "Vé rẻ cuối tuần"];
  //
  //   for (int i = 0; i < 2; i++) {
  //     FlightInfoObject tmpObj = new FlightInfoObject();
  //     tmpObj.depart = depCities[i];
  //     tmpObj.destination = arvCities[i];
  //     // Mặc định ngày đi là 7 ngày sau
  //     tmpObj.dateDepart = DateTime.now().add(Duration(days: 7));
  //     tmpObj.dateBack = DateTime.now().add(Duration(days: 10));
  //     tmpObj.isOneWayTrip = true;
  //     tmpObj.isRoundTrip = false;
  //     tmpObj.depCode = i == 0 ? "SGN" : "SGN";
  //     tmpObj.arvCode = i == 0 ? "DLI" : "HAN";
  //     listFlighObj.add(tmpObj);
  //   }
  // }

  Future<Null> _getPromoItemFuture() async {
    // Giả lập thời gian tải dữ liệu
    await Future.delayed(Duration(milliseconds: 500));

    listFlighObj = [];

    // 15 Link ảnh phong cảnh chất lượng cao (từ Unsplash)
    imageUrl = [
      "https://picsum.photos/seed/hcm/600/400",
      "https://picsum.photos/seed/danang/600/400",
      "https://picsum.photos/seed/nhatrang/600/400",
      "https://picsum.photos/seed/phuquoc/600/400",
      "https://picsum.photos/seed/dalat/600/400",
      "https://picsum.photos/seed/hue/600/400",
      "https://picsum.photos/seed/quynhon/600/400",
      "https://picsum.photos/seed/cantho/600/400",
      "https://picsum.photos/seed/condao/600/400",
      "https://picsum.photos/seed/donghoi/600/400",
      "https://picsum.photos/seed/chulai/600/400",
      "https://picsum.photos/seed/tuyhoa/600/400",
      "https://picsum.photos/seed/pleiku/600/400",
      "https://picsum.photos/seed/bmt/600/400",
      "https://picsum.photos/seed/dienbien/600/400" // Điện Biên
    ];

    // Cố định điểm đi là Hà Nội cho 15 thẻ
    depCities = List.generate(15, (index) => "Hà Nội");

    // 15 Điểm đến tương ứng trải dài Việt Nam
    arvCities = [
      "Hồ Chí Minh", "Đà Nẵng", "Nha Trang", "Phú Quốc", "Đà Lạt",
      "Huế", "Quy Nhơn", "Cần Thơ", "Côn Đảo", "Đồng Hới",
      "Chu Lai", "Tuy Hòa", "Pleiku", "Ban Mê Thuột", "Điện Biên"
    ];

    List<String> arvCodes = [
      "SGN", "DAD", "CXR", "PQC", "DLI",
      "HUI", "UIH", "VCA", "VCS", "VDH",
      "VCL", "TBB", "PXU", "BMV", "DIN"
    ];

    // Tạo giá ngẫu nhiên và câu slogan cho 15 thẻ
    basePrice = [
      790000, 590000, 690000, 890000, 690000,
      490000, 590000, 890000, 1200000, 390000,
      490000, 590000, 790000, 790000, 690000
    ];

    promoTypes = [
      "Sài Gòn năng động", "Biển xanh Đà Nẵng", "Nha Trang vẫy gọi", "Thiên đường Phú Quốc", "Đà Lạt sương mù",
      "Cố đô Huế mộng mơ", "Quy Nhơn biển nhớ", "Khám phá miền Tây", "Côn Đảo huyền thoại", "Đồng Hới Quảng Bình",
      "Chu Lai rực rỡ", "Tuy Hòa hoa vàng", "Phố núi Pleiku", "Cao nguyên đại ngàn", "Điện Biên lịch sử"
    ];

    // Đóng gói dữ liệu
    for (int i = 0; i < imageUrl.length; i++) {
      FlightInfoObject tmpObj = new FlightInfoObject();
      tmpObj.depart = "Hà Nội";
      tmpObj.depCode = "HAN";
      tmpObj.destination = arvCities[i];
      tmpObj.arvCode = arvCodes[i];
      tmpObj.dateDepart = DateTime.now().add(Duration(days: 7));
      tmpObj.dateBack = DateTime.now().add(Duration(days: 10));
      tmpObj.isOneWayTrip = true;
      tmpObj.isRoundTrip = false;
      listFlighObj.add(tmpObj);
    }
  }

  @override
  void initState() {
    super.initState();
    // Gọi ngay hàm giả lập lấy vé khuyến mãi
    tmp = _getPromoItemFuture();
  }



  createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<Widget> list = [];
    for (int i = listFlighObj.length-1; i >= 0; i--){
      list.add(
        createCard(imageUrl[i], depCities[i], arvCities[i], context,
            f.format(basePrice[i]), listFlighObj[i], promoTypes[i])
      );
    }
    return new ListView(
      children: list,
    );
  }

  create(String warning) {
    return new Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Icon(Icons.cloud_off, color: Colors.grey, size: MediaQuery.of(context).size.width * 0.2,),
          new Text(
            warning,
            style: new TextStyle(
                    fontFamily: "Roboto Medium",
                    color: Colors.grey,
                    fontSize: MediaQuery.of(context).size.width*0.038,
                  ),),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var futureBuilder = new FutureBuilder(
        future: tmp,
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
                return create("Lỗi kết nối mạng. Bạn vui lòng thử lại");
              } else {
                if (listFlighObj.length > 0){
                  return createListView(context, snapshot);
                } else {
                  return create("Lỗi kết nối đến máy chủ. Bạn vui lòng thử lại.");
                }
              }
          }
        },
      );
    
    return new Scaffold(
      drawer: new CustomDrawer(),
      appBar: new AppBar(
        title: new CustomAppBar("SANVEMAYBAY.VN", true, 8.0),
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
         
      bottomNavigationBar: new CustomBottomNavigationBar(currentTab),
    );
  }
}

// import 'dart:async';
// import 'dart:convert';
// import 'package:http/http.dart' as http;

import '../utils/firebase_service.dart';
import '../customize_object/flight_model.dart';

import 'package:flutter/material.dart';
import 'package:sanvemaybay_app_fixed/module/custom_app_bar.dart';
import 'package:sanvemaybay_app_fixed/module/custom_drawer.dart';
import 'package:sanvemaybay_app_fixed/customize_object/flight_info_object.dart';
import 'package:intl/intl.dart';
import 'package:sanvemaybay_app_fixed/page/select_flight_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sanvemaybay_app_fixed/customize_object/date_object.dart';

int currentSelectedDateDepart = -1;
int currentSelectedDateBack = -1;

ScrollController _scrollController = new ScrollController();

DateFormat formatter = new DateFormat("dd/MM/yyyy");

NumberFormat f = NumberFormat("###,###");

DateTime today =
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

DateTime selectedDay =
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

DateTime selectedDayBack =
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

late String url1;
// late String url2;

FlightInfoObject tmpF = new FlightInfoObject();

Map<String, String> listAirportID = {
  "Hồ Chí Minh": "SGN",
  "Cần Thơ": "VCA",
  "Côn Đảo": "VCS",
  "Phú Quốc": "PQC",
  "Rạch Giá": "VKG",
  "Cà Mau": "CAH",
  "Hà Nội": "HAN",
  "Hải Phòng": "HPH",
  "Điện Biên": "DIN",
  "Đà Nẵng": "DAD",
  "Thanh Hóa": "THD",
  "Vinh": "VII",
  "Huế": "HUI",
  "Đồng Hới": "VDH",
  "Chu Lai": "VCL",
  "Quy Nhơn": "UIH",
  "Tuy Hòa": "TBB",
  "Nha Trang": "CXR",
  "Pleiku": "PXU",
  "Ban Mê Thuột": "BMV",
  "Đà Lạt": "DLI",
  "Vân Đồn": "VDO",
};

DateFormat df = new DateFormat("yyyy-MM-dd");

FlightInfoObject? tmpFlightInfo;

class SelectDateSalePage extends StatelessWidget {
  final FlightInfoObject flightInfo;

  SelectDateSalePage(this.flightInfo);

  @override
  Widget build(BuildContext context) {
    tmpFlightInfo = flightInfo;
    // url1 = flightInfo.storage["CheapFlightsNew"]!;
    return new SelectDateSalePageSupport();
  }
}

class SelectDateSalePageSupport extends StatefulWidget {
  @override
  _SelectDateSalePageSupportState createState() =>
      _SelectDateSalePageSupportState();
}

class _SelectDateSalePageSupportState extends State<SelectDateSalePageSupport> {
  String? departId;
  String? destinationId;

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
  void initState() {
    super.initState();
    if (tmpFlightInfo!.depCode.length > 0) {
      departId = tmpFlightInfo!.depCode;
    } else {
      departId = listAirportID[tmpFlightInfo!.depart];
    }
    if (tmpFlightInfo!.arvCode.length > 0) {
      destinationId = tmpFlightInfo!.arvCode;
    } else {
      destinationId = listAirportID[tmpFlightInfo!.destination];
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Sanvemaybay.vn",
      theme: new ThemeData(
        primaryColor: Colors.red[700],
      ),
      home: Scaffold(
        drawer: new CustomDrawer(),
        appBar: AppBar(
          title: new CustomAppBar("VÉ RẺ TRONG THÁNG", false, 70.0),
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
        ),
        body: ListView(
          scrollDirection: Axis.vertical,
          controller: _scrollController,
          children: <Widget>[
            new Container(
              padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  new Text(
                    "LỰA CHỌN NGÀY ĐI",
                    style: new TextStyle(
                      color: Colors.black,
                      fontFamily: "Roboto Medium",
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                    ),
                  ),
                  //
                  new Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new Text(
                        departId!,
                        style: new TextStyle(
                            color: Colors.grey[500],
                            fontFamily: "Roboto Medium",
                            fontSize: MediaQuery.of(context).size.width * 0.04),
                      ),
                      new Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.0143,
                            right: MediaQuery.of(context).size.width * 0.0143),
                        child: Image.asset(
                          "assets/plane.png",
                          width: MediaQuery.of(context).size.width * 0.0429,
                          fit: BoxFit.cover,
                          color: Colors.amber,
                        ),
                      ),
                      new Text(
                        destinationId!,
                        style: new TextStyle(
                            color: Colors.grey[500],
                            fontFamily: "Roboto Medium",
                            fontSize: MediaQuery.of(context).size.width * 0.04),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            //Note for users------------------------------------------
            new Container(
              padding: EdgeInsets.only(top: 5.0, left: 20.0, right: 10.0),
              child: new Row(
                children: <Widget>[
                  new Icon(
                    Icons.notifications,
                    color: Colors.amber,
                    size: MediaQuery.of(context).size.width * 0.05,
                  ),
                  new Text(
                    " Chọn một ngày bất kì để tiếp tục.",
                    style: new TextStyle(
                        color: Colors.grey[500],
                        fontFamily: "Roboto Medium",
                        fontSize: MediaQuery.of(context).size.width * 0.035),
                  ),
                ],
              ),
            ),
            //--------------------------------------------------------
            //
            Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
              child: new Container(
                width: MediaQuery.of(context).size.width,
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
                color: Colors.orangeAccent,
                child: new Center(
                  child: new Text(
                    "Tháng ${tmpFlightInfo!.dateDepart.month}/${tmpFlightInfo!.dateDepart.year}",
                    style: new TextStyle(
                      color: Colors.black,
                      fontFamily: "Roboto Medium",
                      fontSize: MediaQuery.of(context).size.width * 0.042,
                    ),
                  ),
                ),
              ),
            ),
            new SaleCalender("đi", tmpFlightInfo!.dateDepart.month,
                tmpFlightInfo!.dateDepart.year, tmpFlightInfo!),
            tmpFlightInfo!.isRoundTrip
                ? new Container(
                    padding:
                        EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        new Text(
                          "LỰA CHỌN NGÀY VỀ",
                          style: new TextStyle(
                            color: Colors.black,
                            fontFamily: "Roboto Medium",
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                          ),
                        ),

                        //============================
                        new Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            new Text(
                              destinationId!,
                              style: new TextStyle(
                                  color: Colors.grey[500],
                                  fontFamily: "Roboto Medium",
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04),
                            ),
                            new Padding(
                              padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width *
                                      0.0143,
                                  right: MediaQuery.of(context).size.width *
                                      0.0143),
                              child: Image.asset(
                                "assets/plane.png",
                                width:
                                    MediaQuery.of(context).size.width * 0.0429,
                                fit: BoxFit.cover,
                                color: Colors.amber,
                              ),
                            ),
                            new Text(
                              departId!,
                              style: new TextStyle(
                                  color: Colors.grey[500],
                                  fontFamily: "Roboto Medium",
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : new Container(),
            //
            //Note for users------------------------------------------
            tmpFlightInfo!.isRoundTrip
                ? new Container(
                    padding: EdgeInsets.only(top: 5.0, left: 20.0, right: 10.0),
                    child: new Row(
                      children: <Widget>[
                        new Icon(
                          Icons.notifications,
                          color: Colors.amber,
                          size: MediaQuery.of(context).size.width * 0.05,
                        ),
                        new Text(
                          " Chọn một ngày bất kì để tiếp tục.",
                          style: new TextStyle(
                              color: Colors.grey[500],
                              fontFamily: "Roboto Medium",
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.035),
                        ),
                      ],
                    ),
                  )
                : new Container(),
            //--------------------------------------------------------
            tmpFlightInfo!.isRoundTrip
                ? Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.03),
                    child: new Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.03),
                      color: Colors.orangeAccent,
                      child: new Center(
                        child: new Text(
                          "Tháng ${tmpFlightInfo!.dateBack.month}/${tmpFlightInfo!.dateBack.year}",
                          style: new TextStyle(
                            color: Colors.black,
                            fontFamily: "Roboto Medium",
                            fontSize: MediaQuery.of(context).size.width * 0.042,
                          ),
                        ),
                      ),
                    ),
                  )
                : new Container(),
            tmpFlightInfo!.isRoundTrip
                ? new SaleCalender("về", tmpFlightInfo!.dateBack.month,
                    tmpFlightInfo!.dateBack.year, tmpFlightInfo!)
                : new Container(),
            //---------------------
            Padding(
              padding: EdgeInsets.all(20.0),
            )
          ].toList(),
        ),
        bottomNavigationBar: new TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.all(0.0),
          ),
          onPressed: () {
            DateTime tmpDepart = new DateTime(tmpFlightInfo!.dateDepart.year,
                tmpFlightInfo!.dateDepart.month, tmpFlightInfo!.dateDepart.day);
            DateTime tmpBack = new DateTime(tmpFlightInfo!.dateBack.year,
                tmpFlightInfo!.dateBack.month, tmpFlightInfo!.dateBack.day);
            if ((tmpFlightInfo!.isRoundTrip &&
                    tmpDepart.compareTo(tmpBack) > 0) ||
                (currentSelectedDateBack == -1 && tmpFlightInfo!.isRoundTrip) ||
                    currentSelectedDateDepart == -1) {
              _confirmDialog(context,
                  "Ngày đi và ngày về không hợp lệ. Vui lòng kiểm tra lại.");
            } else {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (context) => new SelectFlightPage(tmpFlightInfo!)));
            }
          },
          child: new Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.width * 0.12,
            padding: EdgeInsets.all(15.0),
            decoration: new BoxDecoration(
              color: Color.fromRGBO(18, 175, 60, 1.0),
            ),
            child: new Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text(
                    "TIẾP TỤC",
                    style: new TextStyle(
                        color: Colors.white,
                        fontFamily: "Roboto Medium",
                        fontSize: MediaQuery.of(context).size.width * 0.0457),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.02),
                    child: new Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//Draw Sale Calendar
class SaleCalender extends StatelessWidget {
  final String type;
  final int month;
  final int year;
  final FlightInfoObject flightInfo;

  SaleCalender(this.type, this.month, this.year, this.flightInfo);

  @override
  Widget build(BuildContext context) {
    return SaleCalendarSupport(type, month, year, flightInfo);
  }
}

class SaleCalendarSupport extends StatefulWidget {
  final String type;
  final int month;
  final int year;
  final FlightInfoObject flightInfo;

  SaleCalendarSupport(this.type, this.month, this.year, this.flightInfo);
  @override
  _SaleCalendarSupportState createState() => _SaleCalendarSupportState();
}

class _SaleCalendarSupportState extends State<SaleCalendarSupport> {
  List<DateObject> listDate = [];
  DateTime? firstDate;
  DateTime? endDate;
  DateTime today = new DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);

  String? departId;
  String? destinationId;
  String apiKey = "";

  Map<String, dynamic>? list;

  Future<Null>? tmp;

  double cheapestPriceDep = 10000.0;

  double cheapestPriceArv = 10000.0;

  // Future<Null> _getData(String outboundDate, String domain, String depCode,
  //     String arvCode, String adtCount, String chdCount, String infCount) async {
  //
  //   var res = await Future.wait([
  //     http.post(Uri.parse(url1), headers: {
  //       tmpF.storage["NewK"]!: apiKey,
  //     }, body: {
  //       "dep_code": depCode,
  //       "arv_code": arvCode,
  //       "outbound_date": outboundDate,
  //       "adt_count": adtCount,
  //       "chd_count": chdCount,
  //       "inf_count": infCount,
  //       // "domain": tmpF.storage["D"],
  //       "provider_code": "BL",
  //     }).then((response) {
  //       return response;
  //     }),
  //     http.post(Uri.parse(url1), headers: {
  //       tmpF.storage["NewK"]!: apiKey,
  //     }, body: {
  //       "dep_code": depCode,
  //       "arv_code": arvCode,
  //       "outbound_date": outboundDate,
  //       "adt_count": adtCount,
  //       "chd_count": chdCount,
  //       "inf_count": infCount,
  //       // "domain": tmpF.storage["D"],
  //       "provider_code": "VJ",
  //     }).then((response) {
  //
  //       return response;
  //     }),
  //     http.post(Uri.parse(url1), headers: {
  //       tmpF.storage["NewK"]!: apiKey,
  //     }, body: {
  //       "dep_code": depCode,
  //       "arv_code": arvCode,
  //       "outbound_date": outboundDate,
  //       "adt_count": adtCount,
  //       "chd_count": chdCount,
  //       "inf_count": infCount,
  //       // "domain": tmpF.storage["D"],
  //       "provider_code": "VN",
  //     }).then((response) {
  //
  //       return response;
  //     }),
  //     http.post(Uri.parse(url1), headers: {
  //       tmpF.storage["NewK"]!: apiKey,
  //     }, body: {
  //       "dep_code": depCode,
  //       "arv_code": arvCode,
  //       "outbound_date": outboundDate,
  //       "adt_count": adtCount,
  //       "chd_count": chdCount,
  //       "inf_count": infCount,
  //       // "domain": tmpF.storage["D"],
  //       "provider_code": "VU",
  //     }).then((response) {
  //       return response;
  //     }),
  //     http.post(Uri.parse(url1), headers: {
  //       tmpF.storage["NewK"]!: apiKey,
  //     }, body: {
  //       "dep_code": depCode,
  //       "arv_code": arvCode,
  //       "outbound_date": outboundDate,
  //       "adt_count": adtCount,
  //       "chd_count": chdCount,
  //       "inf_count": infCount,
  //       // "domain": tmpF.storage["D"],
  //       "provider_code": "QH",
  //     }).then((response) {
  //
  //       return response;
  //     }),
  //   ]);
  //
  //   if (res[0].statusCode == 201) {
  //     var resBody1 = json.decode(res[0].body);
  //     if (resBody1["error"] == false) {
  //       list = resBody1["data"];
  //       Map tmp = list!["outbound"];
  //       for (int count = 0; count < tmp.length; count++) {
  //         int price = 10000000;
  //         if (tmp[(count + 1).toString()] != "") {
  //           price = num.parse(tmp[(count + 1).toString()]) as int;
  //         }
  //         if (widget.type.contains("đi")) {
  //           for (int j = 0; j < listDate.length; j++) {
  //             if ((count + 1) == listDate[j].date.day &&
  //                 listDate[j].priceDepart > price * 0.001) {
  //               listDate[j].priceDepart = price * 0.001;
  //               if (cheapestPriceDep > listDate[j].priceDepart)
  //                 cheapestPriceDep = listDate[j].priceDepart;
  //             }
  //           }
  //         } else {
  //           for (int j = 0; j < listDate.length; j++) {
  //             if ((count + 1) == listDate[j].date.day &&
  //                 listDate[j].priceBack > price * 0.001) {
  //               listDate[j].priceBack = price * 0.001;
  //               if (cheapestPriceArv > listDate[j].priceBack)
  //                 cheapestPriceArv = listDate[j].priceBack;
  //             }
  //           }
  //         }
  //       }
  //     }
  //   }
  //   if (res[1].statusCode == 201) {
  //     var resBody2 = json.decode(res[1].body);
  //     if (resBody2["error"] == false) {
  //       list = resBody2["data"];
  //       Map tmp = list!["outbound"];
  //       for (int count = 0; count < tmp.length; count++) {
  //         int price = 10000000;
  //         if (tmp[(count + 1).toString()] != "") {
  //           price = num.parse(tmp[(count + 1).toString().trim()]) as int;
  //         }
  //         if (widget.type.contains("đi")) {
  //           for (int j = 0; j < listDate.length; j++) {
  //             if ((count + 1) == listDate[j].date.day &&
  //                 listDate[j].priceDepart > price * 0.001) {
  //               listDate[j].priceDepart = price * 0.001;
  //             }
  //             if (cheapestPriceDep > listDate[j].priceDepart)
  //               cheapestPriceDep = listDate[j].priceDepart;
  //           }
  //         } else {
  //           for (int j = 0; j < listDate.length; j++) {
  //             if ((count + 1) == listDate[j].date.day &&
  //                 listDate[j].priceBack > price * 0.001) {
  //               listDate[j].priceBack = price * 0.001;
  //             }
  //             if (cheapestPriceArv > listDate[j].priceBack)
  //               cheapestPriceArv = listDate[j].priceBack;
  //           }
  //         }
  //       }
  //     }
  //   }
  //       if (res[2].statusCode == 201) {
  //     var resBody3 = json.decode(res[2].body);
  //     if (resBody3["error"] == false) {
  //       list = resBody3["data"];
  //       Map tmp = list!["outbound"];
  //       for (int count = 0; count < tmp.length; count++) {
  //         int price = 10000000;
  //         if (tmp[(count + 1).toString()] != "") {
  //           price = num.parse(tmp[(count + 1).toString().trim()]) as int;
  //         }
  //         if (widget.type.contains("đi")) {
  //           for (int j = 0; j < listDate.length; j++) {
  //             if ((count + 1) == listDate[j].date.day &&
  //                 listDate[j].priceDepart > price * 0.001) {
  //               listDate[j].priceDepart = price * 0.001;
  //             }
  //             if (cheapestPriceDep > listDate[j].priceDepart)
  //               cheapestPriceDep = listDate[j].priceDepart;
  //           }
  //         } else {
  //           for (int j = 0; j < listDate.length; j++) {
  //             if ((count + 1) == listDate[j].date.day &&
  //                 listDate[j].priceBack > price * 0.001) {
  //               listDate[j].priceBack = price * 0.001;
  //             }
  //             if (cheapestPriceArv > listDate[j].priceBack)
  //               cheapestPriceArv = listDate[j].priceBack;
  //           }
  //         }
  //       }
  //     }
  //   }
  //       if (res[3].statusCode == 201) {
  //     var resBody4 = json.decode(res[3].body);
  //     if (resBody4["error"] == false) {
  //       list = resBody4["data"];
  //       Map tmp = list!["outbound"];
  //       for (int count = 0; count < tmp.length; count++) {
  //         int price = 10000000;
  //         if (tmp[(count + 1).toString()] != "") {
  //           price = num.parse(tmp[(count + 1).toString().trim()]) as int;
  //         }
  //         if (widget.type.contains("đi")) {
  //           for (int j = 0; j < listDate.length; j++) {
  //             if ((count + 1) == listDate[j].date.day &&
  //                 listDate[j].priceDepart > price * 0.001) {
  //               listDate[j].priceDepart = price * 0.001;
  //             }
  //             if (cheapestPriceDep > listDate[j].priceDepart)
  //               cheapestPriceDep = listDate[j].priceDepart;
  //           }
  //         } else {
  //           for (int j = 0; j < listDate.length; j++) {
  //             if ((count + 1) == listDate[j].date.day &&
  //                 listDate[j].priceBack > price * 0.001) {
  //               listDate[j].priceBack = price * 0.001;
  //             }
  //             if (cheapestPriceArv > listDate[j].priceBack)
  //               cheapestPriceArv = listDate[j].priceBack;
  //           }
  //         }
  //       }
  //     }
  //   }
  //       if (res[4].statusCode == 201) {
  //     var resBody5 = json.decode(res[4].body);
  //     if (resBody5["error"] == false) {
  //       list = resBody5["data"];
  //       Map tmp = list!["outbound"];
  //       for (int count = 0; count < tmp.length; count++) {
  //         int price = 10000000;
  //         if (tmp[(count + 1).toString()] != "") {
  //           price = num.parse(tmp[(count + 1).toString().trim()]) as int;
  //         }
  //         if (widget.type.contains("đi")) {
  //           for (int j = 0; j < listDate.length; j++) {
  //             if ((count + 1) == listDate[j].date.day &&
  //                 listDate[j].priceDepart > price * 0.001) {
  //               listDate[j].priceDepart = price * 0.001;
  //             }
  //             if (cheapestPriceDep > listDate[j].priceDepart)
  //               cheapestPriceDep = listDate[j].priceDepart;
  //           }
  //         } else {
  //           for (int j = 0; j < listDate.length; j++) {
  //             if ((count + 1) == listDate[j].date.day &&
  //                 listDate[j].priceBack > price * 0.001) {
  //               listDate[j].priceBack = price * 0.001;
  //             }
  //             if (cheapestPriceArv > listDate[j].priceBack)
  //               cheapestPriceArv = listDate[j].priceBack;
  //           }
  //         }
  //       }
  //     }
  //   }
  // }

  Future<Null> _getData(String outboundDate, String domain, String depCode,
      String arvCode, String adtCount, String chdCount, String infCount) async {

    // Giả lập thời gian tải dữ liệu 0.5 giây
    await Future.delayed(Duration(milliseconds: 500));

    if (!mounted) return;

    setState(() {
      // Giả lập giá vé ngẫu nhiên cho các ngày trong lịch (từ 500k - 1tr5) để UI hiển thị đẹp
      for (int j = 0; j < listDate.length; j++) {
        double mockPrice = 500.0 + (j % 5) * 200.0 + (j % 3) * 150.0;

        if (widget.type.contains("đi")) {
          listDate[j].priceDepart = mockPrice;
          if (cheapestPriceDep > listDate[j].priceDepart) {
            cheapestPriceDep = listDate[j].priceDepart;
          }
        } else {
          listDate[j].priceBack = mockPrice;
          if (cheapestPriceArv > listDate[j].priceBack) {
            cheapestPriceArv = listDate[j].priceBack;
          }
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    apiKey = tmpFlightInfo!.apiKey;
    if (tmpFlightInfo!.depCode.length > 0) {
      departId = tmpFlightInfo!.depCode;
    } else {
      departId = listAirportID[tmpFlightInfo!.depart];
    }
    if (tmpFlightInfo!.arvCode.length > 0) {
      destinationId = tmpFlightInfo!.arvCode;
    } else {
      destinationId = listAirportID[tmpFlightInfo!.destination];
    }
    // if (widget.type.contains("đi")) {
    //   tmp = _getData(
    //     df.format(tmpFlightInfo!.dateDepart),
    //     tmpFlightInfo!.storage["last"]!,
    //     departId!,
    //     destinationId!,
    //     tmpFlightInfo!.noOfAdult.toString(),
    //     tmpFlightInfo!.noOfChild.toString(),
    //     tmpFlightInfo!.noOfInfant.toString(),
    //   );
    // } else {
    //   tmp = _getData(
    //     df.format(tmpFlightInfo!.dateBack),
    //     tmpFlightInfo!.storage["last"]!,
    //     destinationId!,
    //     departId!,
    //     tmpFlightInfo!.noOfAdult.toString(),
    //     tmpFlightInfo!.noOfChild.toString(),
    //     tmpFlightInfo!.noOfInfant.toString(),
    //   );
    // }

    if (widget.type.contains("đi")) {
      tmp = _getData(
        df.format(tmpFlightInfo!.dateDepart),
        "",
        departId!,
        destinationId!,
        tmpFlightInfo!.noOfAdult.toString(),
        tmpFlightInfo!.noOfChild.toString(),
        tmpFlightInfo!.noOfInfant.toString(),
      );
    } else {
      tmp = _getData(
        df.format(tmpFlightInfo!.dateBack),
        "",
        destinationId!,
        departId!,
        tmpFlightInfo!.noOfAdult.toString(),
        tmpFlightInfo!.noOfChild.toString(),
        tmpFlightInfo!.noOfInfant.toString(),
      );
    }

    firstDate = DateTime(widget.year, widget.month, 1);
    int max = 31;
    if ((widget.month == 4) ||
        (widget.month == 6) ||
        (widget.month == 9) ||
        (widget.month == 11))
      max = 30;
    else if (widget.month == 2) {
      if ((widget.year % 4 == 0) && (widget.year % 100 != 0) ||
          (widget.year % 400 == 0))
        max = 29;
      else
        max = 28;
    }
    endDate = DateTime(widget.year, widget.month, max);
    if (7 - firstDate!.weekday > 0) {
      for (int i = firstDate!.weekday; i > 0; i--) {
        DateObject tmp = new DateObject();
        tmp.date = firstDate!.subtract(Duration(days: i));
        listDate.add(tmp);
      }
    }
    for (var i = 1; i <= max; i++) {
      DateObject tmp = new DateObject();
      tmp.date = DateTime(widget.year, widget.month, i);
      listDate.add(tmp);
    }
    if (6 - endDate!.weekday > 0) {
      for (var i = 1; i <= 6 - endDate!.weekday; i++) {
        DateObject tmp = new DateObject();
        tmp.date = endDate!.add(Duration(days: i));
        listDate.add(tmp);
      }
    }
    if (endDate!.weekday == 7) {
      for (var i = 1; i <= 6; i++) {
        DateObject tmp = new DateObject();
        tmp.date = endDate!.add(Duration(days: i));
        listDate.add(tmp);
      }
    }
    if (widget.type.contains("đi"))
      currentSelectedDateDepart = findIndexDateInList(today);
    if (widget.type.contains("về"))
      currentSelectedDateBack = findIndexDateInList(today);
  }

  findIndexDateInList(DateTime date) {
    for (var i = 0; i < listDate.length; i++) {
      if (listDate[i].date.compareTo(date) == 0) {
        return i;
      }
    }
    return -1;
  }

  buildCalendar() {
    List<Row> list = [];
    list.add(new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Container(
          width: MediaQuery.of(context).size.width * 0.132,
          height: MediaQuery.of(context).size.width * 0.132,
          decoration: new BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.amber, width: 1.0)),
          ),
          child: Center(
            child: new Text(
              "CN",
              style: new TextStyle(
                  color: Colors.red,
                  fontFamily: "Roboto Medium",
                  fontSize: MediaQuery.of(context).size.width * 0.0343),
            ),
          ),
        ),
        //
        new Container(
          width: MediaQuery.of(context).size.width * 0.132,
          height: MediaQuery.of(context).size.width * 0.132,
          decoration: new BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.amber, width: 1.0)),
          ),
          child: Center(
            child: new Text(
              "T2",
              style: new TextStyle(
                  color: Colors.black,
                  fontFamily: "Roboto Medium",
                  fontSize: MediaQuery.of(context).size.width * 0.0343),
            ),
          ),
        ),
        //
        new Container(
          width: MediaQuery.of(context).size.width * 0.132,
          height: MediaQuery.of(context).size.width * 0.132,
          decoration: new BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.amber, width: 1.0)),
          ),
          child: Center(
            child: new Text(
              "T3",
              style: new TextStyle(
                  color: Colors.black,
                  fontFamily: "Roboto Medium",
                  fontSize: MediaQuery.of(context).size.width * 0.0343),
            ),
          ),
        ),
        new Container(
          width: MediaQuery.of(context).size.width * 0.132,
          height: MediaQuery.of(context).size.width * 0.132,
          decoration: new BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.amber, width: 1.0)),
          ),
          child: Center(
            child: new Text(
              "T4",
              style: new TextStyle(
                  color: Colors.black,
                  fontFamily: "Roboto Medium",
                  fontSize: MediaQuery.of(context).size.width * 0.0343),
            ),
          ),
        ),
        //
        new Container(
          width: MediaQuery.of(context).size.width * 0.132,
          height: MediaQuery.of(context).size.width * 0.132,
          decoration: new BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.amber, width: 1.0)),
          ),
          child: Center(
            child: new Text(
              "T5",
              style: new TextStyle(
                  color: Colors.black,
                  fontFamily: "Roboto Medium",
                  fontSize: MediaQuery.of(context).size.width * 0.0343),
            ),
          ),
        ),
        //
        new Container(
          width: MediaQuery.of(context).size.width * 0.132,
          height: MediaQuery.of(context).size.width * 0.132,
          decoration: new BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.amber, width: 1.0)),
          ),
          child: Center(
            child: new Text(
              "T6",
              style: new TextStyle(
                  color: Colors.black,
                  fontFamily: "Roboto Medium",
                  fontSize: MediaQuery.of(context).size.width * 0.0343),
            ),
          ),
        ),
        //
        new Container(
          width: MediaQuery.of(context).size.width * 0.132,
          height: MediaQuery.of(context).size.width * 0.132,
          decoration: new BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.amber, width: 1.0)),
          ),
          child: Center(
            child: new Text(
              "T7",
              style: new TextStyle(
                  color: Colors.black,
                  fontFamily: "Roboto Medium",
                  fontSize: MediaQuery.of(context).size.width * 0.0343),
            ),
          ),
        ),
      ],
    ));
    List<Widget> elementBoxes = [];
    for (int i = 0; i < listDate.length; i++) {
      if ((i + 1) % 7 == 1) {
        list.add(new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: elementBoxes,
        ));
        elementBoxes = [];
      }
      elementBoxes.add(
        new Container(
          width: MediaQuery.of(context).size.width * 0.132,
          height: MediaQuery.of(context).size.width * 0.132,
          decoration: new BoxDecoration(
            color: Colors.white,
          ),
          child: listDate[i].date.month == widget.month
              ? Center(
                  child: listDate[i].date.compareTo(today) >= 0
                      ? new CircleAvatar(
                          backgroundColor: (i == currentSelectedDateDepart &&
                                      widget.type.contains("đi")) ||
                                  (i == currentSelectedDateBack &&
                                      widget.type.contains("về"))
                              ? Colors.orangeAccent
                              : Colors.white,
                          radius: MediaQuery.of(context).size.width * 0.065,
                          child: new InkResponse(
                            onTap: () {
                              setState(() {
                                widget.type.contains("đi")
                                    ? currentSelectedDateDepart = i
                                    : currentSelectedDateBack = i;
                                widget.type.contains("đi")
                                    ? tmpFlightInfo!.dateDepart =
                                        listDate[i].date
                                    : tmpFlightInfo!.dateBack = listDate[i].date;
                              });
                              if (widget.type.contains("đi")) {
                                _scrollController.animateTo(
                                  MediaQuery.of(context).size.height * 0.6,
                                  curve: Curves.ease,
                                  duration: new Duration(milliseconds: 300),
                                );
                              }
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Text(
                                  widget.type.contains("đi")
                                      ? listDate[i].priceDepart < 10000.0
                                          ? "${f.format(listDate[i].priceDepart)}K"
                                          : ""
                                      : listDate[i].priceBack < 10000.0
                                          ? "${f.format(listDate[i].priceBack)}K"
                                          : "",
                                  style: new TextStyle(
                                    color: (i == currentSelectedDateDepart &&
                                                widget.type.contains("đi")) ||
                                            (i == currentSelectedDateBack &&
                                                widget.type.contains("về"))
                                        ? Colors.black
                                        : (widget.type.contains("đi") &&
                                                    listDate[i].priceDepart ==
                                                        cheapestPriceDep) ||
                                                (widget.type.contains("về") &&
                                                    listDate[i].priceBack ==
                                                        cheapestPriceArv)
                                            ? Colors.amber
                                            : Colors.grey[500],
                                    fontWeight: (i ==
                                                    currentSelectedDateDepart &&
                                                widget.type.contains("đi")) ||
                                            (i == currentSelectedDateBack &&
                                                widget.type.contains("về"))
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    fontFamily: "Roboto Medium",
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.03,
                                  ),
                                ),
                                new Padding(
                                  padding: EdgeInsets.all(
                                      MediaQuery.of(context).size.width *
                                          0.005),
                                ),
                                new Text(
                                  "${listDate[i].date.day}",
                                  textAlign: TextAlign.right,
                                  style: new TextStyle(
                                    color: (i == currentSelectedDateDepart &&
                                                widget.type.contains("đi")) ||
                                            (i == currentSelectedDateBack &&
                                                widget.type.contains("về"))
                                        ? Colors.white
                                        : listDate[i].date.weekday == 7
                                            ? Colors.red
                                            : Colors.blueAccent[700],
                                    fontWeight: (i ==
                                                    currentSelectedDateDepart &&
                                                widget.type.contains("đi")) ||
                                            (i == currentSelectedDateBack &&
                                                widget.type.contains("về"))
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    fontFamily: "Roboto Medium",
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.028,
                                  ),
                                ),
                              ],
                            ),
                          ))
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Text(
                                "${listDate[i].date.day}",
                                style: new TextStyle(
                                  color: listDate[i].date.weekday == 7
                                      ? Colors.red
                                      : Colors.blueAccent[700],
                                  fontFamily: "Roboto Medium",
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.028,
                                ),
                              ),
                              new Padding(
                                padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.width * 0.005),
                              ),
                              new Text(
                                "",
                                style: new TextStyle(
                                  color: Colors.grey[300],
                                  fontFamily: "Roboto Medium",
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.03,
                                ),
                              ),
                            ],
                          ),
                        ),
                )
              : new Container(),
        ),
      );
      if (i == listDate.length - 1) {
        list.add(new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: elementBoxes,
        ));
      }
    }

    return list;
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
      future: tmp,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            {
              return new Center(child: new CircularProgressIndicator());
            }
          default:
            if (snapshot.hasError) {
              return create("Lỗi kết nối mạng. Bạn vui lòng thử lại.");
            } else {
              List<Widget> tmp = buildCalendar();
              if (tmp.length > 0) {
                return new Column(
                  children: tmp,
                );
              } else {
                return create("Lỗi kết nối với máy chủ. Bạn vui lòng thử lại.");
              }
            }
        }
      },
    );
    return futureBuilder;
  }
}

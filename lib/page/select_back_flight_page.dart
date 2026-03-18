// import 'dart:async';
// import 'dart:convert';
// import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:sanvemaybay_app_fixed/module/custom_app_bar.dart';
import 'package:sanvemaybay_app_fixed/module/custom_drawer.dart';
import 'package:sanvemaybay_app_fixed/customize_object/flight_info_object.dart';
import 'package:intl/intl.dart';
import 'package:sanvemaybay_app_fixed/page/fill_customer_info_page.dart';
import 'package:sanvemaybay_app_fixed/page/select_flight_page.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/firebase_service.dart';
import '../customize_object/flight_model.dart';

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

NumberFormat formatter = new NumberFormat("###,###,###");

String? url1;
String? url2;
String? url3;

String? url4;

DateFormat df = new DateFormat("yyyy-MM-dd");

List prices = [];

List companies = [];

List planeIds = [];

List typeSeats = [];

List timeDeparts = [];

List timeBacks = [];

List aldultFares = [];

List childFares = [];

List infantFares = [];

class SelectBackFlightPage extends StatelessWidget {
  final FlightInfoObject flightInfo;

  SelectBackFlightPage(this.flightInfo);

  @override
  Widget build(BuildContext context) {
    // url1 = flightInfo.storage["JetSearchLink"]!;
    // url2 = flightInfo.storage["VjaSearchLink"]!;
    // url3 = flightInfo.storage["VnaSearchLink"]!;
    // url4 = flightInfo.storage["NewApiLink"]!;
    return new SelectBackFlightPageSupport(flightInfo);
  }
}

class SelectBackFlightPageSupport extends StatefulWidget {
  final FlightInfoObject flightInfo;

  SelectBackFlightPageSupport(this.flightInfo);

  @override
  _SelectBackFlightPageSupportState createState() {
    return _SelectBackFlightPageSupportState();
  }
}

class _SelectBackFlightPageSupportState
    extends State<SelectBackFlightPageSupport> {
  DateTime? dateBefore;
  DateTime? dateAfter;
  String? departId;
  String? destinationId;
  int currentChosenFlight = -1;
  int total = 0;
  bool isLoading = true;
  bool isAnotherOpt = false;
  DateTime today = new DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);

  String apiKey = "";

  List list = [];
  List outbound = [];

  Future<Null>? tmp;

  // Future<Null> _getData(String outboundDate, String domain, String depCode,
  //     String arvCode, String adtCount, String chdCount, String infCount) async {
  //   var res = await Future.wait([
  //     http.post(Uri.parse(url4!), headers: {
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
  //     }),
  //     http.post(Uri.parse(url4!), headers: {
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
  //     }),
  //     http.post(Uri.parse(url4!), headers: {
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
  //     }),
  //     http.post(Uri.parse(url4!), headers: {
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
  //     }),
  //     http.post(Uri.parse(url4!), headers: {
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
  //     }),
  //     http.post(Uri.parse(url4!), headers: {
  //       tmpF.storage["NewK"]!: apiKey,
  //     }, body: {
  //       "dep_code": depCode,
  //       "arv_code": arvCode,
  //       "outbound_date": outboundDate,
  //       "adt_count": adtCount,
  //       "chd_count": chdCount,
  //       "inf_count": infCount,
  //       // "domain": tmpF.storage["D"],
  //       "provider_code": "9G",
  //     }),
  //   ]);
  //   outbound = [];
  //   if (res[0].statusCode == 201) {
  //     var resBody1 = json.decode(res[0].body);
  //     if (resBody1["error"] == false) {
  //       list = resBody1["data"];
  //       List tmp = list["outbound"];
  //       for (var item in tmp) {
  //         outbound.add(item);
  //       }
  //     }
  //   }
  //   if (res[1].statusCode == 201) {
  //     var resBody2 = json.decode(res[1].body);
  //     if (resBody2["error"] == false) {
  //       list = resBody2["data"];
  //       List tmp = list["outbound"];
  //       for (var item in tmp) {
  //         outbound.add(item);
  //       }
  //     }
  //   }
  //   if (res[2].statusCode == 201) {
  //     var resBody3 = json.decode(res[2].body);
  //     if (resBody3["error"] == false) {
  //       list = resBody3["data"];
  //       List tmp = list["outbound"];
  //       for (var item in tmp) {
  //         outbound.add(item);
  //       }
  //     }
  //   }
  //   if (res[3].statusCode == 201) {
  //     var resBody4 = json.decode(res[3].body);
  //     if (resBody4["error"] == false) {
  //       list = resBody4["data"];
  //       List tmp = list["outbound"];
  //       for (var item in tmp) {
  //         outbound.add(item);
  //       }
  //     }
  //   }
  //   if (res[4].statusCode == 201) {
  //     var resBody5 = json.decode(res[4].body);
  //     if (resBody5["error"] == false) {
  //       list = resBody5["data"];
  //       List tmp = list["outbound"];
  //       for (var item in tmp) {
  //         outbound.add(item);
  //       }
  //     }
  //   }
  //   if (res[5].statusCode == 201) {
  //     var resBody6 = json.decode(res[5].body);
  //     if (resBody6["error"] == false) {
  //       list = resBody6["data"];
  //       List tmp = list["outbound"];
  //       for (var item in tmp) {
  //         outbound.add(item);
  //       }
  //     }
  //   }
  //
  //   prices = [];
  //   companies = [];
  //   planeIds = [];
  //   typeSeats = [];
  //   timeDeparts = [];
  //   timeBacks = [];
  //   aldultFares = [];
  //   childFares = [];
  //   infantFares = [];
  //   for (var item in outbound) {
  //
  //     prices.add(item["base_price"] ?? 0);
  //     companies.add(item["aircode"] ?? "");
  //     planeIds.add(item["flight_no"] ?? "");
  //     typeSeats.add(item["ticket_class"] ?? "");
  //     timeDeparts.add(item["dep_time"] ?? "");
  //     timeBacks.add(item["arv_time"] ?? "");
  //
  //   }
  //
  //   // Sort prices
  //   for (var i = 0; i < prices.length; i++) {
  //     for (var j = 0; j < prices.length; j++) {
  //       if (prices[i] < prices[j]) {
  //         var tmp = prices[i];
  //         prices[i] = prices[j];
  //         prices[j] = tmp;
  //
  //         tmp = companies[i];
  //         companies[i] = companies[j];
  //         companies[j] = tmp;
  //
  //         tmp = planeIds[i];
  //         planeIds[i] = planeIds[j];
  //         planeIds[j] = tmp;
  //
  //         tmp = timeDeparts[i];
  //         timeDeparts[i] = timeDeparts[j];
  //         timeDeparts[j] = tmp;
  //
  //         tmp = timeBacks[i];
  //         timeBacks[i] = timeBacks[j];
  //         timeBacks[j] = tmp;
  //
  //         tmp = typeSeats[i];
  //         typeSeats[i] = typeSeats[j];
  //         typeSeats[j] = tmp;
  //
  //
  //       }
  //     }
  //   }
  // }

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
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) =>
                          new SelectFlightPage(widget.flightInfo)));
                },
                child: new Text("Chọn lại chuyến đi"),
              ),
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

  printFlightInfo() {
    List<Widget> tmp = [];
    for (var i = 0; i < prices.length; i++) {
      tmp.add(new TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.0171),
        ),
        onPressed: () {
          setState(() {
            currentChosenFlight = i;
            total = (widget.flightInfo.totalPrice +
                (prices[i] * widget.flightInfo.noOfAdult +
                    (prices[i] - 100000) * widget.flightInfo.noOfChild +
                    150000 * widget.flightInfo.noOfInfant) as int);
          });
        },
        child: new Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.width * 0.206,
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.0142),
          decoration: new BoxDecoration(
            color: Colors.white,
            border: new Border.all(
                color: currentChosenFlight != i
                    ? Colors.grey
                    : Colors.red[700] ?? const Color.fromARGB(255, 205, 54, 43),
                width: currentChosenFlight != i
                    ? MediaQuery.of(context).size.width * 0.00857
                    : MediaQuery.of(context).size.width * 0.015,
                style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(
                MediaQuery.of(context).size.width * 0.0171),
          ),
          child: currentChosenFlight != i
              ? new Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Image.asset(
                      companies.length > 0 ? "assets/${companies[i]}.png" : "",
                      width: MediaQuery.of(context).size.width * 0.13,
                      height: MediaQuery.of(context).size.width * 0.13,
                    ),
                    new Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Text(
                          timeDeparts[i],
                          style: new TextStyle(
                              color: Colors.black,
                              fontFamily: "Roboto Medium",
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.0343),
                        ),
                        new Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.width * 0.0143),
                        ),
                        new Text(
                          departId!,
                          style: new TextStyle(
                              color: Colors.grey,
                              fontFamily: "Roboto Medium",
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.0343),
                        ),
                      ],
                    ),
                    Image.asset(
                      "assets/plane.png",
                      width: MediaQuery.of(context).size.width * 0.0457,
                      fit: BoxFit.cover,
                    ),
                    new Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Text(
                          timeBacks[i],
                          style: new TextStyle(
                              color: Colors.black,
                              fontFamily: "Roboto Medium",
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.0343),
                        ),
                        new Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.width * 0.0143),
                        ),
                        new Text(
                          destinationId!,
                          style: new TextStyle(
                              color: Colors.grey,
                              fontFamily: "Roboto Medium",
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.0343),
                        ),
                      ],
                    ),
                    new Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Text(
                          planeIds[i],
                          style: new TextStyle(
                              color: Colors.grey,
                              fontFamily: "Roboto Medium",
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.0314),
                        ),
                        new Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.width * 0.0143),
                        ),
                        new Text(
                          typeSeats[i],
                          style: new TextStyle(
                              color: Colors.grey,
                              fontFamily: "Roboto Medium",
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.0314),
                        ),
                      ],
                    ),
                    new Text(
                      prices.length > 0
                          ? "${formatter.format(prices[i])} VND"
                          : "",
                      style: new TextStyle(
                          color: Colors.red,
                          fontFamily: "Roboto Medium",
                          fontSize: MediaQuery.of(context).size.width * 0.0457),
                    ),
                  ],
                )
              : new Stack(
                  children: <Widget>[
                    Positioned(
                      bottom: MediaQuery.of(context).size.width * 0.005,
                      right: MediaQuery.of(context).size.width * 0.01,
                      child: new Icon(
                        Icons.check_box,
                        size: MediaQuery.of(context).size.width * 0.06,
                        color: Colors.green[400],
                      ),
                    ),
                    SizedBox(
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Image.asset(
                            "assets/${companies[i]}.png",
                            width: MediaQuery.of(context).size.width * 0.13,
                            height: MediaQuery.of(context).size.width * 0.13,
                          ),
                          new Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              new Text(
                                timeDeparts[i],
                                style: new TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Roboto Medium",
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.0343),
                              ),
                              new Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.width *
                                        0.0143),
                              ),
                              new Text(
                                departId!,
                                style: new TextStyle(
                                    color: Colors.grey,
                                    fontFamily: "Roboto Medium",
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.0343),
                              ),
                            ],
                          ),
                          Image.asset(
                            "assets/plane.png",
                            width: MediaQuery.of(context).size.width * 0.0457,
                            fit: BoxFit.cover,
                          ),
                          new Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              new Text(
                                timeBacks[i],
                                style: new TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Roboto Medium",
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.0343),
                              ),
                              new Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.width *
                                        0.0143),
                              ),
                              new Text(
                                destinationId!,
                                style: new TextStyle(
                                    color: Colors.grey,
                                    fontFamily: "Roboto Meidum",
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.0343),
                              ),
                            ],
                          ),
                          new Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              new Text(
                                planeIds[i],
                                style: new TextStyle(
                                    color: Colors.grey,
                                    fontFamily: "Roboto Medium",
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.0314),
                              ),
                              new Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.width *
                                        0.0143),
                              ),
                              new Text(
                                typeSeats[i],
                                style: new TextStyle(
                                    color: Colors.grey,
                                    fontFamily: "Roboto Medium",
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.0314),
                              ),
                            ],
                          ),
                          new Text(
                            "${formatter.format(prices[i])} VND",
                            style: new TextStyle(
                                color: Colors.red,
                                fontFamily: "Roboto Medium",
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.0457),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
        ),
      ));
    }
    return tmp;
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    return Column(
      children: <Widget>[
        //Header cho chieu di hoac chieu ve
        new Container(
          width: double.infinity,
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.0314),
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Text(
                "Chiều về",
                style: new TextStyle(
                    color: Colors.grey[500],
                    fontFamily: "Roboto Medium",
                    fontSize: MediaQuery.of(context).size.width * 0.04),
              ),
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
        //Ket thuc header cho chieu di hoac chieu ve

        //Thanh bar ve ngay thang va gia tien
        new Container(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.0314,
              right: MediaQuery.of(context).size.width * 0.0314,
              bottom: MediaQuery.of(context).size.width * 0.0314),
          width: double.infinity,
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              //day before
              TextButton(
                onPressed: () {
                  if (dateBefore!.compareTo(widget.flightInfo.dateDepart) >=
                      0) {
                    widget.flightInfo.dateBack = dateBefore!;
                    setState(() {
                      widget.flightInfo.isRoundTrip = false;
                    });
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (context) =>
                            new SelectBackFlightPage(widget.flightInfo)));
                  }
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.all(0.0),
                ),
                child: new Column(
                  children: <Widget>[
                    new Column(
                      children: <Widget>[
                        new Text(
                          dateBefore!.weekday + 1 < 8
                              ? "Thứ ${dateBefore!.weekday + 1}"
                              : "Chủ nhật",
                          style: new TextStyle(
                              color: Colors.grey[300],
                              fontFamily: "Roboto Medium",
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04),
                        ),
                        new Text(
                          "${dateBefore!.day} tháng ${dateBefore!.month}",
                          style: new TextStyle(
                              color: Colors.grey[300],
                              fontFamily: "Roboto Medium",
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.width * 0.0114),
                    ),
                  ],
                ),
              ),

              //On that day
              TextButton(
                onPressed: () {
                  setState(() {
                    widget.flightInfo.isRoundTrip = false;
                  });
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) =>
                          new SelectBackFlightPage(widget.flightInfo)));
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.all(0.0),
                ),
                child: new Column(
                  children: <Widget>[
                    new Column(
                      children: <Widget>[
                        new Text(
                          widget.flightInfo.dateBack.weekday + 1 < 8
                              ? "Thứ ${widget.flightInfo.dateBack.weekday + 1}"
                              : "Chủ nhật",
                          style: new TextStyle(
                              color: Colors.black,
                              fontFamily: "Roboto Medium",
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04),
                        ),
                        new Text(
                          "${widget.flightInfo.dateBack.day} tháng ${widget.flightInfo.dateBack.month}",
                          style: new TextStyle(
                              color: Colors.black,
                              fontFamily: "Roboto Medium",
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04),
                        ),
                      ],
                    ),
                    new Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.width * 0.0114),
                    ),
                    new Container(
                      width: MediaQuery.of(context).size.width * 0.2857,
                      height: MediaQuery.of(context).size.width * 0.0143,
                      decoration: new BoxDecoration(
                        color: Colors.red[700],
                      ),
                    ),
                  ],
                ),
              ),

              //day after
              TextButton(
                onPressed: () {
                  setState(() {
                    widget.flightInfo.isRoundTrip = false;
                  });
                  widget.flightInfo.dateBack = dateAfter!;
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) =>
                          new SelectBackFlightPage(widget.flightInfo)));
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.all(0.0),
                ),
                child: new Column(
                  children: <Widget>[
                    new Column(
                      children: <Widget>[
                        new Text(
                          dateAfter!.weekday + 1 < 8
                              ? "Thứ ${dateAfter!.weekday + 1}"
                              : "Chủ nhật",
                          style: new TextStyle(
                              color: Colors.grey[300],
                              fontFamily: "Roboto Medium",
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04),
                        ),
                        new Text(
                          "${dateAfter!.day} tháng ${dateAfter!.month}",
                          style: new TextStyle(
                              color: Colors.grey[300],
                              fontFamily: "Roboto Medium",
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        //Ket thuc thanh bar ve ngay thang va gia tien

        //Container trang tri
        new Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.005),
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // search theo gia
              new TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.all(0.0),
                ),
                onPressed: () {
                  setState(() {
                    for (var i = 0; i < prices.length; i++) {
                      for (var j = 0; j < prices.length; j++) {
                        if (prices[i] < prices[j]) {
                          var tmp = prices[i];
                          prices[i] = prices[j];
                          prices[j] = tmp;

                          tmp = companies[i];
                          companies[i] = companies[j];
                          companies[j] = tmp;

                          tmp = planeIds[i];
                          planeIds[i] = planeIds[j];
                          planeIds[j] = tmp;

                          tmp = timeDeparts[i];
                          timeDeparts[i] = timeDeparts[j];
                          timeDeparts[j] = tmp;

                          tmp = timeBacks[i];
                          timeBacks[i] = timeBacks[j];
                          timeBacks[j] = tmp;

                          tmp = typeSeats[i];
                          typeSeats[i] = typeSeats[j];
                          typeSeats[j] = tmp;

                          // tmp = aldultFares[i];
                          // aldultFares[i] = aldultFares[j];
                          // aldultFares[j] = tmp;

                          // tmp = childFares[i];
                          // childFares[i] = childFares[j];
                          // childFares[j] = tmp;

                          // tmp = infantFares[i];
                          // infantFares[i] = infantFares[j];
                          // infantFares[j] = tmp;
                        }
                      }
                    }
                  });
                },
                child: new Container(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
                  width: MediaQuery.of(context).size.width / 3.15,
                  decoration: new BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(3.0),
                        bottomLeft: Radius.circular(3.0)),
                  ),
                  child: Center(
                      child: Column(
                    children: <Widget>[
                      new Text(
                        "Giá rẻ nhất",
                        style: new TextStyle(
                            color: Colors.grey[200],
                            fontFamily: "Roboto Medium",
                            fontSize: MediaQuery.of(context).size.width * 0.04),
                      ),
                      new Icon(
                        Icons.monetization_on,
                        color: Colors.yellow,
                      ),
                    ],
                  )),
                ),
              ),

              //search theo gio
              new TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.all(0.0),
                ),
                onPressed: () {
                  setState(() {
                    for (var i = 0; i < timeDeparts.length; i++) {
                      for (var j = 0; j < timeDeparts.length; j++) {
                        if (timeDeparts[i].compareTo(timeDeparts[j]) < 0) {
                          var tmp = prices[i];
                          prices[i] = prices[j];
                          prices[j] = tmp;

                          tmp = companies[i];
                          companies[i] = companies[j];
                          companies[j] = tmp;

                          tmp = planeIds[i];
                          planeIds[i] = planeIds[j];
                          planeIds[j] = tmp;

                          tmp = timeDeparts[i];
                          timeDeparts[i] = timeDeparts[j];
                          timeDeparts[j] = tmp;

                          tmp = timeBacks[i];
                          timeBacks[i] = timeBacks[j];
                          timeBacks[j] = tmp;

                          tmp = typeSeats[i];
                          typeSeats[i] = typeSeats[j];
                          typeSeats[j] = tmp;

                          // tmp = aldultFares[i];
                          // aldultFares[i] = aldultFares[j];
                          // aldultFares[j] = tmp;

                          // tmp = childFares[i];
                          // childFares[i] = childFares[j];
                          // childFares[j] = tmp;

                          // tmp = infantFares[i];
                          // infantFares[i] = infantFares[j];
                          // infantFares[j] = tmp;
                        }
                      }
                    }
                  });
                },
                child: new Container(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
                  width: MediaQuery.of(context).size.width / 3.15,
                  decoration: new BoxDecoration(
                    color: Colors.purpleAccent,
                  ),
                  child: Center(
                      child: Column(
                    children: <Widget>[
                      new Text(
                        "Thời gian",
                        style: new TextStyle(
                            color: Colors.grey[200],
                            fontFamily: "Roboto Medium",
                            fontSize: MediaQuery.of(context).size.width * 0.04),
                      ),
                      new Icon(
                        Icons.access_alarms,
                        color: Colors.yellow[500],
                      ),
                    ],
                  )),
                ),
              ),

              //search theo chuyen bay
              new TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.all(0.0),
                ),
                onPressed: () {
                  setState(() {
                    for (var i = 0; i < prices.length; i++) {
                      for (var j = 0; j < prices.length; j++) {
                        if (planeIds[i].compareTo(planeIds[j]) < 0) {
                          var tmp = prices[i];
                          prices[i] = prices[j];
                          prices[j] = tmp;

                          tmp = companies[i];
                          companies[i] = companies[j];
                          companies[j] = tmp;

                          tmp = planeIds[i];
                          planeIds[i] = planeIds[j];
                          planeIds[j] = tmp;

                          tmp = timeDeparts[i];
                          timeDeparts[i] = timeDeparts[j];
                          timeDeparts[j] = tmp;

                          tmp = timeBacks[i];
                          timeBacks[i] = timeBacks[j];
                          timeBacks[j] = tmp;

                          tmp = typeSeats[i];
                          typeSeats[i] = typeSeats[j];
                          typeSeats[j] = tmp;

                          // tmp = aldultFares[i];
                          // aldultFares[i] = aldultFares[j];
                          // aldultFares[j] = tmp;

                          // tmp = childFares[i];
                          // childFares[i] = childFares[j];
                          // childFares[j] = tmp;

                          // tmp = infantFares[i];
                          // infantFares[i] = infantFares[j];
                          // infantFares[j] = tmp;
                        }
                      }
                    }
                  });
                },
                child: new Container(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
                  width: MediaQuery.of(context).size.width / 3.15,
                  decoration: new BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(3.0),
                        bottomRight: Radius.circular(3.0)),
                  ),
                  child: Center(
                      child: Column(
                    children: <Widget>[
                      new Text(
                        "Chuyến bay",
                        style: new TextStyle(
                            color: Colors.grey[200],
                            fontFamily: "Roboto Medium",
                            fontSize: MediaQuery.of(context).size.width * 0.04),
                      ),
                      new Icon(
                        Icons.local_airport,
                        color: Colors.yellow[500],
                      ),
                    ],
                  )),
                ),
              ),
            ],
          ),
        ),
        //Ket thuc container trang tri
        //Show cac chuyen bay
        outbound.length > 0
            ? Expanded(
                child: new ListView(
                  children: printFlightInfo(),
                ),
              )
            : new Expanded(
                child: new Container(
                  child: new Center(
                    child: new Text("Không có chuyến bay phù hợp"),
                  ),
                ),
              )
        //Ket thuc show cac chuyen bay
      ],
    );
  }

  Widget createlistView() {
    return Column(
      children: <Widget>[
        //Header cho chieu di hoac chieu ve
        new Container(
          width: double.infinity,
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.0314),
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Text(
                "Chiều về",
                style: new TextStyle(
                    color: Colors.grey[500],
                    fontFamily: "Roboto Medium",
                    fontSize: MediaQuery.of(context).size.width * 0.04),
              ),
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
        //Ket thuc header cho chieu di hoac chieu ve

        //Thanh bar ve ngay thang va gia tien
        new Container(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.0314,
              right: MediaQuery.of(context).size.width * 0.0314,
              bottom: MediaQuery.of(context).size.width * 0.01),
          width: double.infinity,
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              //day before
              TextButton(
                onPressed: () {
                  if (dateBefore!.compareTo(widget.flightInfo.dateDepart) >=
                      0) {
                    setState(() {
                      widget.flightInfo.isRoundTrip = false;
                    });
                    widget.flightInfo.dateBack = dateBefore!;
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (context) =>
                            new SelectBackFlightPage(widget.flightInfo)));
                  }
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.all(0.0),
                ),
                child: new Column(
                  children: <Widget>[
                    new Column(
                      children: <Widget>[
                        new Text(
                          dateBefore!.weekday + 1 < 8
                              ? "Thứ ${dateBefore!.weekday + 1}"
                              : "Chủ nhật",
                          style: new TextStyle(
                              color: Colors.grey[700],
                              fontFamily: "Roboto Medium",
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04),
                        ),
                        new Text(
                          "${dateBefore!.day} tháng ${dateBefore!.month}",
                          style: new TextStyle(
                              color: Colors.grey[700],
                              fontFamily: "Roboto Medium",
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              //On that day
              TextButton(
                onPressed: () {
                  setState(() {
                    widget.flightInfo.isRoundTrip = false;
                  });
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) =>
                          new SelectBackFlightPage(widget.flightInfo)));
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.all(0.0),
                ),
                child: new Column(
                  children: <Widget>[
                    new Column(
                      children: <Widget>[
                        new Text(
                          widget.flightInfo.dateBack.weekday + 1 < 8
                              ? "Thứ ${widget.flightInfo.dateBack.weekday + 1}"
                              : "Chủ nhật",
                          style: new TextStyle(
                              color: Colors.black,
                              fontFamily: "Roboto Medium",
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04),
                        ),
                        new Text(
                          "${widget.flightInfo.dateBack.day} tháng ${widget.flightInfo.dateBack.month}",
                          style: new TextStyle(
                              color: Colors.black,
                              fontFamily: "Roboto Medium",
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04),
                        ),
                      ],
                    ),
                    new Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.width * 0.0114),
                    ),
                    new Container(
                      width: MediaQuery.of(context).size.width * 0.2857,
                      height: MediaQuery.of(context).size.width * 0.0143,
                      decoration: new BoxDecoration(
                        color: Colors.red[700],
                      ),
                    ),
                  ],
                ),
              ),

              //day after
              TextButton(
                onPressed: () {
                  setState(() {
                    widget.flightInfo.isRoundTrip = false;
                  });
                  widget.flightInfo.dateBack = dateAfter!;
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) =>
                          new SelectBackFlightPage(widget.flightInfo)));
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.all(0.0),
                ),
                child: new Column(
                  children: <Widget>[
                    new Column(
                      children: <Widget>[
                        new Text(
                          dateAfter!.weekday + 1 < 8
                              ? "Thứ ${dateAfter!.weekday + 1}"
                              : "Chủ nhật",
                          style: new TextStyle(
                              color: Colors.grey[700],
                              fontFamily: "Roboto Medium",
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04),
                        ),
                        new Text(
                          "${dateAfter!.day} tháng ${dateAfter!.month}",
                          style: new TextStyle(
                              color: Colors.grey[700],
                              fontFamily: "Roboto Medium",
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        //Ket thuc thanh bar ve ngay thang va gia tien

        //Container trang tri
        new Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.005),
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // search theo gia
              new TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.all(0.0),
                ),
                onPressed: () {
                  setState(() {
                    for (var i = 0; i < prices.length; i++) {
                      for (var j = 0; j < prices.length; j++) {
                        if (prices[i] < prices[j]) {
                          var tmp = prices[i];
                          prices[i] = prices[j];
                          prices[j] = tmp;

                          tmp = companies[i];
                          companies[i] = companies[j];
                          companies[j] = tmp;

                          tmp = planeIds[i];
                          planeIds[i] = planeIds[j];
                          planeIds[j] = tmp;

                          tmp = timeDeparts[i];
                          timeDeparts[i] = timeDeparts[j];
                          timeDeparts[j] = tmp;

                          tmp = timeBacks[i];
                          timeBacks[i] = timeBacks[j];
                          timeBacks[j] = tmp;

                          tmp = typeSeats[i];
                          typeSeats[i] = typeSeats[j];
                          typeSeats[j] = tmp;

                          // tmp = aldultFares[i];
                          // aldultFares[i] = aldultFares[j];
                          // aldultFares[j] = tmp;

                          // tmp = childFares[i];
                          // childFares[i] = childFares[j];
                          // childFares[j] = tmp;

                          // tmp = infantFares[i];
                          // infantFares[i] = infantFares[j];
                          // infantFares[j] = tmp;
                        }
                      }
                    }
                  });
                },
                child: new Container(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
                  width: MediaQuery.of(context).size.width / 3.15,
                  decoration: new BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(3.0),
                        bottomLeft: Radius.circular(3.0)),
                  ),
                  child: Center(
                      child: Column(
                    children: <Widget>[
                      new Text(
                        "Giá rẻ nhất",
                        style: new TextStyle(
                            color: Colors.grey[200],
                            fontFamily: "Roboto Medium",
                            fontSize: MediaQuery.of(context).size.width * 0.04),
                      ),
                      new Icon(
                        Icons.monetization_on,
                        color: Colors.yellow,
                      ),
                    ],
                  )),
                ),
              ),

              //search theo gio
              new TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.all(0.0),
                ),
                onPressed: () {
                  setState(() {
                    for (var i = 0; i < timeDeparts.length; i++) {
                      for (var j = 0; j < timeDeparts.length; j++) {
                        if (timeDeparts[i].compareTo(timeDeparts[j]) < 0) {
                          var tmp = prices[i];
                          prices[i] = prices[j];
                          prices[j] = tmp;

                          tmp = companies[i];
                          companies[i] = companies[j];
                          companies[j] = tmp;

                          tmp = planeIds[i];
                          planeIds[i] = planeIds[j];
                          planeIds[j] = tmp;

                          tmp = timeDeparts[i];
                          timeDeparts[i] = timeDeparts[j];
                          timeDeparts[j] = tmp;

                          tmp = timeBacks[i];
                          timeBacks[i] = timeBacks[j];
                          timeBacks[j] = tmp;

                          tmp = typeSeats[i];
                          typeSeats[i] = typeSeats[j];
                          typeSeats[j] = tmp;

                          // tmp = aldultFares[i];
                          // aldultFares[i] = aldultFares[j];
                          // aldultFares[j] = tmp;

                          // tmp = childFares[i];
                          // childFares[i] = childFares[j];
                          // childFares[j] = tmp;

                          // tmp = infantFares[i];
                          // infantFares[i] = infantFares[j];
                          // infantFares[j] = tmp;
                        }
                      }
                    }
                  });
                },
                child: new Container(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
                  width: MediaQuery.of(context).size.width / 3.15,
                  decoration: new BoxDecoration(
                    color: Colors.purpleAccent,
                  ),
                  child: Center(
                      child: Column(
                    children: <Widget>[
                      new Text(
                        "Thời gian",
                        style: new TextStyle(
                            color: Colors.grey[200],
                            fontFamily: "Roboto Medium",
                            fontSize: MediaQuery.of(context).size.width * 0.04),
                      ),
                      new Icon(
                        Icons.access_alarms,
                        color: Colors.yellow[500],
                      ),
                    ],
                  )),
                ),
              ),

              //search theo chuyen bay
              new TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.all(0.0),
                ),
                onPressed: () {
                  setState(() {
                    for (var i = 0; i < prices.length; i++) {
                      for (var j = 0; j < prices.length; j++) {
                        if (planeIds[i].compareTo(planeIds[j]) < 0) {
                          var tmp = prices[i];
                          prices[i] = prices[j];
                          prices[j] = tmp;

                          tmp = companies[i];
                          companies[i] = companies[j];
                          companies[j] = tmp;

                          tmp = planeIds[i];
                          planeIds[i] = planeIds[j];
                          planeIds[j] = tmp;

                          tmp = timeDeparts[i];
                          timeDeparts[i] = timeDeparts[j];
                          timeDeparts[j] = tmp;

                          tmp = timeBacks[i];
                          timeBacks[i] = timeBacks[j];
                          timeBacks[j] = tmp;

                          tmp = typeSeats[i];
                          typeSeats[i] = typeSeats[j];
                          typeSeats[j] = tmp;

                          // tmp = aldultFares[i];
                          // aldultFares[i] = aldultFares[j];
                          // aldultFares[j] = tmp;

                          // tmp = childFares[i];
                          // childFares[i] = childFares[j];
                          // childFares[j] = tmp;

                          // tmp = infantFares[i];
                          // infantFares[i] = infantFares[j];
                          // infantFares[j] = tmp;
                        }
                      }
                    }
                  });
                },
                child: new Container(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
                  width: MediaQuery.of(context).size.width / 3.15,
                  decoration: new BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(3.0),
                        bottomRight: Radius.circular(3.0)),
                  ),
                  child: Center(
                      child: Column(
                    children: <Widget>[
                      new Text(
                        "Chuyến bay",
                        style: new TextStyle(
                            color: Colors.grey[200],
                            fontFamily: "Roboto Medium",
                            fontSize: MediaQuery.of(context).size.width * 0.04),
                      ),
                      new Icon(
                        Icons.local_airport,
                        color: Colors.yellow[500],
                      ),
                    ],
                  )),
                ),
              ),
            ],
          ),
        ),
        //Ket thuc container trang tri
        //Show cac chuyen bay
        outbound.length > 0
            ? Expanded(
                child: new ListView(
                  children: printFlightInfo(),
                ),
              )
            : new Expanded(
                child: new Container(
                  child: new Center(
                    child: new Text("Không có chuyến bay phù hợp"),
                  ),
                ),
              )
        //Ket thuc show cac chuyen bay
      ],
    );
  }



  // @override
  // void initState() {
  //   super.initState();
  //   dateBefore = widget.flightInfo.dateBack.subtract(Duration(days: 1));
  //   dateAfter = widget.flightInfo.dateBack.add(Duration(days: 1));
  //
  //   if (widget.flightInfo.arvCode.length > 0) {
  //     departId = widget.flightInfo.arvCode;
  //   } else {
  //     departId = listAirportID[widget.flightInfo.destination];
  //   }
  //   if (widget.flightInfo.depCode.length > 0) {
  //     destinationId = widget.flightInfo.depCode;
  //   } else {
  //     destinationId = listAirportID[widget.flightInfo.depart];
  //   }
  //   apiKey = widget.flightInfo.apiKey;
  //   if (widget.flightInfo.isRoundTrip) {
  //     outbound = widget.flightInfo.inbound;
  //     //sort
  //     prices = [];
  //     companies = [];
  //     planeIds = [];
  //     typeSeats = [];
  //     timeDeparts = [];
  //     timeBacks = [];
  //     aldultFares = [];
  //     childFares = [];
  //     infantFares = [];
  //     for (var item in outbound) {
  //       // prices.add(item["base_price"]);
  //       // companies.add(item["aircode"]);
  //       // planeIds.add(item["flight_no"]);
  //       // typeSeats.add(item["ticket_class"]);
  //       // timeDeparts.add(item["dep_time"]);
  //       // timeBacks.add(item["arv_time"]);
  //       // var tmp = item["fares"];
  //       // aldultFares.add(tmp["adt_tax_fee1"]);
  //       // childFares.add(tmp["chd_tax_fee1"]);
  //       // infantFares.add(tmp["inf_tax_fee1"]);
  //       prices.add(item["base_price"] ?? 0);
  //       companies.add(item["aircode"] ?? "");
  //       planeIds.add(item["flight_no"] ?? "");
  //       typeSeats.add(item["ticket_class"] ?? "");
  //       timeDeparts.add(item["dep_time"] ?? "");
  //       timeBacks.add(item["arv_time"] ?? "");
  //       // var tmp = item["fares"];
  //       // if (tmp != null) {
  //       //   aldultFares.add(tmp["adt_tax_fee1"] ?? 0);
  //       //   childFares.add(tmp["chd_tax_fee1"] ?? 0);
  //       //   infantFares.add(tmp["inf_tax_fee1"] ?? 0);
  //       // } else {
  //       //   aldultFares.add(0);
  //       //   childFares.add(0);
  //       //   infantFares.add(0);
  //       // }
  //     }
  //     for (var i = 0; i < prices.length; i++) {
  //       for (var j = 0; j < prices.length; j++) {
  //         if (prices[i] < prices[j]) {
  //           var tmp = prices[i];
  //           prices[i] = prices[j];
  //           prices[j] = tmp;
  //
  //           tmp = companies[i];
  //           companies[i] = companies[j];
  //           companies[j] = tmp;
  //
  //           tmp = planeIds[i];
  //           planeIds[i] = planeIds[j];
  //           planeIds[j] = tmp;
  //
  //           tmp = timeDeparts[i];
  //           timeDeparts[i] = timeDeparts[j];
  //           timeDeparts[j] = tmp;
  //
  //           tmp = timeBacks[i];
  //           timeBacks[i] = timeBacks[j];
  //           timeBacks[j] = tmp;
  //
  //           tmp = typeSeats[i];
  //           typeSeats[i] = typeSeats[j];
  //           typeSeats[j] = tmp;
  //
  //           // tmp = aldultFares[i];
  //           // aldultFares[i] = aldultFares[j];
  //           // aldultFares[j] = tmp;
  //
  //           // tmp = childFares[i];
  //           // childFares[i] = childFares[j];
  //           // childFares[j] = tmp;
  //
  //           // tmp = infantFares[i];
  //           // infantFares[i] = infantFares[j];
  //           // infantFares[j] = tmp;
  //         }
  //       }
  //     }
  //   } else {
  //     tmp = _getData(
  //       df.format(widget.flightInfo.dateBack),
  //       widget.flightInfo.storage["last"]!,
  //       departId!,
  //       destinationId!,
  //       widget.flightInfo.noOfAdult.toString(),
  //       widget.flightInfo.noOfChild.toString(),
  //       widget.flightInfo.noOfInfant.toString(),
  //     );
  //   }
  // }

  // bool isLoading = true;
  // List list = [];

  @override
  void initState() {
    super.initState();
    currentChosenFlight = -1;

    // Phục hồi các biến giao diện quan trọng
    dateBefore = widget.flightInfo.dateBack.subtract(Duration(days: 1));
    dateAfter = widget.flightInfo.dateBack.add(Duration(days: 1));
    departId = widget.flightInfo.arvCode.isNotEmpty ? widget.flightInfo.arvCode : (listAirportID[widget.flightInfo.destination] ?? "");
    destinationId = widget.flightInfo.depCode.isNotEmpty ? widget.flightInfo.depCode : (listAirportID[widget.flightInfo.depart] ?? "");

    _fetchFirebaseData();
  }

  Future<void> _fetchFirebaseData() async {
    FirebaseService service = FirebaseService();

    List<FlightModel> data = await service.searchFlights(
        widget.flightInfo.arvCode,
        widget.flightInfo.depCode
    );

    if (!mounted) return;

    setState(() {
      list.clear(); prices.clear(); companies.clear();
      planeIds.clear(); typeSeats.clear(); timeDeparts.clear(); timeBacks.clear();
      outbound.clear();

      if (data.isEmpty) {
        isLoading = false;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _confirmDialog(context, "Không có chuyến bay lượt về phù hợp. Vui lòng thử lại sau.");
        });
        return;
      }

      for (var flight in data) {
        list.add(flight);
        outbound.add(flight);
        prices.add(flight.basePrice);
        companies.add(flight.providerCode);
        planeIds.add(flight.flightNo);
        typeSeats.add("Phổ thông");
        timeDeparts.add(flight.depTime);
        timeBacks.add("--:--");
      }

      for (var i = 0; i < prices.length; i++) {
        for (var j = 0; j < prices.length; j++) {
          if (prices[i] < prices[j]) {
            _swap(i, j);
          }
        }
      }
      isLoading = false;
    });
  }

  void _swap(int i, int j) {
    var tmpP = prices[i]; prices[i] = prices[j]; prices[j] = tmpP;
    var tmpC = companies[i]; companies[i] = companies[j]; companies[j] = tmpC;
    var tmpId = planeIds[i]; planeIds[i] = planeIds[j]; planeIds[j] = tmpId;
    var tmpD = timeDeparts[i]; timeDeparts[i] = timeDeparts[j]; timeDeparts[j] = tmpD;
    var tmpB = timeBacks[i]; timeBacks[i] = timeBacks[j]; timeBacks[j] = tmpB;
    var tmpS = typeSeats[i]; typeSeats[i] = typeSeats[j]; typeSeats[j] = tmpS;
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
          case ConnectionState.waiting:
            {
              widget.flightInfo.isRoundTrip = true;
              return isLoading
                  ? new Center(child: new CircularProgressIndicator())
                  : createListView(context, snapshot);
            }
          default:
            if (snapshot.hasError) {
              widget.flightInfo.isRoundTrip = true;
              return create("Lỗi kết nối mạng. Bạn vui lòng thử lại.");
            } else {
              widget.flightInfo.isRoundTrip = true;
              isLoading = false;
              if (outbound.length > 0) {
                return createListView(context, snapshot);
              } else {
                return create("Không tìm được chuyến bay phù hợp.");
              }
            }
        }
      },
    );

    return new MaterialApp(
      title: "Sanvemaybay.vn",
      theme: new ThemeData(
        primaryColor: Colors.red[700],
        //accentColor: Colors.grey[700],
      ),
      home: Scaffold(
        drawer: new CustomDrawer(),
        appBar: AppBar(
          title: new CustomAppBar("CHỌN HÀNH TRÌNH", false, 60.0),
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
        body: widget.flightInfo.isRoundTrip == false
            ? futureBuilder
            : createlistView(),
        bottomNavigationBar: currentChosenFlight > -1
            ? new TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.all(0.0),
                ),
                onPressed: () {
                  if (currentChosenFlight > -1) {
                    FlightInfoObject tmp = widget.flightInfo;
                    tmp.company2 = companies[currentChosenFlight];
                    tmp.typeSeat2 = typeSeats[currentChosenFlight];
                    tmp.planeId2 = planeIds[currentChosenFlight];
                    // print("${tmp.planeId2}");
                    tmp.priceBack = prices[currentChosenFlight];
                    tmp.timeDepart2 = timeDeparts[currentChosenFlight];
                    tmp.timeBack2 = timeBacks[currentChosenFlight];
                    // tmp.adultBackTax = aldultFares[currentChosenFlight];
                    // tmp.childBackTax = childFares[currentChosenFlight];
                    // tmp.infantBackTax = infantFares[currentChosenFlight];
                    tmp.adultBackTax = 0;
                    tmp.childBackTax = 0;
                    tmp.infantBackTax = 0;
                    
                    tmp.totalPrice = total;
                    if (tmp.timeBack2.contains("00:")) {
                      tmp.dateBackBack = tmp.dateBack.add(Duration(days: 1));
                    } else {
                      tmp.dateBackBack = tmp.dateBack;
                    }
                    if (tmp.isValidTimeDepart1AndTimeDepart2()) {
                      // print("company2: ${tmp.company2}");
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (context) => new FillCustomerInfoPage(tmp)));
                    } else {
                      _confirmDialog(context,
                          "Thời gian chuyến bay về không phù hợp. Vui lòng kiểm lại.");
                    }
                  } else {
                    _confirmDialog(context,
                        "Chưa có thông tin chuyến bay về. Vui lòng kiểm lại.");
                  }
                },
                child: new Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.width * 0.13,
                  padding: EdgeInsets.all(
                      MediaQuery.of(context).size.width * 0.0314),
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
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.0457),
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
              )
            : new Container(
                height: 0.0,
              ),
      ),
    );
  }
}

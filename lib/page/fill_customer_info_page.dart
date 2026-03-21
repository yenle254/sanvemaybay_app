import 'dart:async';
import 'dart:convert';
// import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // THÊM DÒNG NÀY
import 'package:sanvemaybay_app_fixed/page/booking_history_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sanvemaybay_app_fixed/module/custom_app_bar.dart';
import 'package:sanvemaybay_app_fixed/module/custom_drawer.dart';
import 'package:sanvemaybay_app_fixed/customize_object/flight_info_object.dart';
import 'package:sanvemaybay_app_fixed/customize_object/adult.dart';
import 'package:sanvemaybay_app_fixed/customize_object/child.dart';
import 'package:sanvemaybay_app_fixed/page/finish_booking_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
late FlightInfoObject tmpflightInfo;

FlightInfoObject tmpF = new FlightInfoObject();

late String url1;

DateFormat df = new DateFormat("yyyy-MM-dd");

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

bool isDetailDepart = true;

List<String> listAdultCall = ["Ông", "Bà"];

List<String> listGender = ["Trai", "Gái"];

List<String> listPayment = [
  "Chuyển khoản ngân hàng",
  "Tại văn phòng",
  "Tại nhà (25,000 VND)"
];

List<String> listPackage = [];

Map<String, dynamic> mapPackagePrice = {};

Map<String, String> mapPackage = {};

Map<String, dynamic> mapPackageBuyPrice = {};

List<String> listPackage2 = [];

Map<String, dynamic> mapPackagePrice2 = {};

Map<String, String> mapPackage2 = {};

Map<String, dynamic> mapPackageBuyPrice2 = {};

List<String> listDay = [
  "01",
  "02",
  "03",
  "04",
  "05",
  "06",
  "07",
  "08",
  "09",
  "10",
  "11",
  "12",
  "13",
  "14",
  "15",
  "16",
  "17",
  "18",
  "19",
  "20",
  "21",
  "22",
  "23",
  "24",
  "25",
  "26",
  "27",
  "28",
  "29",
  "30",
  "31"
];

List<String> listMonth = [
  "01",
  "02",
  "03",
  "04",
  "05",
  "06",
  "07",
  "08",
  "09",
  "10",
  "11",
  "12"
];

List<String> listYear = [
  "${DateTime.now().year}",
  "${DateTime.now().year - 1}",
  "${DateTime.now().year - 2}",
  "${DateTime.now().year - 3}",
  "${DateTime.now().year - 4}",
  "${DateTime.now().year - 5}",
  "${DateTime.now().year - 6}",
  "${DateTime.now().year - 7}",
  "${DateTime.now().year - 8}",
  "${DateTime.now().year - 9}",
  "${DateTime.now().year - 10}",
  "${DateTime.now().year - 11}",
  "${DateTime.now().year - 12}"
];

List<String> listYearAdult = List.generate(
  89,
  (index) => "${DateTime.now().year - 12 - index}",
);

checkValidDay(int day, int month, int year) {
  int max = 31;
  if ((month == 4) || (month == 6) || (month == 9) || (month == 11))
    max = 30;
  else if (month == 2) {
    if ((year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0))
      max = 29;
    else
      max = 28;
  }
  return day <= max;
}

DateFormat formatter = new DateFormat("dd/MM/yyyy");
NumberFormat f = new NumberFormat("###,###,###");

// class FillCustomerInfoPage extends StatelessWidget {
//   final FlightInfoObject flightInfo;
//
//   FillCustomerInfoPage(this.flightInfo);
//
//   @override
//   Widget build(BuildContext context) {
//     url1 = flightInfo.storage["BaggageNew2"]!;
//     return new FillCustomerInfoPageSupport(flightInfo);
//   }
// }

class FillCustomerInfoPage extends StatelessWidget {
  final FlightInfoObject flightInfo;
  FillCustomerInfoPage(this.flightInfo);

  @override
  Widget build(BuildContext context) {
    return new FillCustomerInfoPageSupport(flightInfo);
  }
}

class FillCustomerInfoPageSupport extends StatefulWidget {
  final FlightInfoObject flightInfo;

  FillCustomerInfoPageSupport(this.flightInfo);

  @override
  _FillCustomerInfoPageSupportState createState() =>
      _FillCustomerInfoPageSupportState();
}

class _FillCustomerInfoPageSupportState
    extends State<FillCustomerInfoPageSupport> {
  Future<Null>? tmp;
  bool isFirst = true;
  int totalPaymentDepart = 0;
  int totalPaymentBack = 0;
  int pricePayway = 0;

  String apiKey = "";

  // Future<Null> _getBagages(
  //     String domain, String aircode1, String aircode2) async {
  //   var response = await http.post(Uri.parse(url1), headers: {
  //     tmpF.storage["NewK"]!: apiKey,
  //   }, body: {
  //     "domain": tmpF.storage["D"],
  //     "provider_code": aircode1,
  //     "dep_code": widget.flightInfo.depCode,
  //     "arv_code": widget.flightInfo.arvCode,
  //     "ticket_class": widget.flightInfo.typeSeat1,
  //     "pax_type": "0",
  //     "outbound_date": df.format(widget.flightInfo.dateDepart),
  //   });
  //
  //   if (response.statusCode == 201) {
  //     var resBody = json.decode(response.body);
  //
  //     if (resBody["error"] == false) {
  //       listPackage = [];
  //       var list = resBody["data"];
  //       mapPackage = new Map();
  //       mapPackagePrice = new Map();
  //       mapPackageBuyPrice = new Map();
  //
  //       for (var item in list) {
  //         listPackage.add(item["name"]);
  //         mapPackage.putIfAbsent(item["weight"], () => item["name"]);
  //         mapPackagePrice.putIfAbsent(
  //             item["weight"], () => num.parse(item["sell_amt"]));
  //         mapPackageBuyPrice.putIfAbsent(
  //             item["weight"], () => num.parse(item["buy_amt"]));
  //       }
  //
  //       if (list.length > 0) {
  //         var firstItem = list[0];
  //         int defaultWeight = int.parse(firstItem["weight"]);
  //         int defaultSellAmt = num.parse(firstItem["sell_amt"]) as int;
  //         int defaultBuyAmt = num.parse(firstItem["buy_amt"]) as int;
  //
  //         for (int i = 0; i < widget.flightInfo.listAdults.length; i++) {
  //           widget.flightInfo.listAdults[i].departPackage = defaultWeight;
  //           widget.flightInfo.listAdults[i].departBagSellAmt = defaultSellAmt;
  //           widget.flightInfo.listAdults[i].departBagBuyAmt = defaultBuyAmt;
  //         }
  //
  //         for (int i = 0; i < widget.flightInfo.listChildren.length; i++) {
  //           widget.flightInfo.listChildren[i].departPackage = defaultWeight;
  //           widget.flightInfo.listChildren[i].departBagSellAmt = defaultSellAmt;
  //           widget.flightInfo.listChildren[i].departBagBuyAmt = defaultBuyAmt;
  //         }
  //       }
  //     }
  //   }
  //
  //   if (widget.flightInfo.isRoundTrip) {
  //     var response2 = await http.post(Uri.parse(url1), headers: {
  //       tmpF.storage["NewK"]!: apiKey,
  //     }, body: {
  //       "domain": tmpF.storage["D"],
  //       "provider_code": aircode2,
  //       "dep_code": widget.flightInfo.arvCode,
  //       "arv_code": widget.flightInfo.depCode,
  //       "ticket_class": widget.flightInfo.typeSeat2,
  //       "pax_type": "0",
  //       "outbound_date": df.format(widget.flightInfo.dateBack),
  //     });
  //
  //     if (response2.statusCode == 201) {
  //       var resBody2 = json.decode(response2.body);
  //       if (resBody2["error"] == false) {
  //         listPackage2 = [];
  //         var list2 = resBody2["data"];
  //         mapPackage2 = new Map();
  //         mapPackagePrice2 = new Map();
  //         mapPackageBuyPrice2 = new Map();
  //
  //         for (var item in list2) {
  //           listPackage2.add(item["name"]);
  //           mapPackage2.putIfAbsent(item["weight"], () => item["name"]);
  //           mapPackagePrice2.putIfAbsent(
  //               item["weight"], () => num.parse(item["sell_amt"]));
  //           mapPackageBuyPrice2.putIfAbsent(
  //               item["weight"], () => num.parse(item["buy_amt"]));
  //         }
  //
  //         if (list2.length > 0) {
  //           var firstItem2 = list2[0];
  //           int defaultWeight2 = int.parse(firstItem2["weight"]);
  //           int defaultSellAmt2 = num.parse(firstItem2["sell_amt"]) as int;
  //           int defaultBuyAmt2 = num.parse(firstItem2["buy_amt"]) as int;
  //
  //           for (int i = 0; i < widget.flightInfo.listAdults.length; i++) {
  //             widget.flightInfo.listAdults[i].backPackage = defaultWeight2;
  //             widget.flightInfo.listAdults[i].backBagSellAmt = defaultSellAmt2;
  //             widget.flightInfo.listAdults[i].backBagBuyAmt = defaultBuyAmt2;
  //           }
  //
  //           for (int i = 0; i < widget.flightInfo.listChildren.length; i++) {
  //             widget.flightInfo.listChildren[i].backPackage = defaultWeight2;
  //             widget.flightInfo.listChildren[i].backBagSellAmt =
  //                 defaultSellAmt2;
  //             widget.flightInfo.listChildren[i].backBagBuyAmt = defaultBuyAmt2;
  //           }
  //         }
  //       }
  //     }
  //   }
  // }

  Future<Null> _getBagages(String domain, String aircode1, String aircode2) async {
    // Giả lập độ trễ mạng 0.5 giây
    await Future.delayed(Duration(milliseconds: 500));

    // 1. DỮ LIỆU GIẢ LẬP CHO LƯỢT ĐI
    listPackage = ["Không mang hành lý (0 VND)", "15kg (150,000 VND)", "20kg (200,000 VND)"];
    mapPackage = {"0": "Không mang hành lý (0 VND)", "15": "15kg (150,000 VND)", "20": "20kg (200,000 VND)"};
    mapPackagePrice = {"0": 0, "15": 150000, "20": 200000};
    mapPackageBuyPrice = {"0": 0, "15": 130000, "20": 180000};

    // Gán mặc định lượt đi (0kg) cho tất cả hành khách
    for (int i = 0; i < widget.flightInfo.listAdults.length; i++) {
      widget.flightInfo.listAdults[i].departPackage = 0;
      widget.flightInfo.listAdults[i].departBagSellAmt = 0;
      widget.flightInfo.listAdults[i].departBagBuyAmt = 0;
    }
    for (int i = 0; i < widget.flightInfo.listChildren.length; i++) {
      widget.flightInfo.listChildren[i].departPackage = 0;
      widget.flightInfo.listChildren[i].departBagSellAmt = 0;
      widget.flightInfo.listChildren[i].departBagBuyAmt = 0;
    }

    // 2. DỮ LIỆU GIẢ LẬP CHO LƯỢT VỀ (NẾU CÓ)
    if (widget.flightInfo.isRoundTrip) {
      listPackage2 = ["Không mang hành lý (0 VND)", "15kg (150,000 VND)", "20kg (200,000 VND)"];
      mapPackage2 = {"0": "Không mang hành lý (0 VND)", "15": "15kg (150,000 VND)", "20": "20kg (200,000 VND)"};
      mapPackagePrice2 = {"0": 0, "15": 150000, "20": 200000};
      mapPackageBuyPrice2 = {"0": 0, "15": 130000, "20": 180000};

      for (int i = 0; i < widget.flightInfo.listAdults.length; i++) {
        widget.flightInfo.listAdults[i].backPackage = 0;
        widget.flightInfo.listAdults[i].backBagSellAmt = 0;
        widget.flightInfo.listAdults[i].backBagBuyAmt = 0;
      }
      for (int i = 0; i < widget.flightInfo.listChildren.length; i++) {
        widget.flightInfo.listChildren[i].backPackage = 0;
        widget.flightInfo.listChildren[i].backBagSellAmt = 0;
        widget.flightInfo.listChildren[i].backBagBuyAmt = 0;
      }
    }
  }

  // Future<Map<String, dynamic>> _calculateFares({
  //   required bool isRoundTrip,
  //   required String obAirCode,
  //   required int obBasePrice,
  //   required int noOfAdult,
  //   required int noOfChild,
  //   required int noOfInfant,
  //   required String depCode,
  //   required DateTime outboundDate,
  //   String? ibAirCode,
  //   int? ibBasePrice,
  //   String? arvCode,
  //   DateTime? inboundDate,
  // }) async {
  //   try {
  //     Map<String, String> body = {
  //       "domain": widget.flightInfo.storage["D"] ?? "",
  //       "ob_aircode": obAirCode,
  //       "ob_base_price": obBasePrice.toString(),
  //       "adt_count": noOfAdult.toString(),
  //       "chd_count": noOfChild.toString(),
  //       "inf_count": noOfInfant.toString(),
  //       "dep_code": depCode,
  //       "outbound_date": df.format(outboundDate),
  //     };
  //
  //     // neu la roundtrip
  //     if (isRoundTrip) {
  //       body["ib_aircode"] = ibAirCode!;
  //       body["ib_base_price"] = ibBasePrice.toString();
  //       body["arv_code"] = arvCode!;
  //       body["inbound_date"] = df.format(inboundDate!);
  //     }
  //
  //     var response = await http
  //         .post(Uri.parse(widget.flightInfo.storage["CalcFare"]!), headers: {
  //       tmpF.storage["NewK"]!: apiKey,
  //     }, body: body);
  //
  //     if (response.statusCode == 201) {
  //       var data = json.decode(response.body);
  //       if (data["error"] == false) {
  //         var responseData = data["data"];
  //         var outbound = responseData["outbound"];
  //
  //         Map<String, dynamic> result = {
  //           "delivery_fee": responseData["delivery_fee"] ?? 0,
  //           "total_amount": responseData["total_amount"] ?? 0,
  //           "outbound": {
  //             "adt_tax_fee": outbound["adt_tax_fee"] ?? 0,
  //             "chd_tax_fee": outbound["chd_tax_fee"] ?? 0,
  //             "inf_tax_fee": outbound["inf_tax_fee"] ?? 0,
  //             "chd_base_price": outbound["chd_base_price"] ?? 0,
  //             "inf_base_price": outbound["inf_base_price"] ?? 0,
  //           },
  //         };
  //
  //         // Neu co inbound
  //         if (isRoundTrip && responseData["inbound"] != null) {
  //           var inbound = responseData["inbound"];
  //           result["inbound"] = {
  //             "adt_tax_fee": inbound["adt_tax_fee"] ?? 0,
  //             "chd_tax_fee": inbound["chd_tax_fee"] ?? 0,
  //             "inf_tax_fee": inbound["inf_tax_fee"] ?? 0,
  //             "chd_base_price": inbound["chd_base_price"] ?? 0,
  //             "inf_base_price": inbound["inf_base_price"] ?? 0,
  //           };
  //         }
  //
  //         return result;
  //       }
  //     }
  //
  //     return _getEmptyFaresResult(isRoundTrip);
  //   } catch (e) {
  //     print("Error calculating fares: $e");
  //     return _getEmptyFaresResult(isRoundTrip);
  //   }
  // }

  Future<Map<String, dynamic>> _calculateFares({
    required bool isRoundTrip,
    required String obAirCode,
    required int obBasePrice,
    required int noOfAdult,
    required int noOfChild,
    required int noOfInfant,
    required String depCode,
    required DateTime outboundDate,
    String? ibAirCode,
    int? ibBasePrice,
    String? arvCode,
    DateTime? inboundDate,
  }) async {
    // Giả lập xử lý tính thuế
    await Future.delayed(Duration(milliseconds: 500));

    Map<String, dynamic> result = {
      "delivery_fee": 0,
      "total_amount": obBasePrice + 550000,
      "outbound": {
        "adt_tax_fee": 550000, // Thuế phí người lớn giả lập
        "chd_tax_fee": 450000, // Thuế phí trẻ em giả lập
        "inf_tax_fee": 100000, // Thuế phí em bé giả lập
        "chd_base_price": obBasePrice > 100000 ? obBasePrice - 100000 : obBasePrice,
        "inf_base_price": 0,
      },
    };

    if (isRoundTrip && ibBasePrice != null) {
      result["inbound"] = {
        "adt_tax_fee": 550000,
        "chd_tax_fee": 450000,
        "inf_tax_fee": 100000,
        "chd_base_price": ibBasePrice > 100000 ? ibBasePrice - 100000 : ibBasePrice,
        "inf_base_price": 0,
      };
    }
    return result;
  }

  Map<String, dynamic> _getEmptyFaresResult(bool isRoundTrip) {
    Map<String, dynamic> result = {
      "delivery_fee": 0,
      "total_amount": 0,
      "outbound": {
        "adt_tax_fee": 0,
        "chd_tax_fee": 0,
        "inf_tax_fee": 0,
        "chd_base_price": 0,
        "inf_base_price": 0,
      },
    };

    if (isRoundTrip) {
      result["inbound"] = {
        "adt_tax_fee": 0,
        "chd_tax_fee": 0,
        "inf_tax_fee": 0,
        "chd_base_price": 0,
        "inf_base_price": 0,
      };
    }

    return result;
  }

  printAdultInfoForm() {
    List<Widget> tmp = [];
    for (var i = 0; i < widget.flightInfo.noOfAdult; i++) {
      widget.flightInfo.listAdults.add(new Adult());
      tmp.add(Padding(
        padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.03,
          right: MediaQuery.of(context).size.width * 0.03,
          bottom: MediaQuery.of(context).size.width * 0.03,
        ),
        //Nen cua khung
        child: new Container(
          width: double.infinity,
          decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.width * 0.0171),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey,
                    blurRadius: MediaQuery.of(context).size.width * 0.00571)
              ]),
          child: new Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              //Tieu de
              new Container(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.0314),
                width: double.infinity,
                decoration: new BoxDecoration(
                  color: Colors.orangeAccent,
                ),
                child: new Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Text(
                        "Hành khách người lớn ${i + 1}",
                        style: new TextStyle(
                            color: Colors.black,
                            fontFamily: "Roboto Medium",
                            fontSize:
                                MediaQuery.of(context).size.width * 0.0457),
                      ),
                      new Text(
                        "*",
                        style: new TextStyle(
                            color: Colors.red,
                            fontFamily: "Roboto Medium",
                            fontSize:
                                MediaQuery.of(context).size.width * 0.0457),
                      ),
                    ],
                  ),
                ),
              ),
              //Phan than cua form dien thong tin
              Padding(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.0114),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Row đầu tiên: Ông/Bà và Họ tên
                    new Row(
                      children: <Widget>[
                        // Dropdown Ông/Bà
                        Container(
                          width: MediaQuery.of(context).size.width * 0.25,
                          height: MediaQuery.of(context).size.width * 0.12,
                          margin: EdgeInsets.only(
                              right: MediaQuery.of(context).size.width * 0.02),
                          decoration: new BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(
                                MediaQuery.of(context).size.width * 0.0171),
                          ),
                          child: new DropdownButton(
                            iconSize:
                                MediaQuery.of(context).size.width * 0.0743,
                            value: widget.flightInfo.listAdults[i].gender,
                            onChanged: (String? value) {
                              setState(() {
                                widget.flightInfo.listAdults[i].gender = value!;
                              });
                            },
                            items: listAdultCall.map((String call) {
                              return new DropdownMenuItem(
                                value: call,
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Icon(
                                      Icons.person,
                                      color: Colors.orangeAccent,
                                      size: MediaQuery.of(context).size.width *
                                          0.0571,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.0171),
                                      child: new Text(
                                        call,
                                        style: new TextStyle(
                                            color: Colors.black87,
                                            fontFamily: "Roboto Medium",
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.0343),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),

                        // TextField Họ tên
                        Flexible(
                          child: Container(
                            height: MediaQuery.of(context).size.width * 0.12,
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width * 0.0314),
                            decoration: new BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(
                                    MediaQuery.of(context).size.width *
                                        0.0171)),
                            child: new TextField(
                              decoration: new InputDecoration.collapsed(
                                  hintText: widget.flightInfo.listAdults[i]
                                              .fullname.length ==
                                          0
                                      ? "Nhập họ và tên (Bắt buộc)"
                                      : widget
                                          .flightInfo.listAdults[i].fullname,
                                  hintStyle: new TextStyle(
                                      fontFamily: "Roboto Medium",
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.04)),
                              onChanged: (String value) {
                                setState(() {
                                  widget.flightInfo.listAdults[i].fullname =
                                      value;
                                  widget.flightInfo.listAdults[i].checkFilled();
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Ô nhập CCCD/Passport
                    Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.width * 0.03,
                        bottom: MediaQuery.of(context).size.width * 0.02,
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.0314),
                        decoration: new BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(
                                MediaQuery.of(context).size.width * 0.0171)),
                        child: new TextField(
                          decoration: new InputDecoration.collapsed(
                              hintText: widget.flightInfo.listAdults[i]
                                          .cccd_passport.length ==
                                      0
                                  ? "Nhập số CCCD/Passport"
                                  : widget
                                      .flightInfo.listAdults[i].cccd_passport,
                              hintStyle: new TextStyle(
                                  fontFamily: "Roboto Medium",
                                  fontSize: MediaQuery.of(context).size.width *
                                      0.04)),
                          onChanged: (String value) {
                            setState(() {
                              widget.flightInfo.listAdults[i].cccd_passport =
                                  value;
                              widget.flightInfo.listAdults[i].checkFilled();
                            });
                          },
                        ),
                      ),
                    ),

                    // Row thứ hai: Lượt đi và hành lý
                    new Row(
                      children: <Widget>[
                        // Text Lượt đi
                        Padding(
                          padding: EdgeInsets.only(
                              right: MediaQuery.of(context).size.width * 0.02),
                          child: Row(
                            children: <Widget>[
                              new Icon(
                                Icons.arrow_drop_down_circle,
                                color: Colors.orangeAccent,
                                size: MediaQuery.of(context).size.width * 0.05,
                              ),
                              new Text(
                                " Lượt đi: ",
                                style: new TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Roboto Medium",
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.04),
                              ),
                            ],
                          ),
                        ),

                        // Dropdown hành lý lượt đi
                        Flexible(
                          child: Container(
                            decoration: new BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.width * 0.0171),
                            ),
                            child: new DropdownButton(
                              iconSize: 0.0,
                              value: mapPackage[
                                  "${widget.flightInfo.listAdults[i].departPackage}"],
                              onChanged: (String? value) {
                                setState(() {
                                  widget
                                      .flightInfo.totalPrice -= mapPackagePrice[
                                          "${widget.flightInfo.listAdults[i].departPackage}"]
                                      as int;

                                  for (var entry in mapPackage.entries) {
                                    if (entry.value == value) {
                                      widget.flightInfo.listAdults[i]
                                          .departPackage = int.parse(entry.key);
                                      break;
                                    }
                                  }

                                  final w = widget
                                      .flightInfo.listAdults[i].departPackage;
                                  widget.flightInfo.listAdults[i]
                                          .departBagSellAmt =
                                      (mapPackagePrice["$w"] ?? 0) as int;

                                  widget.flightInfo.listAdults[i]
                                          .departBagBuyAmt =
                                      (mapPackageBuyPrice["$w"] ?? 0) as int;

                                  widget
                                      .flightInfo.totalPrice += mapPackagePrice[
                                          "${widget.flightInfo.listAdults[i].departPackage}"]
                                      as int;
                                });
                              },
                              items: listPackage.map((String call) {
                                return new DropdownMenuItem(
                                  value: call,
                                  child: FittedBox(
                                    child: new Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        new Icon(
                                          Icons.launch,
                                          color: Colors.blue,
                                          size: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.0314,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.0171),
                                          child: Center(
                                            child: new Text(
                                              call,
                                              style: new TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: "Roboto Medium",
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.0371),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Row thứ ba: Lượt về và hành lý (nếu round trip)
                    widget.flightInfo.isRoundTrip
                        ? Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.width * 0.02),
                            child: new Row(
                              children: <Widget>[
                                // Text Lượt về
                                Padding(
                                  padding: EdgeInsets.only(
                                      right: MediaQuery.of(context).size.width *
                                          0.02),
                                  child: Row(
                                    children: <Widget>[
                                      new Icon(
                                        Icons.arrow_drop_down_circle,
                                        color: Colors.orangeAccent,
                                        size:
                                            MediaQuery.of(context).size.width *
                                                0.05,
                                      ),
                                      new Text(
                                        " Lượt về: ",
                                        style: new TextStyle(
                                            color: Colors.black,
                                            fontFamily: "Roboto Medium",
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.04),
                                      ),
                                    ],
                                  ),
                                ),

                                // Dropdown hành lý lượt về
                                Flexible(
                                  child: Container(
                                    decoration: new BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(
                                          MediaQuery.of(context).size.width *
                                              0.0171),
                                    ),
                                    child: new DropdownButton(
                                      iconSize: 0.0,
                                      value: mapPackage2[
                                          "${widget.flightInfo.listAdults[i].backPackage}"],
                                      onChanged: (String? value) {
                                        setState(() {
                                          widget.flightInfo
                                              .totalPrice -= mapPackagePrice2[
                                                  "${widget.flightInfo.listAdults[i].backPackage}"]
                                              as int;

                                          for (var entry
                                              in mapPackage2.entries) {
                                            if (entry.value == value) {
                                              widget.flightInfo.listAdults[i]
                                                      .backPackage =
                                                  int.parse(entry.key);
                                              break;
                                            }
                                          }

                                          final w2 = widget.flightInfo
                                              .listAdults[i].backPackage;
                                          widget.flightInfo.listAdults[i]
                                                  .backBagSellAmt =
                                              (mapPackagePrice2["$w2"] ?? 0)
                                                  as int;
                                          widget.flightInfo.listAdults[i]
                                                  .backBagBuyAmt =
                                              (mapPackageBuyPrice2["$w2"] ?? 0)
                                                  as int;

                                          widget.flightInfo
                                              .totalPrice += mapPackagePrice2[
                                                  "${widget.flightInfo.listAdults[i].backPackage}"]
                                              as int;
                                        });
                                      },
                                      items: listPackage2.map((String call) {
                                        return new DropdownMenuItem(
                                          value: call,
                                          child: new Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: <Widget>[
                                              new Icon(
                                                Icons.launch,
                                                color: Colors.blue,
                                                size: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.0314,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.0171),
                                                child: Center(
                                                  child: new Text(
                                                    call,
                                                    style: new TextStyle(
                                                        color: Colors.black,
                                                        fontFamily:
                                                            "Roboto Medium",
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.0371),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : new Container(),

                    // Ngày tháng năm sinh
                    Padding(
                      padding: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width * 0.0114,
                        left: MediaQuery.of(context).size.width * 0.0114,
                        top: MediaQuery.of(context).size.width * 0.04,
                        bottom: MediaQuery.of(context).size.width * 0.04,
                      ),
                      child: new Text(
                        "Ngày tháng năm sinh: ",
                        style: new TextStyle(
                            color: Colors.black87,
                            fontFamily: "Roboto Medium",
                            fontSize: MediaQuery.of(context).size.width * 0.04),
                      ),
                    ),
                    // Chọn ngày tháng năm sinh
                    new Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        //Chọn ngày
                        Padding(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 0.0114),
                          child: Container(
                            height: MediaQuery.of(context).size.width * 0.1143,
                            width: MediaQuery.of(context).size.width * 0.263,
                            decoration: new BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.width * 0.0171),
                            ),
                            child: new DropdownButton(
                              iconSize:
                                  MediaQuery.of(context).size.width * 0.0743,
                              value: widget.flightInfo.listAdults[i].day,
                              onChanged: (String? value) {
                                setState(() {
                                  widget.flightInfo.listAdults[i].day = value!;
                                  widget.flightInfo.listAdults[i].checkFilled();
                                });
                              },
                              items: listDay.map((String call) {
                                return new DropdownMenuItem(
                                  value: call,
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Icon(
                                        Icons.date_range,
                                        color: Colors.orangeAccent,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.06),
                                        child: new Text(
                                          call,
                                          style: new TextStyle(
                                              color: Colors.black,
                                              fontFamily: "Roboto Medium",
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.0343),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        //

                        //Chọn tháng
                        Padding(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 0.0114),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.263,
                            height: MediaQuery.of(context).size.width * 0.1143,
                            decoration: new BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.width * 0.0171),
                            ),
                            child: new DropdownButton(
                              iconSize:
                                  MediaQuery.of(context).size.width * 0.0743,
                              value: widget.flightInfo.listAdults[i].month,
                              onChanged: (String? value) {
                                setState(() {
                                  widget.flightInfo.listAdults[i].month =
                                      value!;
                                  widget.flightInfo.listAdults[i].checkFilled();
                                });
                              },
                              items: listMonth.map((String call) {
                                return new DropdownMenuItem(
                                  value: call,
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Icon(
                                        Icons.date_range,
                                        color: Colors.orangeAccent,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.06),
                                        child: new Text(
                                          call,
                                          style: new TextStyle(
                                              color: Colors.black,
                                              fontFamily: "Roboto Medium",
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.0343),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        //

                        //Chọn năm
                        Padding(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 0.0114),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.32,
                            height: MediaQuery.of(context).size.width * 0.1143,
                            decoration: new BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.width * 0.0171),
                            ),
                            child: new DropdownButton(
                              iconSize:
                                  MediaQuery.of(context).size.width * 0.0743,
                              value: widget.flightInfo.listAdults[i].year,
                              onChanged: (String? value) {
                                setState(() {
                                  widget.flightInfo.listAdults[i].year = value!;
                                  widget.flightInfo.listAdults[i].checkFilled();
                                });
                              },
                              items: listYearAdult.map((String call) {
                                return new DropdownMenuItem(
                                  value: call,
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Icon(
                                        Icons.date_range,
                                        color: Colors.orangeAccent,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.0457),
                                        child: new Text(
                                          call,
                                          style: new TextStyle(
                                              color: Colors.black,
                                              fontFamily: "Roboto Medium",
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.0343),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        //
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ));
    }
    return tmp;
  }

  printChildInfoForm() {
    List<Widget> tmp = [];
    for (var i = 0; i < widget.flightInfo.noOfChild; i++) {
      widget.flightInfo.listChildren.add(new Child());
      tmp.add(Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
        //Nen cua khung
        child: new Container(
          width: double.infinity,
          decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.width * 0.0114),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey,
                    blurRadius: MediaQuery.of(context).size.width * 0.00571)
              ]),
          child: new Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //Tieu de
              new Container(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.0314),
                width: double.infinity,
                decoration: new BoxDecoration(
                  color: Colors.orangeAccent,
                ),
                child: new Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Text(
                        "Hành khách trẻ em ${i + 1}",
                        style: new TextStyle(
                            color: Colors.black,
                            fontFamily: "Roboto Medium",
                            fontSize:
                                MediaQuery.of(context).size.width * 0.0457),
                      ),
                      new Text(
                        "*",
                        style: new TextStyle(
                            color: Colors.red,
                            fontFamily: "Roboto Medium",
                            fontSize:
                                MediaQuery.of(context).size.width * 0.0457),
                      ),
                    ],
                  ),
                ),
              ),
              //Phan than cua form dien thong tin
              Padding(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.0114),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //Header e.g: Trai, gái...
                    new Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 0.0114),
                          child: Container(
                            //height: MediaQuery.of(context).size.width * 0.1143,
                            decoration: new BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.width * 0.0171),
                            ),
                            child: new DropdownButton(
                              iconSize:
                                  MediaQuery.of(context).size.width * 0.0743,
                              value: widget.flightInfo.listChildren[i].gender,
                              onChanged: (String? value) {
                                setState(() {
                                  widget.flightInfo.listChildren[i].gender =
                                      value!;
                                });
                              },
                              items: listGender.map((String call) {
                                return new DropdownMenuItem(
                                  value: call,
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Icon(
                                        Icons.person,
                                        color: Colors.orangeAccent,
                                        size:
                                            MediaQuery.of(context).size.width *
                                                0.0571,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.0171),
                                        child: new Text(
                                          call,
                                          style: new TextStyle(
                                              color: Colors.black,
                                              fontFamily: "Roboto Medium",
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.0343),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        Flexible(
                          child: new Padding(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width * 0.0114),
                            child: Container(
                              padding: EdgeInsets.only(
                                left:
                                    MediaQuery.of(context).size.width * 0.0314,
                                top: MediaQuery.of(context).size.width * 0.0314,
                                bottom:
                                    MediaQuery.of(context).size.width * 0.0314,
                              ),
                              decoration: new BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(
                                      MediaQuery.of(context).size.width *
                                          0.0171)),
                              child: new TextField(
                                decoration: new InputDecoration.collapsed(
                                    hintText: widget.flightInfo.listChildren[i]
                                                .fullname.length ==
                                            0
                                        ? "Nhập họ và tên (Bắt buộc)"
                                        : widget.flightInfo.listChildren[i]
                                            .fullname,
                                    hintStyle: new TextStyle(
                                        fontFamily: "Roboto Medium",
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.04)),
                                onChanged: (String value) {
                                  setState(() {
                                    widget.flightInfo.listChildren[i].fullname =
                                        value;

                                    widget.flightInfo.listChildren[i].isFilled =
                                        true;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Hanh ly ==============
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Container(
                          width: MediaQuery.of(context).size.width * 0.23,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left:
                                    MediaQuery.of(context).size.width * 0.015),
                            child: Row(
                              children: <Widget>[
                                new Icon(
                                  Icons.arrow_drop_down_circle,
                                  color: Colors.orangeAccent,
                                  size:
                                      MediaQuery.of(context).size.width * 0.05,
                                ),
                                new Text(
                                  " Lượt đi: ",
                                  style: new TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Roboto Medium",
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.04),
                                ),
                              ],
                            ),
                          ),
                        ),

                        //Chon hanh li ky gui luot di
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.width * 0.03,
                                bottom:
                                    MediaQuery.of(context).size.width * 0.03,
                                right:
                                    MediaQuery.of(context).size.width * 0.0114,
                                left:
                                    MediaQuery.of(context).size.width * 0.0114),
                            child: Container(
                              width: double.infinity,
                              decoration: new BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(
                                    MediaQuery.of(context).size.width * 0.0171),
                              ),
                              child: new DropdownButton(
                                iconSize: 0.0,
                                value: mapPackage[
                                    "${widget.flightInfo.listChildren[i].departPackage}"],
                                onChanged: (String? value) {
                                  setState(() {
                                    widget.flightInfo
                                        .totalPrice -= mapPackagePrice[
                                            "${widget.flightInfo.listChildren[i].departPackage}"]
                                        as int;

                                    for (var entry in mapPackage.entries) {
                                      if (entry.value == value) {
                                        widget.flightInfo.listChildren[i]
                                                .departPackage =
                                            int.parse(entry.key);
                                        break;
                                      }
                                    }

                                    final w = widget.flightInfo.listChildren[i]
                                        .departPackage;
                                    widget.flightInfo.listChildren[i]
                                            .departBagSellAmt =
                                        (mapPackagePrice["$w"] ?? 0) as int;
                                    widget.flightInfo.listChildren[i]
                                            .departBagBuyAmt =
                                        (mapPackageBuyPrice["$w"] ?? 0) as int;

                                    // if (value.contains("15kg"))
                                    //   widget.flightInfo.listChildren[i]
                                    //       .departPackage = 15;
                                    // if (value.contains("20kg"))
                                    //   widget.flightInfo.listChildren[i]
                                    //       .departPackage = 20;
                                    // if (value.contains("25kg"))
                                    //   widget.flightInfo.listChildren[i]
                                    //       .departPackage = 25;
                                    // if (value.contains("30kg"))
                                    //   widget.flightInfo.listChildren[i]
                                    //       .departPackage = 30;
                                    // if (value.contains("35kg"))
                                    //   widget.flightInfo.listChildren[i]
                                    //       .departPackage = 35;
                                    // if (value.contains("40kg"))
                                    //   widget.flightInfo.listChildren[i]
                                    //       .departPackage = 40;
                                    //
                                    widget.flightInfo
                                        .totalPrice += mapPackagePrice[
                                            "${widget.flightInfo.listChildren[i].departPackage}"]
                                        as int;
                                  });
                                },
                                items: listPackage.map((String call) {
                                  return new DropdownMenuItem(
                                    value: call,
                                    child: new Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        new Icon(
                                          Icons.launch,
                                          color: Colors.blue,
                                          size: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.0314,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.0171),
                                          child: Center(
                                            child: new Text(
                                              call,
                                              style: new TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: "Roboto Medium",
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.0371),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                        //
                      ],
                    ),

                    widget.flightInfo.isRoundTrip
                        ? new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              new Container(
                                width: MediaQuery.of(context).size.width * 0.23,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.015),
                                  child: Row(
                                    children: <Widget>[
                                      new Icon(
                                        Icons.arrow_drop_down_circle,
                                        color: Colors.orangeAccent,
                                        size:
                                            MediaQuery.of(context).size.width *
                                                0.05,
                                      ),
                                      new Text(
                                        " Lượt về:",
                                        style: new TextStyle(
                                            color: Colors.black,
                                            fontFamily: "Roboto Medium",
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.04),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              //Chon hanh li ky gui luot ve
                              widget.flightInfo.isRoundTrip
                                  ? Flexible(
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                            MediaQuery.of(context).size.width *
                                                0.0114),
                                        child: Container(
                                          width: double.infinity,
                                          decoration: new BoxDecoration(
                                            color: Colors.grey[100],
                                            borderRadius: BorderRadius.circular(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.0171),
                                          ),
                                          child: new DropdownButton(
                                            iconSize: 0.0,
                                            value: mapPackage2[
                                                "${widget.flightInfo.listChildren[i].backPackage}"],
                                            onChanged: (String? value) {
                                              setState(() {
                                                widget.flightInfo.totalPrice -=
                                                    mapPackagePrice2[
                                                            "${widget.flightInfo.listChildren[i].backPackage}"]
                                                        as int;

                                                for (var entry
                                                    in mapPackage2.entries) {
                                                  if (entry.value == value) {
                                                    widget
                                                            .flightInfo
                                                            .listChildren[i]
                                                            .backPackage =
                                                        int.parse(entry.key);
                                                    break;
                                                  }
                                                }

                                                final w2 = widget
                                                    .flightInfo
                                                    .listChildren[i]
                                                    .backPackage;
                                                widget
                                                        .flightInfo
                                                        .listChildren[i]
                                                        .backBagSellAmt =
                                                    (mapPackagePrice2["$w2"] ??
                                                        0) as int;
                                                widget
                                                        .flightInfo
                                                        .listChildren[i]
                                                        .backBagBuyAmt =
                                                    (mapPackageBuyPrice2[
                                                            "$w2"] ??
                                                        0) as int;

                                                // if (value.contains("15kg"))
                                                //   widget
                                                //       .flightInfo
                                                //       .listChildren[i]
                                                //       .backPackage = 15;
                                                // if (value.contains("20kg"))
                                                //   widget
                                                //       .flightInfo
                                                //       .listChildren[i]
                                                //       .backPackage = 20;
                                                // if (value.contains("25kg"))
                                                //   widget
                                                //       .flightInfo
                                                //       .listChildren[i]
                                                //       .backPackage = 25;
                                                // if (value.contains("30kg"))
                                                //   widget
                                                //       .flightInfo
                                                //       .listChildren[i]
                                                //       .backPackage = 30;
                                                // if (value.contains("35kg"))
                                                //   widget
                                                //       .flightInfo
                                                //       .listChildren[i]
                                                //       .backPackage = 35;
                                                // if (value.contains("40kg"))
                                                //   widget
                                                //       .flightInfo
                                                //       .listChildren[i]
                                                //       .backPackage = 40;

                                                widget.flightInfo.totalPrice +=
                                                    mapPackagePrice2[
                                                            "${widget.flightInfo.listChildren[i].backPackage}"]
                                                        as int;
                                              });
                                            },
                                            items:
                                                listPackage2.map((String call) {
                                              return new DropdownMenuItem(
                                                value: call,
                                                child: new Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: <Widget>[
                                                    new Icon(
                                                      Icons.launch,
                                                      color: Colors.blue,
                                                      size:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.0314,
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.0171),
                                                      child: Center(
                                                        child: new Text(
                                                          call,
                                                          style: new TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  "Roboto Medium",
                                                              fontSize: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.0371),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    )
                                  : new Container(),
                              //
                            ],
                          )
                        : new Container(),
                    //====================
                    Padding(
                      padding: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width * 0.0114,
                        left: MediaQuery.of(context).size.width * 0.0114,
                        top: MediaQuery.of(context).size.width * 0.04,
                        bottom: MediaQuery.of(context).size.width * 0.04,
                      ),
                      child: new Text(
                        "Ngày tháng năm sinh: ",
                        style: new TextStyle(
                            color: Colors.black87,
                            fontFamily: "Roboto Medium",
                            fontSize: MediaQuery.of(context).size.width * 0.04),
                      ),
                    ),
                    // Bat chon ngay thang nam sinh
                    new Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        //Chon ngày
                        Padding(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 0.0114),
                          child: Container(
                            height: MediaQuery.of(context).size.width * 0.1143,
                            width: MediaQuery.of(context).size.width * 0.263,
                            decoration: new BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.width * 0.0171),
                            ),
                            child: new DropdownButton(
                              iconSize:
                                  MediaQuery.of(context).size.width * 0.0743,
                              value: widget.flightInfo.listChildren[i].day,
                              onChanged: (String? value) {
                                setState(() {
                                  widget.flightInfo.listChildren[i].day =
                                      value!;
                                });
                              },
                              items: listDay.map((String call) {
                                return new DropdownMenuItem(
                                  value: call,
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Icon(
                                        Icons.date_range,
                                        color: Colors.orangeAccent,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.06),
                                        child: new Text(
                                          call,
                                          style: new TextStyle(
                                              color: Colors.black,
                                              fontFamily: "Roboto Medium",
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.0343),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        //

                        //Chon thang
                        Padding(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 0.0114),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.263,
                            height: MediaQuery.of(context).size.width * 0.1143,
                            decoration: new BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.width * 0.0171),
                            ),
                            child: new DropdownButton(
                              iconSize:
                                  MediaQuery.of(context).size.width * 0.0743,
                              value: widget.flightInfo.listChildren[i].month,
                              onChanged: (String? value) {
                                setState(() {
                                  widget.flightInfo.listChildren[i].month =
                                      value!;
                                });
                              },
                              items: listMonth.map((String call) {
                                return new DropdownMenuItem(
                                  value: call,
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Icon(
                                        Icons.date_range,
                                        color: Colors.orangeAccent,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.06),
                                        child: new Text(
                                          call,
                                          style: new TextStyle(
                                              color: Colors.black,
                                              fontFamily: "Roboto Medium",
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.0343),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        //

                        //Chon nam
                        Padding(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 0.0114),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.32,
                            height: MediaQuery.of(context).size.width * 0.1143,
                            decoration: new BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.width * 0.0171),
                            ),
                            child: new DropdownButton(
                              iconSize:
                                  MediaQuery.of(context).size.width * 0.0743,
                              value: widget.flightInfo.listChildren[i].year,
                              onChanged: (String? value) {
                                setState(() {
                                  widget.flightInfo.listChildren[i].year =
                                      value!;
                                });
                              },
                              items: listYear.map((String call) {
                                return new DropdownMenuItem(
                                  value: call,
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Icon(
                                        Icons.date_range,
                                        color: Colors.orangeAccent,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.0457),
                                        child: new Text(
                                          call,
                                          style: new TextStyle(
                                              color: Colors.black,
                                              fontFamily: "Roboto Medium",
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.0343),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        //
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ));
    }
    return tmp;
  }

  printInfantInfoForm() {
    List<Widget> tmp = [];
    for (var i = 0; i < widget.flightInfo.noOfInfant; i++) {
      widget.flightInfo.listInfants.add(new Child());
      tmp.add(Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
        //Nen cua khung
        child: new Container(
          width: double.infinity,
          decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.width * 0.0114),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey,
                    blurRadius: MediaQuery.of(context).size.width * 0.00571)
              ]),
          child: new Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //Tieu de
              new Container(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.0314),
                width: double.infinity,
                decoration: new BoxDecoration(
                  color: Colors.orangeAccent,
                ),
                child: new Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Text(
                        "Hành khách trẻ sơ sinh ${i + 1}",
                        style: new TextStyle(
                            color: Colors.black,
                            fontFamily: "Roboto Medium",
                            fontSize:
                                MediaQuery.of(context).size.width * 0.0457),
                      ),
                      new Text(
                        "*",
                        style: new TextStyle(
                            color: Colors.red,
                            fontFamily: "Roboto Medium",
                            fontSize:
                                MediaQuery.of(context).size.width * 0.0457),
                      ),
                    ],
                  ),
                ),
              ),
              //Phan than cua form dien thong tin
              Padding(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.0114),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //Header e.g: Trai, gái...
                    new Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 0.0114),
                          child: Container(
                            height: MediaQuery.of(context).size.width * 0.1143,
                            decoration: new BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.width * 0.0171),
                            ),
                            child: new DropdownButton(
                              iconSize:
                                  MediaQuery.of(context).size.width * 0.0743,
                              value: widget.flightInfo.listInfants[i].gender,
                              onChanged: (String? value) {
                                setState(() {
                                  widget.flightInfo.listInfants[i].gender =
                                      value!;
                                });
                              },
                              items: listGender.map((String call) {
                                return new DropdownMenuItem(
                                  value: call,
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Icon(
                                        Icons.person,
                                        color: Colors.orangeAccent,
                                        size:
                                            MediaQuery.of(context).size.width *
                                                0.0571,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.0171),
                                        child: new Text(
                                          call,
                                          style: new TextStyle(
                                              color: Colors.black,
                                              fontFamily: "Roboto Medium",
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.0343),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        Flexible(
                          child: new Padding(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width * 0.0114),
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width *
                                      0.0314,
                                  top: MediaQuery.of(context).size.width *
                                      0.0314,
                                  bottom: MediaQuery.of(context).size.width *
                                      0.0314),
                              decoration: new BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(
                                      MediaQuery.of(context).size.width *
                                          0.0171)),
                              child: new TextField(
                                decoration: new InputDecoration.collapsed(
                                    hintText: widget.flightInfo.listInfants[i]
                                                .fullname.length ==
                                            0
                                        ? "Nhập họ và tên (Bắt buộc)"
                                        : widget
                                            .flightInfo.listInfants[i].fullname,
                                    hintStyle: new TextStyle(
                                        fontFamily: "Roboto Medium",
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.04)),
                                onChanged: (String value) {
                                  setState(() {
                                    widget.flightInfo.listInfants[i].fullname =
                                        value;
                                    widget.flightInfo.listInfants[i].isFilled =
                                        true;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.0114),
                      child: new Text(
                        "Ngày tháng năm sinh: ",
                        style: new TextStyle(
                            color: Colors.black87,
                            fontFamily: "Roboto Medium",
                            fontSize: MediaQuery.of(context).size.width * 0.04),
                      ),
                    ),
                    // Bat chon ngay thang nam sinh
                    new Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        //Chon ngày
                        Padding(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 0.0114),
                          child: Container(
                            height: MediaQuery.of(context).size.width * 0.1143,
                            width: MediaQuery.of(context).size.width * 0.263,
                            decoration: new BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.width * 0.0171),
                            ),
                            child: new DropdownButton(
                              iconSize:
                                  MediaQuery.of(context).size.width * 0.0743,
                              value: widget.flightInfo.listInfants[i].day,
                              onChanged: (String? value) {
                                setState(() {
                                  widget.flightInfo.listInfants[i].day = value!;
                                });
                              },
                              items: listDay.map((String call) {
                                return new DropdownMenuItem(
                                  value: call,
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Icon(
                                        Icons.date_range,
                                        color: Colors.orangeAccent,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.06),
                                        child: new Text(
                                          call,
                                          style: new TextStyle(
                                              color: Colors.black,
                                              fontFamily: "Roboto Medium",
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.0343),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        //

                        //Chon thang
                        Padding(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 0.0114),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.263,
                            height: MediaQuery.of(context).size.width * 0.1143,
                            decoration: new BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.width * 0.0171),
                            ),
                            child: new DropdownButton(
                              iconSize:
                                  MediaQuery.of(context).size.width * 0.0743,
                              value: widget.flightInfo.listInfants[i].month,
                              onChanged: (String? value) {
                                setState(() {
                                  widget.flightInfo.listInfants[i].month =
                                      value!;
                                });
                              },
                              items: listMonth.map((String call) {
                                return new DropdownMenuItem(
                                  value: call,
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Icon(
                                        Icons.date_range,
                                        color: Colors.orangeAccent,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.06),
                                        child: new Text(
                                          call,
                                          style: new TextStyle(
                                              color: Colors.black,
                                              fontFamily: "Roboto Medium",
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.0343),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        //

                        //Chon nam
                        Padding(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 0.0114),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.32,
                            height: MediaQuery.of(context).size.width * 0.1143,
                            decoration: new BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.width * 0.0171),
                            ),
                            child: new DropdownButton(
                              iconSize:
                                  MediaQuery.of(context).size.width * 0.0743,
                              value: widget.flightInfo.listInfants[i].year,
                              onChanged: (String? value) {
                                setState(() {
                                  widget.flightInfo.listInfants[i].year =
                                      value!;
                                });
                              },
                              items: listYear.map((String call) {
                                return new DropdownMenuItem(
                                  value: call,
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Icon(
                                        Icons.date_range,
                                        color: Colors.orangeAccent,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.0457),
                                        child: new Text(
                                          call,
                                          style: new TextStyle(
                                              color: Colors.black,
                                              fontFamily: "Roboto Medium",
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.0343),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        //
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ));
    }
    return tmp;
  }

  printInfoOfMainContact() {
    Column tmp = Column(
      children: <Widget>[
        new Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
          child: new Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.width * 0.03),
            width: double.infinity,
            height: MediaQuery.of(context).size.width * 1.15,
            decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width * 0.0171),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey[600] ?? Colors.grey,
                      blurRadius: MediaQuery.of(context).size.width * 0.00571)
                ]),
            child: new Column(
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.all(
                      MediaQuery.of(context).size.width * 0.0314),
                  decoration: new BoxDecoration(
                    color: Colors.orangeAccent,
                  ),
                  child: new Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Text(
                          "Thông tin liên hệ",
                          style: new TextStyle(
                              color: Colors.black,
                              fontFamily: "Roboto Medium",
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.0457),
                        ),
                        new Text(
                          "*",
                          style: new TextStyle(
                              color: Colors.red,
                              fontFamily: "Roboto Medium",
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.0457),
                        ),
                      ],
                    ),
                  ),
                ),
                //new Flexible(
                Padding(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
                  child: new Row(
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.width * 0.1143,
                        decoration: new BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(
                              MediaQuery.of(context).size.width * 0.0143),
                        ),
                        child: new DropdownButton(
                          iconSize: MediaQuery.of(context).size.width * 0.0743,
                          value: widget.flightInfo.contact.gender,
                          onChanged: (String? value) {
                            setState(() {
                              widget.flightInfo.contact.gender = value!;
                            });
                          },
                          items: listAdultCall.map((String call) {
                            return new DropdownMenuItem(
                              value: call,
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Icon(
                                    Icons.person,
                                    color: Colors.orangeAccent,
                                    size: MediaQuery.of(context).size.width *
                                        0.0571,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.02),
                                    child: new Text(
                                      call,
                                      style: new TextStyle(
                                          color: Colors.black,
                                          fontFamily: "Roboto Medium",
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.0343),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      ///////////////////////////////////

                      Flexible(
                        child: new Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.0171,
                              right:
                                  MediaQuery.of(context).size.width * 0.0114),
                          child: Container(
                            height: MediaQuery.of(context).size.width * 0.115,
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width * 0.0314),
                            decoration: new BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(
                                    MediaQuery.of(context).size.width *
                                        0.0171)),
                            child: new TextField(
                              decoration: new InputDecoration.collapsed(
                                  hintText: widget.flightInfo.contact.fullname
                                              .length ==
                                          0
                                      ? "Nhập họ và tên (Bắt buộc)"
                                      : widget.flightInfo.contact.fullname,
                                  hintStyle: new TextStyle(
                                      fontFamily: "Roboto Medium",
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.04)),
                              onChanged: (String value) {
                                setState(() {
                                  widget.flightInfo.contact.fullname = value;

                                  widget.flightInfo.contact.isFilled = true;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //),

                /// -----------------------------------------
                new Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.width * 0.0171),
                ),
                new Flexible(
                  child: new Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.02,
                            top: MediaQuery.of(context).size.width * 0.02,
                            bottom: MediaQuery.of(context).size.width * 0.02,
                            right: MediaQuery.of(context).size.width * 0.02),
                        child: new Text(
                          "Điện thoại:",
                          style: new TextStyle(
                              color: Colors.black,
                              fontFamily: "Roboto Medium",
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04),
                        ),
                      ),
                      Flexible(
                        child: new Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.02,
                              right: MediaQuery.of(context).size.width * 0.02),
                          child: Container(
                            height: MediaQuery.of(context).size.width * 0.115,
                            padding: EdgeInsets.only(
                                left:
                                    MediaQuery.of(context).size.width * 0.0314,
                                top: MediaQuery.of(context).size.width * 0.0314,
                                bottom:
                                    MediaQuery.of(context).size.width * 0.0314),
                            decoration: new BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(
                                    MediaQuery.of(context).size.width *
                                        0.0171)),
                            child: new TextField(
                              keyboardType: TextInputType.number,
                              decoration: new InputDecoration.collapsed(
                                  hintText:
                                      widget.flightInfo.contact.phone.length ==
                                              0
                                          ? "Nhập số điện thoại (Bắt buộc)"
                                          : widget.flightInfo.contact.phone,
                                  hintStyle: new TextStyle(
                                      fontFamily: "Roboto Medium",
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.04)),
                              onChanged: (String value) {
                                setState(() {
                                  widget.flightInfo.contact.phone = value;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                /// ----------------------------------------

                // -----------------------------------------
                /// -----------------------------------------
                new Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.width * 0.0314),
                ),
                new Flexible(
                  child: new Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.02,
                            top: MediaQuery.of(context).size.width * 0.02,
                            bottom: MediaQuery.of(context).size.width * 0.02,
                            right: MediaQuery.of(context).size.width * 0.1),
                        child: new Text(
                          "Email: ",
                          style: new TextStyle(
                              color: Colors.black,
                              fontFamily: "Roboto Medium",
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04),
                        ),
                      ),
                      Flexible(
                        child: new Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.0171,
                              right:
                                  MediaQuery.of(context).size.width * 0.0257),
                          child: Container(
                            padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.0314,
                              top: MediaQuery.of(context).size.width * 0.0314,
                              bottom:
                                  MediaQuery.of(context).size.width * 0.0314,
                            ),
                            decoration: new BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(
                                    MediaQuery.of(context).size.width *
                                        0.0171)),
                            child: new TextField(
                              decoration: new InputDecoration.collapsed(
                                  hintText:
                                      widget.flightInfo.contact.email.length ==
                                              0
                                          ? "Nhập email"
                                          : widget.flightInfo.contact.email,
                                  hintStyle: new TextStyle(
                                      fontFamily: "Roboto Medium",
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.04)),
                              onChanged: (String value) {
                                setState(() {
                                  widget.flightInfo.contact.email = value;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // -----------------------------------------

                //------------------------------------------
                new Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.width * 0.0314),
                ),
                new Flexible(
                  child: new Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.02,
                            top: MediaQuery.of(context).size.width * 0.02,
                            bottom: MediaQuery.of(context).size.width * 0.02,
                            right: MediaQuery.of(context).size.width * 0.08),
                        child: new Text(
                          "Địa chỉ: ",
                          style: new TextStyle(
                              color: Colors.black,
                              fontFamily: "Roboto Medium",
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04),
                        ),
                      ),
                      Flexible(
                        child: new Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.0171,
                              right:
                                  MediaQuery.of(context).size.width * 0.0257),
                          child: Container(
                            padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.0314,
                              top: MediaQuery.of(context).size.width * 0.0314,
                              bottom:
                                  MediaQuery.of(context).size.width * 0.0314,
                            ),
                            decoration: new BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(
                                    MediaQuery.of(context).size.width *
                                        0.0171)),
                            child: new TextField(
                              decoration: new InputDecoration.collapsed(
                                  hintText: widget.flightInfo.contact.address
                                              .length ==
                                          0
                                      ? "Nhập địa chỉ"
                                      : widget.flightInfo.contact.address,
                                  hintStyle: new TextStyle(
                                      fontFamily: "Roboto Medium",
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.04)),
                              onChanged: (String value) {
                                setState(() {
                                  widget.flightInfo.contact.address = value;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //------------------------------------------

                //------------------------------------------
                new Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.width * 0.0314),
                ),
                new Flexible(
                  child: new Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.02,
                            top: MediaQuery.of(context).size.width * 0.02,
                            bottom: MediaQuery.of(context).size.width * 0.02,
                            right: MediaQuery.of(context).size.width * 0.005),
                        child: new Text(
                          "Thanh toán: ",
                          style: new TextStyle(
                              color: Colors.black,
                              fontFamily: "Roboto Medium",
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04),
                        ),
                      ),
                      Expanded(
                        child: new Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.0171,
                              right:
                                  MediaQuery.of(context).size.width * 0.0257),
                          child: Container(
                              padding: EdgeInsets.all(
                                  MediaQuery.of(context).size.width * 0.0214),
                              decoration: new BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(
                                      MediaQuery.of(context).size.width *
                                          0.0171)),
                              height: MediaQuery.of(context).size.width * 0.12,
                              child: new DropdownButton(
                                isExpanded: true,
                                iconSize:
                                    MediaQuery.of(context).size.width * 0.0743,
                                value: widget.flightInfo.payWay,
                                onChanged: (String? value) {
                                  setState(() {
                                    widget.flightInfo.payWay = value!;
                                    if (value.contains("nhà")) {
                                      pricePayway = 25000;
                                    } else
                                      pricePayway = 0;
                                  });
                                },
                                items: listPayment.map((String call) {
                                  return new DropdownMenuItem(
                                    value: call,
                                    child: new Row(
                                      children: <Widget>[
                                        new Icon(
                                          Icons.payment,
                                          color: Colors.orangeAccent,
                                          size: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.0571,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.02,
                                        ),
                                        Expanded(
                                          child: new Text(
                                            call,
                                            style: new TextStyle(
                                              color: Colors.black,
                                              fontFamily: "Roboto Medium",
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.0343,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
                //------------------------------------------

                //-----------------------------------------
                Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.width * 0.0314)),
                new Flexible(
                  flex: 2,
                  fit: FlexFit.loose,
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.02,
                            top: MediaQuery.of(context).size.width * 0.02,
                            bottom: MediaQuery.of(context).size.width * 0.02,
                            right: MediaQuery.of(context).size.width * 0.02),
                        child: new Text(
                          "Ghi chú: ",
                          style: new TextStyle(
                              color: Colors.black,
                              fontFamily: "Roboto Medium",
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        fit: FlexFit.loose,
                        child: Container(
                          height: MediaQuery.of(context).size.width * 0.5,
                          padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.07,
                            right: MediaQuery.of(context).size.width * 0.03,
                            top: MediaQuery.of(context).size.width * 0.0314,
                            bottom: MediaQuery.of(context).size.width * 0.0314,
                          ),
                          child: new TextField(
                            maxLines: 3,
                            decoration: new InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[50],
                                contentPadding: EdgeInsets.all(
                                    MediaQuery.of(context).size.width * 0.03),
                                hintText:
                                    widget.flightInfo.contact.city.length == 0
                                        ? "Nhập ghi chú"
                                        : widget.flightInfo.contact.city,
                                hintStyle: new TextStyle(
                                    fontFamily: "Roboto Medium",
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.04)),
                            onChanged: (String value) {
                              setState(() {
                                widget.flightInfo.contact.city = value;
                                widget.flightInfo.contact.isFilled = true;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //-----------------------------------------
              ],
            ),
          ),
        ),
      ],
    );
    return tmp;
  }

  isAdultCompletelyFilled() {
    for (var i = 0; i < widget.flightInfo.noOfAdult; i++) {
      var adult = widget.flightInfo.listAdults[i];
      if (adult.fullname.trim().isEmpty ||
          adult.cccd_passport.trim().isEmpty ||
          adult.day.isEmpty ||
          adult.month.isEmpty ||
          adult.year.isEmpty ||
          !adult.isValidDoB()) {
        return false;
      }
    }
    return true;
  }

  isChildCompletelyFilled() {
    for (var i = 0; i < widget.flightInfo.noOfChild; i++) {
      if (!widget.flightInfo.listChildren[i].isFilled) return false;
    }
    return true;
  }

  isChildBirthdateValid() {
    for (var i = 0; i < widget.flightInfo.noOfChild; i++) {
      int day = int.parse(widget.flightInfo.listChildren[i].day);
      int month = int.parse(widget.flightInfo.listChildren[i].month);
      int year = int.parse(widget.flightInfo.listChildren[i].year);
      bool tmp = widget.flightInfo.listChildren[i].isValidDoB();
      if (!checkValidDay(day, month, year) || !tmp) return false;
    }
    return true;
  }

  isInfantCompletelyFilled() {
    for (var i = 0; i < widget.flightInfo.noOfInfant; i++) {
      if (!widget.flightInfo.listInfants[i].isFilled) return false;
    }
    return true;
  }

  isInfantBirthdateValid() {
    for (var i = 0; i < widget.flightInfo.noOfInfant; i++) {
      int day = int.parse(widget.flightInfo.listInfants[i].day);
      int month = int.parse(widget.flightInfo.listInfants[i].month);
      int year = int.parse(widget.flightInfo.listInfants[i].year);
      bool tmp = widget.flightInfo.listChildren[i].isValidDoB();
      if (!checkValidDay(day, month, year) || !tmp)
        return false;
      else {
        if (DateTime.now().year - year >= 2) return false;
      }
    }
    return true;
  }

  Future<DateTime?> _confirmAllInfoAreFilled(
      BuildContext context, String content) {
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
                child: new Text("OK"),
              ),
            ],
          );
        });
  }

  Future<Null> _showDetailDepInfo(BuildContext context) {
    int adultTaxPerPerson = widget.flightInfo.noOfAdult > 0
        ? widget.flightInfo.adultDepartTax ~/ widget.flightInfo.noOfAdult
        : 0;
    int childTaxPerPerson = widget.flightInfo.noOfChild > 0
        ? widget.flightInfo.childDepartTax ~/ widget.flightInfo.noOfChild
        : 0;
    int infantTaxPerPerson = widget.flightInfo.noOfInfant > 0
        ? widget.flightInfo.infantDepartTax ~/ widget.flightInfo.noOfInfant
        : 0;

    int childPricePerPerson = widget.flightInfo.noOfChild > 0
        ? widget.flightInfo.childDepartPrice ~/ widget.flightInfo.noOfChild
        : 0;
    int infantPricePerPerson = widget.flightInfo.noOfInfant > 0
        ? widget.flightInfo.infantDepartPrice ~/ widget.flightInfo.noOfInfant
        : 0;

    return showDialog<Null>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            titlePadding: EdgeInsets.all(0.0),
            title: Container(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
              width: double.infinity,
              decoration: new BoxDecoration(color: Colors.red[700]),
              child: Center(
                  child: new Text(
                "Thông tin chi tiết",
                style: new TextStyle(
                    color: Colors.white,
                    fontFamily: "Roboto Medium",
                    fontSize: MediaQuery.of(context).size.width * 0.045),
              )),
            ),
            contentPadding: EdgeInsets.all(0.0),
            content: new Container(
              height: MediaQuery.of(context).size.height * 0.38,
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: new BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    color: Colors.grey[200] ?? Colors.grey, blurRadius: 1.2),
              ]),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new Text(
                        "Lượt đi:",
                        style: new TextStyle(
                            color: Colors.blue,
                            fontFamily: "Roboto Medium",
                            fontSize:
                                MediaQuery.of(context).size.width * 0.038),
                      ),
                      new Text(
                        widget.flightInfo.dateDepart.weekday + 1 < 8
                            ? "Thứ ${widget.flightInfo.dateDepart.weekday + 1}, ${formatter.format(widget.flightInfo.dateDepart)}"
                            : "Chủ nhật, ${formatter.format(widget.flightInfo.dateDepart)}",
                        style: new TextStyle(
                            color: Colors.black,
                            fontFamily: "Roboto Medium",
                            fontSize:
                                MediaQuery.of(context).size.width * 0.038),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.width * 0.01),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Column(
                        children: <Widget>[
                          new Text(
                            "${widget.flightInfo.depart}",
                            style: new TextStyle(
                                color: Colors.black,
                                fontFamily: "Roboto Medium",
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.0323),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.width * 0.025),
                            child: new Text(
                              "${widget.flightInfo.timeDepart1}",
                              style: new TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Roboto Medium",
                                  fontSize: MediaQuery.of(context).size.width *
                                      0.0343),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Image.asset(
                            "assets/${widget.flightInfo.company1}.png",
                            width: MediaQuery.of(context).size.width * 0.09,
                          ),
                          Row(
                            children: <Widget>[
                              new Text("${widget.flightInfo.company1}",
                                  style: new TextStyle(
                                    color: Colors.blueGrey,
                                    fontFamily: "Roboto Medium",
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.0323,
                                  )),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.0114,
                                    right: MediaQuery.of(context).size.width *
                                        0.0114),
                                child: new Icon(
                                  Icons.local_airport,
                                  size:
                                      MediaQuery.of(context).size.width * 0.04,
                                  color: Colors.deepOrange,
                                ),
                              ),
                              new Text(
                                "${widget.flightInfo.planeId1}",
                                style: new TextStyle(
                                    color: Colors.blueGrey,
                                    fontFamily: "Roboto Medium",
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.0323),
                              ),
                            ],
                          ),
                        ],
                      ),
                      new Column(
                        children: <Widget>[
                          new Text(
                            "${widget.flightInfo.destination}",
                            style: new TextStyle(
                                color: Colors.black,
                                fontFamily: "Roboto Medium",
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.0323),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.width * 0.025),
                            child: new Text(
                              "${widget.flightInfo.timeBack1}",
                              style: new TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Roboto Medium",
                                  fontSize: MediaQuery.of(context).size.width *
                                      0.0323),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.width * 0.02,
                      bottom: MediaQuery.of(context).size.width * 0.02,
                    ),
                    child: new Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: MediaQuery.of(context).size.width * 0.005,
                      decoration: new BoxDecoration(color: Colors.grey[400]),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.21,
                        child: new Text(
                          "Hành khách",
                          style: new TextStyle(
                              color: Colors.black,
                              fontFamily: "Roboto Medium",
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.0343),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.1,
                        child: new Text(
                          "SL",
                          style: new TextStyle(
                              color: Colors.black,
                              fontFamily: "Roboto Medium",
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.0343),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.21,
                        child: new Text(
                          "Đơn giá",
                          style: new TextStyle(
                              color: Colors.black,
                              fontFamily: "Roboto Medium",
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.0343),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.21,
                        child: new Text(
                          "Thuế phí",
                          style: new TextStyle(
                              color: Colors.black,
                              fontFamily: "Roboto Medium",
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.0343),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.width * 0.02),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.21,
                        child: new Text(
                          "Người lớn",
                          style: new TextStyle(
                              color: Colors.black,
                              fontFamily: "Roboto Medium",
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.0343),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.1,
                        child: new Text(
                          "${widget.flightInfo.noOfAdult}",
                          style: new TextStyle(
                              color: Colors.black,
                              fontFamily: "Roboto Medium",
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.0343),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.21,
                        child: new Text(
                          "${f.format(widget.flightInfo.priceDepart)}",
                          style: new TextStyle(
                              color: Colors.black,
                              fontFamily: "Roboto Medium",
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.0343),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.21,
                        child: new Text(
                          "${f.format(adultTaxPerPerson)}",
                          style: new TextStyle(
                              color: Colors.black,
                              fontFamily: "Roboto Medium",
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.0343),
                        ),
                      ),
                    ],
                  ),
                  widget.flightInfo.noOfChild > 0
                      ? new Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  top:
                                      MediaQuery.of(context).size.width * 0.02),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.21,
                                  child: new Text(
                                    "Trẻ em",
                                    style: new TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Roboto Medium",
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.0343),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.1,
                                  child: new Text(
                                    "${widget.flightInfo.noOfChild}",
                                    style: new TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Roboto Medium",
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.0343),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.21,
                                  child: new Text(
                                    "${f.format(childPricePerPerson)}",
                                    style: new TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Roboto Medium",
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.0343),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.21,
                                  child: new Text(
                                    "${f.format(childTaxPerPerson)}",
                                    style: new TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Roboto Medium",
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.0343),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Container(),
                  widget.flightInfo.noOfInfant > 0
                      ? new Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  top:
                                      MediaQuery.of(context).size.width * 0.02),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.21,
                                  child: new Text(
                                    "Trẻ sơ sinh",
                                    style: new TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Roboto Medium",
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.0343),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.1,
                                  child: new Text(
                                    "${widget.flightInfo.noOfInfant}",
                                    style: new TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Roboto Medium",
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.0343),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.21,
                                  child: new Text(
                                    "${f.format(infantPricePerPerson)}",
                                    style: new TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Roboto Medium",
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.0343),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.21,
                                  child: new Text(
                                    "${f.format(infantTaxPerPerson)}",
                                    style: new TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Roboto Medium",
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.0343),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Container(),
                  Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.width * 0.02,
                      bottom: MediaQuery.of(context).size.width * 0.02,
                    ),
                    child: new Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: MediaQuery.of(context).size.width * 0.005,
                      decoration: new BoxDecoration(color: Colors.grey[400]),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Text(
                        "Tổng cộng",
                        style: new TextStyle(
                            color: Colors.black,
                            fontFamily: "Roboto Medium",
                            fontSize:
                                MediaQuery.of(context).size.width * 0.038),
                      ),
                      new Text(
                        "${f.format(totalPaymentDepart)} VND",
                        style: new TextStyle(
                            color: Colors.deepOrange,
                            fontFamily: "Roboto Medium",
                            fontSize:
                                MediaQuery.of(context).size.width * 0.038),
                      ),
                    ],
                  ),
                ],
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

  Future<Null> _showDetailBackInfo(BuildContext context) {
    int adultBackTaxPerPerson = widget.flightInfo.noOfAdult > 0
        ? widget.flightInfo.adultBackTax ~/ widget.flightInfo.noOfAdult
        : 0;
    int childBackTaxPerPerson = widget.flightInfo.noOfChild > 0
        ? widget.flightInfo.childBackTax ~/ widget.flightInfo.noOfChild
        : 0;
    int infantBackTaxPerPerson = widget.flightInfo.noOfInfant > 0
        ? widget.flightInfo.infantBackTax ~/ widget.flightInfo.noOfInfant
        : 0;

    int childBackPricePerPerson = widget.flightInfo.noOfChild > 0
        ? widget.flightInfo.childBackPrice ~/ widget.flightInfo.noOfChild
        : 0;
    int infantBackPricePerPerson = widget.flightInfo.noOfInfant > 0
        ? widget.flightInfo.infantBackPrice ~/ widget.flightInfo.noOfInfant
        : 0;

    return showDialog<Null>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            titlePadding: EdgeInsets.all(0.0),
            title: Container(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
              width: double.infinity,
              decoration: new BoxDecoration(color: Colors.red[700]),
              child: Center(
                  child: new Text(
                "Thông tin chi tiết",
                style: new TextStyle(
                    color: Colors.white,
                    fontFamily: "Roboto Medium",
                    fontSize: MediaQuery.of(context).size.width * 0.045),
              )),
            ),
            contentPadding: EdgeInsets.all(0.0),
            content: new Container(
              height: MediaQuery.of(context).size.height * 0.38,
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: new BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    color: Colors.grey[200] ?? Colors.grey, blurRadius: 1.2),
              ]),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new Text(
                        "Lượt về:",
                        style: new TextStyle(
                            color: Colors.blue,
                            fontFamily: "Roboto Medium",
                            fontSize:
                                MediaQuery.of(context).size.width * 0.038),
                      ),
                      new Text(
                        widget.flightInfo.dateDepart.weekday + 1 < 8
                            ? "Thứ ${widget.flightInfo.dateBack.weekday + 1}, ${formatter.format(widget.flightInfo.dateBack)}"
                            : "Chủ nhật, ${formatter.format(widget.flightInfo.dateBack)}",
                        style: new TextStyle(
                            color: Colors.black,
                            fontFamily: "Roboto Medium",
                            fontSize:
                                MediaQuery.of(context).size.width * 0.038),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.width * 0.01),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Column(
                        children: <Widget>[
                          new Text(
                            "${widget.flightInfo.destination}",
                            style: new TextStyle(
                                color: Colors.black,
                                fontFamily: "Roboto Medium",
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.0323),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.width * 0.025),
                            child: new Text(
                              "${widget.flightInfo.timeDepart2}",
                              style: new TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Roboto Medium",
                                  fontSize: MediaQuery.of(context).size.width *
                                      0.0323),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Image.asset(
                            "assets/${widget.flightInfo.company2}.png",
                            width: MediaQuery.of(context).size.width * 0.09,
                          ),
                          Row(
                            children: <Widget>[
                              new Text(
                                "${widget.flightInfo.company2}",
                                style: new TextStyle(
                                    color: Colors.blueGrey,
                                    fontFamily: "Roboto Medium",
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.0323),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.0114,
                                    right: MediaQuery.of(context).size.width *
                                        0.0114),
                                child: new Icon(
                                  Icons.local_airport,
                                  size: MediaQuery.of(context).size.width *
                                      0.0323,
                                  color: Colors.deepOrange,
                                ),
                              ),
                              new Text(
                                "${widget.flightInfo.planeId2}",
                                style: new TextStyle(
                                    color: Colors.blueGrey,
                                    fontFamily: "Roboto Medium",
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.0323),
                              ),
                            ],
                          ),
                        ],
                      ),
                      new Column(
                        children: <Widget>[
                          new Text(
                            "${widget.flightInfo.depart}",
                            style: new TextStyle(
                                color: Colors.black,
                                fontFamily: "Roboto Medium",
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.0323),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.width * 0.025),
                            child: new Text(
                              "${widget.flightInfo.timeBack2}",
                              style: new TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Roboto Medium",
                                  fontSize: MediaQuery.of(context).size.width *
                                      0.0323),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.width * 0.02,
                      bottom: MediaQuery.of(context).size.width * 0.02,
                    ),
                    child: new Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: MediaQuery.of(context).size.width * 0.005,
                      decoration: new BoxDecoration(color: Colors.grey[400]),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.21,
                        child: new Text(
                          "Hành khách",
                          style: new TextStyle(
                              color: Colors.black,
                              fontFamily: "Roboto Medium",
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.0343),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.1,
                        child: new Text(
                          "SL",
                          style: new TextStyle(
                              color: Colors.black,
                              fontFamily: "Roboto Medium",
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.0343),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.21,
                        child: new Text(
                          "Đơn giá",
                          style: new TextStyle(
                              color: Colors.black,
                              fontFamily: "Roboto Medium",
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.0343),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.21,
                        child: new Text(
                          "Thuế phí",
                          style: new TextStyle(
                              color: Colors.black,
                              fontFamily: "Roboto Medium",
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.0343),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.width * 0.02),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.21,
                        child: new Text(
                          "Người lớn",
                          style: new TextStyle(
                              color: Colors.black,
                              fontFamily: "Roboto Medium",
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.0343),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.1,
                        child: new Text(
                          "${widget.flightInfo.noOfAdult}",
                          style: new TextStyle(
                              color: Colors.black,
                              fontFamily: "Roboto Medium",
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.0343),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.21,
                        child: new Text(
                          "${f.format(widget.flightInfo.priceBack)}",
                          style: new TextStyle(
                              color: Colors.black,
                              fontFamily: "Roboto Medium",
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.0343),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.21,
                        child: new Text(
                          "${f.format(adultBackTaxPerPerson)}",
                          style: new TextStyle(
                              color: Colors.black,
                              fontFamily: "Roboto Medium",
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.0343),
                        ),
                      ),
                    ],
                  ),
                  widget.flightInfo.noOfChild > 0
                      ? new Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  top:
                                      MediaQuery.of(context).size.width * 0.02),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.21,
                                  child: new Text(
                                    "Trẻ em",
                                    style: new TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Roboto Medium",
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.0343),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.1,
                                  child: new Text(
                                    "${widget.flightInfo.noOfChild}",
                                    style: new TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Roboto Medium",
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.0343),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.21,
                                  child: new Text(
                                    "${f.format(childBackPricePerPerson)}",
                                    style: new TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Roboto Medium",
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.0343),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.21,
                                  child: new Text(
                                    "${f.format(childBackTaxPerPerson)}",
                                    style: new TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Roboto Medium",
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.0343),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Container(),
                  widget.flightInfo.noOfInfant > 0
                      ? new Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  top:
                                      MediaQuery.of(context).size.width * 0.02),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.21,
                                  child: new Text(
                                    "Trẻ sơ sinh",
                                    style: new TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Roboto Medium",
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.0343),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.1,
                                  child: new Text(
                                    "${widget.flightInfo.noOfInfant}",
                                    style: new TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Roboto Medium",
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.0343),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.21,
                                  child: new Text(
                                    "${f.format(infantBackPricePerPerson)}",
                                    style: new TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Roboto Medium",
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.0343),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.21,
                                  child: new Text(
                                    "${f.format(infantBackTaxPerPerson)}",
                                    style: new TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Roboto Medium",
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.0343),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Container(),
                  Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.width * 0.02,
                      bottom: MediaQuery.of(context).size.width * 0.02,
                    ),
                    child: new Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: MediaQuery.of(context).size.width * 0.005,
                      decoration: new BoxDecoration(color: Colors.grey[400]),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Text(
                        "Tổng cộng",
                        style: new TextStyle(
                            color: Colors.black,
                            fontFamily: "Roboto Medium",
                            fontSize:
                                MediaQuery.of(context).size.width * 0.038),
                      ),
                      new Text(
                        "${f.format(totalPaymentBack)} VND",
                        style: new TextStyle(
                            color: Colors.deepOrange,
                            fontFamily: "Roboto Medium",
                            fontSize:
                                MediaQuery.of(context).size.width * 0.038),
                      ),
                    ],
                  ),
                ],
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

  initValue() {
    widget.flightInfo.totalPrice = totalPaymentBack + totalPaymentDepart;

    if (mapPackagePrice.length >= 1) {
      for (int i = 0; i < widget.flightInfo.listAdults.length; i++) {
        final packageWeight =
            widget.flightInfo.listAdults[i].departPackage.toString();
        final price = mapPackagePrice[packageWeight];
        if (price != null) {
          widget.flightInfo.totalPrice += price as int;
        }
      }
      for (int i = 0; i < widget.flightInfo.listChildren.length; i++) {
        final packageWeight =
            widget.flightInfo.listChildren[i].departPackage.toString();
        final price = mapPackagePrice[packageWeight];
        if (price != null) {
          widget.flightInfo.totalPrice += price as int;
        }
      }
    }

    if (widget.flightInfo.isRoundTrip && mapPackagePrice2.length >= 1) {
      for (int i = 0; i < widget.flightInfo.listAdults.length; i++) {
        final packageWeight =
            widget.flightInfo.listAdults[i].backPackage.toString();
        final price = mapPackagePrice2[packageWeight];
        if (price != null) {
          widget.flightInfo.totalPrice += price as int;
        }
      }
      for (int i = 0; i < widget.flightInfo.listChildren.length; i++) {
        final packageWeight =
            widget.flightInfo.listChildren[i].backPackage.toString();
        final price = mapPackagePrice2[packageWeight];
        if (price != null) {
          widget.flightInfo.totalPrice += price as int;
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    apiKey = widget.flightInfo.apiKey;

    void _calculateTotal() {
      // TÍNH TIỀN LƯỢT ĐI: Chỉ cộng tiền trẻ em/em bé nếu số lượng > 0
      totalPaymentDepart = (widget.flightInfo.priceDepart * widget.flightInfo.noOfAdult) +
          widget.flightInfo.adultDepartTax +
          (widget.flightInfo.noOfChild > 0 ? (widget.flightInfo.childDepartPrice + widget.flightInfo.childDepartTax) : 0) +
          (widget.flightInfo.noOfInfant > 0 ? (widget.flightInfo.infantDepartPrice + widget.flightInfo.infantDepartTax) : 0);

      // TÍNH TIỀN LƯỢT VỀ (Nếu có khứ hồi)
      totalPaymentBack = (widget.flightInfo.priceBack * widget.flightInfo.noOfAdult) +
          widget.flightInfo.adultBackTax +
          (widget.flightInfo.noOfChild > 0 ? (widget.flightInfo.childBackPrice + widget.flightInfo.childBackTax) : 0) +
          (widget.flightInfo.noOfInfant > 0 ? (widget.flightInfo.infantBackPrice + widget.flightInfo.infantBackTax) : 0);

      // TỔNG CỘNG CHUNG
      widget.flightInfo.totalPrice = totalPaymentBack + totalPaymentDepart;
    }
    _calculateFares(
      isRoundTrip: widget.flightInfo.isRoundTrip,
      obAirCode: widget.flightInfo.company1,
      obBasePrice: widget.flightInfo.priceDepart,
      noOfAdult: widget.flightInfo.noOfAdult,
      noOfChild: widget.flightInfo.noOfChild,
      noOfInfant: widget.flightInfo.noOfInfant,
      depCode: widget.flightInfo.depCode,
      outboundDate: widget.flightInfo.dateDepart,

      // param roundtrip neu co 
      ibAirCode: widget.flightInfo.isRoundTrip ? widget.flightInfo.company2 : null,
      ibBasePrice: widget.flightInfo.isRoundTrip ? widget.flightInfo.priceBack : null,
      arvCode: widget.flightInfo.isRoundTrip ? widget.flightInfo.arvCode : null,
      inboundDate: widget.flightInfo.isRoundTrip ? widget.flightInfo.dateBack : null,
    ).then((result) {
      setState(() {
        var outbound = result["outbound"];
        widget.flightInfo.adultDepartTax = outbound["adt_tax_fee"];
        widget.flightInfo.childDepartTax = outbound["chd_tax_fee"];
        widget.flightInfo.infantDepartTax = outbound["inf_tax_fee"];
        widget.flightInfo.childDepartPrice = outbound["chd_base_price"];
        widget.flightInfo.infantDepartPrice = outbound["inf_base_price"];

        // neu co inbound
        if (widget.flightInfo.isRoundTrip && result["inbound"] != null) {
          var inbound = result["inbound"];
          widget.flightInfo.adultBackTax = inbound["adt_tax_fee"];
          widget.flightInfo.childBackTax = inbound["chd_tax_fee"];
          widget.flightInfo.infantBackTax = inbound["inf_tax_fee"];
          widget.flightInfo.childBackPrice = inbound["chd_base_price"];
          widget.flightInfo.infantBackPrice = inbound["inf_base_price"];
        }

        _calculateTotal();
      });
    });

    // tmp = _getBagages(tmpF.storage["D"]!, widget.flightInfo.company1,
    //     widget.flightInfo.company2);
    tmp = _getBagages("", widget.flightInfo.company1, widget.flightInfo.company2);

    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   await showDialog<String>(
    //       context: context,
    //       builder: (BuildContext context) {
    //         return new AlertDialog(
    //           title: new Text(
    //             "Chọn vào khung lượt đi hoặc lượt về để xem thêm chi tiết.",
    //             style: new TextStyle(
    //                 color: Colors.black,
    //                 fontFamily: "Roboto Medium",
    //                 fontSize: MediaQuery.of(context).size.width * 0.038),
    //           ),
    //           actions: <Widget>[
    //             new TextButton(
    //               child: new Text("Tiếp tục"),
    //               onPressed: () {
    //                 Navigator.of(context).pop();
    //               },
    //             ),
    //           ],
    //         );
    //       });
    // });
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    return Column(
      children: <Widget>[
        //Header gio hang
        new Container(
          width: double.infinity,
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.0314),
          decoration: new BoxDecoration(
            color: Colors.black,
          ),
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                    size: MediaQuery.of(context).size.width * 0.06,
                  ),
                  new Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.0171),
                  ),
                  new Text(
                    "Tổng thành tiền",
                    style: new TextStyle(
                        color: Colors.white,
                        fontFamily: "Roboto Medium",
                        fontSize: MediaQuery.of(context).size.width * 0.04),
                  ),
                ],
              ),
              new Text(
                "${f.format(widget.flightInfo.totalPrice + pricePayway)} VND",
                style: new TextStyle(
                    color: Colors.white,
                    fontFamily: "Roboto Medium",
                    fontSize: MediaQuery.of(context).size.width * 0.04),
              ),
            ],
          ),
        ),
        //Ket thuc phan header gio hang

        new Expanded(
          child: new ListView(
            children: <Widget>[
              new Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.width * 0.0171),
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.width * 0.0171,
                    bottom: MediaQuery.of(context).size.width * 0.0171),
                child: new Center(
                  child: new Text(
                    "Thông tin hành trình",
                    style: new TextStyle(
                        color: Colors.black87,
                        fontFamily: "Roboto Medium",
                        fontSize: MediaQuery.of(context).size.width * 0.0457),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.0171,
                  right: MediaQuery.of(context).size.width * 0.0171,
                ),
                child: new Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.width * 0.005714,
                  decoration: new BoxDecoration(
                    color: Colors.grey[300],
                  ),
                ),
              ),

              new TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.width * 0.03,
                    bottom: MediaQuery.of(context).size.width * 0.03,
                  ),
                ),
                onPressed: () {
                  _showDetailDepInfo(context);
                },
                child: new Container(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
                  width: MediaQuery.of(context).size.width * 0.95,
                  decoration:
                      new BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        color: Colors.grey[200] ?? Colors.blueGrey,
                        blurRadius: 1.2),
                  ]),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Text(
                            "Lượt đi:",
                            style: new TextStyle(
                                color: Colors.blue,
                                fontFamily: "Roboto Medium",
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04),
                          ),
                          new Text(
                            widget.flightInfo.dateDepart.weekday + 1 < 8
                                ? "Thứ ${widget.flightInfo.dateDepart.weekday + 1}, ${formatter.format(widget.flightInfo.dateDepart)}"
                                : "Chủ nhật, ${formatter.format(widget.flightInfo.dateDepart)}",
                            style: new TextStyle(
                                color: Colors.black,
                                fontFamily: "Roboto Medium",
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.width * 0.01),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Column(
                            children: <Widget>[
                              new Text(
                                widget.flightInfo.depCode.length == 0
                                    ? "${widget.flightInfo.depart} - ${listAirportID[widget.flightInfo.depart]}"
                                    : "${widget.flightInfo.depart} - ${widget.flightInfo.depCode}",
                                style: new TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Roboto Medium",
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.0343),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.width *
                                        0.025),
                                child: new Text(
                                  "${widget.flightInfo.timeDepart1}",
                                  style: new TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Roboto Medium",
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.0343),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Image.asset(
                                "assets/${widget.flightInfo.company1}.png",
                                width: MediaQuery.of(context).size.width * 0.09,
                              ),
                              Row(
                                children: <Widget>[
                                  new Text(
                                    "${widget.flightInfo.company1}",
                                    style: new TextStyle(
                                        color: Colors.blueGrey,
                                        fontFamily: "Roboto Medium",
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.04),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.0114,
                                        right:
                                            MediaQuery.of(context).size.width *
                                                0.0114),
                                    child: new Icon(
                                      Icons.local_airport,
                                      size: MediaQuery.of(context).size.width *
                                          0.04,
                                      color: Colors.deepOrange,
                                    ),
                                  ),
                                  new Text(
                                    "${widget.flightInfo.planeId1}",
                                    style: new TextStyle(
                                        color: Colors.blueGrey,
                                        fontFamily: "Roboto Medium",
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.0343),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          new Column(
                            children: <Widget>[
                              new Text(
                                widget.flightInfo.arvCode.length == 0
                                    ? "${widget.flightInfo.destination} - ${listAirportID[widget.flightInfo.destination]}"
                                    : "${widget.flightInfo.destination} - ${widget.flightInfo.arvCode}",
                                style: new TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Roboto Medium",
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.0343),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.width *
                                        0.025),
                                child: new Text(
                                  "${widget.flightInfo.timeBack1}",
                                  style: new TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Roboto Medium",
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.0343),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.width * 0.02,
                          bottom: MediaQuery.of(context).size.width * 0.02,
                        ),
                        child: new Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                          height: MediaQuery.of(context).size.width * 0.005,
                          decoration:
                              new BoxDecoration(color: Colors.grey[400]),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Text(
                            "Tổng cộng",
                            style: new TextStyle(
                                color: Colors.black,
                                fontFamily: "Roboto Medium",
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.038),
                          ),
                          new Text(
                            "${f.format(totalPaymentDepart)} VND",
                            style: new TextStyle(
                                color: Colors.deepOrange,
                                fontFamily: "Roboto Medium",
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.038),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              //Chieu ve
              widget.flightInfo.isRoundTrip
                  ? new TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.width * 0.03,
                        ),
                      ),
                      onPressed: () {
                        _showDetailBackInfo(context);
                      },
                      child: new Container(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.03),
                        width: MediaQuery.of(context).size.width * 0.95,
                        decoration:
                            new BoxDecoration(color: Colors.white, boxShadow: [
                          BoxShadow(
                              color: Colors.grey[200] ?? Colors.grey,
                              blurRadius: 1.2),
                        ]),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Text(
                                  "Lượt về:",
                                  style: new TextStyle(
                                      color: Colors.blue,
                                      fontFamily: "Roboto Medium",
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.04),
                                ),
                                new Text(
                                  widget.flightInfo.dateDepart.weekday + 1 < 8
                                      ? "Thứ ${widget.flightInfo.dateBack.weekday + 1}, ${formatter.format(widget.flightInfo.dateBack)}"
                                      : "Chủ nhật, ${formatter.format(widget.flightInfo.dateBack)}",
                                  style: new TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Roboto Medium",
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.04),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top:
                                      MediaQuery.of(context).size.width * 0.01),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Column(
                                  children: <Widget>[
                                    new Text(
                                      widget.flightInfo.arvCode.length == 0
                                          ? "${widget.flightInfo.destination} - ${listAirportID[widget.flightInfo.destination]}"
                                          : "${widget.flightInfo.destination} - ${widget.flightInfo.arvCode}",
                                      style: new TextStyle(
                                          color: Colors.black,
                                          fontFamily: "Roboto Medium",
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.0343),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.025),
                                      child: new Text(
                                        "${widget.flightInfo.timeDepart2}",
                                        style: new TextStyle(
                                            color: Colors.black,
                                            fontFamily: "Roboto Medium",
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.0343),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Image.asset(
                                      "assets/${widget.flightInfo.company2}.png",
                                      width: MediaQuery.of(context).size.width *
                                          0.09,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        new Text(
                                          "${widget.flightInfo.company2}",
                                          style: new TextStyle(
                                              color: Colors.blueGrey,
                                              fontFamily: "Roboto Medium",
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.04),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.0114,
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.0114),
                                          child: new Icon(
                                            Icons.local_airport,
                                            size: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.04,
                                            color: Colors.deepOrange,
                                          ),
                                        ),
                                        new Text(
                                          "${widget.flightInfo.planeId2}",
                                          style: new TextStyle(
                                              color: Colors.blueGrey,
                                              fontFamily: "Roboto Medium",
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.0343),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                new Column(
                                  children: <Widget>[
                                    new Text(
                                      widget.flightInfo.depCode.length == 0
                                          ? "${widget.flightInfo.depart} - ${listAirportID[widget.flightInfo.depart]}"
                                          : "${widget.flightInfo.depart} - ${widget.flightInfo.depCode}",
                                      style: new TextStyle(
                                          color: Colors.black,
                                          fontFamily: "Roboto Medium",
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.0343),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.025),
                                      child: new Text(
                                        "${widget.flightInfo.timeBack2}",
                                        style: new TextStyle(
                                            color: Colors.black,
                                            fontFamily: "Roboto Medium",
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.0343),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.width * 0.02,
                                bottom:
                                    MediaQuery.of(context).size.width * 0.02,
                              ),
                              child: new Container(
                                width: MediaQuery.of(context).size.width * 0.85,
                                height:
                                    MediaQuery.of(context).size.width * 0.005,
                                decoration:
                                    new BoxDecoration(color: Colors.grey[400]),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Text(
                                  "Tổng cộng",
                                  style: new TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Roboto Medium",
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.038),
                                ),
                                new Text(
                                  "${f.format(totalPaymentBack)} VND",
                                  style: new TextStyle(
                                      color: Colors.deepOrange,
                                      fontFamily: "Roboto Medium",
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.038),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  : new Container(),
              //ket thuc chieu ve

              new Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.width * 0.0171),
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.0171),
                child: new Center(
                  child: new Text(
                    "Thông tin hành khách",
                    style: new TextStyle(
                        color: Colors.black87,
                        fontFamily: "Roboto Medium",
                        fontSize: MediaQuery.of(context).size.width * 0.0457),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.0171,
                    right: MediaQuery.of(context).size.width * 0.0171,
                    bottom: MediaQuery.of(context).size.width * 0.0171),
                child: new Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.width * 0.00571,
                  decoration: new BoxDecoration(
                    color: Colors.grey[300],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.width * 0.0171),
              ),

              //Hanh khach nguoi lon
              new Column(
                children: printAdultInfoForm(),
              ),
              //Ket thuc hanh khach nguoi lon

              //Hanh khach tre em
              new Column(
                children: printChildInfoForm(),
              ),
              //Ket thuc hanh khach tre em

              //Hanh khach tre so sinh
              new Column(
                children: printInfantInfoForm(),
              ),
              //Ket thuc hanh khach tre so sinh

              printInfoOfMainContact(),
            ],
          ),
        ),
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
    return new MaterialApp(
      title: "Sanvemaybay.vn",
      theme: new ThemeData(
        primaryColor: Colors.red[700],
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: Colors.grey[700]),
      ),
      home: new Scaffold(
        drawer: new CustomDrawer(),
        appBar: AppBar(
          title: new CustomAppBar("THÔNG TIN HÀNH KHÁCH", false, 60.0),
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
                  launchUrl(Uri.parse("tel:19001060"));
                },
              ),
            ),
          ],
        ),
        body: FutureBuilder(
          future: tmp,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.active:
              case ConnectionState.waiting:
                {
                  return Center(child: new CircularProgressIndicator());
                }
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return create("Lỗi kết nối mạng. Bạn vui lòng thử lại.");
                } else {
                  if (isFirst) {
                    initValue();
                    isFirst = false;
                  }
                  return createListView(context, snapshot);
                }
            }
          },
        ),
        // bottomNavigationBar: new TextButton(
        //   style: TextButton.styleFrom(padding: EdgeInsets.all(0.0)),
        //
        //   onPressed: () async {
        //     if (!isAdultCompletelyFilled() ||
        //         !isChildCompletelyFilled() ||
        //         !isInfantCompletelyFilled() ||
        //         !widget.flightInfo.contact.isFullOFInfo()) {
        //       _confirmAllInfoAreFilled(context,
        //           "Bạn vui lòng điền đầy đủ các thông tin bắt buộc trong \"Thông tin khách hàng\" trước khi thanh toán");
        //     } else {
        //       if (!isChildBirthdateValid() || !isInfantBirthdateValid()) {
        //         _confirmAllInfoAreFilled(context,
        //             "Ngày tháng năm sinh không hợp lệ! Vui lòng kiểm tra lại.");
        //       } else {
        //         if (widget.flightInfo.contact.email.length > 0 &&
        //             !widget.flightInfo.contact.isValidEmail()) {
        //           _confirmAllInfoAreFilled(
        //               context, "Email không hợp lệ! Vui lòng kiểm tra lại.");
        //         } else {
        //           if (!widget.flightInfo.contact.isValidPhone()) {
        //             _confirmAllInfoAreFilled(context,
        //                 "Số điện thoại không hợp lệ! Vui lòng kiểm tra lại.");
        //           } else {
        //             widget.flightInfo.totalPrice += pricePayway;
        //
        //             // --- BẮT ĐẦU LƯU VÉ VỚI TRY-CATCH ---
        //             // --- BẮT ĐẦU LƯU VÉ LAI (HYBRID) ---
        //             try {
        //
        //               String randomPNR = "VJ${(100000 + DateTime.now().millisecondsSinceEpoch % 900000).toString()}";
        //
        //               Map<String, dynamic> newTicket = {
        //                 "pnr": randomPNR,
        //                 "depart": widget.flightInfo.depart,
        //                 "destination": widget.flightInfo.destination,
        //                 "date": "${widget.flightInfo.dateDepart.day}/${widget.flightInfo.dateDepart.month}/${widget.flightInfo.dateDepart.year}",
        //                 "flightNo": widget.flightInfo.planeId1,
        //                 "company": widget.flightInfo.company1,
        //                 "price": widget.flightInfo.totalPrice,
        //                 "contactName": widget.flightInfo.contact.fullname,
        //                 "contactPhone": widget.flightInfo.contact.phone,
        //                 "contactEmail": widget.flightInfo.contact.email,
        //                 "timeDepart": widget.flightInfo.timeDepart1, // Giờ đi lượt đi
        //                 "timeBack": widget.flightInfo.timeBack1,     // Giờ đến lượt đi
        //                 "isRoundTrip": widget.flightInfo.isRoundTrip,
        //                 if (widget.flightInfo.isRoundTrip) ...{
        //                   "dateBack": "${widget.flightInfo.dateBack.day}/${widget.flightInfo.dateBack.month}/${widget.flightInfo.dateBack.year}",
        //                   "flightNoBack": widget.flightInfo.planeId2,
        //                   "companyBack": widget.flightInfo.company2,
        //                   "timeDepartBack": widget.flightInfo.timeDepart2, // Giờ đi lượt về
        //                   "timeBackBack": widget.flightInfo.timeBack2,
        //                 }
        //               };
        //
        //               // KIỂM TRA ĐĂNG NHẬP
        //               User? currentUser = FirebaseAuth.instance.currentUser;
        //
        //               if (currentUser != null) {
        //                 // NẾU ĐÃ ĐĂNG NHẬP: Lưu lên Cloud Firestore
        //                 await FirebaseFirestore.instance
        //                     .collection('users')
        //                     .doc(currentUser.uid)
        //                     .collection('tickets')
        //                     .doc(randomPNR) // Lấy mã PNR làm ID lưu trữ
        //                     .set(newTicket);
        //                 print("=== ĐÃ LƯU LÊN FIREBASE CLOUD ===");
        //               } else {
        //                 // NẾU CHƯA ĐĂNG NHẬP: Lưu Offline vào bộ nhớ máy
        //                 SharedPreferences prefs = await SharedPreferences.getInstance();
        //                 List<String> savedData = prefs.getStringList('my_tickets') ?? [];
        //                 savedData.add(json.encode(newTicket));
        //                 await prefs.setStringList('my_tickets', savedData);
        //                 print("=== ĐÃ LƯU OFFLINE CHO KHÁCH VÃNG LAI ===");
        //               }
        //
        //               // Chuyển sang trang xem chi tiết vé
        //               Navigator.of(context).push(new MaterialPageRoute(
        //                   builder: (context) => new FinishBookingPage(widget.flightInfo)));
        //
        //             } catch (e) {
        //               print("=== LỖI RỒI: $e ===");
        //             }
        //
        //             // --- KẾT THÚC ---
        //           }
        //         }
        //       }
        //     }
        //   },
        //   child: new Container(
        //     width: double.infinity,
        //     height: MediaQuery.of(context).size.width * 0.13,
        //     padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.0314),
        //     decoration: new BoxDecoration(
        //       color: Color.fromRGBO(18, 175, 60, 1.0),
        //     ),
        //     child: new Center(
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: <Widget>[
        //           Padding(
        //             padding: EdgeInsets.only(right: 8.0),
        //             child: new Icon(
        //               Icons.check_circle,
        //               color: Colors.white,
        //             ),
        //           ),
        //           new Text(
        //             "HOÀN TẤT",
        //             style: new TextStyle(
        //                 color: Colors.white,
        //                 fontFamily: "Roboto Medium",
        //                 fontSize: MediaQuery.of(context).size.width * 0.0457),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
        bottomNavigationBar: new TextButton(
          style: TextButton.styleFrom(padding: EdgeInsets.all(0.0)),
          onPressed: () async {
            if (!isAdultCompletelyFilled() ||
                !isChildCompletelyFilled() ||
                !isInfantCompletelyFilled() ||
                !widget.flightInfo.contact.isFullOFInfo()) {
              _confirmAllInfoAreFilled(context,
                  "Bạn vui lòng điền đầy đủ các thông tin bắt buộc trong \"Thông tin khách hàng\" trước khi thanh toán");
            } else {
              if (!isChildBirthdateValid() || !isInfantBirthdateValid()) {
                _confirmAllInfoAreFilled(context,
                    "Ngày tháng năm sinh không hợp lệ! Vui lòng kiểm tra lại.");
              } else {
                if (widget.flightInfo.contact.email.length > 0 &&
                    !widget.flightInfo.contact.isValidEmail()) {
                  _confirmAllInfoAreFilled(
                      context, "Email không hợp lệ! Vui lòng kiểm tra lại.");
                } else {
                  if (!widget.flightInfo.contact.isValidPhone()) {
                    _confirmAllInfoAreFilled(context,
                        "Số điện thoại không hợp lệ! Vui lòng kiểm tra lại.");
                  } else {
                    widget.flightInfo.totalPrice += pricePayway;

                    // --- BẮT ĐẦU LƯU VÉ VỚI TRY-CATCH ---
                    try {
                      String randomPNR = "VJ${(100000 + DateTime.now().millisecondsSinceEpoch % 900000).toString()}";

                      // 1. TẠO THÔNG TIN VÉ LƯỢT ĐI (Mặc định)
                      Map<String, dynamic> newTicket = {
                        "pnr": randomPNR,
                        "createdAt": DateTime.now().millisecondsSinceEpoch,
                        "depart": widget.flightInfo.depart,
                        "destination": widget.flightInfo.destination,
                        "date": "${widget.flightInfo.dateDepart.day}/${widget.flightInfo.dateDepart.month}/${widget.flightInfo.dateDepart.year}",
                        "timeDepart": widget.flightInfo.timeDepart1, // Giờ cất cánh
                        "timeArrive": widget.flightInfo.timeBack1,   // Giờ hạ cánh
                        "flightNo": widget.flightInfo.planeId1,
                        "company": widget.flightInfo.company1,
                        "price": widget.flightInfo.totalPrice,
                        "contactName": widget.flightInfo.contact.fullname,
                        "contactPhone": widget.flightInfo.contact.phone,
                        "contactEmail": widget.flightInfo.contact.email,
                        "isRoundTrip": widget.flightInfo.isRoundTrip,
                      };

                      // 2. NẾU CÓ KHỨ HỒI -> GẮN THÊM DỮ LIỆU LƯỢT VỀ (Cách viết này chống lỗi syntax 100%)
                      if (widget.flightInfo.isRoundTrip) {
                        newTicket["dateReturn"] = "${widget.flightInfo.dateBack.day}/${widget.flightInfo.dateBack.month}/${widget.flightInfo.dateBack.year}";
                        newTicket["timeDepartReturn"] = widget.flightInfo.timeDepart2;
                        newTicket["timeArriveReturn"] = widget.flightInfo.timeBack2;
                        newTicket["flightNoReturn"] = widget.flightInfo.planeId2;
                        newTicket["companyReturn"] = widget.flightInfo.company2;
                      }

                      // 3. KIỂM TRA ĐĂNG NHẬP VÀ LƯU
                      User? currentUser = FirebaseAuth.instance.currentUser;

                      if (currentUser != null) {
                        // Đã đăng nhập -> Lưu lên Firebase Cloud
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(currentUser.uid)
                            .collection('tickets')
                            .doc(randomPNR)
                            .set(newTicket);
                        print("=== ĐÃ LƯU LÊN FIREBASE CLOUD ===");
                      } else {
                        // Chưa đăng nhập -> Lưu Offline Local
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        List<String> savedData = prefs.getStringList('my_tickets') ?? [];
                        savedData.add(json.encode(newTicket));
                        await prefs.setStringList('my_tickets', savedData);
                        print("=== ĐÃ LƯU OFFLINE CHO KHÁCH VÃNG LAI ===");
                      }

                      // Chuyển sang trang xem chi tiết vé
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (context) => new FinishBookingPage(widget.flightInfo)));

                    } catch (e) {
                      print("=== LỖI LƯU VÉ: $e ===");
                    }
                  }
                }
              }
            }
          },
          child: new Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.width * 0.13,
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.0314),
            decoration: new BoxDecoration(
              color: Color.fromRGBO(18, 175, 60, 1.0),
            ),
            child: new Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: new Icon(
                      Icons.check_circle,
                      color: Colors.white,
                    ),
                  ),
                  new Text(
                    "HOÀN TẤT",
                    style: new TextStyle(
                        color: Colors.white,
                        fontFamily: "Roboto Medium",
                        fontSize: MediaQuery.of(context).size.width * 0.0457),
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


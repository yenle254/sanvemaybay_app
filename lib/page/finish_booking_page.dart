import 'dart:async';

import 'package:sanvemaybay_app_fixed/page/booking_history_page.dart';
import 'package:flutter/material.dart';
import 'package:sanvemaybay_app_fixed/module/custom_app_bar.dart';
import 'package:sanvemaybay_app_fixed/module/custom_drawer.dart';
import 'package:intl/intl.dart';
import 'package:sanvemaybay_app_fixed/customize_object/flight_info_object.dart';
import 'package:url_launcher/url_launcher.dart';
import './home_page.dart';

String? urlBooking;

FlightInfoObject tmpFlightInfo = new FlightInfoObject();

NumberFormat formatter = new NumberFormat("###,###,###");

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
  "Vân Đồn": "VDO"
};

class FinishBookingPage extends StatelessWidget {
  final FlightInfoObject flighInfo;

  FinishBookingPage(this.flighInfo);

  @override
  Widget build(BuildContext context) {
    // urlBooking = flighInfo.storage["SaveBookingNew2"];
    return new FinishBookingPageSupport(flighInfo);
  }
}

class FinishBookingPageSupport extends StatefulWidget {
  final FlightInfoObject flighInfo;

  FinishBookingPageSupport(this.flighInfo);

  @override
  _FinishBookingPageSupportState createState() {
    tmpFlightInfo = flighInfo;
    return _FinishBookingPageSupportState();
  }
}

class _FinishBookingPageSupportState extends State<FinishBookingPageSupport> {
  // Future<Null> _bookingFuture(String data) async {
  //   final uri = Uri.parse(urlBooking!);
  //   var res = await Future.wait([http.post(uri,
  //       headers: {
  //         tmpFlightInfo.storage["NewK"]!: tmpFlightInfo.apiKey,
  //         "Content-Type": "application/json",
  //       },
  //       body: data)]);
  //   if ( res[0].statusCode == 201) {
  //     var resBody1 = json.decode(res[0].body);
  //     if (resBody1["error"] == false) {
  //       tmpFlightInfo.bookingNo = resBody1["booking_no"];
  //     }
  //   }
  // }
  Future<Null> _bookingFuture() async {
    // Giả lập thời gian chờ server xử lý 1 giây
    await Future.delayed(Duration(seconds: 1));

    // Tạo một mã đặt chỗ (Booking No) ngẫu nhiên cho ngầu
    String randomID = DateTime.now().millisecondsSinceEpoch.toString().substring(7);
    tmpFlightInfo.bookingNo = "GEEKTEK-$randomID";
  }
  var tp;

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

  // @override
  // void initState() {
  //   super.initState();
  //   DateTime arrivalTimeDepart = tmpFlightInfo.dateDepart;
  //   if (tmpFlightInfo.timeBack1.contains("00:")) {
  //     arrivalTimeDepart = arrivalTimeDepart.add(Duration(days: 1));
  //   }
  //   // print("Departure time: ${df.format(tmpFlightInfo.dateDepart)} ${tmpFlightInfo.timeDepart1}:00");
  //   // print("Arrive time: ${df.format(arrivalTimeDepart)} ${tmpFlightInfo.timeBack1}");
  //   // print(tmpFlightInfo.depCode.length == 0 ?
  //   //     listAirportID[tmpFlightInfo.depart]
  //   //     : tmpFlightInfo.depCode);
  //   // print(tmpFlightInfo.arvCode.length == 0 ?
  //   //     listAirportID[tmpFlightInfo.destination]
  //   //     : tmpFlightInfo.arvCode);
  //   Map departInfo = {
  //     "way_flight": "0",
  //     "iata_code": tmpFlightInfo.company1,
  //     "flight_number": tmpFlightInfo.planeId1,
  //     "flight_class": tmpFlightInfo.typeSeat1,
  //     "departure_code": tmpFlightInfo.depCode.length == 0 ?
  //       listAirportID[tmpFlightInfo.depart]
  //       : tmpFlightInfo.depCode,
  //     "arrival_code": tmpFlightInfo.arvCode.length == 0 ?
  //       listAirportID[tmpFlightInfo.destination]
  //       : tmpFlightInfo.arvCode,
  //     "departure_time":
  //         "${df.format(tmpFlightInfo.dateDepart)} ${tmpFlightInfo.timeDepart1}:00",
  //     "arrival_time":
  //         "${df.format(arrivalTimeDepart)} ${tmpFlightInfo.timeBack1}:00",
  //     "is_transit": 0,
  //     "description": "",
  //     "base_price": tmpFlightInfo.priceDepart,
  //   };
  //   DateTime arrivalTimeBack = tmpFlightInfo.dateBack;
  //   if (tmpFlightInfo.timeBack2.contains("00:")) {
  //     arrivalTimeBack = arrivalTimeBack.add(Duration(days: 1));
  //   }
  //   // print("Departure time: ${df.format(tmpFlightInfo.dateBack)} ${tmpFlightInfo.timeDepart2}:00");
  //   // print("Arrive time: ${df.format(arrivalTimeBack)} ${tmpFlightInfo.timeBack2}:00");
  //   // print(listAirportID[tmpFlightInfo.destination]);
  //   // print(listAirportID[tmpFlightInfo.depart]);
  //   Map destionationInfo = {
  //     "way_flight": "1",
  //     "iata_code": tmpFlightInfo.company2,
  //     "flight_number": tmpFlightInfo.planeId2,
  //     "flight_class": tmpFlightInfo.typeSeat2,
  //     "departure_code": tmpFlightInfo.arvCode.length == 0 ?
  //       listAirportID[tmpFlightInfo.destination]
  //       : tmpFlightInfo.arvCode,
  //     "arrival_code": tmpFlightInfo.depCode.length == 0 ?
  //       listAirportID[tmpFlightInfo.depart]
  //       : tmpFlightInfo.depCode,
  //     "departure_time":
  //         "${df.format(tmpFlightInfo.dateBack)} ${tmpFlightInfo.timeDepart2}:00",
  //     "arrival_time":
  //         "${df.format(arrivalTimeBack)} ${tmpFlightInfo.timeBack2}:00",
  //     "is_transit": 0,
  //     "description": "",
  //     "base_price": tmpFlightInfo.priceBack,
  //   };
  //   List listPassenger = [];
  //   var data;
  //   if (tmpFlightInfo.isRoundTrip) {
  //     for (int i = 0; i < tmpFlightInfo.noOfAdult; i++) {
  //       Map tmp = {
  //         "name": tmpFlightInfo.listAdults[i].fullname,
  //         "pax_type": "0",
  //         "pax_title":
  //             tmpFlightInfo.listAdults[i].gender.contains("Ông") ? "0" : "1",
  //         "date_of_birth":
  //             "${tmpFlightInfo.listAdults[i].year}-${tmpFlightInfo.listAdults[i].month}-${tmpFlightInfo.listAdults[i].day}",
  //         "cccd_passport": tmpFlightInfo.listAdults[i].cccd_passport,
  //         "iata_code_out": tmpFlightInfo.company1,
  //         "iata_code_in": tmpFlightInfo.company2,
  //         "baggage_weight_out": tmpFlightInfo.listAdults[i].departPackage,
  //         "baggage_weight_in": tmpFlightInfo.listAdults[i].backPackage,
  //       };
  //       listPassenger.add(tmp);
  //     }
  //     for (int i = 0; i < tmpFlightInfo.noOfChild; i++) {
  //       Map tmp = {
  //         "name": tmpFlightInfo.listChildren[i].fullname,
  //         "pax_type": "1",
  //         "pax_title":
  //             tmpFlightInfo.listChildren[i].gender.contains("Trai") ? "0" : "1",
  //         "date_of_birth":
  //             "${tmpFlightInfo.listChildren[i].year}-${tmpFlightInfo.listChildren[i].month}-${tmpFlightInfo.listChildren[i].day}",
  //         "iata_code_out": tmpFlightInfo.company1,
  //         "iata_code_in": tmpFlightInfo.company2,
  //         "baggage_weight_out": tmpFlightInfo.listChildren[i].departPackage,
  //         "baggage_weight_in": tmpFlightInfo.listChildren[i].backPackage,
  //       };
  //       listPassenger.add(tmp);
  //     }
  //     for (int i = 0; i < tmpFlightInfo.noOfInfant; i++) {
  //       Map tmp = {
  //         "name": tmpFlightInfo.listInfants[i].fullname,
  //         "pax_type": "2",
  //         "pax_title":
  //             tmpFlightInfo.listInfants[i].gender.contains("Trai") ? "0" : "1",
  //         "date_of_birth":
  //             "${tmpFlightInfo.listInfants[i].year}-${tmpFlightInfo.listInfants[i].month}-${tmpFlightInfo.listInfants[i].day}",
  //         "iata_code_out": tmpFlightInfo.company1,
  //         "iata_code_in": tmpFlightInfo.company2,
  //         "baggage_weight_out": 0,
  //         "baggage_weight_in": 0,
  //       };
  //       listPassenger.add(tmp);
  //     }
  //     data = tmpFlightInfo.contact.email.length > 0 ?
  //     json.encode({
  //       "direction": "0",
  //       "dep_iata": tmpFlightInfo.company1,
  //       "ret_iata": tmpFlightInfo.company2,
  //       "ticket_type": "0",
  //       "payment_type": tmpFlightInfo.payWay.contains("Chuyển khoản")
  //           ? "0"
  //           : tmpFlightInfo.payWay.contains("Tại nhà") ? "2" : "3",
  //       "contact_title":
  //           tmpFlightInfo.contact.gender.contains("Ông") ? "0" : "1",
  //       "contact_name": tmpFlightInfo.contact.fullname,
  //       "contact_email": tmpFlightInfo.contact.email,
  //       "contact_phone": tmpFlightInfo.contact.phone,
  //       "contact_address": tmpFlightInfo.contact.address,
  //       "domain": tmpFlightInfo.storage["D"],
  //       "route_data": [
  //         departInfo,
  //         destionationInfo,
  //       ],
  //       "pax_data": listPassenger,
  //       "description": "test app, vui long khong xu ly"
  //     }) :
  //     json.encode({
  //       "direction": "0",
  //       "dep_iata": tmpFlightInfo.company1,
  //       "ret_iata": tmpFlightInfo.company2,
  //       "ticket_type": "0",
  //       "payment_type": tmpFlightInfo.payWay.contains("Chuyển khoản")
  //           ? "0"
  //           : tmpFlightInfo.payWay.contains("Tại nhà") ? "2" : "3",
  //       "contact_title":
  //           tmpFlightInfo.contact.gender.contains("Ông") ? "0" : "1",
  //       "contact_name": tmpFlightInfo.contact.fullname,
  //       "contact_phone": tmpFlightInfo.contact.phone,
  //       "contact_address": tmpFlightInfo.contact.address,
  //       "domain": tmpFlightInfo.storage["D"],
  //       "route_data": [
  //         departInfo,
  //         destionationInfo,
  //       ],
  //       "pax_data": listPassenger,
  //       "description": tmpFlightInfo.contact.city
  //     });
  //   } else {
  //     // oneway
  //     for (int i = 0; i < tmpFlightInfo.noOfAdult; i++) {
  //       Map tmp = {
  //         "name": tmpFlightInfo.listAdults[i].fullname,
  //         "pax_type": "0",
  //         "pax_title":
  //             tmpFlightInfo.listAdults[i].gender.contains("Ông") ? "0" : "1",
  //         "date_of_birth":
  //             "${tmpFlightInfo.listAdults[i].year}-${tmpFlightInfo.listAdults[i].month}-${tmpFlightInfo.listAdults[i].day}",
  //         "cccd_passport": tmpFlightInfo.listAdults[i].cccd_passport,
  //         "iata_code_out": tmpFlightInfo.company1,
  //         "baggage_weight_out": tmpFlightInfo.listAdults[i].departPackage,
  //         "baggage_weight_in": tmpFlightInfo.listAdults[i].backPackage,
  //       };
  //       listPassenger.add(tmp);
  //     }
  //     for (int i = 0; i < tmpFlightInfo.noOfChild; i++) {
  //       Map tmp = {
  //         "name": tmpFlightInfo.listChildren[i].fullname,
  //         "pax_type": "1",
  //         "pax_title":
  //             tmpFlightInfo.listChildren[i].gender.contains("Trai") ? "0" : "1",
  //         "date_of_birth":
  //             "${tmpFlightInfo.listChildren[i].year}-${tmpFlightInfo.listChildren[i].month}-${tmpFlightInfo.listChildren[i].day}",
  //         "iata_code_out": tmpFlightInfo.company1,
  //         "baggage_weight_out": tmpFlightInfo.listChildren[i].departPackage,
  //         "baggage_weight_in": tmpFlightInfo.listChildren[i].backPackage,
  //       };
  //       listPassenger.add(tmp);
  //     }
  //     for (int i = 0; i < tmpFlightInfo.noOfInfant; i++) {
  //       Map tmp = {
  //         "name": tmpFlightInfo.listInfants[i].fullname,
  //         "pax_type": "2",
  //         "pax_title":
  //             tmpFlightInfo.listInfants[i].gender.contains("Trai") ? "0" : "1",
  //         "date_of_birth":
  //             "${tmpFlightInfo.listInfants[i].year}-${tmpFlightInfo.listInfants[i].month}-${tmpFlightInfo.listInfants[i].day}",
  //         "iata_code_out": tmpFlightInfo.company1,
  //         "baggage_weight_out": 0,
  //         "baggage_weight_in": 0,
  //       };
  //       listPassenger.add(tmp);
  //     }
  //     data = json.encode({
  //       "direction": "1",
  //       "dep_iata": tmpFlightInfo.company1,
  //       // "ret_iata": tmpFlightInfo.company2,
  //       "ticket_type": "0",
  //       "payment_type": tmpFlightInfo.payWay.contains("Chuyển khoản")
  //           ? "0"
  //           : tmpFlightInfo.payWay.contains("Tại nhà") ? "2" : "3",
  //       "contact_title":
  //           tmpFlightInfo.contact.gender.contains("Ông") ? "0" : "1",
  //       "contact_name": tmpFlightInfo.contact.fullname,
  //       "contact_email": tmpFlightInfo.contact.email,
  //       "contact_phone": tmpFlightInfo.contact.phone,
  //       "contact_address": tmpFlightInfo.contact.address,
  //       "domain": tmpFlightInfo.storage["D"],
  //       "route_data": [
  //         departInfo,
  //       ],
  //       "pax_data": listPassenger,
  //       "description": tmpFlightInfo.contact.city,
  //     });
  //   }
  //   tp = _bookingFuture(data);
  // }

  @override
  void initState() {
    super.initState();
    // Gọi hàm giả lập tạo mã đặt chỗ
    tp = _bookingFuture();
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    return ListView(
      children: <Widget>[
        //Xac nhan don hang---------------------
        Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.width * 0.0171,
                left: MediaQuery.of(context).size.width * 0.0171,
                right: MediaQuery.of(context).size.width * 0.0171),
            child: new Column(
              children: <Widget>[
                //Tieu de-------------
                new Container(
                  padding: EdgeInsets.all(
                      MediaQuery.of(context).size.width * 0.0171),
                  decoration: new BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(
                              MediaQuery.of(context).size.width * 0.0171),
                          topRight: Radius.circular(
                              MediaQuery.of(context).size.width * 0.0171)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius:
                                MediaQuery.of(context).size.width * 0.00571)
                      ]),
                  child: Center(
                    child: new Text(
                      "Xác nhận đơn hàng",
                      style: new TextStyle(
                          color: Colors.black,
                           
                          fontFamily: "Roboto Medium",
                          fontSize: MediaQuery.of(context).size.width * 0.0457),
                    ),
                  ),
                ),
                //----------------
                //Phan than ------------------------------
                new Container(
                  padding: EdgeInsets.all(
                      MediaQuery.of(context).size.width * 0.0171),
                  decoration:
                      new BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        blurRadius: MediaQuery.of(context).size.width * 0.00571)
                  ]),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //Ma so don hang -----------------
                      new Row(
                        children: <Widget>[
                          new Text(
                            "Mã số đơn hàng: ",
                            style: new TextStyle(
                                color: Colors.black,
                                 
                                fontFamily: "Roboto Medium",
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left:
                                    MediaQuery.of(context).size.width * 0.0171),
                          ),
                          new Text(
                            tmpFlightInfo.bookingNo,
                            style: new TextStyle(
                                color: Colors.deepOrange,
                                 
                                fontFamily: "Roboto Medium",
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04),
                          ),
                        ],
                      ),
                      //--------------------
                      //"Don hang dang duoc xu li"
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.width * 0.0314),
                      ),
                      new Text(
                        "*** Đơn hàng đang được xử lý.",
                        style: new TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.blue,
                            fontFamily: "Roboto Medium",
                            fontSize: MediaQuery.of(context).size.width * 0.04),
                      ),
                      //--------------------
                      //Luu y cho phan xac nhan thong tin===================
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.width * 0.0457),
                      ),
                      new Text(
                        "Booker sẽ liên hệ quý khách để xác thực thông tin trong thời gian sớm nhất. Quý khách cần chuyển khoản thanh toán để bảo vệ giá. Chi tiết thông tin chuyến bay và mã vé sẽ được gửi tới email như form quý khách đã điền:",
                        textAlign: TextAlign.justify,
                        style: new TextStyle(
                            height: MediaQuery.of(context).size.width * 0.00429,
                            color: Colors.black,
                            fontFamily: "Roboto Medium",
                            fontSize:
                                MediaQuery.of(context).size.width * 0.0314),
                      ),
                      new Text(
                        "${tmpFlightInfo.contact.email}",
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                            height: MediaQuery.of(context).size.width * 0.00429,
                            color: Colors.black,
                             
                            fontFamily: "Roboto Medium",
                            fontSize:
                                MediaQuery.of(context).size.width * 0.0314),
                      )
                      //===============
                    ],
                  ),
                ),
                //------------------------
              ],
            )),
        //--------------------------

        //Thong tin don hang---------------------
        Padding(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.0171,
                right: MediaQuery.of(context).size.width * 0.0171),
            child: new Column(
              children: <Widget>[
                //Tieu de-------------
                new Container(
                  padding: EdgeInsets.all(
                      MediaQuery.of(context).size.width * 0.0171),
                  decoration:
                      new BoxDecoration(color: Colors.grey[300], boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        blurRadius: MediaQuery.of(context).size.width * 0.00571)
                  ]),
                  child: Center(
                    child: new Text(
                      "Thông tin đơn hàng",
                      style: new TextStyle(
                          color: Colors.black,
                           
                          fontFamily: "Roboto Medium",
                          fontSize: MediaQuery.of(context).size.width * 0.0457),
                    ),
                  ),
                ),
                //----------------
                //Phan than ------------------------------
                new Container(
                  padding: EdgeInsets.all(
                      MediaQuery.of(context).size.width * 0.0171),
                  decoration:
                      new BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        blurRadius: MediaQuery.of(context).size.width * 0.00571)
                  ]),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      //Cot ben trai: tieu de -----------------
                      new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text(
                            "Mã số đơn hàng: ",
                            style: new TextStyle(
                                color: Colors.black,
                                height:
                                    MediaQuery.of(context).size.width * 0.00429,
                                fontFamily: "Roboto Medium",
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.0314),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).size.width * 0.0171),
                          ),
                          new Text(
                            "Trạng thái: ",
                            style: new TextStyle(
                                color: Colors.black,
                                height:
                                    MediaQuery.of(context).size.width * 0.00429,
                                fontFamily: "Roboto Medium",
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.0314),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).size.width * 0.0171),
                          ),
                          new Text(
                            "Chuyến bay: ",
                            style: new TextStyle(
                                color: Colors.black,
                                height:
                                    MediaQuery.of(context).size.width * 0.00429,
                                fontFamily: "Roboto Medium",
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.0314),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).size.width * 0.0171),
                          ),
                          new Text(
                            "Số hành khách: ",
                            style: new TextStyle(
                                color: Colors.black,
                                height:
                                    MediaQuery.of(context).size.width * 0.00429,
                                fontFamily: "Roboto Medium",
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.0314),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).size.width * 0.0171),
                          ),
                          new Text(
                            "Ngày đi: ",
                            style: new TextStyle(
                                color: Colors.black,
                                height:
                                    MediaQuery.of(context).size.width * 0.00429,
                                fontFamily: "Roboto Medium",
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.0314),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).size.width * 0.0171),
                          ),
                          tmpFlightInfo.isRoundTrip
                              ? new Text(
                                  "Ngày về: ",
                                  style: new TextStyle(
                                      color: Colors.black,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.00429,
                                      fontFamily: "Roboto Medium",
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.0314),
                                )
                              : new Container(),
                          Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).size.width * 0.0171),
                          ),
                        ],
                      ),
                      //--------------------

                      new Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.0457),
                      ),

                      //Cot ben phai: noi dung -----------------
                      new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text(
                            tmpFlightInfo.bookingNo,
                            style: new TextStyle(
                                color: Colors.black,
                                 
                                height:
                                    MediaQuery.of(context).size.width * 0.00429,
                                fontFamily: "Roboto Medium",
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.0314),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).size.width * 0.0171),
                          ),
                          new Text(
                            "Chưa xác nhận",
                            style: new TextStyle(
                                color: Colors.black,
                                 
                                height:
                                    MediaQuery.of(context).size.width * 0.00429,
                                fontFamily: "Roboto Medium",
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.0314),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).size.width * 0.0171),
                          ),
                          new Text(
                            tmpFlightInfo.isRoundTrip ? "Khứ hồi" : "Một chiều",
                            style: new TextStyle(
                                color: Colors.black,
                                 
                                height:
                                    MediaQuery.of(context).size.width * 0.00429,
                                fontFamily: "Roboto Medium",
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.0314),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).size.width * 0.0171),
                          ),
                          new Text(
                            "${tmpFlightInfo.noOfAdult} người lớn, ${tmpFlightInfo.noOfChild} trẻ em, ${tmpFlightInfo.noOfInfant} trẻ sơ sinh.",
                            style: new TextStyle(
                                color: Colors.black,
                                 
                                height:
                                    MediaQuery.of(context).size.width * 0.00429,
                                fontFamily: "Roboto Medium",
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.0314),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).size.width * 0.0171),
                          ),
                          new Text(
                            "${DateFormat("dd/MM/yyyy").format(tmpFlightInfo.dateDepart)}",
                            style: new TextStyle(
                                color: Colors.black,
                                 
                                height:
                                    MediaQuery.of(context).size.width * 0.00429,
                                fontFamily: "Roboto Medium",
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.0314),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).size.width * 0.0171),
                          ),
                          tmpFlightInfo.isRoundTrip
                              ? new Text(
                                  "${DateFormat("dd/MM/yyyy").format(tmpFlightInfo.dateBack)}",
                                  style: new TextStyle(
                                      color: Colors.black,
                                       
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.00429,
                                      fontFamily: "Roboto Medium",
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.0314),
                                )
                              : new Container(),
                          Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).size.width * 0.0171),
                          ),
                        ],
                      ),
                      //--------------------
                    ],
                  ),
                ),
                //------------------------
              ],
            )),
        //--------------------------

        //Thong tin hanh trinh---------------------
        Padding(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.0171,
                right: MediaQuery.of(context).size.width * 0.0171),
            child: new Column(
              children: <Widget>[
                //Tieu de-------------
                new Container(
                  padding: EdgeInsets.all(
                      MediaQuery.of(context).size.width * 0.0171),
                  decoration:
                      new BoxDecoration(color: Colors.grey[300], boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        blurRadius: MediaQuery.of(context).size.width * 0.00571)
                  ]),
                  child: Center(
                    child: new Text(
                      "Thông tin hành trình",
                      style: new TextStyle(
                          color: Colors.black,
                           
                          fontFamily: "Roboto Medium",
                          fontSize: MediaQuery.of(context).size.width * 0.0457),
                    ),
                  ),
                ),
                //----------------
                //Phan than ------------------------------
                new Container(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.0171),
                    decoration:
                        new BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          blurRadius:
                              MediaQuery.of(context).size.width * 0.00571)
                    ]),
                    child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          //Chuyen bay di
                          new Row(
                            children: <Widget>[
                              //Hinh anh hang may bay--------------------
                              Image.asset(
                                "assets/${tmpFlightInfo.company1}.png",
                                width:
                                    MediaQuery.of(context).size.width * 0.189,
                                height:
                                    MediaQuery.of(context).size.width * 0.189,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.0171),
                              ),
                              //----------------------
                              //Thong tin cu the chuyen bay di ---------------------
                              new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  //Dong 1 -----------------------
                                  new Row(
                                    children: <Widget>[
                                      new Text(
                                        tmpFlightInfo.depart
                                                .contains("Hồ Chí Minh")
                                            ? "Thành phố ${tmpFlightInfo.depart}"
                                            : "${tmpFlightInfo.depart}",
                                        style: new TextStyle(
                                            color: Colors.black,
                                             
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.00429,
                                            fontFamily: "Roboto Medium",
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.0314),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.0171),
                                      ),
                                      Icon(
                                        Icons.local_airport,
                                        color: Colors.deepOrange,
                                        size:
                                            MediaQuery.of(context).size.width *
                                                0.0457,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.0171),
                                      ),
                                      new Text(
                                        tmpFlightInfo.destination
                                                .contains("Hồ Chí Minh")
                                            ? "Thành phố ${tmpFlightInfo.destination}"
                                            : "${tmpFlightInfo.destination}",
                                        style: new TextStyle(
                                            color: Colors.black,
                                             
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.00429,
                                            fontFamily: "Roboto Medium",
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.0314),
                                      ),
                                    ],
                                  ),
                                  //-----------------------------
                                  //Dong 2 -----------------------
                                  new Row(
                                    children: <Widget>[
                                      new Text(
                                        "${DateFormat("dd/MM/yyyy").format(tmpFlightInfo.dateDepart)}",
                                        style: new TextStyle(
                                            color: Colors.black,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.00429,
                                            fontFamily: "Roboto Medium",
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.0314),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.0171),
                                      ),
                                      new Text(
                                        "${tmpFlightInfo.timeDepart1}",
                                        style: new TextStyle(
                                            color: Colors.black,
                                             
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.00429,
                                            fontFamily: "Roboto Medium",
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.0314),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.0743),
                                      ),
                                      new Text(
                                        "${DateFormat("dd/MM/yyyy").format(tmpFlightInfo.dateDepart)}",
                                        style: new TextStyle(
                                            color: Colors.black,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.00429,
                                            fontFamily: "Roboto Medium",
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.0314),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.0171),
                                      ),
                                      new Text(
                                        "${tmpFlightInfo.timeBack1}",
                                        style: new TextStyle(
                                            color: Colors.black,
                                             
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.00429,
                                            fontFamily: "Roboto Medium",
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.0314),
                                      ),
                                    ],
                                  ),
                                  //-----------------------------

                                  //Dong 3 -----------------------
                                  new Row(
                                    children: <Widget>[
                                      new Text(
                                        "Mã chuyến: ",
                                        style: new TextStyle(
                                            color: Colors.black,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.00429,
                                            fontFamily: "Roboto Medium",
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.0314),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.0171),
                                      ),
                                      new Text(
                                        "${tmpFlightInfo.planeId1}",
                                        style: new TextStyle(
                                            color: Colors.black,
                                             
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.00429,
                                            fontFamily: "Roboto Medium",
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.0314),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.103),
                                      ),
                                      new Text(
                                        "Loại vé: ",
                                        style: new TextStyle(
                                            color: Colors.black,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.00429,
                                            fontFamily: "Roboto Medium",
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.0314),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.0171),
                                      ),
                                      new Text(
                                        "${tmpFlightInfo.typeSeat1}",
                                        style: new TextStyle(
                                            color: Colors.black,
                                             
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.00429,
                                            fontFamily: "Roboto Medium",
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.0314),
                                      ),
                                    ],
                                  ),
                                  //-----------------------------
                                ],
                              ),
                              //---------------------------------------
                            ],
                          ),
                          //--------------------

                          tmpFlightInfo.isRoundTrip
                              ? Padding(
                                  padding: EdgeInsets.all(
                                      MediaQuery.of(context).size.width *
                                          0.0229),
                                  child: Container(
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.width *
                                        0.00571,
                                    decoration: new BoxDecoration(
                                        color: Colors.grey[300]),
                                  ),
                                )
                              : new Container(),

                          //Chuyen bay ve ---------------------
                          tmpFlightInfo.isRoundTrip
                              ? new Row(
                                  children: <Widget>[
                                    //Hinh anh hang may bay--------------------
                                    Image.asset(
                                      "assets/${tmpFlightInfo.company2}.png",
                                      width: MediaQuery.of(context).size.width *
                                          0.189,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.189,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.0171),
                                    ),
                                    //----------------------
                                    //Thong tin cu the chuyen bay ve ---------------------
                                    new Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        //Dong 1 -----------------------
                                        new Row(
                                          children: <Widget>[
                                            new Text(
                                              tmpFlightInfo.destination
                                                      .contains("Hồ Chí Minh")
                                                  ? "Thành phố ${tmpFlightInfo.destination}"
                                                  : "${tmpFlightInfo.destination}",
                                              style: new TextStyle(
                                                  color: Colors.black,
                                                   
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.00429,
                                                  fontFamily: "Roboto Medium",
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.0314),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.0171),
                                            ),
                                            Icon(
                                              Icons.local_airport,
                                              color: Colors.deepOrange,
                                              size: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.0457,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.0171),
                                            ),
                                            new Text(
                                              tmpFlightInfo.depart
                                                      .contains("Hồ Chí Minh")
                                                  ? "Thành phố ${tmpFlightInfo.depart}"
                                                  : "${tmpFlightInfo.depart}",
                                              style: new TextStyle(
                                                  color: Colors.black,
                                                   
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.00429,
                                                  fontFamily: "Roboto Medium",
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.0314),
                                            ),
                                          ],
                                        ),
                                        //-----------------------------
                                        //Dong 2 -----------------------
                                        new Row(
                                          children: <Widget>[
                                            new Text(
                                              "${DateFormat("dd/MM/yyyy").format(tmpFlightInfo.dateBack)}",
                                              style: new TextStyle(
                                                  color: Colors.black,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.00429,
                                                  fontFamily: "Roboto Medium",
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.0314),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.0171),
                                            ),
                                            new Text(
                                              "${tmpFlightInfo.timeDepart2}",
                                              style: new TextStyle(
                                                  color: Colors.black,
                                                   
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.00429,
                                                  fontFamily: "Roboto Medium",
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.0314),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.0743),
                                            ),
                                            new Text(
                                              "${DateFormat("dd/MM/yyyy").format(tmpFlightInfo.dateBack)}",
                                              style: new TextStyle(
                                                  color: Colors.black,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.00429,
                                                  fontFamily: "Roboto Medium",
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.0314),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.0171),
                                            ),
                                            new Text(
                                              "${tmpFlightInfo.timeBack2}",
                                              style: new TextStyle(
                                                  color: Colors.black,
                                                   
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.00429,
                                                  fontFamily: "Roboto Medium",
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.0314),
                                            ),
                                          ],
                                        ),
                                        //-----------------------------

                                        //Dong 3 -----------------------
                                        new Row(
                                          children: <Widget>[
                                            new Text(
                                              "Mã chuyến: ",
                                              style: new TextStyle(
                                                  color: Colors.black,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.00429,
                                                  fontFamily: "Roboto Medium",
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.0314),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.0171),
                                            ),
                                            new Text(
                                              "${tmpFlightInfo.planeId2}",
                                              style: new TextStyle(
                                                  color: Colors.black,
                                                   
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.00429,
                                                  fontFamily: "Roboto Medium",
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.0314),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.103),
                                            ),
                                            new Text(
                                              "Loại vé: ",
                                              style: new TextStyle(
                                                  color: Colors.black,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.00429,
                                                  fontFamily: "Roboto Medium",
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.0314),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.0171),
                                            ),
                                            new Text(
                                              "${tmpFlightInfo.typeSeat2}",
                                              style: new TextStyle(
                                                  color: Colors.black,
                                                   
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.00429,
                                                  fontFamily: "Roboto Medium",
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.0314),
                                            ),
                                          ],
                                        ),
                                        //-----------------------------
                                      ],
                                    ),
                                    //---------------------------------------
                                  ],
                                )
                              : new Container(),
                          //Ket thuc chuyen bay ve----------------------------------
                        ])),
              ],
            )),
        //--------------------------
        //Thong tin thanh toan---------------------
        Padding(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.0171,
                right: MediaQuery.of(context).size.width * 0.0171),
            child: new Column(
              children: <Widget>[
                //Tieu de-------------
                new Container(
                  padding: EdgeInsets.all(
                      MediaQuery.of(context).size.width * 0.0171),
                  decoration:
                      new BoxDecoration(color: Colors.grey[300], boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        blurRadius: MediaQuery.of(context).size.width * 0.00571)
                  ]),
                  child: Center(
                    child: new Text(
                      "Thông tin thanh toán",
                      style: new TextStyle(
                          color: Colors.black,
                           
                          fontFamily: "Roboto Medium",
                          fontSize: MediaQuery.of(context).size.width * 0.0457),
                    ),
                  ),
                ),
                //----------------
                //Phan than ------------------------------
                new Container(
                  padding: EdgeInsets.all(
                      MediaQuery.of(context).size.width * 0.0171),
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(
                              MediaQuery.of(context).size.width * 0.0171),
                          bottomRight: Radius.circular(
                              MediaQuery.of(context).size.width * 0.0171)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius:
                                MediaQuery.of(context).size.width * 0.00571)
                      ]),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //thong tin thanh toan -----------------
                      new Row(
                        children: <Widget>[
                          new Text(
                            "Tổng thành tiền: ",
                            style: new TextStyle(
                                color: Colors.black,
                                fontFamily: "Roboto Medium",
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.0314),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left:
                                    MediaQuery.of(context).size.width * 0.0743),
                          ),
                          new Text(
                            "${formatter.format(tmpFlightInfo.totalPrice)} VND",
                            style: new TextStyle(
                                color: Colors.deepOrange,
                                 
                                fontFamily: "Roboto Medium",
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.0457),
                          ),
                        ],
                      ),
                      //--------------------

                      //Hinh thuc thanh toan ===================
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.width * 0.0171),
                      ),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          new Text(
                            "Hình thức thanh toán: ",
                            textAlign: TextAlign.justify,
                            style: new TextStyle(
                                height:
                                    MediaQuery.of(context).size.width * 0.00429,
                                color: Colors.black,
                                fontFamily: "Roboto Medium",
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.0314),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left:
                                    MediaQuery.of(context).size.width * 0.0743),
                          ),
                          new Text(
                            "${tmpFlightInfo.payWay}",
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                                height:
                                    MediaQuery.of(context).size.width * 0.00429,
                                color: Colors.black,
                                 
                                fontFamily: "Roboto Medium",
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.0314),
                          ),
                        ],
                      ),
                      //===============

                      //Trang thai thanh toan ===================
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.width * 0.0171),
                      ),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          new Text(
                            "Trạng thái thanh toán: ",
                            textAlign: TextAlign.justify,
                            style: new TextStyle(
                                height:
                                    MediaQuery.of(context).size.width * 0.00429,
                                color: Colors.black,
                                fontFamily: "Roboto Medium",
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.0314),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 25.0),
                          ),
                          new Text(
                            "Chưa thanh toán",
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                                height:
                                    MediaQuery.of(context).size.width * 0.00429,
                                color: Colors.black,
                                 
                                fontFamily: "Roboto Medium",
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.0314),
                          ),
                        ],
                      ),
                      //===============
                    ],
                  ),
                ),
                //------------------------
              ],
            )),
        //--------------------------
        Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.0457),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var bottomTmp = new FutureBuilder(
      future: tp,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            {
              return new Container(height: 0,);
            }
          default:
            if (snapshot.hasError) {
              return create("Lỗi kết nối mạng. Bạn vui lòng thử lại.");
            } else {
              if (tmpFlightInfo.bookingNo.length > 0){
                return new TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.all(0.0)
                  ),
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => BookingHistoryPage()),
                            (Route<dynamic> route) => false
                    );
                  },
                  child: new Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.width * 0.13,
                    padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.0314),
                    decoration: new BoxDecoration(
                      color: Color.fromRGBO(18, 175, 60, 1.0),
                    ),
                    child: new Center(
                      child: new Text(
                        "HOÀN THÀNH",
                        style: new TextStyle(
                            color: Colors.white,
                            fontFamily: "Roboto Medium",
                            fontSize: MediaQuery.of(context).size.width * 0.0457),
                      ),
                    ),
                  ),
                );
              } else {
                return create("Lỗi kết nối với máy chủ. Bạn vui lòng thử lại");
              }
            }
        }
      },
    );
    var futureBuilder = new FutureBuilder(
      future: tp,
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
              if (tmpFlightInfo.bookingNo.length > 0){
                return createListView(context, snapshot);
              } else {
                return create("Lỗi kết nối với máy chủ. Bạn vui lòng thử lại");
              }
            }
        }
      },
    );
    return new MaterialApp(
      title: "Sanvemaybay.vn",
      theme: new ThemeData(
        primaryColor: Colors.red[700],
      ),
      home: Scaffold(
        drawer: new CustomDrawer(),
        appBar: AppBar(
          title: new CustomAppBar("HOÀN TẤT ĐƠN HÀNG", false, 60.0),
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
        body: futureBuilder,
        bottomNavigationBar: bottomTmp, 
      ),
    );
  }
}

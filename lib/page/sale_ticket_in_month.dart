import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';
import 'package:sanvemaybay_app_fixed/customize_object/adult.dart';
import 'package:sanvemaybay_app_fixed/customize_object/child.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sanvemaybay_app_fixed/module/custom_app_bar.dart';
import 'package:sanvemaybay_app_fixed/module/custom_horizontial_divider.dart';
import 'package:sanvemaybay_app_fixed/module/select_item_sale.dart';
import 'package:sanvemaybay_app_fixed/module/type_of_custom.dart';
import 'package:sanvemaybay_app_fixed/customize_object/flight_info_object.dart';
import 'package:sanvemaybay_app_fixed/module/custom_drawer.dart';
import 'package:sanvemaybay_app_fixed/page/select_date_sale_page.dart';

late String url;

class SaleTicketInMonth extends StatelessWidget {
  final FlightInfoObject flightInfo;

  SaleTicketInMonth(this.flightInfo);

  @override
  Widget build(BuildContext context) {
    // url = flightInfo.storage["GenKeyLink"]!;
    return new SaleTicketInMonthSupport(flightInfo);
  }
}

class SaleTicketInMonthSupport extends StatefulWidget {
  final FlightInfoObject flightInfo;

  SaleTicketInMonthSupport(this.flightInfo);
  @override
  _SaleTicketInMonthSupportState createState() =>
      _SaleTicketInMonthSupportState(
          DateFormat("MM/yyyy").format(flightInfo.dateDepart),
          DateFormat("MM/yyyy").format(flightInfo.dateBack));
}

class _SaleTicketInMonthSupportState extends State<SaleTicketInMonthSupport> {
  late FlightInfoObject flightInfo;
  DateTime today = new DateTime.now();
  String _date1;
  String _date2;

  _SaleTicketInMonthSupportState(this._date1, this._date2);

  Map<String, DateTime> values = new Map();

  // late File jsonFile;
  // late Directory dir;
  // String filename = "apiKey.json";
  // bool fileExists = false;
  // late Map<String, dynamic> fileContent;
  //
  // Future<Null> getAPIKey() async {
  //   var res = await http.post(Uri.parse(url),
  //       headers: {"domain": flightInfo.storage["last"]!},
  //       body: {"domain": flightInfo.storage["last"]});
  //   setState(() {
  //     var resBody = json.decode(res.body);
  //     if (resBody["status"] == 1)
  //       flightInfo.apiKey = resBody["key"];
  //     else
  //       flightInfo.apiKey = "71c4fd985882f8940b73582bf5b723964d6f8d74";
  //     writeToFile("key", flightInfo.apiKey);
  //   });
  // }
  //
  // void createFile(Map<String, String> content, Directory dir, String fileName) {
  //   File file = new File(dir.path + "/" + fileName);
  //   file.createSync();
  //   fileExists = true;
  //   file.writeAsStringSync(json.encode(content));
  // }
  //
  // void writeToFile(String key, String value) {
  //   Map<String, String> content = {key: value};
  //   if (fileExists) {
  //     Map<String, String> jsonFileContent =
  //         json.decode(jsonFile.readAsStringSync());
  //     jsonFileContent.addAll(content);
  //     jsonFile.writeAsStringSync(json.encode(jsonFileContent));
  //   } else {
  //     createFile(content, dir, filename);
  //   }
  //   this.setState(() => fileContent = json.decode(jsonFile.readAsStringSync()));
  // }

  void _handlePressed(String type) {
    _selectMonthDepart(context, type).then((DateTime? value) {
      setState(() {
        if (type.contains("đi")) {
          flightInfo.dateDepart = value!;
          _date1 = DateFormat("MM/yyyy").format(value);
          if (value.compareTo(flightInfo.dateBack) > 0) {
            flightInfo.dateBack = value;
            _date2 = DateFormat("MM/yyyy").format(value);
          }
        } else {
          flightInfo.dateBack = value!;
          _date2 = DateFormat("MM/yyyy").format(value);
        }
      });
    });
  }

  _createListMonthValues(BuildContext context, String type) {
    DateTime month = DateTime.now();
    for (var i = 0; i < 10; i++) {
      values.putIfAbsent("$i", () {
        return month;
      });
      int tmp = month.month;
      month = month.add(Duration(days: 28));
      if (tmp == month.month) {
        month = month.add(Duration(days: 2));
        tmp = month.month;
      }
      if (tmp == month.month) {
        month = month.add(Duration(days: 1));
        tmp = month.month;
      }
    }
    List<Widget> listMonth = [];
    for (DateTime item in values.values) {
      if (type.contains("đi")) {
        listMonth.add(
          new TextButton(
            style: TextButton.styleFrom(
              backgroundColor:
                  DateFormat("MM/yyyy").format(item).contains(_date1)
                      ? Colors.green
                      : Colors.white,
            ),
            child: Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.103,
                  right: MediaQuery.of(context).size.width * 0.103),
              child: new Text(
                DateFormat("MM/yyyy").format(item),
                style: new TextStyle(
                  fontFamily: "Roboto Medium",
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                  color: DateFormat("MM/yyyy").format(item).contains(_date1)
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop(item);
            },
          ),
        );
      } else {
        listMonth.add(
          new TextButton(
            style: TextButton.styleFrom(
              backgroundColor:
                  DateFormat("MM/yyyy").format(item).contains(_date1)
                      ? Colors.green
                      : Colors.white,
            ),
            child: Container(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.103,
                  right: MediaQuery.of(context).size.width * 0.103,
                  top: 0.0,
                  bottom: 0.0),
              child: new Text(
                DateFormat("MM/yyyy").format(item),
                style: new TextStyle(
                  color: item.compareTo(flightInfo.dateDepart) < 0
                      ? Colors.grey
                      : DateFormat("MM/yyyy").format(item).contains(_date2)
                          ? Colors.white
                          : Colors.black,
                  fontFamily: "Roboto Medium",
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                ),
              ),
            ),
            onPressed: () {
              if (item.compareTo(flightInfo.dateDepart) >= 0)
                Navigator.of(context).pop(item);
            },
          ),
        );
      }
    }

    return new Column(
      children: listMonth,
    );
  }

  Future<DateTime?> _selectMonthDepart(BuildContext context, String type) {
    return showDialog<DateTime>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            contentPadding: EdgeInsets.only(
                top: MediaQuery.of(context).size.width * 0.0286),
            titlePadding: EdgeInsets.all(0.0),
            title: new Container(
              height: MediaQuery.of(context).size.width * 0.12,
              decoration: new BoxDecoration(
                color: Colors.red[700],
              ),
              child: Center(
                child: new Text(
                  "CHỌN THÁNG CẦN TÌM",
                  style: new TextStyle(
                    color: Colors.white,
                    fontFamily: "Roboto Medium",
                    fontSize: MediaQuery.of(context).size.width * 0.0457,
                  ),
                ),
              ),
            ),
            content: new Container(
              height: MediaQuery.of(context).size.height * 0.8,
              child: _createListMonthValues(context, type),
            ),
          );
        });
  }

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
    _date1 = new DateFormat("MM/yyyy").format(widget.flightInfo.dateDepart);
    _date2 = new DateFormat("MM/yyyy").format(widget.flightInfo.dateBack);
    flightInfo = new FlightInfoObject(
        destination: widget.flightInfo.destination,
        depart: widget.flightInfo.depart,
        isOneWayTrip: widget.flightInfo.isOneWayTrip,
        isRoundTrip: widget.flightInfo.isRoundTrip,
        noOfAdult: widget.flightInfo.noOfAdult,
        noOfChild: widget.flightInfo.noOfChild,
        noOfInfant: widget.flightInfo.noOfInfant);
    flightInfo.dateDepart = widget.flightInfo.dateDepart;
    flightInfo.dateBack = widget.flightInfo.dateBack;
    if (widget.flightInfo.depart.isEmpty) {
      flightInfo.depart = "Hồ Chí Minh";
    } else {
      flightInfo.depart = widget.flightInfo.depart;
    }

    if (widget.flightInfo.destination.isEmpty) {
      flightInfo.destination = "Hà Nội";
    } else {
      flightInfo.destination = widget.flightInfo.destination;
    }

  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Sanvemaybay.vn",
      theme: new ThemeData(
        primaryColor: Colors.red[700],
      ),
      home: new Scaffold(
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
        body: new Container(
          child: new Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // *************************** Chon khu hoi hay mot chieu ***************************************
              new Padding(
                padding: new EdgeInsets.only(top: 10.0),
              ),
              new Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.all(0.0),
                    ),
                    child: new Container(
                      padding: new EdgeInsets.all(6.0),
                      width: MediaQuery.of(context).size.width * 0.25,
                      decoration: new BoxDecoration(
                        color: flightInfo.isRoundTrip
                            ? Colors.red[700]
                            : Colors.grey[300],
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(6.0),
                            bottomLeft: Radius.circular(6.0)),
                      ),
                      child: new Text(
                        "Khứ hồi",
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                          fontFamily: "Roboto Medium",
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          color: flightInfo.isRoundTrip
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        flightInfo.isRoundTrip = true;
                        flightInfo.isOneWayTrip = false;
                      });
                    },
                  ),
                  new TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.all(0.0),
                    ),
                    child: new Container(
                      padding: new EdgeInsets.all(6.0),
                      width: MediaQuery.of(context).size.width * 0.25,
                      decoration: new BoxDecoration(
                        color: flightInfo.isOneWayTrip
                            ? Colors.red[700]
                            : Colors.grey[300],
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(6.0),
                            bottomRight: Radius.circular(6.0)),
                      ),
                      child: new Text(
                        "Một chiều",
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                          fontFamily: "Roboto Medium",
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          color: flightInfo.isOneWayTrip
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        flightInfo.isOneWayTrip = true;
                        flightInfo.isRoundTrip = false;
                      });
                    },
                  ),
                ],
              ),
              // ************************************ Chon dia diem ******************************************
              new CustomHorizontialDivider(
                  MediaQuery.of(context).size.width * 0.9, 10.0),
              new Container(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.055,
                    right: MediaQuery.of(context).size.width * 0.055),
                width: double.infinity,
                child: new Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new SelectItemSale(
                        "Nơi đi",
                        flightInfo,
                        new Icon(
                          Icons.location_on,
                          color: Colors.red[700],
                          size: 20.0,
                        ),
                        context),
                    new SelectItemSale(
                        "Nơi đến",
                        flightInfo,
                        new Icon(
                          Icons.location_on,
                          color: Colors.red[700],
                          size: 20.0,
                        ),
                        context),
                  ],
                ),
              ),
              // ********************************************Chon ngay******************************************
              new CustomHorizontialDivider(
                  MediaQuery.of(context).size.width * 0.9, 15.0),
              new Container(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.055,
                    right: MediaQuery.of(context).size.width * 0.055),
                width: double.infinity,
                child: new Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    //Ngày đi
                    new Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                          "Tháng đi",
                          style: new TextStyle(
                            fontFamily: "Roboto Medium",
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                          ),
                        ),
                        new Padding(
                            padding: new EdgeInsets.only(
                                top: MediaQuery.of(context).size.width *
                                    0.0229)),
                        new TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.all(0.0),
                          ),
                          onPressed: () {
                            _handlePressed("đi");
                          },
                          child: new Container(
                            width: MediaQuery.of(context).size.width * 0.42,
                            height: MediaQuery.of(context).size.width * 0.1,
                            padding: new EdgeInsets.all(6.0),
                            decoration: new BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6.0)),
                              boxShadow: [
                                new BoxShadow(
                                    color: Colors.black, blurRadius: 2.0),
                              ],
                            ),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  child: new Text(
                                    _date1,
                                    style: new TextStyle(
                                      fontFamily: "Roboto Medium",
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.035,
                                    ),
                                  ),
                                ),
                                new IconButton(
                                  padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.07),
                                  onPressed: () {
                                    _handlePressed("đi");
                                  },
                                  icon: new Icon(
                                    Icons.date_range,
                                    color: Colors.red[700],
                                    size: 20.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    //Ngày về
                    flightInfo.isRoundTrip
                        ? new Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text(
                                "Tháng về",
                                style: new TextStyle(
                                  fontFamily: "Roboto Medium",
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
                                ),
                              ),
                              new Padding(
                                  padding: new EdgeInsets.only(
                                      top: MediaQuery.of(context).size.width *
                                          0.0229)),
                              new TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.all(0.0),
                                ),
                                onPressed: () {
                                  _handlePressed("về");
                                },
                                child: new Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.42,
                                  height:
                                      MediaQuery.of(context).size.width * 0.1,
                                  padding: new EdgeInsets.all(6.0),
                                  decoration: new BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6.0)),
                                    boxShadow: [
                                      new BoxShadow(
                                          color: Colors.black, blurRadius: 2.0),
                                    ],
                                  ),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      new Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.25,
                                        child: new Text(
                                          _date2,
                                          style: new TextStyle(
                                            fontFamily: "Roboto Medium",
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.035,
                                          ),
                                        ),
                                      ),
                                      new IconButton(
                                        padding: EdgeInsets.only(
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.07),
                                        onPressed: () {
                                          _handlePressed("về");
                                        },
                                        icon: new Icon(
                                          Icons.date_range,
                                          color: Colors.red[700],
                                          size: 20.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        : new Container(
                            width: MediaQuery.of(context).size.width * 0.38,
                          ),
                  ],
                ),
              ),
              new CustomHorizontialDivider(
                  MediaQuery.of(context).size.width * 0.9, 15.0),

              new Container(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.018,
                    right: MediaQuery.of(context).size.width * 0.018),
                width: double.infinity,
                child: new Column(
                  children: <Widget>[
                    new Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        new TypeOfCustom(
                            "assets/adult.png", "Người lớn", "12 tuổi trở lên"),
                        new TypeOfCustom(
                            "assets/child.png", "Trẻ em", "Từ 2 - 11 tuổi"),
                        new TypeOfCustom(
                            "assets/infant.png", "Trẻ sơ sinh", "Dưới 2 tuổi"),
                      ],
                    ),
                    new Container(
                      width: MediaQuery.of(context).size.width * 1.0,
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          new Padding(
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.09),
                          ),
                          //So luong nguoi lon
                          new Column(
                            children: <Widget>[
                              new Text(
                                flightInfo.noOfAdult.toString(),
                                style: new TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.15,
                                  fontFamily: "Roboto Medium",
                                ),
                              ),
                              new CustomHorizontialDivider(
                                  MediaQuery.of(context).size.width * 0.12, 1.0)
                            ],
                          ),
                          // new Padding(
                          //   padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.015),
                          // ),
                          //button of nguoi lon
                          new Column(
                            children: <Widget>[
                              new Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.width *
                                        0.015),
                              ),
                              new IconButton(
                                icon: Icon(
                                  Icons.arrow_drop_up,
                                  size:
                                      MediaQuery.of(context).size.width * 0.08,
                                ),
                                color: flightInfo.noOfAdult <= 8
                                    ? Colors.black
                                    : Colors.grey,
                                onPressed: () {
                                  setState(() {
                                    if (flightInfo.noOfAdult <= 8)
                                      flightInfo.noOfAdult++;
                                    if (flightInfo.noOfAdult <
                                        flightInfo.noOfInfant)
                                      flightInfo.noOfInfant =
                                          flightInfo.noOfAdult;
                                  });
                                },
                              ),
                              new IconButton(
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  size:
                                      MediaQuery.of(context).size.width * 0.08,
                                ),
                                color: flightInfo.noOfAdult > 1
                                    ? Colors.black
                                    : Colors.grey,
                                onPressed: () {
                                  setState(() {
                                    if (flightInfo.noOfAdult > 1)
                                      flightInfo.noOfAdult--;
                                    if (flightInfo.noOfAdult <
                                        flightInfo.noOfInfant)
                                      flightInfo.noOfInfant =
                                          flightInfo.noOfAdult;
                                  });
                                },
                              ),
                            ],
                          ),
                          // new Padding(
                          //   padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.035),
                          // ),
                          //So luong tre em
                          new Column(
                            children: <Widget>[
                              new Text(
                                flightInfo.noOfChild.toString(),
                                style: new TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.15,
                                  fontFamily: "Roboto Medium",
                                ),
                              ),
                              new CustomHorizontialDivider(
                                  MediaQuery.of(context).size.width * 0.12, 1.0)
                            ],
                          ),
                          // new Padding(
                          //   padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.015),
                          // ),
                          //button of tre em
                          new Column(
                            children: <Widget>[
                              new IconButton(
                                icon: Icon(
                                  Icons.arrow_drop_up,
                                  size:
                                      MediaQuery.of(context).size.width * 0.08,
                                ),
                                color: flightInfo.noOfChild <= 8
                                    ? Colors.black
                                    : Colors.grey,
                                onPressed: () {
                                  setState(() {
                                    if (flightInfo.noOfChild <= 8)
                                      flightInfo.noOfChild++;
                                  });
                                },
                              ),
                              new IconButton(
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  size:
                                      MediaQuery.of(context).size.width * 0.08,
                                ),
                                color: flightInfo.noOfChild > 0
                                    ? Colors.black
                                    : Colors.grey,
                                onPressed: () {
                                  setState(() {
                                    if (flightInfo.noOfChild > 0)
                                      flightInfo.noOfChild--;
                                  });
                                },
                              ),
                            ],
                          ),
                          // new Padding(
                          //   padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.035),
                          // ),
                          //So luong tre so sinh
                          new Column(
                            children: <Widget>[
                              new Text(
                                flightInfo.noOfInfant.toString(),
                                style: new TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.15,
                                    fontFamily: "Roboto Medium"),
                              ),
                              new CustomHorizontialDivider(
                                  MediaQuery.of(context).size.width * 0.12, 1.0)
                            ],
                          ),
                          //button of tre so sinh
                          new Column(
                            children: <Widget>[
                              new IconButton(
                                icon: Icon(
                                  Icons.arrow_drop_up,
                                  size:
                                      MediaQuery.of(context).size.width * 0.08,
                                ),
                                color:
                                    flightInfo.noOfInfant < flightInfo.noOfAdult
                                        ? Colors.black
                                        : Colors.grey,
                                onPressed: () {
                                  setState(() {
                                    if (flightInfo.noOfInfant <
                                        flightInfo.noOfAdult)
                                      flightInfo.noOfInfant++;
                                  });
                                },
                              ),
                              new IconButton(
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  size:
                                      MediaQuery.of(context).size.width * 0.08,
                                ),
                                color: flightInfo.noOfInfant > 0
                                    ? Colors.black
                                    : Colors.grey,
                                onPressed: () {
                                  setState(() {
                                    if (flightInfo.noOfInfant > 0)
                                      flightInfo.noOfInfant--;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              //Next Button
              new Expanded(
                flex: 1,
                child: new Column(
                  verticalDirection: VerticalDirection.up,
                  children: <Widget>[
                    new Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.width * 0.12,
                      decoration: new BoxDecoration(
                          color: Color.fromRGBO(18, 175, 60, 1.0)),
                      child: new TextButton(
                        onPressed: () async {
                          var connectivityResult =
                              await new Connectivity().checkConnectivity();
                          // if (connectivityResult != ConnectivityResult.mobile &&
                          //     connectivityResult != ConnectivityResult.wifi) {
                          //   _confirmDialog(context,
                          //       "Không có kết nối mạng. Vui lòng kiểm tra lại.");
                          bool isOnline = false;
                          if (connectivityResult is Iterable) {
                            final results = connectivityResult.cast<ConnectivityResult>().toSet();
                            isOnline = results.contains(ConnectivityResult.ethernet) ||
                                       results.contains(ConnectivityResult.mobile) ||
                                       results.contains(ConnectivityResult.wifi) ||
                                       results.contains(ConnectivityResult.bluetooth) ||
                                       results.contains(ConnectivityResult.other);
                          }

                          if (!isOnline) {
                            _confirmDialog(context,
                                "Không có kết nối mạng. Vui lòng kiểm tra lại.");
                          } else {
                            if (flightInfo.depart
                                    .compareTo(flightInfo.destination) ==
                                0) {
                              _confirmDialog(context,
                                  "Nơi đi và nơi đến không hợp lý. Vui lòng kiểm tra lại");
                            } else {
                              for (int i = 0; i < flightInfo.noOfAdult; i++) {
                                flightInfo.listAdults.add(new Adult());
                              }
                              for (int i = 0; i < flightInfo.noOfChild; i++) {
                                flightInfo.listChildren.add(new Child());
                              }
                              for (int i = 0; i < flightInfo.noOfInfant; i++) {
                                flightInfo.listInfants.add(new Child());
                              }
                              Navigator.of(context).push(new MaterialPageRoute(
                                  builder: (context) =>
                                      new SelectDateSalePage(flightInfo)));
                            }
                          }
                        },
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Icon(
                              Icons.search,
                              color: Colors.white,
                              size: MediaQuery.of(context).size.width * 0.06,
                            ),
                            new Text(
                              "TÌM NGAY",
                              style: new TextStyle(
                                fontFamily: "Roboto Medium",
                                fontSize: 16.0,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              //Ket thuc Next button
            ],
          ),
        ),
      ),
    );
  }
}

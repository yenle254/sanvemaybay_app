import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sanvemaybay_app_fixed/customize_object/adult.dart';
import 'package:sanvemaybay_app_fixed/customize_object/child.dart';
import 'package:sanvemaybay_app_fixed/module/custom_app_bar.dart';
import 'package:sanvemaybay_app_fixed/module/custom_horizontial_divider.dart';
import 'package:sanvemaybay_app_fixed/module/select_item.dart';
import 'package:sanvemaybay_app_fixed/module/type_of_custom.dart';
import 'package:sanvemaybay_app_fixed/customize_object/flight_info_object.dart';
import 'package:sanvemaybay_app_fixed/module/custom_drawer.dart';
import 'package:sanvemaybay_app_fixed/page/select_flight_page.dart';

// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

DateFormat df = new DateFormat("dd/MM/yyyy");

String? url;

// class BookTicketPage extends StatelessWidget {
//   final FlightInfoObject flightInfo;

//   BookTicketPage(this.flightInfo);
//
//   @override
//   Widget build(BuildContext context) {
//     // url = flightInfo.storage["GenKeyLink"];
//     return new BookTicket(flightInfo);
//   }
// }
//
// class BookTicket extends StatefulWidget {
//   final FlightInfoObject flightInfo;
//
//   BookTicket(this.flightInfo);
//   @override
//   _BookTicketState createState() => _BookTicketState();
// }
//
// class _BookTicketState extends State<BookTicket> {
//   late FlightInfoObject flightInfo;
//   DateTime today = new DateTime.now();
//   late DateTime tmp;
//
//   late File jsonFile;
//   late Directory dir;
//   String filename = "apiKey.json";
//   bool fileExists = false;
//   late Map<String, dynamic> fileContent;
//
//   Future<Null> getAPIKey() async {
//
//
//     var res = await http.post(Uri.parse(url!),
//         headers: {"domain":  flightInfo.storage["last"]!},
//         body: {"domain":  flightInfo.storage["last"]});
//
//
//     setState(() {
//       var resBody = json.decode(res.body);
//       if (resBody["status"] == 1) {
//         flightInfo.apiKey = resBody["key"];
//       } else {
//         flightInfo.apiKey = "71c4fd985882f8940b73582bf5b723964d6f8d74";
//       }
//       writeToFile("key", flightInfo.apiKey);
//     });
//   }
//
//   void createFile(Map<String, String> content, Directory dir, String fileName) {
//     File file = new File(dir.path + "/" + fileName);
//     file.createSync();
//     fileExists = true;
//     file.writeAsStringSync(json.encode(content));
//   }
//
//   void writeToFile(String key, String value) {
//     Map<String, String> content = {key: value};
//     if (fileExists) {
//       Map<String, String> jsonFileContent =
//           json.decode(jsonFile.readAsStringSync());
//       jsonFileContent.addAll(content);
//       jsonFile.writeAsStringSync(json.encode(jsonFileContent));
//     } else {
//       createFile(content, dir, filename);
//     }
//     this.setState(() => fileContent = json.decode(jsonFile.readAsStringSync()));
//   }
//
//   Future<Null> _selectDateDepart(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: flightInfo.dateDepart,
//       firstDate: today.subtract(Duration(days: 1)),
//       lastDate: new DateTime(DateTime.now().year + 1, 12, 31),
//     );
//     setState(() {
//       flightInfo.dateDepart = picked!;
//       if (picked.compareTo(flightInfo.dateBack) == 1) {
//         flightInfo.dateBack = flightInfo.dateDepart;
//       }
//     });
//     }
//
//   Future<Null> _selectDateBack(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: flightInfo.dateBack,
//       firstDate: (new DateFormat("dd/MM/yyyy")
//                   .format(flightInfo.dateDepart)
//                   .compareTo(new DateFormat("dd/MM/yyyy").format(today)) ==
//               0)
//           ? today.subtract(Duration(days: 1))
//           : flightInfo.dateDepart,
//       lastDate: new DateTime(DateTime.now().year + 1, 12, 31),
//     );
//     setState(() {
//       flightInfo.dateBack = picked!;
//     });
//     }
//
//   @override
//   void initState() {
//     super.initState();
//     flightInfo = new FlightInfoObject(
//         destination: widget.flightInfo.destination,
//         depart: widget.flightInfo.depart,
//         isOneWayTrip: widget.flightInfo.isOneWayTrip,
//         isRoundTrip: widget.flightInfo.isRoundTrip,
//         noOfAdult: widget.flightInfo.noOfAdult,
//         noOfChild: widget.flightInfo.noOfChild,
//         noOfInfant: widget.flightInfo.noOfInfant);
//     flightInfo.dateDepart = widget.flightInfo.dateDepart;
//     flightInfo.dateBack = widget.flightInfo.dateBack;
//     if (widget.flightInfo.depart.isEmpty) {
//       flightInfo.depart = "Hồ Chí Minh";
//     } else {
//       flightInfo.depart = widget.flightInfo.depart;
//     }
//
//     if (widget.flightInfo.destination.isEmpty) {
//       flightInfo.destination = "Hà Nội";
//     } else {
//       flightInfo.destination = widget.flightInfo.destination;
//     }
//
//     getApplicationDocumentsDirectory().then((Directory directory) {
//       dir = directory;
//       jsonFile = new File(dir.path + "/" + filename);
//       fileExists = jsonFile.existsSync();
//       if (fileExists) {
//         this.setState(
//             () => fileContent = json.decode(jsonFile.readAsStringSync()));
//         flightInfo.apiKey = fileContent["key"];
//       } else {
//         getAPIKey();
//       }
//     });
//   }
class BookTicketPage extends StatelessWidget {
  final FlightInfoObject flightInfo;

  BookTicketPage(this.flightInfo);

  @override
  Widget build(BuildContext context) {
    return new BookTicket(flightInfo);
  }
}

class BookTicket extends StatefulWidget {
  final FlightInfoObject flightInfo;

  BookTicket(this.flightInfo);
  @override
  _BookTicketState createState() => _BookTicketState();
}

class _BookTicketState extends State<BookTicket> {
  late FlightInfoObject flightInfo;
  DateTime today = new DateTime.now();

  Future<Null> _selectDateDepart(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: flightInfo.dateDepart,
      firstDate: today.subtract(Duration(days: 1)),
      lastDate: new DateTime(DateTime.now().year + 1, 12, 31),
    );
    if (picked != null) {
      setState(() {
        flightInfo.dateDepart = picked;
        if (picked.compareTo(flightInfo.dateBack) == 1) {
          flightInfo.dateBack = flightInfo.dateDepart;
        }
      });
    }
  }

  Future<Null> _selectDateBack(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: flightInfo.dateBack,
      firstDate: (new DateFormat("dd/MM/yyyy")
          .format(flightInfo.dateDepart)
          .compareTo(new DateFormat("dd/MM/yyyy").format(today)) ==
          0)
          ? today.subtract(Duration(days: 1))
          : flightInfo.dateDepart,
      lastDate: new DateTime(DateTime.now().year + 1, 12, 31),
    );
    if (picked != null) {
      setState(() {
        flightInfo.dateBack = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
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
    return new MaterialApp(
      title: "Sanvemaybay.vn",
      theme: new ThemeData(
        primaryColor: Colors.red[700],
      ),
      home: new Scaffold(
        drawer: new CustomDrawer(),
        appBar: AppBar(
          title: new CustomAppBar("TÌM CHUYẾN BAY", false, 60.0),
          actions: <Widget>[
            Padding(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.width * 0.0171),
              
              child: new InkResponse(
              child: new Icon(Icons.phone, size: MediaQuery.of(context).size.width * 0.071,),
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
                    new SelectItem(
                        "Nơi đi",
                        flightInfo,
                        new Icon(
                          Icons.location_on,
                          color: Colors.red[700],
                          size: 20.0,
                        ),
                        context),
                    new SelectItem(
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
                          "Ngày đi",
                          style: new TextStyle(
                            fontFamily: "Roboto Medium",
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                          ),
                        ),
                        new Padding(padding: new EdgeInsets.only(top: MediaQuery.of(context).size.width*0.0229)),
                        new Container(
                          width: MediaQuery.of(context).size.width * 0.42,
                          height: MediaQuery.of(context).size.width * 0.1,
                          padding: new EdgeInsets.all(MediaQuery.of(context).size.width * 0.0171),
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
                              new TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.all(0.0),
                                ),
                                onPressed: () {
                                  _selectDateDepart(context);
                                },
                                child: new Container(
                                  
                                  width: MediaQuery.of(context).size.width * 0.25,
                                  child: new Text(
                                    df.format(flightInfo.dateDepart),
                                    style: new TextStyle(
                                      fontFamily: "Roboto Medium",
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.035,
                                       
                                    ),
                                  ),
                                ),
                              ),
                              new IconButton(
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.068),
                                onPressed: () {
                                  _selectDateDepart(context);
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
                      ],
                    ),
                    //Ngày về
                    flightInfo.isRoundTrip
                        ? new Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text(
                                "Ngày về",
                                style: new TextStyle(
                                  fontFamily: "Roboto Medium",
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
                                ),
                              ),
                              new Padding(
                                  padding: new EdgeInsets.only(top: MediaQuery.of(context).size.width*0.0229)),
                              new Container(
                                width: MediaQuery.of(context).size.width * 0.42,
                                height: MediaQuery.of(context).size.width * 0.1,
                                padding: new EdgeInsets.all(MediaQuery.of(context).size.width * 0.0171),
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
                                    new TextButton(
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.all(0.0),
                                      ),
                                      onPressed: () {
                                        _selectDateBack(context);
                                      },
                                      child: new Container(
                                        
                                        width: MediaQuery.of(context).size.width *
                                            0.25,
                                        child: new Text(
                                          df.format(flightInfo.dateBack),
                                          style: new TextStyle(
                                            fontFamily: "Roboto Medium",
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.035,
                                             
                                          ),
                                        ),
                                      ),
                                    ),
                                    new IconButton(
                                      padding: EdgeInsets.only(
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.068),
                                      onPressed: () {
                                        _selectDateBack(context);
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
                    left: MediaQuery.of(context).size.width * 0.015,
                    right: MediaQuery.of(context).size.width * 0.015),
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
                            var connectivityResult = await new Connectivity().checkConnectivity();
                            bool isOnline = false;
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
                            // if (connectivityResult != ConnectivityResult.mobile 
                            // && connectivityResult != ConnectivityResult.wifi) {
                            //   _confirmDialog(context, "Không có kết nối mạng. Vui lòng kiểm tra lại.");
                            if (!isOnline) {
                              _confirmDialog(context, "Không có kết nối mạng. Vui lòng kiểm tra lại.");
                            } else {
                              if (flightInfo.depart.compareTo(flightInfo.destination) == 0){
                                _confirmDialog(context, "Nơi đi và nơi đến không hợp lý. Vui lòng kiểm tra lại");
                              } else {
                                for (int i = 0; i < flightInfo.noOfAdult; i++){
                                  flightInfo.listAdults.add(new Adult());
                                }
                                for (int i = 0; i < flightInfo.noOfChild; i++){
                                  flightInfo.listChildren.add(new Child());
                                }
                                for (int i = 0; i < flightInfo.noOfInfant; i++){
                                  flightInfo.listInfants.add(new Child());
                                }
                                Navigator.of(context).push(new MaterialPageRoute(
                                builder: (context) =>
                                    new SelectFlightPage(flightInfo)));
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

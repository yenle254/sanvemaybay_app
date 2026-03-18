

import 'package:flutter/material.dart';
import 'package:sanvemaybay_app_fixed/module/custom_app_bar.dart';
import 'package:sanvemaybay_app_fixed/module/custom_drawer.dart';
import 'package:sanvemaybay_app_fixed/customize_object/flight_info_object.dart';
import 'package:intl/intl.dart';
import 'package:sanvemaybay_app_fixed/page/book_ticket_page.dart';
import 'package:sanvemaybay_app_fixed/page/select_back_flight_page.dart';
import 'package:sanvemaybay_app_fixed/page/fill_customer_info_page.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/firebase_service.dart';
import '../customize_object/flight_model.dart';

String? url1;
String? url2;
String? url3;

String? url4;

FlightInfoObject tmpF = new FlightInfoObject();

int total = 0;

int currentChosenFlight = -1;

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

DateTime? dateBefore;
DateTime? dateAfter;
String? departId;
String? destinationId;

DateTime today = new DateTime(
    DateTime.now().year, DateTime.now().month, DateTime.now().day);

class SelectFlightPage extends StatelessWidget {
  final FlightInfoObject flightInfo;

  SelectFlightPage(this.flightInfo);

  @override
  Widget build(BuildContext context) {
    // url1 = flightInfo.storage["JetSearchLink"];
    // url2 = flightInfo.storage["VjaSearchLink"];
    // url3 = flightInfo.storage["VnaSearchLink"];
    // url4 = flightInfo.storage["NewApiLink"];
    return new SelectFlightPageSupport(flightInfo);
  }
}

class SelectFlightPageSupport extends StatefulWidget {
  final FlightInfoObject flightInfo;

  SelectFlightPageSupport(this.flightInfo);

  @override
  _SelectFlightPageSupportState createState() {
    return _SelectFlightPageSupportState();
  }
}

class _SelectFlightPageSupportState extends State<SelectFlightPageSupport> {
  bool isLoading = true;

  String apiKey = "";

  Map<String, dynamic> list = {};
  List outbound = [];
  List inbound = [];

  Future<Null> tmp = Future<Null>.value();


  @override
  void initState() {
    super.initState();
    currentChosenFlight = -1;
    dateBefore = widget.flightInfo.dateDepart.subtract(Duration(days: 1));
    dateAfter = widget.flightInfo.dateDepart.add(Duration(days: 1));
    if (widget.flightInfo.depCode.isNotEmpty) {
      departId = widget.flightInfo.depCode;
    } else {
      departId = listAirportID[widget.flightInfo.depart];
    }
    if (widget.flightInfo.arvCode.isNotEmpty) {
      destinationId = widget.flightInfo.arvCode;
    } else {
      destinationId = listAirportID[widget.flightInfo.destination];
    }
    apiKey = widget.flightInfo.apiKey;
    widget.flightInfo.depCode = departId ?? "";
    widget.flightInfo.arvCode = destinationId ?? "";

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
  int currentChosenFlight = -1;
  @override
  Widget build(BuildContext context) {


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
        body: new SearchFlightList(widget.flightInfo),
      ),
    );
  }
}

class SearchFlightList extends StatefulWidget {
  final FlightInfoObject flightInfoObject;

  SearchFlightList(this.flightInfoObject);

  _SearchFlightListState createState() => _SearchFlightListState();
}

// class _SearchFlightListState extends State<SearchFlightList> {
//   late StreamController<Map<String, dynamic>> streamController1;
//   late StreamController<Map<String, dynamic>> streamController2;
//   late StreamController<Map<String, dynamic>> streamController3;
//   late StreamController<Map<String, dynamic>> streamController4;
//   late StreamController<Map<String, dynamic>> streamController5;
//   late StreamController<Map<String, dynamic>> streamController6;
//   List list = [];
//   List listInbound = [];
//   int completedApiCalls = 0;
//   int lastProcessedCount = 0;
//   Timer? timeoutTimer;
//
//   void processFlightArrays() {
//     if (list.length == lastProcessedCount) {
//       return;
//     }
//
//     lastProcessedCount = list.length;
//
//     prices = [];
//     companies = [];
//     planeIds = [];
//     typeSeats = [];
//     timeDeparts = [];
//     timeBacks = [];
//     aldultFares = [];
//     childFares = [];
//     infantFares = [];
//
//     for (var item in list) {
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
//
//
//     // Sort by price
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
//     print("Arrays sorted by price");
//   }
//
//   @override
//   void initState() {
//     super.initState();
//
//     streamController1 = StreamController.broadcast();
//
//     currentChosenFlight = -1;
//     completedApiCalls = 0;
//     lastProcessedCount = 0;
//
//     streamController1.stream.listen((res) => setState((){
//       completedApiCalls++;
//       if (res != null) {
//         var temp = res["data"];
//         if (temp != null) {
//           var tmp = temp["outbound"];
//           if (tmp != null && tmp is List) {
//             for (var item in tmp){
//               if (item != null) {
//                 list.add(item);
//               }
//             }
//           } else {
//             print("BL - No outbound flights or invalid format");
//           }
//
//           if (widget.flightInfoObject.isRoundTrip) {
//             var tmp = temp["inbound"];
//             if (tmp != null && tmp is List) {
//               for (var item in tmp){
//                 if (item != null) {
//                   listInbound.add(item);
//                 }
//               }
//             }
//           }
//         }
//       }
//
//       if (list.isNotEmpty) {
//         processFlightArrays();
//         if (timeoutTimer != null && timeoutTimer!.isActive) {
//           timeoutTimer!.cancel();
//         }
//       }
//
//       if (completedApiCalls >= 6) {
//         if (list.isNotEmpty) {
//           processFlightArrays();
//         }
//       }
//     }));
//
//     streamController2 = StreamController.broadcast();
//
//     streamController2.stream.listen((res) => setState((){
//       completedApiCalls++;
//       if (res != null) {
//         var temp = res["data"];
//         if (temp != null) {
//           var tmp = temp["outbound"];
//           if (tmp != null && tmp is List) {
//             for (var item in tmp){
//               if (item != null) {
//                 list.add(item);
//               }
//             }
//           } else {
//             print("VJ - No outbound flights or invalid format");
//           }
//
//           if (!widget.flightInfoObject.isOneWayTrip) {
//             var tmp = temp["inbound"];
//             if (tmp != null && tmp is List) {
//               for (var item in tmp){
//                 if (item != null) {
//                   listInbound.add(item);
//                 }
//               }
//             }
//           }
//         }
//       }
//
//       if (list.isNotEmpty) {
//         processFlightArrays();
//         if (timeoutTimer != null && timeoutTimer!.isActive) {
//           timeoutTimer!.cancel();
//         }
//       }
//
//       if (completedApiCalls >= 6) {
//         if (list.isNotEmpty) {
//           processFlightArrays();
//         }
//       }
//     }));
//
//     streamController3 = StreamController.broadcast();
//
//     streamController3.stream.listen((res) => setState((){
//       completedApiCalls++;
//       if (res != null) {
//         var temp = res["data"];
//         if (temp != null) {
//           var tmp = temp["outbound"];
//           if (tmp != null && tmp is List) {
//             for (var item in tmp){
//               if (item != null) {
//                 list.add(item);
//               }
//             }
//           } else {
//             print("VN - No outbound flights or invalid format");
//           }
//
//           if (!widget.flightInfoObject.isOneWayTrip) {
//             var tmp = temp["inbound"];
//             if (tmp != null && tmp is List) {
//               for (var item in tmp){
//                 if (item != null) {
//                   listInbound.add(item);
//                 }
//               }
//             }
//             // print("List inbound: $listInbound");
//           }
//         }
//       }
//
//       if (list.isNotEmpty) {
//         processFlightArrays();
//         if (timeoutTimer != null && timeoutTimer!.isActive) {
//           timeoutTimer!.cancel();
//         }
//       }
//
//       if (completedApiCalls >= 6) {
//         if (list.isNotEmpty) {
//           processFlightArrays();
//         }
//       }
//     }));
//
//
//     streamController4 = StreamController.broadcast();
//     streamController4.stream.listen((res) => setState((){
//       completedApiCalls++;
//       if (res != null) {
//         var temp = res["data"];
//         if (temp != null) {
//           var tmp = temp["outbound"];
//           if (tmp != null && tmp is List) {
//             for (var item in tmp){
//               if (item != null) {
//                 list.add(item);
//               }
//             }
//           } else {
//             print("QH - No outbound flights or invalid format");
//           }
//
//           if (!widget.flightInfoObject.isOneWayTrip) {
//             var tmp = temp["inbound"];
//             if (tmp != null && tmp is List) {
//               for (var item in tmp){
//                 if (item != null) {
//                   listInbound.add(item);
//                 }
//               }
//             }
//           }
//         }
//       }
//
//       if (list.isNotEmpty) {
//         processFlightArrays();
//         if (timeoutTimer != null && timeoutTimer!.isActive) {
//           timeoutTimer!.cancel();
//         }
//       }
//
//       if (completedApiCalls >= 6) {
//         if (list.isNotEmpty) {
//           processFlightArrays();
//         }
//       }
//     }));
//
//
//     streamController5 = StreamController.broadcast();
//     streamController5.stream.listen((res) => setState(() {
//       completedApiCalls++;
//       if (res != null) {
//         var temp = res["data"];
//         if (temp != null) {
//           var tmp = temp["outbound"];
//           if (tmp != null && tmp is List) {
//
//             for (var item in tmp){
//               if (item != null) {
//
//                 list.add(item);
//               }
//             }
//           } else {
//             print("VU - No outbound flights or invalid format");
//           }
//
//
//           if (!widget.flightInfoObject.isOneWayTrip) {
//             var tmp = temp["inbound"];
//             if (tmp != null && tmp is List) {
//               for (var item in tmp){
//                 if (item != null) {
//                   listInbound.add(item);
//                 }
//               }
//             }
//           }
//         }
//       }
//
//
//       if (list.isNotEmpty) {
//
//         processFlightArrays();
//         if (timeoutTimer != null && timeoutTimer!.isActive) {
//           timeoutTimer!.cancel();
//
//         }
//       }
//
//       if (completedApiCalls >= 6) {
//
//         if (list.isNotEmpty) {
//           processFlightArrays();
//         }
//       }
//     }));
//
//     streamController6 = StreamController.broadcast();
//     streamController6.stream.listen((res) => setState(() {
//       completedApiCalls++;
//       if (res != null) {
//         var temp = res["data"];
//         if (temp != null) {
//           var tmp = temp["outbound"];
//           if (tmp != null && tmp is List) {
//             for (var item in tmp){
//               if (item != null) {
//                 list.add(item);
//               }
//             }
//           } else {
//             print("9G - No outbound flights or invalid format");
//           }
//
//           if (widget.flightInfoObject.isRoundTrip) {
//             var tmp = temp["inbound"];
//             if (tmp != null && tmp is List) {
//               for (var item in tmp){
//                 if (item != null) {
//                   listInbound.add(item);
//                 }
//               }
//             }
//           }
//         }
//       }
//
//
//       if (list.isNotEmpty) {
//         processFlightArrays();
//         if (timeoutTimer != null && timeoutTimer!.isActive) {
//           timeoutTimer!.cancel();
//         }
//       }
//
//       if (completedApiCalls >= 6) {
//         if (list.isNotEmpty) {
//           processFlightArrays();
//         }
//       }
//     }));
//
//
//
//
//     widget.flightInfoObject.isOneWayTrip ? load(streamController1) : loadRoundTrip(streamController1);
//
//     Timer(Duration(seconds: 10), () {
//       if (list.isNotEmpty && completedApiCalls < 6) {
//
//         setState(() {
//           processFlightArrays();
//         });
//       }
//     });
//
//     // timeoutTimer = Timer(Duration(seconds: 15), () {
//     //   if (list.isEmpty) {
//     //     print("20s timeout reached, no flights found - showing no flights message");
//     //     _confirmDialog2(context, "Không có chuyến bay phù hợp. Vui lòng thử lại sau hoặc thay đổi thông tin tìm kiếm.");
//     //   }
//     // });
//     streamController1.stream.listen((res) {
//       if (mounted && list.isEmpty && completedApiCalls >= 6) {
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           _confirmDialog2(context, "Không có chuyến bay phù hợp. Vui lòng thử lại sau hoặc thay đổi thông tin tìm kiếm.");
//         });
//       }
//     });
//     streamController2.stream.listen((res) {
//       if (mounted && list.isEmpty && completedApiCalls >= 6) {
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           _confirmDialog2(context, "Không có chuyến bay phù hợp. Vui lòng thử lại sau hoặc thay đổi thông tin tìm kiếm.");
//         });
//       }
//     });
//     streamController3.stream.listen((res) {
//       if (mounted && list.isEmpty && completedApiCalls >= 6) {
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           _confirmDialog2(context, "Không có chuyến bay phù hợp. Vui lòng thử lại sau hoặc thay đổi thông tin tìm kiếm.");
//         });
//       }
//     });
//     streamController4.stream.listen((res) {
//       if (mounted && list.isEmpty && completedApiCalls >= 6) {
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           _confirmDialog2(context, "Không có chuyến bay phù hợp. Vui lòng thử lại sau hoặc thay đổi thông tin tìm kiếm.");
//         });
//       }
//     });
//     streamController5.stream.listen((res) {
//       if (mounted && list.isEmpty && completedApiCalls >= 6) {
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           _confirmDialog2(context, "Không có chuyến bay phù hợp. Vui lòng thử lại sau hoặc thay đổi thông tin tìm kiếm.");
//         });
//       }
//     });
//   }


class _SearchFlightListState extends State<SearchFlightList> {
  List list = [];
  List listInbound = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    currentChosenFlight = -1;
    _fetchFirebaseData();
  }

  Future<void> _fetchFirebaseData() async {
    FirebaseService service = FirebaseService();

    // Tìm vé chiều đi (depCode -> arvCode)
    List<FlightModel> data = await service.searchFlights(
        widget.flightInfoObject.depCode,
        widget.flightInfoObject.arvCode
    );

    if (!mounted) return;

    setState(() {
      list.clear(); prices.clear(); companies.clear();
      planeIds.clear(); typeSeats.clear(); timeDeparts.clear(); timeBacks.clear();

      if (data.isEmpty) {
        isLoading = false;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _confirmDialog2(context, "Không có chuyến bay chiều đi phù hợp. Vui lòng thử lại sau.");
        });
        return;
      }

      for (var flight in data) {
        list.add(flight);
        prices.add(flight.basePrice);
        companies.add(flight.providerCode);
        planeIds.add(flight.flightNo);
        typeSeats.add("Phổ thông");
        timeDeparts.add(flight.depTime);
        timeBacks.add("--:--");
      }

      // Sắp xếp vé theo giá tăng dần
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

  Future<DateTime?> _confirmDialog2(BuildContext context, String content) {
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
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) =>
                          BookTicketPage(widget.flightInfoObject),
                    ),
                  );
                },
                child: new Text("Quay lại"),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var tmpWidget = Column(
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
                "Chiều đi",
                style: new TextStyle(
                    color: Colors.grey[500],
                    fontFamily: "Roboto Medium",
                    fontSize: MediaQuery.of(context).size.width * 0.04),
              ),
              new Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Text(
                    departId ?? "",
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
                    destinationId ?? "",
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
                style: TextButton.styleFrom(
                  padding: EdgeInsets.all(0.0),
                ),
                onPressed: () {
                  if (dateBefore != null && dateBefore!.compareTo(today) >= 0) {
                    widget.flightInfoObject.dateDepart = dateBefore!;
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (context) =>
                        new SelectFlightPage(widget.flightInfoObject)));
                  }
                },
                child: new Column(
                  children: <Widget>[
                    new Column(
                      children: <Widget>[
                        new Text(
                          dateBefore != null && dateBefore!.weekday + 1 < 8
                              ? "Thứ ${dateBefore!.weekday + 1}"
                              : "Chủ nhật",
                          style: new TextStyle(
                              color: Colors.grey[700],
                              fontFamily: "Roboto Medium",
                              fontSize:
                              MediaQuery.of(context).size.width * 0.04),
                        ),
                        new Text(
                          dateBefore != null ? "${dateBefore!.day} tháng ${dateBefore!.month}" : "",
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
                style: TextButton.styleFrom(
                  padding: EdgeInsets.all(0.0),
                ),
                onPressed: () {
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) =>
                      new SelectFlightPage(widget.flightInfoObject)));
                },
                child: new Column(
                  children: <Widget>[
                    new Column(
                      children: <Widget>[
                        new Text(
                          widget.flightInfoObject.dateDepart.weekday + 1 < 8
                              ? "Thứ ${widget.flightInfoObject.dateDepart.weekday + 1}"
                              : "Chủ nhật",
                          style: new TextStyle(
                              color: Colors.black,
                              fontFamily: "Roboto Medium",
                              fontSize:
                              MediaQuery.of(context).size.width * 0.04),
                        ),
                        new Text(
                          "${widget.flightInfoObject.dateDepart.day} tháng ${widget.flightInfoObject.dateDepart.month}",
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
                style: TextButton.styleFrom(
                  padding: EdgeInsets.all(0.0),
                ),
                onPressed: () {
                  if (dateAfter != null) {
                    widget.flightInfoObject.dateDepart = dateAfter!;
                    if (widget.flightInfoObject.dateBack.compareTo(dateAfter!) < 0) {
                      widget.flightInfoObject.dateBack = dateAfter!;
                    }
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (context) =>
                        new SelectFlightPage(widget.flightInfoObject)));
                  }
                },
                child: new Column(
                  children: <Widget>[
                    new Column(
                      children: <Widget>[
                        new Text(
                          dateAfter != null && dateAfter!.weekday + 1 < 8
                              ? "Thứ ${dateAfter!.weekday + 1}"
                              : "Chủ nhật",
                          style: new TextStyle(
                              color: Colors.grey[700],
                              fontFamily: "Roboto Medium",
                              fontSize:
                              MediaQuery.of(context).size.width * 0.04),
                        ),
                        new Text(
                          dateAfter != null ? "${dateAfter!.day} tháng ${dateAfter!.month}" : "",
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
        list.isNotEmpty
            ? Expanded(
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              // print(list);
              if (index >= list.length) {
                return Container();
              }

              return new TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.0171),
                ),
                onPressed: () {
                  setState(() {
                    print("choose index: $index");
                    currentChosenFlight = index;
                    if (index < prices.length && index < list.length) {
                      total = (prices[index] * widget.flightInfoObject.noOfAdult +
                          (prices[index] - 100000) * widget.flightInfoObject.noOfChild +
                          150000 * widget.flightInfoObject.noOfInfant);
                    }
                  });
                },
                child: new Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.width * 0.206,
                  padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.0142),
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    border: new Border.all(
                        color: currentChosenFlight != index ? Colors.grey : Colors.red[700] ?? const Color.fromARGB(255, 213, 51, 39),
                        width: currentChosenFlight != index
                            ? MediaQuery.of(context).size.width * 0.00857
                            : MediaQuery.of(context).size.width * 0.015,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width * 0.0171),
                  ),
                  child: currentChosenFlight != index
                      ? new Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Image.asset(
                        "assets/${index < companies.length ? companies[index] : 'default'}.png",
                        width: MediaQuery.of(context).size.width * 0.13,
                        height: MediaQuery.of(context).size.width * 0.13,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.airplanemode_active,
                              size: MediaQuery.of(context).size.width * 0.13,
                              color: Colors.grey);
                        },
                      ),
                      new Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Text(
                            index < timeDeparts.length ? timeDeparts[index] : "--:--",
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
                            departId ?? "",
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
                            index < timeBacks.length ? timeBacks[index] : "--:--",
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
                            destinationId ?? "",
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
                            index < planeIds.length ? planeIds[index] : "",
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
                            index < typeSeats.length ? typeSeats[index] : "",
                            style: new TextStyle(
                                color: Colors.grey,
                                fontFamily: "Roboto Medium",
                                fontSize:
                                MediaQuery.of(context).size.width * 0.0314),
                          ),
                        ],
                      ),
                      new Text(
                        "${formatter.format(index < prices.length ? prices[index] : 0)} VND",
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
                              "assets/${index < companies.length ? companies[index] : 'default'}.png",
                              width: MediaQuery.of(context).size.width * 0.13,
                              height: MediaQuery.of(context).size.width * 0.13,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.airplanemode_active,
                                    size: MediaQuery.of(context).size.width * 0.13,
                                    color: Colors.grey);
                              },
                            ),
                            new Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                new Text(
                                  index < timeDeparts.length ? timeDeparts[index] : "--:--",
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
                                  departId ?? "",
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
                                  index < timeBacks.length ? timeBacks[index] : "--:--",
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
                                  destinationId ?? "",
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
                                  index < planeIds.length ? planeIds[index] : "",
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
                                  index < typeSeats.length ? typeSeats[index] : "",
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
                              "${formatter.format(index < prices.length ? prices[index] : 0)} VND",
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
              );
            },
          ),
        )
            : new Expanded(
          child: new Container(
            child: new Center(
              child: new CircularProgressIndicator(),
            ),
          ),
        ),
        new Expanded(
          flex: 0,
          child: currentChosenFlight > -1
              ? new TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.all(0.0),
            ),
            onPressed: () {
              if (currentChosenFlight < 0) {
                _confirmDialog(context,
                    "Chưa có thông tin của chuyến bay đi. Vui lòng kiểm tra lại.");
              } else {
                FlightInfoObject tmp = widget.flightInfoObject;
                tmp.company1 = currentChosenFlight < companies.length ? companies[currentChosenFlight] : "";
                tmp.typeSeat1 = currentChosenFlight < typeSeats.length ? typeSeats[currentChosenFlight] : "";
                tmp.planeId1 = currentChosenFlight < planeIds.length ? planeIds[currentChosenFlight] : "";
                tmp.priceDepart = currentChosenFlight < prices.length ? prices[currentChosenFlight] : 0;
                tmp.timeDepart1 = currentChosenFlight < timeDeparts.length ? timeDeparts[currentChosenFlight] : "";
                tmp.timeBack1 = currentChosenFlight < timeBacks.length ? timeBacks[currentChosenFlight] : "";
                tmp.adultDepartTax = 0;
                tmp.childDepartTax = 0;
                tmp.infantDepartTax = 0;


                tmp.totalPrice = total;
                if (tmp.timeBack1.contains("00:")) {
                  tmp.dateDepartBack =
                      tmp.dateDepart.add(Duration(days: 1));
                } else {
                  tmp.dateDepartBack = tmp.dateDepart;
                }
                print("company1: ${tmp.company1}");
                if (widget.flightInfoObject.isRoundTrip) {
                  tmp.inbound = listInbound;
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) => new SelectBackFlightPage(tmp)));
                } else {
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) => new FillCustomerInfoPage(tmp)));
                }
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
        )
        //Ket thuc show cac chuyen bay
      ],
    );
    return tmpWidget;
  }

  // load(StreamController sc) async {
  //   String? url1 = widget.flightInfoObject.storage["JetSearchLink"];
  //   String? url2 = widget.flightInfoObject.storage["VjaSearchLink"];
  //   String? url3 = widget.flightInfoObject.storage["VnaSearchLink"];
  //   String? url4 = widget.flightInfoObject.storage["NewApiLink"];
  //
  //
  //   if (url1 == null || url2 == null || url3 == null || url4 == null) {
  //     streamController1.add({"data": {"outbound": []}});
  //     streamController2.add({"data": {"outbound": []}});
  //     streamController3.add({"data": {"outbound": []}});
  //     streamController4.add({"data": {"outbound": []}});
  //     streamController5.add({"data": {"outbound": []}});
  //     streamController6.add({"data": {"outbound": []}});
  //     return;
  //   }
  //
  //   var client = new http.Client();
  //
  //   try {
  //     var res1 = await client.post(Uri.parse(url4), headers: {
  //       tmpF.storage["NewK"]!: widget.flightInfoObject.apiKey,
  //     }, body: {
  //       "dep_code": widget.flightInfoObject.depCode,
  //       "arv_code": widget.flightInfoObject.arvCode,
  //       "outbound_date": df.format(widget.flightInfoObject.dateDepart),
  //       "adt_count": widget.flightInfoObject.noOfAdult.toString(),
  //       "chd_count": widget.flightInfoObject.noOfChild.toString(),
  //       "inf_count": widget.flightInfoObject.noOfInfant.toString(),
  //       "provider_code": "BL",
  //     });
  //
  //     try {
  //
  //
  //       var decoded1 = jsonDecode(res1.body);
  //
  //
  //       if (decoded1["error"] == true) {
  //         streamController1.add({"data": {"outbound": []}});
  //       } else {
  //         if (decoded1["data"] != null && decoded1["data"]["outbound"] != null) {
  //         }
  //         streamController1.add(decoded1);
  //       }
  //     } catch (e) {
  //
  //       streamController1.add({"data": {"outbound": []}});
  //     }
  //   } catch (e) {
  //
  //     streamController1.add({"data": {"outbound": []}});
  //   }
  //
  //   try {
  //     var res2 = await client.post(Uri.parse(url4), headers: {
  //       tmpF.storage["NewK"]!: widget.flightInfoObject.apiKey,
  //     }, body: {
  //       "dep_code": widget.flightInfoObject.depCode,
  //       "arv_code": widget.flightInfoObject.arvCode,
  //       "outbound_date": df.format(widget.flightInfoObject.dateDepart),
  //       "adt_count": widget.flightInfoObject.noOfAdult.toString(),
  //       "chd_count": widget.flightInfoObject.noOfChild.toString(),
  //       "inf_count": widget.flightInfoObject.noOfInfant.toString(),
  //       "provider_code": "VJ",
  //     });
  //     try {
  //
  //
  //       var decoded2 = jsonDecode(res2.body);
  //
  //
  //       if (decoded2["error"] == true) {
  //
  //         streamController2.add({"data": {"outbound": []}});
  //       } else {
  //         if (decoded2["data"] != null && decoded2["data"]["outbound"] != null) {
  //         }
  //         streamController2.add(decoded2);
  //       }
  //     } catch (e) {
  //
  //       streamController2.add({"data": {"outbound": []}});
  //     }
  //   } catch (e) {
  //
  //     streamController2.add({"data": {"outbound": []}});
  //   }
  //
  //
  //   try {
  //     var res3 = await client.post(Uri.parse(url4), headers: {
  //       tmpF.storage["NewK"]!: widget.flightInfoObject.apiKey,
  //     }, body: {
  //       "dep_code": widget.flightInfoObject.depCode,
  //       "arv_code": widget.flightInfoObject.arvCode,
  //       "outbound_date": df.format(widget.flightInfoObject.dateDepart),
  //       "adt_count": widget.flightInfoObject.noOfAdult.toString(),
  //       "chd_count": widget.flightInfoObject.noOfChild.toString(),
  //       "inf_count": widget.flightInfoObject.noOfInfant.toString(),
  //       "provider_code": "VN",
  //     });
  //     try {
  //
  //
  //       var decoded3 = jsonDecode(res3.body);
  //
  //
  //       if (decoded3["error"] == true) {
  //
  //         streamController3.add({"data": {"outbound": []}});
  //       } else {
  //         if (decoded3["data"] != null && decoded3["data"]["outbound"] != null) {
  //         }
  //         streamController3.add(decoded3);
  //       }
  //     } catch (e) {
  //
  //       streamController3.add({"data": {"outbound": []}});
  //     }
  //   } catch (e) {
  //
  //     streamController3.add({"data": {"outbound": []}});
  //   }
  //
  //   try {
  //     var res4 = await client.post(Uri.parse(url4), headers: {
  //       tmpF.storage["NewK"]!: widget.flightInfoObject.apiKey,
  //     }, body: {
  //       "dep_code": widget.flightInfoObject.depCode,
  //       "arv_code": widget.flightInfoObject.arvCode,
  //       "outbound_date": df.format(widget.flightInfoObject.dateDepart),
  //       "adt_count": widget.flightInfoObject.noOfAdult.toString(),
  //       "chd_count": widget.flightInfoObject.noOfChild.toString(),
  //       "inf_count": widget.flightInfoObject.noOfInfant.toString(),
  //       "provider_code": "QH",
  //     });
  //     try {
  //
  //
  //
  //       var decoded4 = jsonDecode(res4.body);
  //
  //
  //       if (decoded4["error"] == true) {
  //
  //         streamController4.add({"data": {"outbound": []}});
  //       } else {
  //         if (decoded4["data"] != null && decoded4["data"]["outbound"] != null) {
  //         }
  //         streamController4.add(decoded4);
  //       }
  //     } catch (e) {
  //
  //
  //       streamController4.add({"data": {"outbound": []}});
  //     }
  //
  //   } catch (e) {
  //
  //     streamController4.add({"data": {"outbound": []}});
  //   }
  //
  //
  //
  //   try {
  //     var res5 = await client.post(Uri.parse(url4), headers: {
  //       tmpF.storage["NewK"]!: widget.flightInfoObject.apiKey,
  //     }, body: {
  //       "dep_code": widget.flightInfoObject.depCode,
  //       "arv_code": widget.flightInfoObject.arvCode,
  //       "outbound_date": df.format(widget.flightInfoObject.dateDepart),
  //       "adt_count": widget.flightInfoObject.noOfAdult.toString(),
  //       "chd_count": widget.flightInfoObject.noOfChild.toString(),
  //       "inf_count": widget.flightInfoObject.noOfInfant.toString(),
  //       "provider_code": "VU",
  //     });
  //     try {
  //
  //
  //       var decoded5 = jsonDecode(res5.body);
  //
  //
  //
  //       if (decoded5["error"] == true) {
  //
  //         streamController5.add({"data": {"outbound": []}});
  //       } else {
  //         if (decoded5["data"] != null && decoded5["data"]["outbound"] != null) {
  //         }
  //         streamController5.add(decoded5);
  //       }
  //     } catch (e) {
  //
  //       streamController5.add({"data": {"outbound": []}});
  //     }
  //
  //   } catch(e) {
  //     streamController5.add({"data": {"outbound": []}});
  //   }
  //
  //
  //   try {
  //     var res6 = await client.post(Uri.parse(url4), headers: {
  //       tmpF.storage["NewK"]!: widget.flightInfoObject.apiKey,
  //     }, body: {
  //       "dep_code": widget.flightInfoObject.depCode,
  //       "arv_code": widget.flightInfoObject.arvCode,
  //       "outbound_date": df.format(widget.flightInfoObject.dateDepart),
  //       "adt_count": widget.flightInfoObject.noOfAdult.toString(),
  //       "chd_count": widget.flightInfoObject.noOfChild.toString(),
  //       "inf_count": widget.flightInfoObject.noOfInfant.toString(),
  //       "provider_code": "9G",
  //     });
  //     try {
  //
  //       var decoded6 = jsonDecode(res6.body);
  //
  //       if (decoded6["error"] == true) {
  //         streamController6.add({"data": {"outbound": []}});
  //       } else {
  //         if (decoded6["data"] != null && decoded6["data"]["outbound"] != null) {
  //         }
  //         streamController6.add(decoded6);
  //       }
  //     } catch (e) {
  //       streamController6.add({"data": {"outbound": []}});
  //     }
  //
  //   } catch(e) {
  //     streamController6.add({"data": {"outbound": []}});
  //   }
  //
  // }
  //
  // loadRoundTrip(StreamController sc) async {
  //   String? url1 = widget.flightInfoObject.storage["JetSearchLink"];
  //   String? url2 = widget.flightInfoObject.storage["VjaSearchLink"];
  //   String? url3 = widget.flightInfoObject.storage["VnaSearchLink"];
  //   String? url4 = widget.flightInfoObject.storage["NewApiLink"];
  //
  //   if (url1 == null || url2 == null || url3 == null || url4 == null) {
  //
  //     streamController1.add({"data": {"outbound": [], "inbound": []}});
  //     streamController2.add({"data": {"outbound": [], "inbound": []}});
  //     streamController3.add({"data": {"outbound": [], "inbound": []}});
  //     streamController4.add({"data": {"outbound": [], "inbound": []}});
  //     streamController5.add({"data": {"outbound": [], "inbound": []}});
  //     streamController6.add({"data": {"outbound": [], "inbound": []}});
  //     return;
  //   }
  //
  //   var client = new http.Client();
  //
  //   try {
  //     var res1 = await client.post(Uri.parse(url4), headers: {
  //       tmpF.storage["NewK"]!: widget.flightInfoObject.apiKey,
  //     }, body: {
  //       "dep_code": widget.flightInfoObject.depCode,
  //       "arv_code": widget.flightInfoObject.arvCode,
  //       "outbound_date": df.format(widget.flightInfoObject.dateDepart),
  //       "inbound_date": df.format(widget.flightInfoObject.dateBack),
  //       "adt_count": widget.flightInfoObject.noOfAdult.toString(),
  //       "chd_count": widget.flightInfoObject.noOfChild.toString(),
  //       "inf_count": widget.flightInfoObject.noOfInfant.toString(),
  //       "provider_code": "BL",
  //     });
  //
  //     try {
  //       var decoded1 = jsonDecode(res1.body);
  //
  //       if (decoded1["error"] == true) {
  //         streamController1.add({"data": {"outbound": [], "inbound": []}});
  //       } else {
  //         streamController1.add(decoded1);
  //       }
  //     } catch (e) {
  //
  //       streamController1.add({"data": {"outbound": [], "inbound": []}});
  //     }
  //   } catch (e) {
  //     streamController1.add({"data": {"outbound": [], "inbound": []}});
  //   }
  //
  //   try {
  //     var res2 = await client.post(Uri.parse(url4), headers: {
  //       tmpF.storage["NewK"]!: widget.flightInfoObject.apiKey,
  //     }, body: {
  //       "dep_code": widget.flightInfoObject.depCode,
  //       "arv_code": widget.flightInfoObject.arvCode,
  //       "outbound_date": df.format(widget.flightInfoObject.dateDepart),
  //       "inbound_date": df.format(widget.flightInfoObject.dateBack),
  //       "adt_count": widget.flightInfoObject.noOfAdult.toString(),
  //       "chd_count": widget.flightInfoObject.noOfChild.toString(),
  //       "inf_count": widget.flightInfoObject.noOfInfant.toString(),
  //       "provider_code": "VJ",
  //     });
  //
  //     try {
  //       var decoded2 = jsonDecode(res2.body);
  //
  //       if (decoded2["error"] == true) {
  //         streamController2.add({"data": {"outbound": [], "inbound": []}});
  //       } else {
  //         streamController2.add(decoded2);
  //       }
  //     } catch (e) {
  //
  //       streamController2.add({"data": {"outbound": [], "inbound": []}});
  //     }
  //   } catch (e) {
  //     streamController2.add({"data": {"outbound": [], "inbound": []}});
  //   }
  //
  //   try {
  //     var res3 = await client.post(Uri.parse(url4), headers: {
  //       tmpF.storage["NewK"]!: widget.flightInfoObject.apiKey,
  //     }, body: {
  //       "dep_code": widget.flightInfoObject.depCode,
  //       "arv_code": widget.flightInfoObject.arvCode,
  //       "outbound_date": df.format(widget.flightInfoObject.dateDepart),
  //       "inbound_date": df.format(widget.flightInfoObject.dateBack),
  //       "adt_count": widget.flightInfoObject.noOfAdult.toString(),
  //       "chd_count": widget.flightInfoObject.noOfChild.toString(),
  //       "inf_count": widget.flightInfoObject.noOfInfant.toString(),
  //       "provider_code": "VN",
  //     });
  //
  //     try {
  //       var decoded3 = jsonDecode(res3.body);
  //
  //       if (decoded3["error"] == true) {
  //         streamController3.add({"data": {"outbound": [], "inbound": []}});
  //       } else {
  //         streamController3.add(decoded3);
  //       }
  //     } catch (e) {
  //
  //       streamController3.add({"data": {"outbound": [], "inbound": []}});
  //     }
  //   } catch (e) {
  //     streamController3.add({"data": {"outbound": [], "inbound": []}});
  //   }
  //
  //   try {
  //     var res4 = await client.post(Uri.parse(url4), headers: {
  //       tmpF.storage["NewK"]!: widget.flightInfoObject.apiKey,
  //     }, body: {
  //       "dep_code": widget.flightInfoObject.depCode,
  //       "arv_code": widget.flightInfoObject.arvCode,
  //       "outbound_date": df.format(widget.flightInfoObject.dateDepart),
  //       "inbound_date": df.format(widget.flightInfoObject.dateBack),
  //       "adt_count": widget.flightInfoObject.noOfAdult.toString(),
  //       "chd_count": widget.flightInfoObject.noOfChild.toString(),
  //       "inf_count": widget.flightInfoObject.noOfInfant.toString(),
  //       "provider_code": "QH",
  //     });
  //
  //     try {
  //       var decoded4 = jsonDecode(res4.body);
  //
  //       if (decoded4["error"] == true) {
  //         streamController4.add({"data": {"outbound": [], "inbound": []}});
  //       } else {
  //         streamController4.add(decoded4);
  //       }
  //     } catch (e) {
  //
  //       streamController4.add({"data": {"outbound": [], "inbound": []}});
  //     }
  //   } catch (e) {
  //     streamController4.add({"data": {"outbound": [], "inbound": []}});
  //   }
  //
  //   try {
  //     var res5 = await client.post(Uri.parse(url4), headers: {
  //       tmpF.storage["NewK"]!: widget.flightInfoObject.apiKey,
  //     }, body: {
  //       "dep_code": widget.flightInfoObject.depCode,
  //       "arv_code": widget.flightInfoObject.arvCode,
  //       "outbound_date": df.format(widget.flightInfoObject.dateDepart),
  //       "inbound_date": df.format(widget.flightInfoObject.dateBack),
  //       "adt_count": widget.flightInfoObject.noOfAdult.toString(),
  //       "chd_count": widget.flightInfoObject.noOfChild.toString(),
  //       "inf_count": widget.flightInfoObject.noOfInfant.toString(),
  //       "provider_code": "VU",
  //     });
  //
  //     try {
  //       var decoded5 = jsonDecode(res5.body);
  //
  //       if (decoded5["error"] == true) {
  //         streamController5.add({"data": {"outbound": [], "inbound": []}});
  //       } else {
  //         streamController5.add(decoded5);
  //       }
  //     } catch (e) {
  //
  //       streamController5.add({"data": {"outbound": [], "inbound": []}});
  //     }
  //   } catch (e) {
  //     streamController5.add({"data": {"outbound": [], "inbound": []}});
  //   }
  //
  //   try {
  //     var res6 = await client.post(Uri.parse(url4), headers: {
  //       tmpF.storage["NewK"]!: widget.flightInfoObject.apiKey,
  //     }, body: {
  //       "dep_code": widget.flightInfoObject.depCode,
  //       "arv_code": widget.flightInfoObject.arvCode,
  //       "outbound_date": df.format(widget.flightInfoObject.dateDepart),
  //       "inbound_date": df.format(widget.flightInfoObject.dateBack),
  //       "adt_count": widget.flightInfoObject.noOfAdult.toString(),
  //       "chd_count": widget.flightInfoObject.noOfChild.toString(),
  //       "inf_count": widget.flightInfoObject.noOfInfant.toString(),
  //       "provider_code": "9G",
  //     });
  //
  //     try {
  //       var decoded6 = jsonDecode(res6.body);
  //
  //       if (decoded6["error"] == true) {
  //         streamController6.add({"data": {"outbound": [], "inbound": []}});
  //       } else {
  //         streamController6.add(decoded6);
  //       }
  //     } catch (e) {
  //       streamController6.add({"data": {"outbound": [], "inbound": []}});
  //     }
  //   } catch (e) {
  //     streamController6.add({"data": {"outbound": [], "inbound": []}});
  //   }
  //
  // }
  //
  //
  // @override
  // void dispose() {
  //   if (timeoutTimer != null && timeoutTimer!.isActive) {
  //     timeoutTimer!.cancel();
  //   }
  //   streamController1.close();
  //   streamController2.close();
  //   streamController3.close();
  //   streamController4.close();
  //   streamController5.close();
  //   streamController6.close();
  //   super.dispose();
  // }
}
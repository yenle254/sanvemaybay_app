import 'package:flutter/material.dart';
import 'package:sanvemaybay_app_fixed/module/custom_app_bar.dart';
import 'package:sanvemaybay_app_fixed/customize_object/flight_info_object.dart';
import 'package:sanvemaybay_app_fixed/module/custom_drawer.dart';
import 'package:sanvemaybay_app_fixed/module/custom_horizontial_divider.dart';
import 'package:sanvemaybay_app_fixed/page/sale_ticket_in_month.dart';
import 'package:url_launcher/url_launcher.dart';

class SelectLocationPage extends StatelessWidget {
  final FlightInfoObject flightInfo;
  final String type;

  SelectLocationPage(this.flightInfo, this.type);

  @override
  Widget build(BuildContext context) {
    return new SelectLocationPageSupport(flightInfo, type);
  }
}

class SelectLocationPageSupport extends StatefulWidget {
  final FlightInfoObject flightInfo;
  final String type;

  SelectLocationPageSupport(this.flightInfo, this.type);

  @override
  _SelectLocationPageSupportState createState() =>
      _SelectLocationPageSupportState();
}

class _SelectLocationPageSupportState extends State<SelectLocationPageSupport> {
  List<String> southern = [];
  List<String> northern = [];
  List<String> middle = [];
  String searchValue = "";
  final TextEditingController controler = new TextEditingController();

  printAirport(List<String> list, BuildContext context) {
    List<Widget> returnList = [];
    for (var i = 0; i < list.length; i++) {
      if (list[i].toLowerCase().contains(searchValue.toLowerCase())) {
        returnList.add(
          new TextButton(
            child: new Container(
              decoration: new BoxDecoration(
                color: Colors.white,
              ),
              width: double.infinity,
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.width * 0.0171),
              child: new Text(
                list[i].substring(0, list[i].indexOf("-")),
                style: new TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                   
                  fontFamily: "Roboto Medium",
                ),
              ),
            ),
            onPressed: () {
              String pickedPlace = list[i].substring(0, list[i].indexOf(" ("));
              FlightInfoObject flightInfo = new FlightInfoObject(
                  isOneWayTrip: widget.flightInfo.isOneWayTrip,
                  isRoundTrip: widget.flightInfo.isRoundTrip,
                  noOfAdult: widget.flightInfo.noOfAdult,
                  noOfChild: widget.flightInfo.noOfChild,
                  noOfInfant: widget.flightInfo.noOfInfant);
              flightInfo.dateDepart = widget.flightInfo.dateDepart;
              flightInfo.dateBack = widget.flightInfo.dateBack;
              if (widget.type.contains("đi")) {
                flightInfo.depart = pickedPlace;
                flightInfo.destination = widget.flightInfo.destination;
              } else {
                flightInfo.destination = pickedPlace;
                flightInfo.depart = widget.flightInfo.depart;
              }
              Navigator.of(context).push(
                  new MaterialPageRoute(
                      builder: (context) => new SaleTicketInMonth(flightInfo)));
            },
          ),
        );
      }
    }
    return new Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: returnList,
    );
  }

  isContain(List<String> list) {
    for (var i = 0; i < list.length; i++) {
      if (list[i].toLowerCase().contains(searchValue.toLowerCase())) return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();

    southern.add("Hồ Chí Minh (SGN) - Ho Chi Minh");
    southern.add("Hà Nội (HAN) - ha noi");
    southern.add("Đà Nẵng (DAD) - da nang");
    southern.add("Nha Trang (CXR) - nha trang");
    southern.add("Vinh (VII) - vinh");
    southern.add("Hải Phòng (HPH) - hai phong");
    southern.add("Phú Quốc (PQC) - Phu Quoc");
    southern.add("Đồng Hới (VDH) - dong hoi");
    southern.add("Đà Lạt (DLI) - da lat");
    southern.add("Côn Đảo (VCS) - Con Dao");
    southern.add("Chu Lai (VCL) - chu lai");
    southern.add("Pleiku (PXU) - pleiku");
    southern.add("Cần Thơ (VCA) - Can Tho");
    southern.add("Cà Mau (CAH) - Ca Mau");
    southern.add("Huế (HUI) - hue");
    southern.add("Quy Nhơn (UIH) - quy nhon");
    southern.add("Rạch Giá (VKG) - Rach Gia");
    southern.add("Thanh Hóa (THD) - thanh hoa");
    southern.add("Tuy Hòa (TBB) - tuy hoa");
    southern.add("Ban Mê Thuột (BMV) - ban me thuot");
    southern.add("Điện Biên (DIN) - dien bien");
    southern.add("Vân Đồn (VDO) - van don");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: CustomAppBar(
          widget.type.contains("đi") ? "CHỌN NƠI ĐI" : "CHỌN NƠI ĐẾN",
          false,
          85.0,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.0171),
            child: InkResponse(
              child: Icon(
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
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.05),
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.02),
                  child: Icon(Icons.search, color: Colors.grey[500]),
                ),
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.width * 0.09,
                    color: Colors.white,
                    child: TextField(
                      controller: controler,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        // helperText: southern.any((item) => item
                        //         .toLowerCase()
                        //         .contains(searchValue.toLowerCase()))
                        //     ? null
                        //     : "Không có địa điểm phù hợp",
                        helperStyle: TextStyle(
                          fontFamily: "Roboto Medium",
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                        ),
                        border: InputBorder.none,
                        hintText: "Nhập tên thành phố hoặc mã sân bay",
                        hintStyle: TextStyle(
                          color: Colors.grey[500],
                          fontFamily: "Roboto Medium",
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Roboto Medium",
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                      ),
                      onChanged: (String str) {
                        setState(() {
                          searchValue = str;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.0171,
            ),
            if (isContain(southern)) ...[
              CustomHorizontialDivider(
                MediaQuery.of(context).size.width,
                0.0,
              ),
              printAirport(southern, context),
            ],
          ],
        ),
      ),
    );
  }
}

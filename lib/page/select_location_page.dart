import 'package:flutter/material.dart';
import 'package:sanvemaybay_app_fixed/module/custom_app_bar.dart';
import 'package:sanvemaybay_app_fixed/customize_object/flight_info_object.dart';
import 'package:sanvemaybay_app_fixed/module/custom_drawer.dart';
import 'package:sanvemaybay_app_fixed/module/custom_horizontial_divider.dart';
import 'package:sanvemaybay_app_fixed/page/book_ticket_page.dart';
import 'package:url_launcher/url_launcher.dart';

class SelectLocationPage extends StatelessWidget {
  final FlightInfoObject flightInfo;
  final String type;

  const SelectLocationPage(this.flightInfo, this.type, {super.key});

  @override
  Widget build(BuildContext context) {
    return SelectLocationPageSupport(flightInfo, type);
  }
}

class SelectLocationPageSupport extends StatefulWidget {
  final FlightInfoObject flightInfo;
  final String type;

  const SelectLocationPageSupport(this.flightInfo, this.type, {super.key});

  @override
  _SelectLocationPageSupportState createState() =>
      _SelectLocationPageSupportState();
}

class _SelectLocationPageSupportState extends State<SelectLocationPageSupport> {
  List<String> southern = [];
  String? searchValue = "";
  final TextEditingController controller = TextEditingController();

  Widget printAirport(List<String> list, BuildContext context) {
    List<Widget> returnList = [];
    for (var i = 0; i < list.length; i++) {
      if (searchValue == null ||
          searchValue!.isEmpty ||
          list[i].toLowerCase().contains(searchValue!.toLowerCase())) {
        returnList.add(
          TextButton(
            child: Container(
              decoration: const BoxDecoration(color: Colors.white),
              width: double.infinity,
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.width * 0.0171),
              child: Text(
                list[i].substring(0, list[i].indexOf("-")),
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                  fontFamily: "Roboto Medium",
                ),
              ),
            ),
            onPressed: () {
              String pickedPlace = list[i].substring(0, list[i].indexOf(" ("));
              FlightInfoObject flightInfo = FlightInfoObject(
                isOneWayTrip: widget.flightInfo.isOneWayTrip,
                isRoundTrip: widget.flightInfo.isRoundTrip,
                noOfAdult: widget.flightInfo.noOfAdult,
                noOfChild: widget.flightInfo.noOfChild,
                noOfInfant: widget.flightInfo.noOfInfant,
              );
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
                MaterialPageRoute(
                  builder: (context) => BookTicketPage(flightInfo),
                ),
              );
            },
          ),
        );
      }
    }
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: returnList,
    );
  }

  bool isContain(List<String> list) {
    if (searchValue == null || searchValue!.isEmpty) return true;
    for (var i = 0; i < list.length; i++) {
      if (list[i].toLowerCase().contains(searchValue!.toLowerCase())) {
        return true;
      }
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    southern = [
      "Hồ Chí Minh (SGN) - Ho Chi Minh",
      "Hà Nội (HAN) - ha noi",
      "Đà Nẵng (DAD) - da nang",
      "Nha Trang (CXR) - nha trang",
      "Vinh (VII) - vinh",
      "Hải Phòng (HPH) - hai phong",
      "Phú Quốc (PQC) - Phu Quoc",
      "Đồng Hới (VDH) - dong hoi",
      "Đà Lạt (DLI) - da lat",
      "Côn Đảo (VCS) - Con Dao",
      "Chu Lai (VCL) - chu lai",
      "Pleiku (PXU) - pleiku",
      "Cần Thơ (VCA) - Can Tho",
      "Cà Mau (CAH) - Ca Mau",
      "Huế (HUI) - hue",
      "Quy Nhơn (UIH) - quy nhon",
      "Rạch Giá (VKG) - Rach Gia",
      "Thanh Hóa (THD) - thanh hoa",
      "Tuy Hòa (TBB) - tuy hoa",
      "Ban Mê Thuột (BMV) - ban me thuot",
      "Điện Biên (DIN) - dien bien",
      "Vân Đồn (VDO) - van don",
    ];
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
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.05),
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.02),
                  child: Icon(Icons.search, color: Colors.grey[500]),
                ),
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.width * 0.09,
                    color: Colors.white,
                    child: TextField(
                      controller: controller,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        helperText: southern.any((item) => item
                                .toLowerCase()
                                .contains(searchValue!.toLowerCase()))
                            ? null
                            : null,
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

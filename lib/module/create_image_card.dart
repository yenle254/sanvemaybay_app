import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sanvemaybay_app_fixed/customize_object/adult.dart';
import 'package:sanvemaybay_app_fixed/customize_object/child.dart';
import 'package:sanvemaybay_app_fixed/customize_object/flight_info_object.dart';
import 'package:sanvemaybay_app_fixed/page/select_flight_page.dart';
import 'package:sanvemaybay_app_fixed/page/select_date_sale_page.dart';

DateFormat df = new DateFormat("dd/MM/yyyy");

createCard(String image, String place1, String place2, BuildContext context,
    String price, FlightInfoObject flighObj, String promoType) {
  String place = "$place1 - $place2";
  return Padding(
    padding: const EdgeInsets.only(right: 8.0, left: 8.0, top: 8.0),
    child: new Card(
      elevation: 10.0,
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    clipBehavior: Clip.antiAlias,
      child: new Stack(
        alignment: AlignmentDirectional.topStart,
        children: <Widget>[
          new Image.network(
            image,
            width: double.infinity,
            height: MediaQuery.of(context).size.width * 0.714,
            fit: BoxFit.cover,
          ),
          new SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.width * 0.2,
            child: new Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 1.0),
                    Colors.black.withValues(alpha: 0.9),
                    Colors.black.withValues(alpha: 0.8),
                    Colors.black.withValues(alpha: 0.6),
                    Colors.black.withValues(alpha: 0.5),
                    Colors.black.withValues(alpha: 0.3),
                    Colors.black.withValues(alpha: 0.1),
                    Colors.black.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          new Positioned(
            bottom: MediaQuery.of(context).size.width*0.0,
            child: new Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 1.0),
                    Colors.black.withValues(alpha: 0.9),
                    Colors.black.withValues(alpha: 0.8),
                    Colors.black.withValues(alpha: 0.6),
                    Colors.black.withValues(alpha: 0.5),
                    Colors.black.withValues(alpha: 0.3),
                    Colors.black.withValues(alpha: 0.1),
                    Colors.black.withValues(alpha: 0.0),
                  ],
                ),
              ),
              child: new Text(
                "",
                style: new TextStyle(
                  height: 5.0,
                ),
              ),
            ),
          ),
          new Positioned(
            bottom: MediaQuery.of(context).size.width * 0.634,
            left: MediaQuery.of(context).size.width * 0.0429,
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text(
                  place,
                  style: new TextStyle(
                    fontFamily: "Roboto Medium",
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width * 0.038,
                  ),
                ),
              ],
            ),
          ),
          //Depart Date
          new Positioned(
            width: MediaQuery.of(context).size.width * 0.3,
            bottom: MediaQuery.of(context).size.width * 0.634,
            right: MediaQuery.of(context).size.width * 0.0429,
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                new Icon(
                  Icons.date_range,
                  size: MediaQuery.of(context).size.width * 0.042,
                  color: Colors.white,
                ),
                new Text(
                  promoType.contains("flights") ? df.format(flighObj.dateDepart) : "Tháng ${flighObj.dateDepart.month}",
                  style: new TextStyle(
                    fontFamily: "Roboto Medium",
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width * 0.038,
                  ),
                ),
              ],
            ),
          ),
          new Positioned(
            bottom: MediaQuery.of(context).size.width * 0.0571,
            left: MediaQuery.of(context).size.width * 0.0429,
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text(
                  "$price VND",
                  style: new TextStyle(
                    fontFamily: "Roboto Medium",
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width * 0.038,
                  ),
                ),
              ],
            ),
          ),
          new Positioned(
            bottom: MediaQuery.of(context).size.width * 0.0343,
            //left: MediaQuery.of(context).size.width*0.7,
            // left: MediaQuery.of(context).size.width * 0.63,
            right: MediaQuery.of(context).size.width * 0.0429,
            child: new ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
              ),
              onPressed: () {
                for (int i = 0; i < flighObj.noOfAdult; i++) {
                  flighObj.listAdults.add(new Adult());
                }
                for (int i = 0; i < flighObj.noOfChild; i++) {
                  flighObj.listChildren.add(new Child());
                }
                for (int i = 0; i < flighObj.noOfInfant; i++) {
                  flighObj.listInfants.add(new Child());
                }
                Navigator.of(context).push(new MaterialPageRoute(
                  builder: (context) {
                  print("depCode: ${flighObj.depCode}");
                  print("arvCode: ${flighObj.arvCode}");
                  if (promoType.contains("cheap")) {
                    return new SelectDateSalePage(flighObj);
                  } else {
                    return new SelectFlightPage(flighObj);
                  }
                }
                ));
              },
              child: new Text(
                "ĐẶT NGAY",
                style: new TextStyle(
                  fontFamily: "Roboto Medium",
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.width * 0.0343,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

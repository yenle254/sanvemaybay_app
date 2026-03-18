import 'package:flutter/material.dart';
import 'package:sanvemaybay_app_fixed/customize_object/date_object.dart';
import 'package:sanvemaybay_app_fixed/customize_object/flight_info_object.dart';
import 'package:intl/intl.dart';

NumberFormat f = NumberFormat("###,###");


class SaleCalender extends StatelessWidget {
  final int month;
  final int year;
  final FlightInfoObject flightInfo;

  SaleCalender(this.month, this.year, this.flightInfo);

  @override
  Widget build(BuildContext context) {
    return SaleCalendarSupport(month, year, flightInfo);
  }
}

class SaleCalendarSupport extends StatefulWidget {
  final int month;
  final int year;
  final FlightInfoObject flightInfo;

  SaleCalendarSupport(this.month, this.year, this.flightInfo);
  @override
  _SaleCalendarSupportState createState() => _SaleCalendarSupportState();
}

class _SaleCalendarSupportState extends State<SaleCalendarSupport> {
  List<DateObject> listDate = <DateObject>[];
  late DateTime firstDate;
  late DateTime endDate;
  DateTime today = new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  int currentSelectedDate = -1;
  late FlightInfoObject tmpFlighInfoObject;

  @override
  void initState() {
    super.initState();
    tmpFlighInfoObject = widget.flightInfo;
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
    if (7 - firstDate.weekday > 0) {
      for (int i = firstDate.weekday; i > 0; i--) {
        DateObject tmp = new DateObject();
        tmp.date = firstDate.subtract(Duration(days: i));
        listDate.add(tmp);
      }
    }
    for (var i = 1; i <= max; i++) {
      DateObject tmp = new DateObject();
      tmp.date = DateTime(widget.year, widget.month, i);
      listDate.add(tmp);
    }
    if (6 - endDate.weekday > 0) {
      for (var i = 1; i <= 6 - endDate.weekday; i++) {
        DateObject tmp = new DateObject();
        tmp.date = endDate.add(Duration(days: i));
        listDate.add(tmp);
      }
    }
    print(
        "startDate: thứ ${firstDate.weekday}, ${firstDate.day}/${firstDate.month}/${firstDate.year}");
    print(
        "endDate: thứ ${endDate.weekday}, ${endDate.day}/${endDate.month}/${endDate.year}");
    for (var i = 0; i < listDate.length; i++) {
      if (listDate[i].date.compareTo(today) == 0) {
        currentSelectedDate = i;
      }
      print("$i. ${listDate[i].date.toString()}");
    }
  }

  List<Row> buildCalendar() {
    List<Row> list = <Row>[];
    List<Widget> elementBoxes = <Widget>[];
    for (int i = 0; i < listDate.length; i++) {
      if ((i + 1) % 7 == 1) {
        list.add(new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: elementBoxes,
        ));
        elementBoxes = <Widget>[];
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
                  child: listDate[i].date.compareTo(today) >= 0 ? new CircleAvatar(
                      backgroundColor: i == currentSelectedDate
                          ? Colors.orangeAccent
                          : Colors.white,
                      radius: MediaQuery.of(context).size.width * 0.065,
                      child: new InkResponse(
                        onTap: () {
                          setState(() {
                            currentSelectedDate = i;
                            tmpFlighInfoObject.dateDepart = listDate[i].date;
                            print("Ngày đi được chọn: ${tmpFlighInfoObject.dateDepart.toString()}");
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Text(
                              "${listDate[i].date.day}",
                              style: new TextStyle(
                                color: i == currentSelectedDate ? Colors.black : Colors.blueAccent[700],
                                fontWeight: i == currentSelectedDate ? FontWeight.bold : FontWeight.normal,
                                fontFamily: "Roboto Medium",
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.035,
                              ),
                            ),
                            new Padding(padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.005),),
                            new Text(
                              "${f.format(listDate[i].priceDepart)}K",
                              style: new TextStyle(
                                color: i == currentSelectedDate ? Colors.white : Colors.amber,
                                fontWeight: i == currentSelectedDate ? FontWeight.bold : FontWeight.normal,
                                fontFamily: "Roboto Medium",
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.03,
                              ),
                            ),
                          ],
                        ),
                      )): Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Text(
                                "${listDate[i].date.day}",
                                style: new TextStyle(
                                  color: Colors.blueGrey[600],
                                  fontFamily: "Roboto Medium",
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.035,
                                ),
                              ),
                              new Padding(padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.005),),
                              new Text(
                                "${f.format(listDate[i].priceDepart)}K",
                                style: new TextStyle(
                                  color: Colors.grey[300],
                                  fontWeight: FontWeight.bold,
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: buildCalendar(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sanvemaybay_app_fixed/page/select_location_sale_page.dart';
import 'package:sanvemaybay_app_fixed/customize_object/flight_info_object.dart';

class SelectItemSale extends StatelessWidget {
  final BuildContext orginalContext;
  final String type;
  final FlightInfoObject flighInfo;
  final Icon customeIcon;

  SelectItemSale(this.type, this.flighInfo, this.customeIcon, this.orginalContext);


  @override
  Widget build(BuildContext context) {
    return SelectLocationItemSupport(type, flighInfo, customeIcon, orginalContext);
  }
}

class SelectLocationItemSupport extends StatefulWidget {
  final String type;
  final FlightInfoObject flighInfo;
  final Icon customeIcon;
  final BuildContext orginalContext;

  SelectLocationItemSupport(this.type, this.flighInfo, this.customeIcon,  this.orginalContext);

  @override
  _SelectLocationItemSupportState createState() =>
      _SelectLocationItemSupportState();
}

class _SelectLocationItemSupportState extends State<SelectLocationItemSupport> {

  @override
  Widget build(BuildContext  context) {
    return new Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Text(
          widget.type,
          style: new TextStyle(
            fontFamily: "Roboto Medium",
            fontSize: MediaQuery.of(context).size.width*0.04,
          ),
        ),
        new Padding(padding: new EdgeInsets.only(top: MediaQuery.of(context).size.width*0.0229)),
        new Container(
          width: MediaQuery.of(context).size.width*0.42,
          height: MediaQuery.of(context).size.width*0.1,
          padding: new EdgeInsets.all(MediaQuery.of(context).size.width * 0.0171),
          decoration: new BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.all(Radius.circular(6.0)),
            boxShadow: [
              new BoxShadow(color: Colors.black, blurRadius: 2.0),
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
                  Navigator.of(widget.orginalContext).push( new MaterialPageRoute(
                    builder: (orginalContext) => new SelectLocationPage(widget.flighInfo, widget.type)
                  ));
                },
                child: new Container(
                  width: MediaQuery.of(context).size.width*0.25,
                  child: new Text(
                    widget.type.contains("đi") ? widget.flighInfo.depart : widget.flighInfo.destination,
                    style: new TextStyle(
                      fontFamily: "Roboto Medium",
                      fontSize: MediaQuery.of(context).size.width*0.035,
                       
                    ),
                  ),
                ),
              ),
              new IconButton(
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.07),
                onPressed: () {
                  print("Ngày đi: ${widget.flighInfo.dateDepart.toString()}");
                  print("Ngày về: ${widget.flighInfo.dateBack.toString()}");
                  Navigator.of(widget.orginalContext).push( new MaterialPageRoute(
                    builder: (orginalContext) => new SelectLocationPage(widget.flighInfo, widget.type)
                  ));
                },
                icon: widget.customeIcon,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

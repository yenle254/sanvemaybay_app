import 'package:sanvemaybay_app_fixed/module/item_in_drawer.dart';
import 'package:flutter/material.dart';
import 'package:sanvemaybay_app_fixed/page/business_rule_page.dart';
import 'package:sanvemaybay_app_fixed/page/booking_history_page.dart';
class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomDrawerSupport();
  }
}

class CustomDrawerSupport extends StatefulWidget {
  @override
  _CustomDrawerSupportState createState() => _CustomDrawerSupportState();
}

class _CustomDrawerSupportState extends State<CustomDrawerSupport> {

  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: Container(
        color: Colors.black,
        child: SafeArea(
          child: new Container(
            decoration: new BoxDecoration(
              color: Colors.black,
            ),
            child: new Column(
              children: <Widget>[
                // new Padding(
                //   padding: EdgeInsets.only(
                //       top: MediaQuery.of(context).size.width * 0.06),
                // ),
                //Trang Chủ
                new ItemInDrawer(
                    "Trang chủ",
                    new Icon(
                      Icons.home,
                      size: MediaQuery.of(context).size.width * 0.06,
                      color: Colors.white,
                    ),
                    "home_page"),
          
                //Đặt vé máy bay
                new ItemInDrawer(
                    "Đặt vé máy bay",
                    new Icon(
                      Icons.airplanemode_active,
                      size: MediaQuery.of(context).size.width * 0.06,
                      color: Colors.white,
                    ),
                    "book_ticket_page"),

                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                  leading: Icon(
                    Icons.receipt_long,
                    size: MediaQuery.of(context).size.width * 0.06,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Vé của tôi",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Roboto Medium",
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop(); // Đóng menu
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => BookingHistoryPage(),
                    ));
                  },
                ),
          
                //Vé rẻ trong tháng
                new ItemInDrawer(
                    "Vé rẻ trong tháng",
                    new Icon(
                      Icons.date_range,
                      size: MediaQuery.of(context).size.width * 0.06,
                      color: Colors.white,
                    ),
                    "sale_ticket_in_month"),
          
                //Tin tuc
                new ItemInDrawer(
                    "Tin tức",
                    new Icon(
                      Icons.new_releases,
                      size: MediaQuery.of(context).size.width * 0.06,
                      color: Colors.white,
                    ),
                    "announce"),
          
                //Khuyến mãi
                new ItemInDrawer(
                    "Khuyến mãi",
                    new Icon(
                      Icons.stars,
                      size: MediaQuery.of(context).size.width * 0.06,
                      color: Colors.white,
                    ),
                    "sale_news"),
          
          
                //Hướng dẫn thanh toán
                new ItemInDrawer(
                    "Hướng dẫn thanh toán",
                    new Icon(
                      Icons.payment,
                      size: MediaQuery.of(context).size.width * 0.06,
                      color: Colors.white,
                    ),
                    "payment_page"),
          
                //Liên hệ
                new ItemInDrawer(
                    "Liên hệ",
                    new Icon(
                      Icons.bookmark,
                      size: MediaQuery.of(context).size.width * 0.06,
                      color: Colors.white,
                    ),
                    "contact_page"),
                    
                // Zalo
                new ItemInDrawer(
                  "Chat Zalo",
                  new Icon(
                    Icons.chat_bubble,
                    size: MediaQuery.of(context).size.width * 0.06,
                    color: Colors.white,
                  ),
                  "chat_zalo"),
          
                new Expanded(
                  flex: 1,
                  child: new Container(
                    child: Column(
                      verticalDirection: VerticalDirection.up,
                      children: <Widget>[
                        new Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.width * 0.0857),
                        ),
                        InkResponse(
                          onTap: () {
                            // Navigator.push(
                            //     context,
                            //     new MaterialPageRoute(
                            //         builder: (context) => new BusinessRulePage()));
                            Navigator.of(context).push(
                              new MaterialPageRoute(
                                builder: (context) => new BusinessRulePage()
                              )
                            );
                          },
                          
                          child: Column(
                            children: <Widget>[
                              new Text(
                                "Điều khoản sử dụng",
                                style: new TextStyle(
                                  decorationColor: Colors.white,
                                  decorationStyle: TextDecorationStyle.solid,
                                  decoration: TextDecoration.underline,
                                  color: Colors.white,
                                  fontFamily: "Roboto Medium",
                                  fontSize: MediaQuery.of(context).size.width * 0.0343,
                                ),
                              ),
                              new Text(
                                "version 1.3",
                                style: new TextStyle(
                                  height: 1.2,
                                  decorationColor: Colors.white,
                                  decorationStyle: TextDecorationStyle.solid,
                                  color: Colors.white,
                                  fontFamily: "Roboto Medium",
                                  fontSize: MediaQuery.of(context).size.width * 0.03,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

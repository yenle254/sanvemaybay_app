import 'dart:core';

class Adult {
  String gender = "Ông";
  String fullname = "";
  int departPackage = 0;
  int backPackage = 0;
  String phone = "";
  String email = "";
  String address = "";
  String city = "";
  bool isFilled = false;
  bool isVNDep = false;
  bool isVNBack = false;

  String day = "01";
  String month = "01";
  String year = "${DateTime.now().year - 18}";

  String cccd_passport = "";

  int departBagSellAmt = 0;
  int backBagSellAmt = 0;
  int departBagBuyAmt = 0;
  int backBagBuyAmt = 0;

  Adult({
    String gender = "Ông",
    String fullname = "",
    int departPackage = 0,
    int backPackage = 0,
    String phone = "",
    String email = "",
    String address = "",
    String city = "",
  }) {
    this.gender = gender;
    this.fullname = fullname;
    this.departPackage = departPackage;
    this.backPackage = backPackage;
    this.phone = phone;
    this.email = email;
    this.address = address;
    this.city = city;
  }

  bool isValidDoB() {
    try {
      int d = int.parse(day);
      int m = int.parse(month);
      int y = int.parse(year);
      DateTime dob = DateTime(y, m, d);
      DateTime now = DateTime.now();
      int age = now.year - dob.year;
      if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
        age--;
      }
      return age >= 12;
    } catch (e) {
      return false;
    }
  }

  bool isValidEmail(){
    RegExp exp = new RegExp(r"(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)");
    return exp.hasMatch(email);
  }

  bool isValidPhone(){
    RegExp exp = new RegExp(r"(^[0]{1}[1-9]{1}[0-9]{8}$)");
    return exp.hasMatch(phone);
  }

  bool isFullOFInfo(){
    bool check = true;
    if ((fullname.trim().length == 0) || (phone.trim().length == 0)) check = false;
    return check;
  }

  void checkFilled() {
    isFilled = fullname.isNotEmpty && 
               cccd_passport.isNotEmpty && 
               day.isNotEmpty &&
               month.isNotEmpty &&
               year.isNotEmpty &&
               isValidDoB();
  }
}
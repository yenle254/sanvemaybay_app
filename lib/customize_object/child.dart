class Child {
  String gender = "Trai";
  String fullname ="";
  String day = "01";
  String month = "01";
  int departPackage = 0;
  int backPackage = 0;
  String year = "${DateTime.now().year}";
  bool isFilled = false;
  bool isVNDep = false;
  bool isVNBack = false;

  int departBagSellAmt = 0;
  int backBagSellAmt = 0;
  int departBagBuyAmt = 0;
  int backBagBuyAmt = 0;


  Child();

  bool isValidDoB(){
    bool result = true;
    int presentMonth = DateTime.now().month;
    int presentDay = DateTime.now().day;
    int presentYear = DateTime.now().year;
    if (int.parse(year) == presentYear){
      if (int.parse(month) > presentMonth) {
        result = false;
      } else {
        if (int.parse(day) > presentDay) {
          result = false;
        }
      }
    }
    return result;
  }
}
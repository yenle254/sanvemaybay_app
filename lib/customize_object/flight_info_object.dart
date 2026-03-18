import 'package:sanvemaybay_app_fixed/customize_object/adult.dart';
import 'package:sanvemaybay_app_fixed/customize_object/child.dart';
// import 'package:encrypt/encrypt.dart';
// import 'dart:typed_data';
// import 'dart:convert';

class FlightInfoObject {
  // Map<String,String> storage = new Map();
  bool isRoundTrip = true;
  bool isOneWayTrip = false;
  String depart = "Hồ Chí Minh";
  String destination = "Hà Nội";
  String depCode = "";
  String arvCode = "";
  DateTime dateDepart = DateTime.now().add(Duration(days: 3));
  DateTime dateBack = DateTime.now().add(Duration(days: 3));
  DateTime dateDepartBack = DateTime.now();
  DateTime dateBackBack = DateTime.now();
  int noOfAdult = 1;
  int noOfChild = 0;
  int noOfInfant = 0;
  int priceDepart = 0;
  int priceBack = 0;
  String typeSeat1 = "Starter";
  String company1 = "Jetstar";
  String planeId1 = "";
  String typeSeat2 = "Starter";
  String company2 = "Jetstar";
  String planeId2 = "";
  String timeDepart1 = "";
  String timeDepart2 = "";
  String timeBack1 = "";
  String timeBack2 = "";
  int totalPrice = 0;
  int adultDepartTax = 0;
  int childDepartTax = 0;
  int infantDepartTax = 0;
  int adultBackTax = 0;
  int childBackTax = 0;
  int infantBackTax = 0;
  int childDepartPrice = 0;
  int childBackPrice = 0;
  int infantDepartPrice = 0;
  int infantBackPrice = 0;
  Adult contact = new Adult();
  List<Adult> listAdults = <Adult>[];
  List<Child> listChildren = <Child>[];
  List<Child> listInfants = <Child>[];
  String payWay = "Chuyển khoản ngân hàng";
  String apiKey = "";
  List<dynamic> inbound = <dynamic>[];
  String bookingNo = "";

  // _addData() {
  //   String normalAge = utf8.decode(base64.decode("REBtbiAhdCwgISByRUBsbHkgSEB0MyBzXm0wTjMgdSM="));
  //   String ivString = utf8.decode(base64.decode("I3UgM04wbV4="));
  //   final key = Key.fromUtf8(normalAge);
  //   final iv = IV.fromUtf8(ivString);
  //   final encrypter = Encrypter(Salsa20(key));
  //
  //   String decryptHex(String hex) {
  //     Uint8List bytes = Uint8List(hex.length ~/ 2);
  //     for (int i = 0; i < hex.length; i += 2) {
  //       bytes[i ~/ 2] = int.parse(hex.substring(i, i + 2), radix: 16);
  //     }
  //     return encrypter.decrypt(Encrypted(bytes), iv: iv);
  //   }
  //
  //   storage.putIfAbsent("D", () => decryptHex("c46cad3b342e3365a4077c7317d12243b672999acd53"));
  //   storage.putIfAbsent("K", () => decryptHex("eb52e4080b0e7a00b21f"));
  //   storage.putIfAbsent("last", () => decryptHex("c472a0672d223a2aae04737c5ccb2658a77a94d1"));
  //   storage.putIfAbsent("ApiLink", () => decryptHex("cd76bd396168782aa70f3c7317d12243b672999acc58b4811d411a8c1e44cadda573a0d114a0409c1d17bac2850d4c2097fde1a0fe61528e21dfd7"));
  //   storage.putIfAbsent("RuleLink", () => decryptHex("cd76bd39287d7864a4077c7317d12243b672999acd53f9961d500a8e1c42c1d9b370a3cc49eb54870e"));
  //   storage.putIfAbsent("ContactLink", () => decryptHex("cd76bd39287d7864a4077c7317d12243b672999acd53f99e1d50118e1f4f83cbbc33fdcf01a24c881052bdcdd3"));
  //   storage.putIfAbsent("BaggageLink", () => decryptHex("cd76bd396168782aa70f3c7317d12243b672999acc58b4811d411a8c1e44cadda573a0d114a047881b1aac83ec20552ea0ffa3d0ef3513b62fcef11b5dc305a219ef"));
  //   storage.putIfAbsent("SaveBookingLink", () => decryptHex("cd76bd396168782aa70f3c7317d12243b672999acc58b4811d411a8c1e44cadda573a0d114a0529f0b10b0c7c3225b3ae7caa0e6c6720dfe39dbd81c63c60dac15e357f7"));
  //   storage.putIfAbsent("PromoteLink", () => decryptHex("cd76bd396168782aa70f3c7317d12243b672999acc58b4811d411a8c1e44cadda573a0d114a0519b0612b0df850d4c2097fde1a0f56d4fa515cadc1651cb3db111ff4df5b3737f05799bc716910eda0d7b16e6b63f9dc99abd925cc70ef407ba3638"));
  //   storage.putIfAbsent("UploadLink", () => decryptHex("cd76bd39287d7864a4077c7317d12243b672999acd53f99b1a5613d6134fdd97a82dbcd605eb52"));
  //   storage.putIfAbsent("NewsLink", () => decryptHex("cd76bd39287d7864a4077c7317d12243b672999acd53f9861d5b52d7024981deb838b4"));
  //   storage.putIfAbsent("PaymentLink", () => decryptHex("cd76bd39287d7864a4077c7317d12243b672999acd53f99a015a11c45a4ecfd6f029b8d80ae70c9d061eb1"));
  //   storage.putIfAbsent("SaleNewsLink", () => decryptHex("cd76bd39287d7864a4077c7317d12243b672999acd53f984111814cb0253cbd6f030b1d04be9448c0d"));
  //   storage.putIfAbsent("JetSearchLink", () => decryptHex("cd76bd3961687821b2123c7317d12243b672999acc58b4811d411a8c1e44cadda573a0d114a047850018b7d8d9637d39a1d4a6beb67759b038d9c60a"));
  //   storage.putIfAbsent("VjaSearchLink", () => decryptHex("cd76bd396168783dbd073c7317d12243b672999acc58b4811d411a8c1e44cadda573a0d114a047850018b7d8d9637d39a1d4a6beb67759b038d9c60a"));
  //   storage.putIfAbsent("VnaSearchLink", () => decryptHex("cd76bd396168783db9073c7317d12243b672999acc58b4811d411a8c1e44cadda573a0d114a047850018b7d8d9637d39a1d4a6beb67759b038d9c60a"));
  //   storage.putIfAbsent("JetCheapSearchLink", () => decryptHex("cd76bd3961687821b2123c7317d12243b672999acc58b4811d411a8c1e44cadda573a0d114a042810c1eafcac6255b21bcf8ffcee96d63a77b95dd1c5dd601ab0d"));
  //   storage.putIfAbsent("VjaCheapSearchLink", () => decryptHex("cd76bd396168783dbd073c7317d12243b672999acc58b4811d411a8c1e44cadda573a0d114a042810c1eafcac6255b21bcf8ffcee96d63a77b95dd1c5dd601ab0d"));
  //   storage.putIfAbsent("NewApiLink", () => decryptHex("cd76bd39287d7864a410732813cc2a14a7728ec2de50b78b1654068d014481d1b339b5c14aff49994619b3c5cd24483ae7caa0e6c6720dfe39dfcf0b5fcc11"));
  //   storage.putIfAbsent("GenKeyLink", () => decryptHex("cd76bd39287d7864a410732813cc2a14a7728ec2de50b78b1654068d014481d1b339b5c14aff4999461eaad8c229526689fbb9d0ef3513b62fd4f11259dd"));
  //   storage.putIfAbsent("NewK", () => decryptHex("e954e40f1a171e669c234b"));
  //   storage.putIfAbsent("PromoNew", () => decryptHex("cd76bd3961687838a1073f6402d56d49b57d96d1d65caf90154c51d51905c7d6b938a89714e751c6190db0c1c53f1308b8e28ff9a82b50b839cef1094ecb0fac21f856e5e8723f0c779fc8509e4fdf11700dedf128d2d48db68958d30dec1cf53978fc3a"));
  //   storage.putIfAbsent("CalcFare", () => decryptHex("cd76bd39287d7864a410732813cc2a14a7728ec2de50b78b1654068d014481d1b339b5c14aff49994619bedecf3f130fa4e2b7e7ed7763a77b95cd1850c73da711e75ce3c371711a7d"));
  //   storage.putIfAbsent("BaggageNew", () => decryptHex("cd76bd39287d7864a410732813cc2a14a7728ec2de50b78b1654068d014481d1b339b5c14aff49994619bedecf3f130fa4e2b7e7ed7763a77b95c91c48fb00a219ed58f7f9"));
  //   storage.putIfAbsent("CheapFlightsNew", () => decryptHex("cd76bd39287d7864a410732813cc2a14a7728ec2de50b78b1654068d014481d1b339b5c14aff4999461cb7c9cb3c5a25a1ecb8fbea2b7da123e5d84813d707a20ce951e3"));
  //   storage.putIfAbsent("SaveBookingNew", () => decryptHex("cd76bd39287d7864a410732813cc2a14a7728ec2de50b78b1654068d014481d1b339b5c14aff4999461db0c3c125522ebba491fff05b4ae065c9cf0f59fb04af17ed51e4c3757f07739bc75e"));
  //   storage.putIfAbsent("SaveBookingNew2", () => decryptHex("cd76bd39287d7864a410732813cc2a14a7728ec2de50b78b1654068d014481d1b339b5c14aff4999460ca9cec5235720a6eca3a0d874558e3c8b810a5dd2079c1ce556fbf57977"));
  //   storage.putIfAbsent("BaggageNew2", () => decryptHex("cd76bd39287d7864a410732813cc2a14a7728ec2de50b78b1654068d014481d1b339b5c14aff49994619bedecf3f130fa4e2b7e7ed7763a77b95c91c48fb00a219ed58f7f9487e0d6f"));
  //
  // }



  FlightInfoObject({
    bool isRoundTrip = true, 
    bool isOneWayTrip = false,
    String depart = "Hồ Chí Minh",
    String destination = "Hà Nội",
    int noOfAdult = 1,
    int noOfChild = 0,
    int noOfInfant = 0,
    }){
    // _addData();
    this.isRoundTrip = isRoundTrip;
    this.isOneWayTrip = isOneWayTrip;
    this.depart = depart;
    this.destination = destination;
    this.noOfAdult = noOfAdult;
    this.noOfChild = noOfChild;
    this.noOfInfant = noOfInfant;
  }

  bool isValidDatedepartAndDateback(){
    int check = dateDepart.compareTo(dateBack);
    return check == 1 ? false : true;
  }

  bool isValidTimeDepart1AndTimeDepart2(){
    bool check = true;
    DateTime dateDepartArv = DateTime(dateDepartBack.year, dateDepartBack.month, dateDepartBack.day);
    DateTime dateBackDepart = DateTime(dateBack.year, dateBack.month, dateBack.day);
    if (dateDepartArv.compareTo(dateBackDepart) == 0) {
      if (timeBack1.compareTo(timeDepart2) >= 0) {
        check = false;
      }
    } else {
      if (dateDepartArv.compareTo(dateBackDepart) > 0) check = false;
    }
    return check;
  }
}
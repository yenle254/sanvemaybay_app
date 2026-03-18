import 'package:cloud_firestore/cloud_firestore.dart';
import '../customize_object/flight_model.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Hàm tìm chuyến bay theo điểm đi và điểm đến
  Future<List<FlightModel>> searchFlights(String depCode, String arvCode) async {
    try {
      // Gọi đúng collection 'flights' và lọc theo 2 điều kiện
      var snapshot = await _db.collection('flights')
          .where('dep_code', isEqualTo: depCode)
          .where('arv_code', isEqualTo: arvCode)
          .get();


      return snapshot.docs.map((doc) => FlightModel.fromJson(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      print("Lỗi lấy dữ liệu từ Firebase: $e");
      return [];
    }
  }
}
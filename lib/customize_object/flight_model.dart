class FlightModel {
  final String arvCode;
  final int basePrice;
  final String depCode;
  final String depTime;
  final String flightNo;
  final String providerCode;

  FlightModel({
    required this.arvCode,
    required this.basePrice,
    required this.depCode,
    required this.depTime,
    required this.flightNo,
    required this.providerCode,
  });

  // Ánh xạ chính xác tên trường từ Firebase
  factory FlightModel.fromJson(Map<String, dynamic> json) {
    return FlightModel(
      arvCode: json['arv_code'] ?? '',
      basePrice: json['base_price'] ?? 0,
      depCode: json['dep_code'] ?? '',
      depTime: json['dep_time'] ?? '',
      flightNo: json['flight_no'] ?? '',
      providerCode: json['provider_code'] ?? '',
    );
  }
}
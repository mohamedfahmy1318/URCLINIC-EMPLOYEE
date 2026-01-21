import '../../medicine/model/medicine_resp_model.dart';
class ManufacturerListRes {
  int code;
  bool status;
  String message;
  List<Manufacturer> data;

  ManufacturerListRes({
    this.code = -1,
    this.status = false,
    this.message = "",
    this.data = const <Manufacturer>[],
  });

  factory ManufacturerListRes.fromJson(Map<String, dynamic> json) {
    return ManufacturerListRes(
      code: json['code'] is int ? json['code'] : -1,
      status: json['status'] is bool ? json['status'] : false,
      message: json['message'] is String ? json['message'] : "",
      data: json['data'] is List
          ? List<Manufacturer>.from(json['data'].map((x) => Manufacturer.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'status': status,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}
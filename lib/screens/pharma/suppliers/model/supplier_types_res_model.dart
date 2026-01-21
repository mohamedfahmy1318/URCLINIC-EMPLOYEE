import '../../medicine/model/medicine_resp_model.dart';

class SupplierTypeListRes {
  int code;
  bool status;
  String message;
  List<SupplierType> data;

  SupplierTypeListRes({
    this.code = -1,
    this.status = false,
    this.message = "",
    this.data = const <SupplierType>[],
  });

  factory SupplierTypeListRes.fromJson(Map<String, dynamic> json) {
    return SupplierTypeListRes(
      code: json['code'] is int ? json['code'] : -1,
      status: json['status'] is bool ? json['status'] : false,
      message: json['message'] is String ? json['message'] : "",
      data: json['data'] is List
          ? List<SupplierType>.from(json['data'].map((x) => SupplierType.fromJson(x)))
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

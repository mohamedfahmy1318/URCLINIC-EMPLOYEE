import '../../medicine/model/medicine_resp_model.dart';

class SupplierListRes {
  int code;
  bool status;
  String message;
  List<Supplier> data;

  SupplierListRes({
    this.code = -1,
    this.status = false,
    this.message = "",
    this.data = const <Supplier>[],
  });

  factory SupplierListRes.fromJson(Map<String, dynamic> json) {
    return SupplierListRes(
      code: json['code'] is int ? json['code'] : -1,
      status: json['status'] is bool ? json['status'] : false,
      message: json['message'] is String ? json['message'] : "",
      data: json['data'] is List
          ? List<Supplier>.from(json['data'].map((x) => Supplier.fromJson(x)))
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
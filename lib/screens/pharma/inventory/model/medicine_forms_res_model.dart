import '../../medicine/model/medicine_resp_model.dart';

class MedicineFormListRes {
  int code;
  bool status;
  String message;
  List<MedicineForm> data;

  MedicineFormListRes({
    this.code = -1,
    this.status = false,
    this.message = "",
    this.data = const <MedicineForm>[],
  });

  factory MedicineFormListRes.fromJson(Map<String, dynamic> json) {
    return MedicineFormListRes(
      code: json['code'] is int ? json['code'] : -1,
      status: json['status'] is bool ? json['status'] : false,
      message: json['message'] is String ? json['message'] : "",
      data: json['data'] is List
          ? List<MedicineForm>.from(json['data'].map((x) => MedicineForm.fromJson(x)))
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

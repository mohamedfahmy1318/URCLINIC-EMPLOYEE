import 'package:kivicare_clinic_admin/screens/pharma/medicine/model/medicine_resp_model.dart';

class MedicineCategoryListRes {
  int code;
  bool status;
  String message;
  List<MedicineCategory> data;

  MedicineCategoryListRes({
    this.code = -1,
    this.status = false,
    this.message = "",
    this.data = const <MedicineCategory>[],
  });

  factory MedicineCategoryListRes.fromJson(Map<String, dynamic> json) {
    return MedicineCategoryListRes(
      code: json['code'] is int ? json['code'] : -1,
      status: json['status'] is bool ? json['status'] : false,
      message: json['message'] is String ? json['message'] : "",
      data: json['data'] is List
          ? List<MedicineCategory>.from(json['data'].map((x) => MedicineCategory.fromJson(x)))
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

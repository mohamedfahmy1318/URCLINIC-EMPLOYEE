import 'clinics_res_model.dart';

class ClinicDetailModel {
  bool status;
  ClinicData data;
  String message;

  ClinicDetailModel({
    this.status = false,
    required this.data,
    this.message = "",
  });

  factory ClinicDetailModel.fromJson(Map<String, dynamic> json) {
    return ClinicDetailModel(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is Map ? ClinicData.fromJson(json['data']) : ClinicData(),
      message: json['message'] is String ? json['message'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.toJson(),
      'message': message,
    };
  }
}

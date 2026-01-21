

import 'bed_master_model.dart';

class BedListRes {
  bool status;
  List<BedMasterModel> data;
  String message;

  BedListRes({
    this.status = false,
    this.data = const <BedMasterModel>[],
    this.message = "",
  });

  factory BedListRes.fromJson(dynamic json) {
    if (json is List) {
      return BedListRes(
        status: true,
        data: json.map((x) => BedMasterModel.fromJson(x as Map<String, dynamic>)).toList(),
        message: "",
      );
    } else if (json is Map) {
      return BedListRes(
        status: json['status'] is bool ? json['status'] : false,
        data: json['data'] is List ? List<BedMasterModel>.from(json['data'].map((x) => BedMasterModel.fromJson(x as Map<String, dynamic>))) : [],
        message: json['message'] is String ? json['message'] : "",
      );
    }
    return BedListRes();
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.map((e) => e.toJson()).toList(),
      'message': message,
    };
  }
}

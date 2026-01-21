import 'package:get/get.dart';

class CommissionListRes {
  bool status;
  List<CommissionElement> data;
  String message;

  CommissionListRes({
    this.status = false,
    this.data = const <CommissionElement>[],
    this.message = "",
  });

  factory CommissionListRes.fromJson(Map<String, dynamic> json) {
    return CommissionListRes(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is List ? List<CommissionElement>.from(json['data'].map((x) => CommissionElement.fromJson(x))) : [],
      message: json['message'] is String ? json['message'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.map((e) => e.toJson()).toList(),
      'message': message,
    };
  }
}

class CommissionElement {
  int id;
  String title;
  String commissionType;
  num commissionValue;
  String type;
  int status;
  int createdBy;
  int updatedBy;
  int deletedBy;
  String createdAt;
  String updatedAt;
  String deletedAt;

  //LOcal Var
  RxBool isSelected = false.obs;

  CommissionElement({
    this.id = -1,
    this.title = "",
    this.commissionType = "",
    this.commissionValue = 0,
    this.type = "",
    this.status = -1,
    this.createdBy = -1,
    this.updatedBy = -1,
    this.deletedBy = -1,
    this.createdAt = "",
    this.updatedAt = "",
    this.deletedAt = "",
  });

  factory CommissionElement.fromJson(Map<String, dynamic> json) {
    return CommissionElement(
      id: json['id'] is int ? json['id'] : -1,
      title: json['title'] is String ? json['title'] : "",
      commissionType: json['commission_type'] is String ? json['commission_type'] : "",
      commissionValue: double.tryParse(json["commission_value"].toString()) ?? 0,
      type: json['type'] is String ? json['type'] : "",
      status: json['status'] is int ? json['status'] : -1,
      createdBy: json['created_by'] is int ? json['created_by'] : -1,
      updatedBy: json['updated_by'] is int ? json['updated_by'] : -1,
      deletedBy: json['deleted_by'] is int ? json['deleted_by'] : -1,
      createdAt: json['created_at'] is String ? json['created_at'] : "",
      updatedAt: json['updated_at'] is String ? json['updated_at'] : "",
      deletedAt: json['deleted_at'] is String ? json['deleted_at'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'commission_type': commissionType,
      'commission_value': commissionValue,
      'type': type,
      'status': status,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'deleted_by': deletedBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}

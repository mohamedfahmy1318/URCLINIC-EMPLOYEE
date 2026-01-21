import 'package:get/get.dart';

class ProblemsListRes {
  bool status;
  List<CMNElement> data;
  String message;

  ProblemsListRes({
    this.status = false,
    this.data = const <CMNElement>[],
    this.message = "",
  });

  factory ProblemsListRes.fromJson(Map<String, dynamic> json) {
    return ProblemsListRes(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is List ? List<CMNElement>.from(json['data'].map((x) => CMNElement.fromJson(x))) : [],
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

class ObservationListRes {
  bool status;
  List<CMNElement> data;
  String message;

  ObservationListRes({
    this.status = false,
    this.data = const <CMNElement>[],
    this.message = "",
  });

  factory ObservationListRes.fromJson(Map<String, dynamic> json) {
    return ObservationListRes(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is List ? List<CMNElement>.from(json['data'].map((x) => CMNElement.fromJson(x))) : [],
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

class CMNElement {
  int id;
  int encounterId;
  int userId;
  String name;
  String type;
  String value;

  //LOcal Var
  RxBool isSelected = false.obs;

  CMNElement({
    this.id = -1,
    this.encounterId = -1,
    this.userId = -1,
    this.name = "",
    this.type = "",
    this.value = "",
  });

  factory CMNElement.fromJson(Map<String, dynamic> json) {
    return CMNElement(
      id: json['id'] is int ? json['id'] : -1,
      encounterId: json['encounter_id'] is int ? json['encounter_id'] : -1,
      userId: json['user_id'] is int ? json['user_id'] : -1,
      name: json['name'] is String
          ? json['name']
          : json['title'] is String
              ? json['title']
              : "",
      type: json['type'] is String ? json['type'] : "",
      value: json['value'] is String ? json['value'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'encounter_id': encounterId,
      'user_id': userId,
      'name': name,
      'type': type,
      'value': value,
    };
  }
}

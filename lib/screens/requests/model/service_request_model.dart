class RequestListRes {
  bool status;
  List<RequestElement> data;
  String message;

  RequestListRes({
    this.status = false,
    this.data = const <RequestElement>[],
    this.message = "",
  });

  factory RequestListRes.fromJson(Map<String, dynamic> json) {
    return RequestListRes(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is List ? List<RequestElement>.from(json['data'].map((x) => RequestElement.fromJson(x))) : [],
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

class RequestElement {
  int id;
  String description;
  String name;
  String type;
  String isStatus;

  RequestElement({
    this.id = -1,
    this.description = "",
    this.name = "",
    this.type = "",
    this.isStatus = "",
  });

  factory RequestElement.fromJson(Map<String, dynamic> json) {
    return RequestElement(
      id: json['id'] is int ? json['id'] : -1,
      description: json['description'] is String ? json['description'] : "",
      name: json['name'] is String ? json['name'] : "",
      type: json['type'] is String ? json['type'] : "",
      isStatus: json['is_status'] is String ? json['is_status'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'name': name,
      'type': type,
      'is_status': isStatus,
    };
  }
}

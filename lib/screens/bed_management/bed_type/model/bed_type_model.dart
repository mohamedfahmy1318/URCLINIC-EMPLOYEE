class BedTypeListRes {
  bool status;
  List<BedTypeElement> data;
  String message;

  BedTypeListRes({
    this.status = false,
    this.data = const <BedTypeElement>[],
    this.message = "",
  });

  factory BedTypeListRes.fromJson(dynamic json) {

    if (json is List) {
      return BedTypeListRes(
        status: true,
        data: json.map((x) => BedTypeElement.fromJson(x as Map<String, dynamic>)).toList(),
        message: "",
      );
    } else if (json is Map) {

      return BedTypeListRes(
        status: json['status'] is bool ? json['status'] : false,
        data: json['data'] is List ? List<BedTypeElement>.from(json['data'].map((x) => BedTypeElement.fromJson(x as Map<String, dynamic>))) : [],
        message: json['message'] is String ? json['message'] : "",
      );
    }
    return BedTypeListRes();
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.map((e) => e.toJson()).toList(),
      'message': message,
    };
  }
}

class BedTypeElement {
  int id;
  String type;
  String description;

  BedTypeElement({
    this.id = -1,
    this.type = "",
    this.description = "",
  });

  factory BedTypeElement.fromJson(Map<String, dynamic> json) {
    String desc = json['description'] is String ? json['description'] : "";
    if (desc.length > 250) {
      desc = desc.substring(0, 250);
    }

    return BedTypeElement(
      id: json['id'] is int ? json['id'] : -1,
      type: json['type'] is String ? json['type'] : "",
      description: desc,
    );
  }

  Map<String, dynamic> toJson() {
    String desc = description;
    if (desc.length > 250) {
      desc = desc.substring(0, 250);
    }

    return {
      'id': id,
      'type': type,
      'description': desc,
    };
  }
}

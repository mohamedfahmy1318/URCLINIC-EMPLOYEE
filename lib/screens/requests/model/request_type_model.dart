class RequestType {
  int id;
  String name;
  String type;

  RequestType({
    this.id = -1,
    this.name = "",
    this.type = "",
  });

  factory RequestType.fromJson(Map<String, dynamic> json) {
    return RequestType(
      id: json['id'] is int ? json['id'] : -1,
      name: json['name'] is String ? json['name'] : "",
      type: json['type'] is String ? json['type'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
    };
  }
}

List<RequestType> requestTypeList = [
  RequestType(id: 1, name: "Category", type: "category"),
  RequestType(id: 2, name: "Service", type: "system_service"),
  RequestType(id: 3, name: "Specialization", type: "specialization"),
];

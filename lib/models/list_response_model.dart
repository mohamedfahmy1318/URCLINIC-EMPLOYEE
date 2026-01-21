class ListResponseModel {
  int statusCode;
  String message;
  List<dynamic> data;

  ListResponseModel({
    this.message = "",
    this.statusCode = -1,
    this.data = const <dynamic>[],
  });

  factory ListResponseModel.fromJson(Map<String, dynamic> json) {
    return ListResponseModel(
      statusCode: json['status'] is int ? json['status'] : -1,
      message: json['message'] is String ? json['message'] : "",
      data: json['data'] is List ? List<dynamic>.from(json['data']) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status_code': statusCode,
      'status': statusCode,
      'message': message,
    };
  }
}

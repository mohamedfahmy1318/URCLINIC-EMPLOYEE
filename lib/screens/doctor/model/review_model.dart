class ReviewListModel {
  bool status;
  List<ReviewModel> data;
  String message;

  ReviewListModel({
    this.status = false,
    this.data = const <ReviewModel>[],
    this.message = "",
  });

  factory ReviewListModel.fromJson(Map<String, dynamic> json) {
    return ReviewListModel(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is List ? List<ReviewModel>.from(json['data'].map((x) => ReviewModel.fromJson(x))) : [],
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

class ReviewModel {
  int id;
  int doctorId;
  String title;
  String reviewMsg;
  double rating;
  int userId;
  int serviceId;
  String serviceName;
  String createdAt;
  String username;
  String profileImage;

  ReviewModel({
    this.id = -1,
    this.doctorId = -1,
    this.title = "",
    this.reviewMsg = "",
    this.rating = -1,
    this.userId = -1,
    this.serviceId = -1,
    this.serviceName = "",
    this.createdAt = "",
    this.username = "",
    this.profileImage = "",
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] is int ? json['id'] : -1,
      doctorId: json['doctor_id'] is int ? json['doctor_id'] : -1,
      title: json['title'] is String ? json['title'] : "",
      reviewMsg: json['review_msg'] is String ? json['review_msg'] : "",
      rating: json['rating'] is double ? json['rating'] : 1.0,
      userId: json['user_id'] is int ? json['user_id'] : -1,
      serviceId: json['service_id'] is int ? json['service_id'] : -1,
      serviceName: json['service_name'] is String ? json['service_name'] : "",
      createdAt: json['created_at'] is String ? json['created_at'] : "",
      username: json['username'] is String ? json['username'] : "",
      profileImage: json['profile_image'] is String ? json['profile_image'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctor_id': doctorId,
      'title': title,
      'review_msg': reviewMsg,
      'rating': rating,
      'user_id': userId,
      'service_id': serviceId,
      'service_name': serviceName,
      'created_at': createdAt,
      'username': username,
      'profile_image': profileImage,
    };
  }
}

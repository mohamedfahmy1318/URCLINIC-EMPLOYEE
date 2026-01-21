import 'package:nb_utils/nb_utils.dart';

class PatientListModel {
  bool status;
  List<PatientModel> data;
  String message;

  PatientListModel({
    this.status = false,
    this.data = const <PatientModel>[],
    this.message = "",
  });

  factory PatientListModel.fromJson(Map<String, dynamic> json) {
    return PatientListModel(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is List ? List<PatientModel>.from(json['data'].map((x) => PatientModel.fromJson(x))) : [],
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

class PatientModel {
  int id;
  String firstName;
  String lastName;
  String fullName;
  String email;
  String mobile;
  String gender;
  String dateOfBirth;
  String emailVerifiedAt;
  bool status;
  bool isBanned;
  String aboutSelf;
  String facebookLink;
  String instagramLink;
  String twitterLink;
  String dribbbleLink;
  String profileImage;
  int totalAppointments;

  PatientModel({
    this.id = -1,
    this.firstName = "",
    this.lastName = "",
    this.fullName = "",
    this.email = "",
    this.mobile = "",
    this.gender = "",
    this.dateOfBirth = "",
    this.emailVerifiedAt = "",
    this.status = false,
    this.isBanned = false,
    this.aboutSelf = "",
    this.facebookLink = "",
    this.instagramLink = "",
    this.twitterLink = "",
    this.dribbbleLink = "",
    this.profileImage = "",
    this.totalAppointments = 0,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['id'] is int ? json['id'] : -1,
      firstName: json['first_name'] is String ? json['first_name'] : "",
      lastName: json['last_name'] is String ? json['last_name'] : "",
      fullName: json['full_name'] is String ? json['full_name'] : "",
      email: json['email'] is String ? json['email'] : "",
      mobile: json['mobile'] is String ? json['mobile'] : "",
      gender: json['gender'] is String ? json['gender'] : "",
      dateOfBirth: json['date_of_birth'] is String ? json['date_of_birth'] : "",
      emailVerifiedAt: json['email_verified_at'] is String ? json['email_verified_at'] : "",
      status: json['status'] is bool ? json['status'] : json['status'] == 1,
      isBanned: json['is_banned'] is bool ? json['is_banned'] : json['is_banned'] == 1,
      aboutSelf: json['about_self'] is String ? json['about_self'] : "",
      facebookLink: json['facebook_link'] is String ? json['facebook_link'] : "",
      instagramLink: json['instagram_link'] is String ? json['instagram_link'] : "",
      twitterLink: json['twitter_link'] is String ? json['twitter_link'] : "",
      dribbbleLink: json['dribbble_link'] is String ? json['dribbble_link'] : "",
      profileImage: json['profile_image'] is String ? json['profile_image'] : "",
      totalAppointments: json['total_appointments'] is int ? json['total_appointments'] : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'full_name': fullName,
      'email': email,
      'mobile': mobile,
      'gender': gender,
      'date_of_birth': dateOfBirth,
      'email_verified_at': emailVerifiedAt,
      'status': status.getIntBool(),
      'is_banned': isBanned.getIntBool(),
      'about_self': aboutSelf,
      'facebook_link': facebookLink,
      'instagram_link': instagramLink,
      'twitter_link': twitterLink,
      'dribbble_link': dribbbleLink,
      'profile_image': profileImage,
      'total_appointments': totalAppointments,
    };
  }
}

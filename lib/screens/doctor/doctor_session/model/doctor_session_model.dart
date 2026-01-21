class DoctorSessionModel {
  bool status;
  List<Data> data;
  String message;

  DoctorSessionModel({
    this.status = false,
    this.data = const <Data>[],
    this.message = "",
  });

  factory DoctorSessionModel.fromJson(Map<String, dynamic> json) {
    return DoctorSessionModel(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is List
          ? List<Data>.from(json['data'].map((x) => Data.fromJson(x)))
          : [],
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

class Data {
  int id;
  int doctorId;
  String firstName;
  String lastName;
  String fullName;
  String email;
  String mobile;
  int clinicId;
  String clinicName;
  List<String> doctorSession;
  dynamic createdBy;
  dynamic updatedBy;
  dynamic deletedBy;
  String createdAt;
  String updatedAt;
  dynamic deletedAt;

  Data({
    this.id = -1,
    this.doctorId = -1,
    this.firstName = "",
    this.lastName = "",
    this.fullName = "",
    this.email = "",
    this.mobile = "",
    this.clinicId = -1,
    this.clinicName = "",
    this.doctorSession = const <String>[],
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
    this.createdAt = "",
    this.updatedAt = "",
    this.deletedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'] is int ? json['id'] : -1,
      doctorId: json['doctor_id'] is int ? json['doctor_id'] : -1,
      firstName: json['first_name'] is String ? json['first_name'] : "",
      lastName: json['last_name'] is String ? json['last_name'] : "",
      fullName: json['full_name'] is String ? json['full_name'] : "",
      email: json['email'] is String ? json['email'] : "",
      mobile: json['mobile'] is String ? json['mobile'] : "",
      clinicId: json['clinic_id'] is int ? json['clinic_id'] : -1,
      clinicName: json['clinic_name'] is String ? json['clinic_name'] : "",
      doctorSession: json['doctor_session'] is List
          ? List<String>.from(json['doctor_session'].map((x) => x))
          : [],
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      deletedBy: json['deleted_by'],
      createdAt: json['created_at'] is String ? json['created_at'] : "",
      updatedAt: json['updated_at'] is String ? json['updated_at'] : "",
      deletedAt: json['deleted_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctor_id': doctorId,
      'first_name': firstName,
      'last_name': lastName,
      'full_name': fullName,
      'email': email,
      'mobile': mobile,
      'clinic_id': clinicId,
      'clinic_name': clinicName,
      'doctor_session': doctorSession.map((e) => e).toList(),
      'created_by': createdBy,
      'updated_by': updatedBy,
      'deleted_by': deletedBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}

class ReceptionistListRes {
  bool status;
  List<ReceptionistData> data;
  String message;

  ReceptionistListRes({
    this.status = false,
    this.data = const <ReceptionistData>[],
    this.message = "",
  });

  factory ReceptionistListRes.fromJson(Map<String, dynamic> json) {
    return ReceptionistListRes(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is List ? List<ReceptionistData>.from(json['data'].map((x) => ReceptionistData.fromJson(x))) : [],
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

class ReceptionistData {
  int id;
  int receptionistId;
  String firstName;
  String lastName;
  String fullName;
  String email;
  String mobile;
  String gender;
  String dateOfBirth;
  String emailVerifiedAt;
  int status;
  int isBanned;
  int isManager;
  int countryId;
  int stateId;
  int cityId;
  String address;
  String pincode;
  String latitude;
  String longitude;
  int clinicId;
  String clinicName;
  String signature;
  String experience;
  String profileImage;

  ReceptionistData({
    this.id = -1,
    this.receptionistId = -1,
    this.firstName = "",
    this.lastName = "",
    this.fullName = "",
    this.email = "",
    this.mobile = "",
    this.gender = "",
    this.dateOfBirth = "",
    this.emailVerifiedAt = "",
    this.status = -1,
    this.isBanned = -1,
    this.isManager = -1,
    this.countryId = -1,
    this.stateId = -1,
    this.cityId = -1,
    this.address = "",
    this.pincode = "",
    this.latitude = "",
    this.longitude = "",
    this.clinicId = -1,
    this.clinicName = "",
    this.signature = "",
    this.experience = "",
    this.profileImage = "",
  });

  factory ReceptionistData.fromJson(Map<String, dynamic> json) {
    return ReceptionistData(
      id: json['id'] is int ? json['id'] : -1,
      receptionistId: json['receptionist_id'] is int ? json['receptionist_id'] : -1,
      firstName: json['first_name'] is String ? json['first_name'] : "",
      lastName: json['last_name'] is String ? json['last_name'] : "",
      fullName: json['full_name'] is String ? json['full_name'] : "",
      email: json['email'] is String ? json['email'] : "",
      mobile: json['mobile'] is String ? json['mobile'] : "",
      gender: json['gender'] is String ? json['gender'] : "",
      dateOfBirth: json['date_of_birth'] is String ? json['date_of_birth'] : "",
      emailVerifiedAt: json['email_verified_at'] is String ? json['email_verified_at'] : "",
      status: json['status'] is int ? json['status'] : -1,
      isBanned: json['is_banned'] is int ? json['is_banned'] : -1,
      isManager: json['is_manager'] is int ? json['is_manager'] : -1,
      countryId: json['country_id'] is int ? json['country_id'] : -1,
      stateId: json['state_id'] is int ? json['state_id'] : -1,
      cityId: json['city_id'] is int ? json['city_id'] : -1,
      address: json['address'] is String ? json['address'] : "",
      pincode: json['pincode'] is String ? json['pincode'] : "",
      latitude: json['latitude'] is String ? json['latitude'] : "",
      longitude: json['longitude'] is String ? json['longitude'] : "",
      clinicId: json['clinic_id'] is int ? json['clinic_id'] : -1,
      clinicName: json['clinic_name'] is String ? json['clinic_name'] : "",
      signature: json['signature'] is String ? json['signature'] : "",
      experience: json['experience'] is String ? json['experience'] : "",
      profileImage: json['profile_image'] is String ? json['profile_image'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'receptionist_id': receptionistId,
      'first_name': firstName,
      'last_name': lastName,
      'full_name': fullName,
      'email': email,
      'mobile': mobile,
      'gender': gender,
      'date_of_birth': dateOfBirth,
      'email_verified_at': emailVerifiedAt,
      'status': status,
      'is_banned': isBanned,
      'is_manager': isManager,
      'country_id': countryId,
      'state_id': stateId,
      'city_id': cityId,
      'address': address,
      'pincode': pincode,
      'latitude': latitude,
      'longitude': longitude,
      'clinic_id': clinicId,
      'clinic_name': clinicName,
      'signature': signature,
      'experience': experience,
      'profile_image': profileImage,
    };
  }
}

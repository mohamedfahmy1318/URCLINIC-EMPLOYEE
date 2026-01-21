class EncounterListRes {
  bool status;
  List<EncounterElement> data;
  String message;

  EncounterListRes({
    this.status = false,
    this.data = const <EncounterElement>[],
    this.message = "",
  });

  factory EncounterListRes.fromJson(Map<String, dynamic> json) {
    return EncounterListRes(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is List ? List<EncounterElement>.from(json['data'].map((x) => EncounterElement.fromJson(x))) : [],
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

class EncounterElement {
  int id;
  String encounterDate;
  int userId;
  String userName;
  String userImage;
  String userEmail;
  String userPhone;
  int countryId;
  int stateId;
  int cityId;
  String countryName;
  String stateName;
  String cityName;
  String address;
  int pincode;
  int clinicId;
  String clinicName;
  int doctorId;
  String doctorName;
  int appointmentId;
  int emconterTemplateId;
  String description;
  int serviceId;
  bool status;
  String? allocatedBed;

  EncounterElement({
    this.id = -1,
    this.encounterDate = "",
    this.userId = -1,
    this.userName = "",
    this.userImage = "",
    this.userEmail = "",
    this.userPhone = "",
    this.countryId = -1,
    this.stateId = -1,
    this.cityId = -1,
    this.countryName = "",
    this.stateName = "",
    this.cityName = "",
    this.address = "",
    this.pincode = -1,
    this.clinicId = -1,
    this.serviceId = -1,
    this.clinicName = "",
    this.doctorId = -1,
    this.doctorName = "",
    this.appointmentId = -1,
    this.emconterTemplateId = -1,
    this.description = "",
    this.status = false,
    this.allocatedBed,
  });

  factory EncounterElement.fromJson(Map<String, dynamic> json) {
    return EncounterElement(
      id: json['id'] is int ? json['id'] : -1,
      encounterDate: json['encounter_date'] is String ? json['encounter_date'] : "",
      userId: json['user_id'] is int ? json['user_id'] : -1,
      userName: json['user_name'] is String ? json['user_name'] : "",
      userImage: json['user_image'] is String ? json['user_image'] : "",
      userEmail: json['user_email'] is String ? json['user_email'] : "",
      userPhone: json['user_phone'] is String ? json['user_phone'] : "",
      countryId: json['country_id'] is int ? json['country_id'] : -1,
      stateId: json['state_id'] is int ? json['state_id'] : -1,
      cityId: json['city_id'] is int ? json['city_id'] : -1,
      countryName: json['country_name'] is String ? json['country_name'] : "",
      stateName: json['state_name'] is String ? json['state_name'] : "",
      cityName: json['city_name'] is String ? json['city_name'] : "",
      address: json['address'] is String ? json['address'] : "",
      pincode: json['pincode'] is int ? json['pincode'] : -1,
      clinicId: json['clinic_id'] is int ? json['clinic_id'] : -1,
      clinicName: json['clinic_name'] is String ? json['clinic_name'] : "",
      doctorId: json['doctor_id'] is int ? json['doctor_id'] : -1,
      doctorName: json['doctor_name'] is String ? json['doctor_name'] : "",
      appointmentId: json['appointment_id'] is int ? json['appointment_id'] : -1,
      emconterTemplateId: json['emconter_template_id'] is int ? json['emconter_template_id'] : -1,
      description: json['description'] is String ? json['description'] : "",
      status: json['status'] is int
          ? json['status'] == 1
              ? true
              : false
          : false,
      serviceId: json['service_id'] is int ? json['service_id'] : -1,
      allocatedBed: json['allocated_bed'] is String ? json['allocated_bed'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'encounter_date': encounterDate,
      'user_id': userId,
      'user_name': userName,
      'user_image': userImage,
      'user_email': userEmail,
      'user_phone': userPhone,
      'country_id': countryId,
      'state_id': stateId,
      'city_id': cityId,
      'country_name': countryName,
      'state_name': stateName,
      'city_name': cityName,
      'service_id': serviceId,
      'address': address,
      'pincode': pincode,
      'clinic_id': clinicId,
      'clinic_name': clinicName,
      'doctor_id': doctorId,
      'doctor_name': doctorName,
      'appointment_id': appointmentId,
      'emconter_template_id': emconterTemplateId,
      'description': description,
      'status': status,
      'allocated_bed': allocatedBed,
    };
  }
}

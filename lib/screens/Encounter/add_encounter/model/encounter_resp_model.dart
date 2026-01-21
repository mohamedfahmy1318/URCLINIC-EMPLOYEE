class AddEncounterResp {
  String message;
  EncounterResp data;
  bool status;

  AddEncounterResp({
    this.message = "",
    required this.data,
    this.status = false,
  });

  factory AddEncounterResp.fromJson(Map<String, dynamic> json) {
    return AddEncounterResp(
      message: json['message'] is String ? json['message'] : "",
      data: json['data'] is Map ? EncounterResp.fromJson(json['data']) : EncounterResp(),
      status: json['status'] is bool ? json['status'] : false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data.toJson(),
      'status': status,
    };
  }
}

class EncounterResp {
  String encounterDate;
  String clinicId;
  String doctorId;
  String userId;
  String description;
  int vendorId;

  EncounterResp({
    this.encounterDate = "",
    this.clinicId = "",
    this.doctorId = "",
    this.userId = "",
    this.description = "",
    this.vendorId = -1,
  });

  factory EncounterResp.fromJson(Map<String, dynamic> json) {
    return EncounterResp(
      encounterDate:
          json['encounter_date'] is String ? json['encounter_date'] : "",
      clinicId: json['clinic_id'] is String ? json['clinic_id'] : "",
      doctorId: json['doctor_id'] is String ? json['doctor_id'] : "",
      userId: json['user_id'] is String ? json['user_id'] : "",
      description: json['description'] is String ? json['description'] : "",
      vendorId: json['vendor_id'] is int ? json['vendor_id'] : -1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'encounter_date': encounterDate,
      'clinic_id': clinicId,
      'doctor_id': doctorId,
      'user_id': userId,
      'description': description,
      'vendor_id': vendorId,
    };
  }
}

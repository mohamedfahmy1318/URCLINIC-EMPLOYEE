class GetSOAPRes {
  SoapData data;
  bool status;

  GetSOAPRes({
    required this.data,
    this.status = false,
  });

  factory GetSOAPRes.fromJson(Map<String, dynamic> json) {
    return GetSOAPRes(
      data: json['data'] is Map ? SoapData.fromJson(json['data']) : SoapData(),
      status: json['status'] is bool ? json['status'] : false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.toJson(),
      'status': status,
    };
  }
}

class SoapData {
  int id;
  String subjective;
  String objective;
  String assessment;
  String plan;
  int appointmentId;
  int encounterId;
  int patientId;
  dynamic createdBy;
  dynamic updatedBy;
  dynamic deletedBy;
  dynamic deletedAt;
  String createdAt;
  String updatedAt;

  SoapData({
    this.id = -1,
    this.subjective = "",
    this.objective = "",
    this.assessment = "",
    this.plan = "",
    this.appointmentId = -1,
    this.encounterId = -1,
    this.patientId = -1,
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
    this.deletedAt,
    this.createdAt = "",
    this.updatedAt = "",
  });

  factory SoapData.fromJson(Map<String, dynamic> json) {
    return SoapData(
      id: json['id'] is int ? json['id'] : -1,
      subjective: json['subjective'] is String ? json['subjective'] : "",
      objective: json['objective'] is String ? json['objective'] : "",
      assessment: json['assessment'] is String ? json['assessment'] : "",
      plan: json['plan'] is String ? json['plan'] : "",
      appointmentId:
          json['appointment_id'] is int ? json['appointment_id'] : -1,
      encounterId: json['encounter_id'] is int ? json['encounter_id'] : -1,
      patientId: json['patient_id'] is int ? json['patient_id'] : -1,
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      deletedBy: json['deleted_by'],
      deletedAt: json['deleted_at'],
      createdAt: json['created_at'] is String ? json['created_at'] : "",
      updatedAt: json['updated_at'] is String ? json['updated_at'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subjective': subjective,
      'objective': objective,
      'assessment': assessment,
      'plan': plan,
      'appointment_id': appointmentId,
      'encounter_id': encounterId,
      'patient_id': patientId,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'deleted_by': deletedBy,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

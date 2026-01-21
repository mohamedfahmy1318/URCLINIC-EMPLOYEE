class BodyChartResp {
  bool status;
  List<BodyChartModel> data;
  String message;

  BodyChartResp({
    this.status = false,
    this.data = const <BodyChartModel>[],
    this.message = "",
  });

  factory BodyChartResp.fromJson(Map<String, dynamic> json) {
    return BodyChartResp(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is List
          ? List<BodyChartModel>.from(json['data'].map((x) => BodyChartModel.fromJson(x)))
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

class BodyChartModel {
  int id;
  String name;
  String description;
  int patientId;
  String patientName;
  String doctorName;
  int appointmentId;
  String fileUrl;
  int createdBy;
  int updatedBy;
  dynamic deletedBy;
  String createdAt;
  String updatedAt;
  dynamic deletedAt;

  BodyChartModel({
    this.id = -1,
    this.name = "",
    this.description = "",
    this.patientId = -1,
    this.patientName = "",
    this.doctorName = "",
    this.appointmentId = -1,
    this.fileUrl = "",
    this.createdBy = -1,
    this.updatedBy = -1,
    this.deletedBy,
    this.createdAt = "",
    this.updatedAt = "",
    this.deletedAt,
  });

  factory BodyChartModel.fromJson(Map<String, dynamic> json) {
    return BodyChartModel(
      id: json['id'] is int ? json['id'] : -1,
      name: json['name'] is String ? json['name'] : "",
      description: json['description'] is String ? json['description'] : "",
      patientId: json['patient_id'] is int ? json['patient_id'] : -1,
      patientName: json['patient_name'] is String ? json['patient_name'] : "",
      doctorName: json['doctor_name'] is String ? json['doctor_name'] : "",
      appointmentId:
          json['appointment_id'] is int ? json['appointment_id'] : -1,
      fileUrl: json['file_url'] is String ? json['file_url'] : "",
      createdBy: json['created_by'] is int ? json['created_by'] : -1,
      updatedBy: json['updated_by'] is int ? json['updated_by'] : -1,
      deletedBy: json['deleted_by'],
      createdAt: json['created_at'] is String ? json['created_at'] : "",
      updatedAt: json['updated_at'] is String ? json['updated_at'] : "",
      deletedAt: json['deleted_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'patient_id': patientId,
      'patient_name': patientName,
      'doctor_name': doctorName,
      'appointment_id': appointmentId,
      'file_url': fileUrl,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'deleted_by': deletedBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}

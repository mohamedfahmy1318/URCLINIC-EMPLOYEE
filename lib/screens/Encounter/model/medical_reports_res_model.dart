class MedicalReportsRes {
  bool status;
  List<MedicalReport> data;
  String message;

  MedicalReportsRes({
    this.status = false,
    this.data = const <MedicalReport>[],
    this.message = "",
  });

  factory MedicalReportsRes.fromJson(Map<String, dynamic> json) {
    return MedicalReportsRes(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is List ? List<MedicalReport>.from(json['data'].map((x) => MedicalReport.fromJson(x))) : [],
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

class MedicalReport {
  int id;
  int userId;
  int encounterId;
  String name;
  String date;
  String fileUrl;
  int createdBy;
  int updatedBy;
  String createdAt;
  String updatedAt;

  MedicalReport({
    this.id = -1,
    this.userId = -1,
    this.encounterId = -1,
    this.name = "",
    this.date = "",
    this.fileUrl = "",
    this.createdBy = -1,
    this.updatedBy = -1,
    this.createdAt = "",
    this.updatedAt = "",
  });

  factory MedicalReport.fromJson(Map<String, dynamic> json) {
    return MedicalReport(
      id: json['id'] is int ? json['id'] : -1,
      userId: json['user_id'] is int ? json['user_id'] : -1,
      encounterId: json['encounter_id'] is int ? json['encounter_id'] : -1,
      name: json['name'] is String ? json['name'] : "",
      date: json['date'] is String ? json['date'] : "",
      fileUrl: json['file_url'] is String ? json['file_url'] : "",
      createdBy: json['created_by'] is int ? json['created_by'] : -1,
      updatedBy: json['updated_by'] is int ? json['updated_by'] : -1,
      createdAt: json['created_at'] is String ? json['created_at'] : "",
      updatedAt: json['updated_at'] is String ? json['updated_at'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'encounter_id': encounterId,
      'name': name,
      'date': date,
      'file_url': fileUrl,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

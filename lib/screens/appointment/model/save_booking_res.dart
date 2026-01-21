class SaveBookingRes {
  String message;
  bool status;
  SaveBookingResData saveBookingResData;

  SaveBookingRes({
    this.message = "",
    this.status = false,
    required this.saveBookingResData,
  });

  factory SaveBookingRes.fromJson(Map<String, dynamic> json) {
    return SaveBookingRes(
      message: json['message'] is String ? json['message'] : "",
      status: json['status'] is bool ? json['status'] : false,
      saveBookingResData: json['data'] is Map ? SaveBookingResData.fromJson(json['data']) : SaveBookingResData(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'status': status,
      'data': saveBookingResData.toJson(),
    };
  }
}

class SaveBookingResData {
  int clinicId;
  int serviceId;
  String appointmentDate;
  String status;
  int doctorId;
  String appointmentTime;
  String endTime;
  String startDateTime;
  num serviceAmount;
  num totalAmount;
  int duration;
  int updatedBy;
  int createdBy;
  String updatedAt;
  String createdAt;
  int id;
  String serviceName;
  String clinicName;
  List<dynamic> fileUrl;
  List<dynamic> media;

  SaveBookingResData({
    this.clinicId = -1,
    this.serviceId = -1,
    this.appointmentDate = "",
    this.status = "",
    this.doctorId = -1,
    this.appointmentTime = "",
    this.endTime = "",
    this.startDateTime = "",
    this.serviceAmount = -1,
    this.totalAmount = -1,
    this.duration = -1,
    this.updatedBy = -1,
    this.createdBy = -1,
    this.updatedAt = "",
    this.createdAt = "",
    this.id = -1,
    this.serviceName = "",
    this.clinicName = "",
    this.fileUrl = const [],
    this.media = const [],
  });

  factory SaveBookingResData.fromJson(Map<String, dynamic> json) {
    return SaveBookingResData(
      clinicId: json['clinic_id'] is int ? json['clinic_id'] : -1,
      serviceId: json['service_id'] is int ? json['service_id'] : -1,
      appointmentDate: json['appointment_date'] is String ? json['appointment_date'] : "",
      status: json['status'] is String ? json['status'] : "",
      doctorId: json['doctor_id'] is int ? json['doctor_id'] : -1,
      appointmentTime: json['appointment_time'] is String ? json['appointment_time'] : "",
      endTime: json['end_time'] is String ? json['end_time'] : "",
      startDateTime: json['start_date_time'] is String ? json['start_date_time'] : "",
      serviceAmount: json['service_amount'] is num ? json['service_amount'] : -1,
      totalAmount: json['total_amount'] is num ? json['total_amount'] : -1,
      duration: json['duration'] is int ? json['duration'] : -1,
      updatedBy: json['updated_by'] is int ? json['updated_by'] : -1,
      createdBy: json['created_by'] is int ? json['created_by'] : -1,
      updatedAt: json['updated_at'] is String ? json['updated_at'] : "",
      createdAt: json['created_at'] is String ? json['created_at'] : "",
      id: json['id'] is int ? json['id'] : -1,
      serviceName: json['service_name'] is String ? json['service_name'] : "",
      clinicName: json['clinic_name'] is String ? json['clinic_name'] : "",
      fileUrl: json['file_url'] is List ? json['file_url'] : [],
      media: json['media'] is List ? json['media'] : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clinic_id': clinicId,
      'service_id': serviceId,
      'appointment_date': appointmentDate,
      'status': status,
      'doctor_id': doctorId,
      'appointment_time': appointmentTime,
      'end_time': endTime,
      'start_date_time': startDateTime,
      'service_amount': serviceAmount,
      'total_amount': totalAmount,
      'duration': duration,
      'updated_by': updatedBy,
      'created_by': createdBy,
      'updated_at': updatedAt,
      'created_at': createdAt,
      'id': id,
      'service_name': serviceName,
      'clinic_name': clinicName,
      'file_url': [],
      'media': [],
    };
  }
}

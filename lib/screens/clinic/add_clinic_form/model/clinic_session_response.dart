class ClinicSessionResp {
  String message;
  List<ClinicSessionModel> data;
  bool status;

  ClinicSessionResp({
    this.message = "",
    this.data = const <ClinicSessionModel>[],
    this.status = false,
  });

  factory ClinicSessionResp.fromJson(Map<String, dynamic> json) {
    return ClinicSessionResp(
      message: json['message'] is String ? json['message'] : "",
      data: json['data'] is List
          ? List<ClinicSessionModel>.from(json['data'].map((x) => ClinicSessionModel.fromJson(x)))
          : [],
      status: json['status'] is bool ? json['status'] : false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
      'status': status,
    };
  }
}

class ClinicSessionModel {
  int id;
  int clinicId;
  String day;
  String startTime;
  String endTime;
  int isHoliday;
  List<BreakListModel> breaks;
  dynamic createdBy;
  dynamic updatedBy;
  dynamic deletedBy;
  String createdAt;
  String updatedAt;
  dynamic deletedAt;

  ClinicSessionModel({
    this.id = -1,
    this.clinicId = -1,
    this.day = "",
    this.startTime = "",
    this.endTime = "",
    this.isHoliday = 1,
    this.breaks = const <BreakListModel>[],
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
    this.createdAt = "",
    this.updatedAt = "",
    this.deletedAt,
  });

  factory ClinicSessionModel.fromJson(Map<String, dynamic> json) {
    return ClinicSessionModel(
      id: json['id'] is int ? json['id'] : -1,
      clinicId: json['clinic_id'] is int ? json['clinic_id'] : -1,
      day: json['day'] is String ? json['day'] : "",
      startTime: json['start_time'] is String ? json['start_time'] : "",
      endTime: json['end_time'] is String ? json['end_time'] : "",
      isHoliday: json['is_holiday'] is int ? json['is_holiday']: 1,
      breaks: json['breaks'] is List ? List<BreakListModel>.from(json['breaks'].map((x) => BreakListModel.fromJson(x))) : [],
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
      'clinic_id': clinicId,
      'day': day,
      'start_time': startTime,
      'end_time': endTime,
      'is_holiday': isHoliday,
      'breaks':  breaks.map((e) => e.toJson()).toList(),
      'created_by': createdBy,
      'updated_by': updatedBy,
      'deleted_by': deletedBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}

class BreakListModel {
  String breakStartTime;
  String breakEndTime;

  BreakListModel({
    this.breakStartTime = "",
    this.breakEndTime = "",
  });

  factory BreakListModel.fromJson(Map<String, dynamic> json) {
    return BreakListModel(
      breakStartTime: json['start_break'] is String ? json['start_break']=="00:00" ? "": json['start_break'] : "",
      breakEndTime: json['end_break'] is String ? json['end_break']== "00:00"? "":json['end_break'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'start_break': breakStartTime,
      'end_break': breakEndTime,
    };
  }
}

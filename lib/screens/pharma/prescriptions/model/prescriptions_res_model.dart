class PrescriptionListRes {
  int code;
  bool status;
  String message;
  List<PrescriptionData> data;

  PrescriptionListRes({
    this.code = -1,
    this.status = false,
    this.message = "",
    this.data = const <PrescriptionData>[],
  });

  factory PrescriptionListRes.fromJson(Map<String, dynamic> json) {
    return PrescriptionListRes(
      code: json['code'] is int ? json['code'] : -1,
      status: json['status'] is bool ? json['status'] : false,
      message: json['message'] is String ? json['message'] : "",
      data: json['data'] is List ? List<PrescriptionData>.from(json['data'].map((x) => PrescriptionData.fromJson(x))) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'status': status,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class PrescriptionData {
  int id;
  int appointmentId;
  String encounterDate;
  num totalAmount;
  String appointmentStatus;
  String prescriptionStatus;
  String appointmentPaymentStatus;
  String prescriptionPaymentStatus;
  String userName;
  String userEmail;
  String userImage;
  String prescriptionDate;
  List<int> medicineIds = [];

  PrescriptionData({
    this.id = -1,
    this.appointmentId = -1,
    this.encounterDate = "",
    this.totalAmount = 0,
    this.appointmentStatus = "",
    this.prescriptionStatus = "",
    this.appointmentPaymentStatus = "",
    this.prescriptionPaymentStatus = "",
    this.userName = "",
    this.userEmail = "",
    this.userImage = "",
    this.prescriptionDate = "",
    this.medicineIds = const [],
  });

  factory PrescriptionData.fromJson(Map<String, dynamic> json) {
    return PrescriptionData(
      id: json['id'] is int ? json['id'] : -1,
      appointmentId: json['appointment_id'] is int ? json['appointment_id'] : -1,
      encounterDate: json['encounter_date'] is String ? json['encounter_date'] : "",
      totalAmount: json['total_amount'] is num ? json['total_amount'] : 0,
      appointmentStatus: json['appointment_status'] is String ? json['appointment_status'] : "",
      prescriptionStatus: json['prescription_status'] is String ? json['prescription_status'] : "",
      appointmentPaymentStatus: json['appointment_payment_status'] is String ? json['appointment_payment_status'] : "",
      prescriptionPaymentStatus: json['prescription_payment_status'] is String ? json['prescription_payment_status'] : "",
      userName: json['user_name'] is String ? json['user_name'] : "",
      userEmail: json['user_email'] is String ? json['user_email'] : "",
      userImage: json['user_image'] is String ? json['user_image'] : "",
      prescriptionDate: json['prescription_date'] is String ? json['prescription_date'] : "",
      medicineIds: json['medicine_ids'] is List ? List<int>.from(json['medicine_ids'].map((x) => x)) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'appointment_id': appointmentId,
      'encounter_date': encounterDate,
      'total_amount': totalAmount,
      'appointment_status': appointmentStatus,
      'prescription_status': prescriptionStatus,
      'appointment_payment_status': appointmentPaymentStatus,
      'prescription_payment_status': prescriptionPaymentStatus,
      'user_name': userName,
      'user_email': userEmail,
      'user_image': userImage,
      'prescription_date': prescriptionDate,
      'medicine_ids': medicineIds,
    };
  }
}

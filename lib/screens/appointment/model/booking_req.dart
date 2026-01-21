import 'package:file_picker/file_picker.dart';

class BookingReq {
  String clinicId;
  String serviceId;
  String doctorId;
  String appointmentDate;
  String patientId;
  String status;
  String appointmentType;
  String systemServiceId;
  String centerId;
  String employeeId;
  String appointmentTime;

  //Extra local variables
  String serviceName;
  String doctorName;
  String clinicName;
  String location;

  //Files local variable
  List<PlatformFile> files;

  BookingReq({
    this.clinicId = "",
    this.serviceId = "",
    this.doctorId = "",
    this.appointmentDate = "",
    this.patientId = "",
    this.status = "",
    this.appointmentType = "",
    this.systemServiceId = "",
    this.centerId = "",
    this.employeeId = "",
    this.appointmentTime = "",

    //Extra local variables
    this.serviceName = "",
    this.doctorName = "",
    this.clinicName = "",
    this.location = "",

    //Files local variable
    this.files = const <PlatformFile>[],
  });

  factory BookingReq.fromJson(Map<String, dynamic> json) {
    return BookingReq(
      clinicId: json['clinic_id'] is String ? json['clinic_id'] : "",
      serviceId: json['service_id'] is String ? json['service_id'] : "",
      doctorId: json['doctor_id'] is String ? json['doctor_id'] : "",
      appointmentDate: json['appointment_date'] is String ? json['appointment_date'] : "",
      patientId: json['patient_id'] is String ? json['patient_id'] : "",
      status: json['status'] is String ? json['status'] : "",
      appointmentType: json['appointment_type'] is String ? json['appointment_type'] : "",
      systemServiceId: json['system_service_id'] is String ? json['system_service_id'] : "",
      centerId: json['center_id'] is String ? json['center_id'] : "",
      employeeId: json['employee_id'] is String ? json['employee_id'] : "",
      appointmentTime: json['appointment_time'] is String ? json['appointment_time'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clinic_id': clinicId,
      'service_id': serviceId,
      'doctor_id': doctorId,
      'appointment_date': appointmentDate,
      'patient_id': patientId,
      'status': status,
      'appointment_type': appointmentType,
      'system_service_id': systemServiceId,
      'center_id': centerId,
      'employee_id': employeeId,
      'appointment_time': appointmentTime,
    };
  }
}

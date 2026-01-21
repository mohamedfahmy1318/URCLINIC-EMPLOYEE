import 'package:kivicare_clinic_admin/screens/appointment/model/encounter_detail_model.dart';

import '../add_encounter/model/prescription_model.dart';
import 'medical_reports_res_model.dart';
import 'problems_observations_model.dart';

class EncounterDashboardRes {
  bool status;
  EncounterDashboardDetail data;
  String message;

  EncounterDashboardRes({
    this.status = false,
    required this.data,
    this.message = "",
  });

  factory EncounterDashboardRes.fromJson(Map<String, dynamic> json) {
    return EncounterDashboardRes(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is Map ? EncounterDashboardDetail.fromJson(json['data']) : EncounterDashboardDetail(),
      message: json['message'] is String ? json['message'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.toJson(),
      'message': message,
    };
  }
}

class EncounterDashboardDetail {
  int id;
  String encounterDate;
  int userId;
  String userImage;
  String userName;
  String userEmail;
  String userMobile;
  String userAddress;
  int clinicId;
  String clinicName;
  int doctorId;
  String doctorName;
  String description;
  List<CMNElement> problems;
  List<CMNElement> observations;
  List<CMNElement> notes;
  List<Prescription> prescriptions;
  String otherDetails;
  List<MedicalReport> medicalReport;
  int appointmentId;
  List<BedAllocation> bedAllocations;

  EncounterDashboardDetail({
    this.id = -1,
    this.encounterDate = "",
    this.userId = -1,
    this.userImage = "",
    this.userName = "",
    this.userEmail = "",
    this.userMobile = "",
    this.userAddress = "",
    this.clinicId = -1,
    this.clinicName = "",
    this.doctorId = -1,
    this.doctorName = "",
    this.description = "",
    this.problems = const <CMNElement>[],
    this.observations = const <CMNElement>[],
    this.notes = const <CMNElement>[],
    this.prescriptions = const <Prescription>[],
    this.otherDetails = "",
    this.medicalReport = const <MedicalReport>[],
    this.appointmentId = -1,
    this.bedAllocations = const <BedAllocation>[],
  });

  factory EncounterDashboardDetail.fromJson(Map<String, dynamic> json) {
    return EncounterDashboardDetail(
      id: json['id'] is int ? json['id'] : -1,
      encounterDate: json['encounter_date'] is String ? json['encounter_date'] : "",
      userId: json['user_id'] is int ? json['user_id'] : -1,
      userImage: json['user_image'] is String ? json['user_image'] : "",
      userName: json['user_name'] is String ? json['user_name'] : "",
      userEmail: json['user_email'] is String ? json['user_email'] : "",
      userMobile: json['user_mobile'] is String ? json['user_mobile'] : "",
      userAddress: json['user_address'] is String ? json['user_address'] : "",
      clinicId: json['clinic_id'] is int ? json['clinic_id'] : -1,
      clinicName: json['clinic_name'] is String ? json['clinic_name'] : "",
      doctorId: json['doctor_id'] is int ? json['doctor_id'] : -1,
      doctorName: json['doctor_name'] is String ? json['doctor_name'] : "",
      description: json['description'] is String ? json['description'] : "",
      problems: json['problems'] is List ? List<CMNElement>.from(json['problems'].map((x) => CMNElement.fromJson(x))) : [],
      observations: json['observations'] is List ? List<CMNElement>.from(json['observations'].map((x) => CMNElement.fromJson(x))) : [],
      notes: json['notes'] is List ? List<CMNElement>.from(json['notes'].map((x) => CMNElement.fromJson(x))) : [],
      prescriptions: json['prescriptions'] is List ? List<Prescription>.from(json['prescriptions'].map((x) => Prescription.fromJson(x))) : [],
      otherDetails: json['other_details'] is String ? json['other_details'] : "",
      medicalReport: json['medical_report'] is List ? List<MedicalReport>.from(json['medical_report'].map((x) => MedicalReport.fromJson(x))) : [],
      appointmentId: json['appointment_id'] is int ? json['appointment_id'] : -1,
      bedAllocations: json['bed_allocations'] is List ? List<BedAllocation>.from(json['bed_allocations'].map((x) => BedAllocation.fromJson(x))) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'encounter_date': encounterDate,
      'user_id': userId,
      'user_image': userImage,
      'user_name': userName,
      'user_email': userEmail,
      'user_mobile': userMobile,
      'user_address': userAddress,
      'clinic_id': clinicId,
      'clinic_name': clinicName,
      'doctor_id': doctorId,
      'doctor_name': doctorName,
      'description': description,
      'problems': problems.map((e) => e.toJson()).toList(),
      'observations': observations.map((e) => e.toJson()).toList(),
      'notes': notes.map((e) => e.toJson()).toList(),
      'prescriptions': prescriptions.map((e) => e.toJson()).toList(),
      'other_details': otherDetails,
      'medical_report': medicalReport.map((e) => e.toJson()).toList(),
      'appointment_id': appointmentId,
      'bed_allocations': bedAllocations.map((e) => e.toJson()).toList(),
    };
  }
}

import '../../../utils/constants.dart';
import '../../Encounter/model/medical_reports_res_model.dart';

class AppointmentEncounterDetailModel {
  bool status;
  EncounterData data;
  String message;

  AppointmentEncounterDetailModel({
    this.status = false,
    required this.data,
    this.message = "",
  });

  factory AppointmentEncounterDetailModel.fromJson(Map<String, dynamic> json) {
    return AppointmentEncounterDetailModel(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is Map ? EncounterData.fromJson(json['data']) : EncounterData(),
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

class EncounterData {
  int id;
  String encounterDate;
  int userId;
  String userImage;
  String userName;
  String userEmail;
  String userMobile;
  dynamic userAddress;
  int clinicId;
  String clinicName;
  int doctorId;
  String doctorName;
  String description;
  List<ProblemsData> problems;
  List<ObservationsData> observations;
  List<NotesData> notes;
  List<Prescriptions> prescriptions;
  String otherDetails;
  List<MedicalReport> medicalReport;
  int appointmentId;
  String status;
  int createdBy;
  int updatedBy;
  int deletedBy;
  String createdAt;
  String updatedAt;
  String deletedAt;
  List<BedAllocation> bedAllocations;
  BedAllocation? allocatedBedDetails;

  EncounterData({
    this.id = -1,
    this.encounterDate = "",
    this.userId = -1,
    this.userImage = "",
    this.userName = "",
    this.userEmail = "",
    this.userMobile = "",
    this.userAddress,
    this.clinicId = -1,
    this.clinicName = "",
    this.doctorId = -1,
    this.doctorName = "",
    this.description = "",
    this.problems = const <ProblemsData>[],
    this.observations = const <ObservationsData>[],
    this.notes = const <NotesData>[],
    this.prescriptions = const <Prescriptions>[],
    this.otherDetails = "",
    this.medicalReport = const <MedicalReport>[],
    this.appointmentId = -1,
    this.status = EncounterStatus.ACTIVE,
    this.createdBy = -1,
    this.updatedBy = -1,
    this.deletedBy = -1,
    this.createdAt = "",
    this.updatedAt = "",
    this.deletedAt = "",
    this.bedAllocations = const <BedAllocation>[],
    this.allocatedBedDetails,
  });

  factory EncounterData.fromJson(Map<String, dynamic> json) {
    return EncounterData(
      id: json['id'] is int ? json['id'] : -1,
      encounterDate: json['encounter_date'] is String ? json['encounter_date'] : "",
      userId: json['user_id'] is int ? json['user_id'] : -1,
      userImage: json['user_image'] is String ? json['user_image'] : "",
      userName: json['user_name'] is String ? json['user_name'] : "",
      userEmail: json['user_email'] is String ? json['user_email'] : "",
      userMobile: json['user_mobile'] is String ? json['user_mobile'] : "",
      userAddress: json['user_address'],
      clinicId: json['clinic_id'] is int ? json['clinic_id'] : -1,
      clinicName: json['clinic_name'] is String ? json['clinic_name'] : "",
      doctorId: json['doctor_id'] is int ? json['doctor_id'] : -1,
      doctorName: json['doctor_name'] is String ? json['doctor_name'] : "",
      description: json['description'] is String ? json['description'] : "",
      problems: json['problems'] is List ? List<ProblemsData>.from(json['problems'].map((x) => ProblemsData.fromJson(x))) : [],
      observations: json['observations'] is List ? List<ObservationsData>.from(json['observations'].map((x) => ObservationsData.fromJson(x))) : [],
      notes: json['notes'] is List ? List<NotesData>.from(json['notes'].map((x) => NotesData.fromJson(x))) : [],
      prescriptions: json['prescriptions'] is List ? List<Prescriptions>.from(json['prescriptions'].map((x) => Prescriptions.fromJson(x))) : [],
      otherDetails: json['other_details'] is String ? json['other_details'] : "",
      medicalReport: json['medical_report'] is List ? List<MedicalReport>.from(json['medical_report'].map((x) => MedicalReport.fromJson(x))) : [],
      appointmentId: json['appointment_id'] is int ? json['appointment_id'] : -1,
      status: json['status'] is int
          ? json['status'] == 1
              ? EncounterStatus.ACTIVE
              : json['status'] == 0
                  ? EncounterStatus.CLOSED
                  : EncounterStatus.CLOSED
          : EncounterStatus.CLOSED,
      createdBy: json['created_by'] is int ? json['created_by'] : -1,
      updatedBy: json['updated_by'] is int ? json['updated_by'] : -1,
      deletedBy: json['deleted_by'] is int ? json['updated_by'] : -1,
      createdAt: json['created_at'] is String ? json['created_at'] : "",
      updatedAt: json['updated_at'] is String ? json['updated_at'] : "",
      deletedAt: json['deleted_at'] is String ? json['updated_at'] : "",
      bedAllocations: json['bed_allocations'] is List ? List<BedAllocation>.from(json['bed_allocations'].map((x) => BedAllocation.fromJson(x))) : [],
      allocatedBedDetails: (json['bed_allocations'] is List && json['bed_allocations'].isNotEmpty) ? BedAllocation.fromJson(json['bed_allocations'][0]) : null,
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
      'status': status,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'deleted_by': deletedBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'bed_allocations': bedAllocations.map((e) => e.toJson()).toList(),
      'allocated_bed_details': allocatedBedDetails?.toJson(),
    };
  }
}

class ProblemsData {
  int id;
  int encounterId;
  int userId;
  String type;
  String title;
  int isFromTemplate;

  ProblemsData({
    this.id = -1,
    this.encounterId = -1,
    this.userId = -1,
    this.type = "",
    this.title = "",
    this.isFromTemplate = -1,
  });

  factory ProblemsData.fromJson(Map<String, dynamic> json) {
    return ProblemsData(
      id: json['id'] is int ? json['id'] : -1,
      encounterId: json['encounter_id'] is int ? json['encounter_id'] : -1,
      userId: json['user_id'] is int ? json['user_id'] : -1,
      type: json['type'] is String ? json['type'] : "",
      title: json['title'] is String ? json['title'] : "",
      isFromTemplate: json['is_from_template'] is int ? json['is_from_template'] : -1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'encounter_id': encounterId,
      'user_id': userId,
      'type': type,
      'title': title,
      'is_from_template': isFromTemplate,
    };
  }
}

class ObservationsData {
  int id;
  int encounterId;
  int userId;
  String type;
  String title;
  int isFromTemplate;

  ObservationsData({
    this.id = -1,
    this.encounterId = -1,
    this.userId = -1,
    this.type = "",
    this.title = "",
    this.isFromTemplate = -1,
  });

  factory ObservationsData.fromJson(Map<String, dynamic> json) {
    return ObservationsData(
      id: json['id'] is int ? json['id'] : -1,
      encounterId: json['encounter_id'] is int ? json['encounter_id'] : -1,
      userId: json['user_id'] is int ? json['user_id'] : -1,
      type: json['type'] is String ? json['type'] : "",
      title: json['title'] is String ? json['title'] : "",
      isFromTemplate: json['is_from_template'] is int ? json['is_from_template'] : -1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'encounter_id': encounterId,
      'user_id': userId,
      'type': type,
      'title': title,
      'is_from_template': isFromTemplate,
    };
  }
}

class NotesData {
  int id;
  int encounterId;
  int userId;
  String type;
  String title;
  int isFromTemplate;

  NotesData({
    this.id = -1,
    this.encounterId = -1,
    this.userId = -1,
    this.type = "",
    this.title = "",
    this.isFromTemplate = -1,
  });

  factory NotesData.fromJson(Map<String, dynamic> json) {
    return NotesData(
      id: json['id'] is int ? json['id'] : -1,
      encounterId: json['encounter_id'] is int ? json['encounter_id'] : -1,
      userId: json['user_id'] is int ? json['user_id'] : -1,
      type: json['type'] is String ? json['type'] : "",
      title: json['title'] is String ? json['title'] : "",
      isFromTemplate: json['is_from_template'] is int ? json['is_from_template'] : -1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'encounter_id': encounterId,
      'user_id': userId,
      'type': type,
      'title': title,
      'is_from_template': isFromTemplate,
    };
  }
}

class Prescriptions {
  int id;
  int encounterId;
  int userId;
  String name;
  String frequency;
  String duration;
  String instruction;

  Prescriptions({
    this.id = -1,
    this.encounterId = -1,
    this.userId = -1,
    this.name = "",
    this.frequency = "",
    this.duration = "",
    this.instruction = "",
  });

  factory Prescriptions.fromJson(Map<String, dynamic> json) {
    return Prescriptions(
      id: json['id'] is int ? json['id'] : -1,
      encounterId: json['encounter_id'] is int ? json['encounter_id'] : -1,
      userId: json['user_id'] is int ? json['user_id'] : -1,
      name: json['name'] is String ? json['name'] : "",
      frequency: json['frequency'] is String ? json['frequency'] : "",
      duration: json['duration'] is String ? json['duration'] : "",
      instruction: json['instruction'] is String ? json['instruction'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'encounter_id': encounterId,
      'user_id': userId,
      'name': name,
      'frequency': frequency,
      'duration': duration,
      'instruction': instruction,
    };
  }
}

class BedAllocation {
  int id;
  int patientId;
  int bedMasterId;
  int? bedTypeId;
  String? bedMasterName;
  String bedTypeName;
  String bed;
  String assignDate;
  String dischargeDate;
  bool status;
  String? description;
  double? temperature;
  String? symptoms;
  String? notes;
  double? weight;
  double? height;
  String? bloodPressure;
  int? heartRate;
  String? bloodGroup;
  bool paymentStatus;
  double charge;
  num perDayCharge;
  String createdAt;
  String updatedAt;
  String? deletedAt;

  BedAllocation({
    this.id = -1,
    this.patientId = -1,
    this.bedMasterId = -1,
    this.bedTypeId,
    this.bedMasterName,
    this.bedTypeName = "",
    this.bed = "",
    this.assignDate = "",
    this.dischargeDate = "",
    this.status = false,
    this.description,
    this.temperature,
    this.symptoms,
    this.notes,
    this.weight,
    this.height,
    this.bloodPressure,
    this.heartRate,
    this.bloodGroup,
    this.paymentStatus = false,
    this.charge = 0.0,
    this.createdAt = "",
    this.updatedAt = "",
    this.deletedAt,
    this.perDayCharge = 0,
  });

  factory BedAllocation.fromJson(Map<String, dynamic> json) {
    return BedAllocation(
      id: json['bed_allocation_id'] is int ? json['bed_allocation_id'] : -1,
      patientId: json['patient_id'] ?? -1,
      bedMasterId: json['bed_master_id'] ?? -1,
      bedTypeId: json['bed_type_id'],
      bedMasterName: json['bed_master_name'],
      bedTypeName: json['bed_type'] is String ? json['bed_type'] : '',
      bed: json['bed_name'] is String ? json['bed_name'] : "",
      assignDate: json['assign_date'] ?? "",
      dischargeDate: json['discharge_date'] ?? "",
      status: json['status'] ?? false,
      description: json['description'],
      temperature: json['temperature'] != null ? (json['temperature'] as num).toDouble() : null,
      symptoms: json['symptoms'],
      notes: json['notes'],
      weight: json['weight'] is String ? double.tryParse(json['weight']) : json['weight']?.toDouble(),
      height: json['height'] is String ? double.tryParse(json['height']) : json['height']?.toDouble(),
      bloodPressure: json['blood_pressure'],
      heartRate: json['heart_rate'] is String ? int.tryParse(json['heart_rate']) : (json['heart_rate'] is int ? json['heart_rate'] : null),
      bloodGroup: json['blood_group'],
      paymentStatus: json['payment_status'] ?? false,
      charge: json['charge'] != null ? (json['charge'] as num).toDouble() : 0.0,
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
      deletedAt: json['deleted_at'],
      perDayCharge: json['per_day_charge'] is num ? json['per_day_charge'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patient_id': patientId,
      'bed_master_id': bedMasterId,
      'bed_type_id': bedTypeId,
      'bed_master_name': bedMasterName,
      'bed_type_name': bedTypeName,
      'bed': bed,
      'assign_date': assignDate,
      'discharge_date': dischargeDate,
      'status': status,
      'description': description,
      'temperature': temperature,
      'symptoms': symptoms,
      'notes': notes,
      'weight': weight,
      'height': height,
      'blood_pressure': bloodPressure,
      'heart_rate': heartRate,
      'blood_group': bloodGroup,
      'payment_status': paymentStatus,
      'charge': charge,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'per_day_charge': perDayCharge,
    };
  }
}

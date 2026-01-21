class BedMasterModel {
  int id;
  String bed;
  dynamic bedId;
  String bedTypeId;
  String bedTypeName;
  num charges;
  int capacity;
  String description;
  bool status;
  String statusText;
  String bedStatus;
  bool isUnderMaintenance;
  String maintenanceText;
  int? patientId;
  String? patientName;
  int clinicId;

  BedMasterModel({
    this.id = -1,
    this.bed = "",
    this.bedId,
    this.bedTypeId = "",
    this.bedTypeName = "",
    this.charges = -1,
    this.capacity = -1,
    this.description = "",
    this.status = false,
    this.statusText = "",
    this.bedStatus = "",
    this.isUnderMaintenance = false,
    this.maintenanceText = "",
    this.patientId,
    this.patientName = "",
    this.clinicId = -1,
  });

  factory BedMasterModel.fromJson(Map<String, dynamic> json) {
    return BedMasterModel(
      id: json['id'] is int ? json['id'] : -1,
      bed: json['bed'] is String ? json['bed'] : "",
      bedId: json['bed_id'],
      bedTypeId: json['bed_type_id'] is String ? json['bed_type_id'] : "",
      bedTypeName: json['bed_type_name'] is String ? json['bed_type_name'] : "",
      charges: json['charges'] is num ? json['charges'] : -1,
      capacity: json['capacity'] is int ? json['capacity'] : -1,
      description: json['description'] is String ? json['description'] : "",
      status: json['status'] is bool ? json['status'] : false,
      statusText: json['status_text'] is String ? json['status_text'] : "",
      bedStatus: json['bed_status'] is String ? json['bed_status'] : "",
      isUnderMaintenance: json['is_under_maintenance'] is bool ? json['is_under_maintenance'] : false,
      maintenanceText: json['maintenance_text'] is String ? json['maintenance_text'] : "",
      patientId: json['patient_id'] is String ? int.tryParse(json['patient_id']) : (json['patient_id'] is int ? json['patient_id'] : null),
      patientName: json['patient_name']?.toString(),
      clinicId: json['clinic_id'] is int ? json['clinic_id'] : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bed': bed,
      'bed_id': bedId,
      'bed_type_name': bedTypeName,
      'bed_type_id': bedTypeId,
      'charges': charges,
      'capacity': capacity,
      'description': description,
      'status': status,
      'status_text': statusText,
      'bed_status': bedStatus,
      'is_under_maintenance': isUnderMaintenance,
      'maintenance_text': maintenanceText,
      'patient_id': patientId,
      'patient_name': patientName,
      'clinic_id' : clinicId,
    };
  }
}

class BedAllocationModel {
  int id;
  String token;
  String patientEncounterId;
  String bedTypeId;
  String bedTypeName;
  String roomNo;
  String assignDate;
  String dischargeDate;
  String description;
  dynamic weight;
  dynamic height;
  dynamic bloodPressure;
  dynamic heartRate;
  dynamic bloodGroup;
  dynamic temperature;
  dynamic symptoms;
  dynamic notes;
  String? bed;
  String? bedStatus;
  final bool? isUnderMaintenance;
  int? bedId;

  BedAllocationModel({
    this.id = 0,
    this.token = "",
    this.patientEncounterId = "",
    this.bedTypeId = "",
    this.bedTypeName = "",
    this.roomNo = "",
    this.assignDate = "",
    this.dischargeDate = "",
    this.description = "",
    this.weight,
    this.height,
    this.bloodPressure,
    this.heartRate,
    this.bloodGroup,
    this.temperature,
    this.symptoms,
    this.notes,
    this.bed,
    this.bedStatus,
    this.isUnderMaintenance,
    this.bedId,
  });

  factory BedAllocationModel.fromJson(Map<String, dynamic> json) {
    return BedAllocationModel(
      token: json['_token'] is String ? json['_token'] : "",
      id: json['id'] is int ? json['id'] : -1,
      patientEncounterId: json['patient_encounter_id'] is String ? json['patient_encounter_id'] : "",
      bedTypeId: json['bed_type_id'] is String ? json['bed_type_id'] : "",
      bedTypeName: json['bed_type_name'] is String ? json['bed_type_name'] : "",
      roomNo: json['room_no'] is String ? json['room_no'] : "",
      assignDate: json['assign_date'] is String ? json['assign_date'] : "",
      dischargeDate: json['discharge_date'] is String ? json['discharge_date'] : "",
      description: json['description'] is String ? json['description'] : "",
      weight: json['weight'],
      height: json['height'],
      bloodPressure: json['blood_pressure'],
      heartRate: json['heart_rate'],
      bloodGroup: json['blood_group'],
      temperature: json['temperature'],
      symptoms: json['symptoms'],
      notes: json['notes'],
      bed: json['bed'],
      bedStatus: json['bed_status'],
      isUnderMaintenance: json['is_under_maintenance'] == true || json['is_under_maintenance'] == 1,
      bedId: json['bed_id'] is String ? int.tryParse(json['bed_id']) : (json['bed_id'] is int ? json['bed_id'] : null),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_token': token,
      'patient_encounter_id': patientEncounterId,
      'bed_type_id': bedTypeId,
      'bed_type_name': bedTypeName,
      'room_no': roomNo,
      'assign_date': assignDate,
      'discharge_date': dischargeDate,
      'description': description,
      'weight': weight,
      'height': height,
      'blood_pressure': bloodPressure,
      'heart_rate': heartRate,
      'blood_group': bloodGroup,
      'temperature': temperature,
      'symptoms': symptoms,
      'notes': notes,
      'bed': bed,
      'bed_status': bedStatus,
      'bed_id': bedId,
    };
  }
}

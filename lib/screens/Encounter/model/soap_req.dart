class SOAPReq {
  String subjective;
  String objective;
  String assessment;
  String plan;
  int appointmentId;
  int encounterId;
  int patientId;

  SOAPReq({
    this.subjective = "",
    this.objective = "",
    this.assessment = "",
    this.plan = "",
    this.appointmentId = -1,
    this.encounterId = -1,
    this.patientId = -1,
  });

  factory SOAPReq.fromJson(Map<String, dynamic> json) {
    return SOAPReq(
      subjective: json['subjective'] is String ? json['subjective'] : "",
      objective: json['objective'] is String ? json['objective'] : "",
      assessment: json['assessment'] is String ? json['assessment'] : "",
      plan: json['plan'] is String ? json['plan'] : "",
      appointmentId: json['appointment_id'] is int ? json['appointment_id'] : -1,
      encounterId: json['encounter_id'] is int ? json['encounter_id'] : -1,
      patientId: json['patient_id'] is int ? json['patient_id'] : -1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subjective': subjective,
      'objective': objective,
      'assessment': assessment,
      'plan': plan,
      'encounter_id': encounterId,
      'patient_id': patientId,
      if (!appointmentId.isNegative) 'appointment_id': appointmentId,
    };
  }
}

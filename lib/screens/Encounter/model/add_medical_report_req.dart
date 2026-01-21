class AddMedicalReportReq {
  String name;
  String encounterId;
  String userId;
  String date;

  // String specialty;

  AddMedicalReportReq({
    this.name = "",
    this.encounterId = "",
    this.userId = "",
    this.date = "",
  });

  factory AddMedicalReportReq.fromJson(Map<String, dynamic> json) {
    return AddMedicalReportReq(
      name: json['name'] is String ? json['name'] : "",
      encounterId: json['encounter_id'] is String ? json['encounter_id'] : "",
      userId: json['user_id'] is String ? json['user_id'] : "",
      date: json['date'] is String ? json['date'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'encounter_id': encounterId,
      'user_id': userId,
      'date': date,
    };
  }
}

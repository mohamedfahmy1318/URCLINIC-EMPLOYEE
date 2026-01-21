class EncounterNote {
  int id;
  int encounterId;
  int userId;
  String type;
  String title;
  int isFromTemplate;

  EncounterNote({
    this.id = -1,
    this.encounterId = -1,
    this.userId = -1,
    this.type = "",
    this.title = "",
    this.isFromTemplate = -1,
  });

  factory EncounterNote.fromJson(Map<String, dynamic> json) {
    return EncounterNote(
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

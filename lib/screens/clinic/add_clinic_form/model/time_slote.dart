class TimeSlotMinResponse {
  int id;
  String name;
  String value;

  TimeSlotMinResponse({
    this.id = -1,
    this.name = "",
    this.value = "",
  });

  factory TimeSlotMinResponse.fromJson(Map<String, dynamic> json) {
    return TimeSlotMinResponse(
      id: json['id'] is int ? json['id'] : -1,
      name: json['name'] is String ? json['name'] : "",
      value: json['value'] is String ? json['value'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'value': value,
    };
  }
}

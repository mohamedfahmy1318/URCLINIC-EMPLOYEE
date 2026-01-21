class BedTypeModel {
  int id;
  String type;
  String description;

  BedTypeModel({
    this.id = -1,
    this.type = "",
    this.description = "",
  });

  factory BedTypeModel.fromJson(Map<String, dynamic> json) {
    return BedTypeModel(
      id: json['id'] is int ? json['id'] : -1,
      type: json['type'] is String ? json['type'] : "",
      description: json['description'] is String ? json['description'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'description': description,
    };
  }
}

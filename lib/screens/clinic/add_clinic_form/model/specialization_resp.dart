class SpecializationResp {
  bool status;
  List<SpecializationModel> data;
  String message;

  SpecializationResp({
    this.status = false,
    this.data = const <SpecializationModel>[],
    this.message = "",
  });

  factory SpecializationResp.fromJson(Map<String, dynamic> json) {
    return SpecializationResp(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is List ? List<SpecializationModel>.from(json['data'].map((x) => SpecializationModel.fromJson(x))) : [],
      message: json['message'] is String ? json['message'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.map((e) => e.toJson()).toList(),
      'message': message,
    };
  }
}

class SpecializationModel {
  int id;
  String name;
  dynamic parentId;
  dynamic categoryName;
  int status;
  dynamic isFeatured;
  String specializationImage;
  dynamic createdBy;
  dynamic updatedBy;
  dynamic deletedBy;
  String createdAt;
  String updatedAt;
  dynamic deletedAt;

  SpecializationModel({
    this.id = -1,
    this.name = "",
    this.parentId,
    this.categoryName,
    this.status = -1,
    this.isFeatured,
    this.specializationImage = "",
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
    this.createdAt = "",
    this.updatedAt = "",
    this.deletedAt,
  });

  factory SpecializationModel.fromJson(Map<String, dynamic> json) {
    return SpecializationModel(
      id: json['id'] is int ? json['id'] : -1,
      name: json['name'] is String ? json['name'] : "",
      parentId: json['parent_id'],
      categoryName: json['category_name'],
      status: json['status'] is int ? json['status'] : -1,
      isFeatured: json['is_featured'],
      specializationImage: json['specialization_image'] is String ? json['specialization_image'] : "",
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      deletedBy: json['deleted_by'],
      createdAt: json['created_at'] is String ? json['created_at'] : "",
      updatedAt: json['updated_at'] is String ? json['updated_at'] : "",
      deletedAt: json['deleted_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'parent_id': parentId,
      'category_name': categoryName,
      'status': status,
      'is_featured': isFeatured,
      'specialization_image': specializationImage,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'deleted_by': deletedBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}

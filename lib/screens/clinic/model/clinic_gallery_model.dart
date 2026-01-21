class ClinicGalleryModel {
  bool status;
  List<GalleryData> data;
  String message;

  ClinicGalleryModel({
    this.status = false,
    this.data = const <GalleryData>[],
    this.message = "",
  });

  factory ClinicGalleryModel.fromJson(Map<String, dynamic> json) {
    return ClinicGalleryModel(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is List ? List<GalleryData>.from(json['data'].map((x) => GalleryData.fromJson(x))) : [],
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

class GalleryData {
  int id;
  int clinicId;
  int status;
  String fullUrl;
  int createdBy;
  int updatedBy;
  int deletedBy;
  String createdAt;
  String updatedAt;
  String deletedAt;

  GalleryData({
    this.id = -1,
    this.clinicId = -1,
    this.status = -1,
    this.fullUrl = "",
    this.createdBy = -1,
    this.updatedBy = -1,
    this.deletedBy = -1,
    this.createdAt = "",
    this.updatedAt = "",
    this.deletedAt = "",
  });

  factory GalleryData.fromJson(Map<String, dynamic> json) {
    return GalleryData(
      id: json['id'] is int ? json['id'] : -1,
      clinicId: json['clinic_id'] is int ? json['clinic_id'] : -1,
      status: json['status'] is int ? json['status'] : -1,
      fullUrl: json['full_url'] is String ? json['full_url'] : "",
      createdBy: json['created_by'] is int ? json['created_by'] : -1,
      updatedBy: json['updated_by'] is int ? json['updated_by'] : -1,
      deletedBy: json['deleted_by'] is int ? json['updated_by'] : -1,
      createdAt: json['created_at'] is String ? json['created_at'] : "",
      updatedAt: json['updated_at'] is String ? json['updated_at'] : "",
      deletedAt: json['deleted_at'] is String ? json['updated_at'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clinic_id': clinicId,
      'status': status,
      'full_url': fullUrl,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'deleted_by': deletedBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}

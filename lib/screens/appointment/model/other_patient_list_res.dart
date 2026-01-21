import '../../auth/model/login_response.dart';

class OtherPatientListRes {
  bool status;
  List<UserData> data;
  String message;

  OtherPatientListRes({
    this.status = false,
    this.data = const <UserData>[],
    this.message = "",
  });

  factory OtherPatientListRes.fromJson(Map<String, dynamic> json) {
    return OtherPatientListRes(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is List ? List<UserData>.from(json['data'].map((x) => UserData.fromJson(x))) : [],
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

class Media {
  final int id;
  final String modelType;
  final int modelId;
  final String uuid;
  final String collectionName;
  final String name;
  final String fileName;
  final String mimeType;
  final String disk;
  final String conversionsDisk;
  final int size;
  final List<dynamic> manipulations;
  final List<dynamic> customProperties;
  final List<dynamic> generatedConversions;
  final List<dynamic> responsiveImages;
  final int orderColumn;
  final String createdAt;
  final String updatedAt;
  final String originalUrl;
  final String? previewUrl;

  Media({
    required this.id,
    required this.modelType,
    required this.modelId,
    required this.uuid,
    required this.collectionName,
    required this.name,
    required this.fileName,
    required this.mimeType,
    required this.disk,
    required this.conversionsDisk,
    required this.size,
    required this.manipulations,
    required this.customProperties,
    required this.generatedConversions,
    required this.responsiveImages,
    required this.orderColumn,
    required this.createdAt,
    required this.updatedAt,
    required this.originalUrl,
    this.previewUrl,
  });

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      id: json['id'] ?? "",
      modelType: json['model_type'] ?? "",
      modelId: json['model_id'] ?? "",
      uuid: json['uuid'] ?? "",
      collectionName: json['collection_name'] ?? "",
      name: json['name'] ?? "",
      fileName: json['file_name'] ?? "",
      mimeType: json['mime_type'] ?? "",
      disk: json['disk'] ?? "",
      conversionsDisk: json['conversions_disk'] ?? "",
      size: json['size'] ?? "",
      manipulations: json['manipulations'] ?? [],
      customProperties: json['custom_properties'] ?? [],
      generatedConversions: json['generated_conversions'] ?? [],
      responsiveImages: json['responsive_images'] ?? [],
      orderColumn: json['order_column'] ?? "",
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
      originalUrl: json['original_url'] ?? "",
      previewUrl: json['preview_url'] ?? "",
    );
  }
}

class PatientDetails {
  final int id;
  final int userId;
  final String firstName;
  final String lastName;
  final String dob;
  final String gender;
  final String relation;
  final String contactNumber;
  final String subtitle;
  final String profileImageUrl;
  final String createdAt;
  final String updatedAt;

  PatientDetails({
    required this.id,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.dob,
    required this.gender,
    required this.relation,
    required this.contactNumber,
    required this.subtitle,
    required this.profileImageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PatientDetails.fromJson(Map<String, dynamic> json) {
    return PatientDetails(
      id: json['id'] ?? "",
      userId: json['user_id'] ?? "",
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      dob: json['dob'] ?? '',
      gender: json['gender'] ?? '',
      relation: json['relation'] ?? '',
      contactNumber: json['contactNumber'] ?? '',
      subtitle: json['subtitle'] ?? '',
      profileImageUrl: json['profile_image'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

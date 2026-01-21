class ClinicListRes {
  bool status;
  List<ClinicData> data;
  String message;

  ClinicListRes({
    this.status = false,
    this.data = const <ClinicData>[],
    this.message = "",
  });

  factory ClinicListRes.fromJson(Map<String, dynamic> json) {
    return ClinicListRes(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is List ? List<ClinicData>.from(json['data'].map((x) => ClinicData.fromJson(x))) : [],
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

class ClinicData {
  int id;
  String slug;
  String name;
  String email;
  String description;
  int systemServiceCategory;
  String specialty;
  String contactNumber;
  int countryId;
  int stateId;
  int cityId;
  String countryName;
  String stateName;
  String cityName;
  String address;
  String pincode;
  String latitude;
  String longitude;
  String distance;
  String distanceFormate;
  int status;
  String clinicImage;
  String clinicStatus;
  int timeSlot;
  int totalServices;
  int totalDoctors;
  int totalGalleryImages;
  int createdBy;
  int updatedBy;
  int deletedBy;
  String createdAt;
  String updatedAt;
  String deletedAt;

  ClinicData({
    this.id = -1,
    this.slug = "",
    this.name = "",
    this.email = "",
    this.description = "",
    this.systemServiceCategory = -1,
    this.specialty = "",
    this.contactNumber = "",
    this.countryId = -1,
    this.stateId = -1,
    this.cityId = -1,
    this.countryName = "",
    this.stateName = "",
    this.cityName = "",
    this.address = "",
    this.pincode = "",
    this.latitude = "",
    this.longitude = "",
    this.distance = "",
    this.distanceFormate = "",
    this.status = -1,
    this.clinicImage = "",
    this.clinicStatus = "",
    this.timeSlot = -1,
    this.totalServices = 0,
    this.totalDoctors = 0,
    this.totalGalleryImages = 0,
    this.createdBy = -1,
    this.updatedBy = -1,
    this.deletedBy = -1,
    this.createdAt = "",
    this.updatedAt = "",
    this.deletedAt = "",
  });

  factory ClinicData.fromJson(Map<String, dynamic> json) {
    return ClinicData(
      id: json['id'] is int ? json['id'] : -1,
      slug: json['slug'] is String ? json['slug'] : "",
      name: json['name'] is String ? json['name'] : "",
      email: json['email'] is String ? json['email'] : "",
      description: json['description'] is String ? json['description'] : "",
      systemServiceCategory: json['system_service_category'] is int ? json['system_service_category'] : -1,
      specialty: json['specialty'] is String ? json['specialty'] : "",
      contactNumber: json['contact_number'] is String ? json['contact_number'] : "",
      countryId: json['country_id'] is int ? json['country_id'] : -1,
      stateId: json['state_id'] is int ? json['state_id'] : -1,
      cityId: json['city_id'] is int ? json['city_id'] : -1,
      countryName: json['country_name'] is String ? json['country_name'] : "",
      stateName: json['state_name'] is String ? json['state_name'] : "",
      cityName: json['city_name'] is String ? json['city_name'] : "",
      address: json['address'] is String ? json['address'] : "",
      pincode: json['pincode'] is String ? json['pincode'] : "",
      latitude: json['latitude'] is String ? json['latitude'] : "",
      longitude: json['longitude'] is String ? json['longitude'] : "",
      distance: json['distance'] is String ? json['distance'] : "",
      distanceFormate: json['distance_formate'] is String ? json['distance_formate'] : "",
      status: json['status'] is int ? json['status'] : -1,
      clinicImage: json['clinic_image'] is String ? json['clinic_image'] : "",
      clinicStatus: json['clinic_status'] is String ? json['clinic_status'] : "",
      timeSlot: json['time_slot'] is int ? json['time_slot'] : -1,
      totalServices: json['total_services'] is int ? json['total_services'] : 0,
      totalDoctors: json['total_doctors'] is int ? json['total_doctors'] : 0,
      totalGalleryImages: json['total_gallery_images'] is int ? json['total_gallery_images'] : 0,
      updatedBy: json['updated_by'] is int ? json['updated_by'] : -1,
      deletedBy: json['deleted_by'] is int ? json['deleted_by'] : -1,
      createdBy: json['created_by'] is int ? json['created_by'] : -1,
      createdAt: json['created_at'] is String ? json['created_at'] : "",
      updatedAt: json['updated_at'] is String ? json['updated_at'] : "",
      deletedAt: json['deleted_at'] is String ? json['deleted_at'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slug': slug,
      'name': name,
      'email': email,
      'description': description,
      'system_service_category': systemServiceCategory,
      'specialty': specialty,
      'contact_number': contactNumber,
      'country_id': countryId,
      'state_id': stateId,
      'city_id': cityId,
      'country_name': countryName,
      'state_name': stateName,
      'city_name': cityName,
      'address': address,
      'pincode': pincode,
      'latitude': latitude,
      'longitude': longitude,
      'distance': distance,
      'distance_formate': distanceFormate,
      'status': status,
      'clinic_image': clinicImage,
      'clinic_status': clinicStatus,
      'time_slot': timeSlot,
      'total_services': totalServices,
      'total_doctors': totalDoctors,
      'total_gallery_images': totalGalleryImages,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'deleted_by': deletedBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}

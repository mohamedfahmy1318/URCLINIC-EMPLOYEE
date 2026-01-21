import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'qualification_model.dart';

class DoctorListRes {
  bool status;
  List<Doctor> data;
  String message;

  DoctorListRes({
    this.status = false,
    this.data = const <Doctor>[],
    this.message = "",
  });

  factory DoctorListRes.fromJson(Map<String, dynamic> json) {
    return DoctorListRes(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is List ? List<Doctor>.from(json['data'].map((x) => Doctor.fromJson(x))) : [],
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

/*class Doctor {
  int id;
  int doctorId;
  String firstName;
  String lastName;
  String fullName;
  String email;
  String mobile;
  String gender;
  String expert;
  String dateOfBirth;
  String emailVerifiedAt;
  String profileImage;
  String experience;
  int status;
  int isBanned;
  int isManager;
  int showInCalender;
  String createdAt;
  String updatedAt;
  String deletedAt;
  String aboutSelf;
  String facebookLink;
  String instagramLink;
  String twitterLink;
  String dribbbleLink;
  String averageRating;

  //Local Vars
  RxBool isSelected = false.obs;
  TextEditingController charges = TextEditingController();

  Doctor({
    this.id = -1,
    this.doctorId = -1,
    this.firstName = "",
    this.lastName = "",
    this.fullName = "",
    this.email = "",
    this.mobile = "",
    this.gender = "",
    this.expert = "",
    this.dateOfBirth = "",
    this.emailVerifiedAt = "",
    this.profileImage = "",
    this.experience = "",
    this.status = -1,
    this.isBanned = -1,
    this.isManager = -1,
    this.showInCalender = -1,
    this.createdAt = "",
    this.updatedAt = "",
    this.deletedAt = "",
    this.aboutSelf = "",
    this.facebookLink = "",
    this.instagramLink = "",
    this.twitterLink = "",
    this.dribbbleLink = "",
    this.averageRating = "",
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'] is int ? json['id'] : -1,
      doctorId: json['doctor_id'] is int ? json['doctor_id'] : -1,
      firstName: json['first_name'] is String ? json['first_name'] : "",
      lastName: json['last_name'] is String ? json['last_name'] : "",
      fullName: json['full_name'] is String ? json['full_name'] : "",
      email: json['email'] is String ? json['email'] : "",
      mobile: json['mobile'] is String ? json['mobile'] : "",
      gender: json['gender'] is String ? json['gender'] : "",
      expert: json['expert'] is String ? json['expert'] : "",
      dateOfBirth: json['date_of_birth'] is String ? json['date_of_birth'] : "",
      emailVerifiedAt: json['email_verified_at'] is String ? json['email_verified_at'] : "",
      profileImage: json['profile_image'] is String ? json['profile_image'] : "",
      experience: json['experience'] is String ? json['experience'] : "",
      status: json['status'] is int ? json['status'] : -1,
      isBanned: json['is_banned'] is int ? json['is_banned'] : -1,
      isManager: json['is_manager'] is int ? json['is_manager'] : -1,
      showInCalender: json['show_in_calender'] is int ? json['show_in_calender'] : -1,
      createdAt: json['created_at'] is String ? json['created_at'] : "",
      updatedAt: json['updated_at'] is String ? json['updated_at'] : "",
      deletedAt: json['deleted_at'] is String ? json['deleted_at'] : "",
      aboutSelf: json['about_self'] is String ? json['about_self'] : "",
      facebookLink: json['facebook_link'] is String ? json['facebook_link'] : "",
      instagramLink: json['instagram_link'] is String ? json['instagram_link'] : "",
      twitterLink: json['twitter_link'] is String ? json['twitter_link'] : "",
      dribbbleLink: json['dribbble_link'] is String ? json['dribbble_link'] : "",
      averageRating: json['average_rating'] is String ? json['average_rating'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctor_id': doctorId,
      'first_name': firstName,
      'last_name': lastName,
      'full_name': fullName,
      'email': email,
      'mobile': mobile,
      'gender': gender,
      'expert': expert,
      'date_of_birth': dateOfBirth,
      'email_verified_at': emailVerifiedAt,
      'profile_image': profileImage,
      'experience': experience,
      'status': status,
      'is_banned': isBanned,
      'is_manager': isManager,
      'show_in_calender': showInCalender,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'about_self': aboutSelf,
      'facebook_link': facebookLink,
      'instagram_link': instagramLink,
      'twitter_link': twitterLink,
      'dribbble_link': dribbbleLink,
      'average_rating': averageRating,
    };
  }
}
*/
class Doctor {
  int id;
  int doctorId;
  String firstName;
  String lastName;
  String fullName;
  String email;
  String mobile;
  int playerId; //
  String gender;
  String expert;
  String dateOfBirth;
  String emailVerifiedAt;
  int status;
  int isBanned;
  int isManager;
  String aboutSelf;
  String facebookLink;
  String instagramLink;
  String twitterLink;
  String dribbbleLink;
  int countryId;
  int stateId;
  int cityId;
  String countryName;
  String stateName;
  String cityName;
  List<Services> services;
  List<Clinics> clinics;
  List<Commissions> commissions;
  String address;
  String pincode;
  String latitude;
  String longitude;
  String description;
  String signature;
  String experience;
  String profileImage;
  int createdBy;
  int updatedBy;
  int deletedBy;
  String createdAt;
  String updatedAt;
  String deletedAt;
  int totalServices;
  int totalReviews;
  num averageRating;
  List<Qualifications> qualifications;

  //Local Vars
  RxBool isSelected = false.obs;
  TextEditingController charges = TextEditingController();

  Doctor({
    this.id = -1,
    this.doctorId = -1,
    this.firstName = "",
    this.lastName = "",
    this.fullName = "",
    this.email = "",
    this.mobile = "",
    this.playerId = -1,
    this.gender = "",
    this.expert = "",
    this.dateOfBirth = "",
    this.emailVerifiedAt = "",
    this.status = -1,
    this.isBanned = -1,
    this.isManager = -1,
    this.aboutSelf = "",
    this.facebookLink = "",
    this.instagramLink = "",
    this.twitterLink = "",
    this.dribbbleLink = "",
    this.countryId = -1,
    this.stateId = -1,
    this.cityId = -1,
    this.countryName = "",
    this.stateName = "",
    this.cityName = "",
    this.services = const <Services>[],
    this.clinics = const <Clinics>[],
    this.commissions = const <Commissions>[],
    this.address = "",
    this.pincode = "",
    this.latitude = "",
    this.longitude = "",
    this.description = "",
    this.signature = "",
    this.experience = "",
    this.profileImage = "",
    this.createdBy = -1,
    this.updatedBy = -1,
    this.deletedBy = -1,
    this.createdAt = "",
    this.updatedAt = "",
    this.deletedAt = "",
    this.totalServices = 0,
    this.totalReviews = 0,
    this.averageRating = 0,
    this.qualifications = const <Qualifications>[],
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'] is int ? json['id'] : -1,
      doctorId: json['doctor_id'] is int ? json['doctor_id'] : -1,
      firstName: json['first_name'] is String ? json['first_name'] : "",
      lastName: json['last_name'] is String ? json['last_name'] : "",
      fullName: json['full_name'] is String ? json['full_name'] : "",
      email: json['email'] is String ? json['email'] : "",
      mobile: json['mobile'] is String ? json['mobile'] : "",
      playerId: json['player_id'] is int ? json['player_id'] : -1,
      gender: json['gender'] is String ? json['gender'] : "",
      expert: json['expert'] is String ? json['expert'] : "",
      dateOfBirth: json['date_of_birth'] is String ? json['date_of_birth'] : "",
      emailVerifiedAt: json['email_verified_at'] is String ? json['email_verified_at'] : "",
      status: json['status'] is int ? json['status'] : -1,
      isBanned: json['is_banned'] is int ? json['is_banned'] : -1,
      isManager: json['is_manager'] is int ? json['is_manager'] : -1,
      aboutSelf: json['about_self'] is String ? json['about_self'] : "",
      facebookLink: json['facebook_link'] is String ? json['facebook_link'] : "",
      instagramLink: json['instagram_link'] is String ? json['instagram_link'] : "",
      twitterLink: json['twitter_link'] is String ? json['twitter_link'] : "",
      dribbbleLink: json['dribbble_link'] is String ? json['dribbble_link'] : "",
      countryId: json['country_id'] is int ? json['country_id'] : -1,
      stateId: json['state_id'] is int ? json['state_id'] : -1,
      cityId: json['city_id'] is int ? json['city_id'] : -1,
      countryName: json['country_name'] is String ? json['country_name'] : "",
      stateName: json['state_name'] is String ? json['state_name'] : "",
      cityName: json['city_name'] is String ? json['city_name'] : "",
      services: json['services'] is List ? List<Services>.from(json['services'].map((x) => Services.fromJson(x))) : [],
      clinics: json['clinics'] is List ? List<Clinics>.from(json['clinics'].map((x) => Clinics.fromJson(x))) : [],
      commissions: json['commissions'] is List ? List<Commissions>.from(json['commissions'].map((x) => Commissions.fromJson(x))) : [],
      address: json['address'] is String ? json['address'] : "",
      pincode: json['pincode'] is String ? json['pincode'] : "",
      latitude: json['latitude'] is String ? json['latitude'] : "",
      longitude: json['longitude'] is String ? json['longitude'] : "",
      description: json['description'] is String ? json['description'] : "",
      signature: json['signature'] is String ? json['signature'] : "",
      experience: json['experience'] is String ? json['experience'] : "",
      profileImage: json['profile_image'] is String ? json['profile_image'] : "",
      createdBy: json['created_by'] is int ? json['created_by'] : -1,
      updatedBy: json['updated_by'] is int ? json['updated_by'] : -1,
      deletedBy: json['deleted_by'] is int ? json['deleted_by'] : -1,
      createdAt: json['created_at'] is String ? json['created_at'] : "",
      updatedAt: json['updated_at'] is String ? json['updated_at'] : "",
      deletedAt: json['deleted_at'] is String ? json['deleted_at'] : "",
      totalServices: json['total_services'] is int ? json['total_services'] : 0,
      totalReviews: json['total_reviews'] is int ? json['total_reviews'] : 0,
      averageRating: json['average_rating'] is num ? json['average_rating'] : 0,
      qualifications: json['qualifications'] is List ? List<Qualifications>.from(json['qualifications'].map((x) => Qualifications.fromJson(x))) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctor_id': doctorId,
      'first_name': firstName,
      'last_name': lastName,
      'full_name': fullName,
      'email': email,
      'mobile': mobile,
      'player_id': playerId,
      'gender': gender,
      'expert': expert,
      'date_of_birth': dateOfBirth,
      'email_verified_at': emailVerifiedAt,
      'status': status,
      'is_banned': isBanned,
      'is_manager': isManager,
      'about_self': aboutSelf,
      'facebook_link': facebookLink,
      'instagram_link': instagramLink,
      'twitter_link': twitterLink,
      'dribbble_link': dribbbleLink,
      'country_id': countryId,
      'state_id': stateId,
      'city_id': cityId,
      'country_name': countryName,
      'state_name': stateName,
      'city_name': cityName,
      'services': services.map((e) => e.toJson()).toList(),
      'clinics': clinics.map((e) => e.toJson()).toList(),
      'commissions': commissions.map((e) => e.toJson()).toList(),
      'address': address,
      'pincode': pincode,
      'latitude': latitude,
      'longitude': longitude,
      'description': description,
      'signature': signature,
      'experience': experience,
      'profile_image': profileImage,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'deleted_by': deletedBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'qualifications': qualifications.map((e) => e.toJson()).toList(),
    };
  }
}

class Services {
  int id;
  int serviceId;
  int doctorId;
  int serviceCharges;
  int status;
  String name;
  dynamic createdBy;
  dynamic updatedBy;
  dynamic deletedBy;
  String createdAt;
  String updatedAt;
  dynamic deletedAt;
  Clinicservice clinicservice;

  Services({
    this.id = -1,
    this.serviceId = -1,
    this.doctorId = -1,
    this.serviceCharges = -1,
    this.status = -1,
    this.name = "",
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
    this.createdAt = "",
    this.updatedAt = "",
    this.deletedAt,
    required this.clinicservice,
  });

  factory Services.fromJson(Map<String, dynamic> json) {
    return Services(
      id: json['id'] is int ? json['id'] : -1,
      serviceId: json['service_id'] is int ? json['service_id'] : -1,
      doctorId: json['doctor_id'] is int ? json['doctor_id'] : -1,
      serviceCharges: json['charges'] is int ? json['charges'] : -1,
      status: json['status'] is int ? json['status'] : -1,
      name: json['name'] is String ? json['name'] : "",
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      deletedBy: json['deleted_by'],
      createdAt: json['created_at'] is String ? json['created_at'] : "",
      updatedAt: json['updated_at'] is String ? json['updated_at'] : "",
      deletedAt: json['deleted_at'],
      clinicservice: json['clinicservice'] is Map ? Clinicservice.fromJson(json['clinicservice']) : Clinicservice(systemservice: Systemservice()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'service_id': serviceId,
      'doctor_id': doctorId,
      'charges': serviceCharges,
      'status': status,
      'name': name,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'deleted_by': deletedBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'clinicservice': clinicservice.toJson(),
    };
  }
}

class Clinicservice {
  int id;
  int systemServiceId;
  String description;
  int clinicCharges;
  int categoryId;
  dynamic subcategoryId;
  int vendorId;
  int durationMin;
  String timeSlot;
  int status;
  int discount;
  int discountValue;
  String discountType;
  int createdBy;
  int updatedBy;
  dynamic deletedBy;
  String createdAt;
  String updatedAt;
  dynamic deletedAt;
  String fileUrl;
  List<ClinicServiceMapping> clinicServiceMapping;
  List<dynamic> appointmentService;
  Systemservice systemservice;
  List<dynamic> media;

  Clinicservice({
    this.id = -1,
    this.systemServiceId = -1,
    this.description = "",
    this.clinicCharges = -1,
    this.categoryId = -1,
    this.subcategoryId,
    this.vendorId = -1,
    this.durationMin = -1,
    this.timeSlot = "",
    this.status = -1,
    this.discount = -1,
    this.discountValue = -1,
    this.discountType = "",
    this.createdBy = -1,
    this.updatedBy = -1,
    this.deletedBy,
    this.createdAt = "",
    this.updatedAt = "",
    this.deletedAt,
    this.fileUrl = "",
    this.clinicServiceMapping = const <ClinicServiceMapping>[],
    this.appointmentService = const [],
    required this.systemservice,
    this.media = const [],
  });

  factory Clinicservice.fromJson(Map<String, dynamic> json) {
    return Clinicservice(
      id: json['id'] is int ? json['id'] : -1,
      systemServiceId: json['system_service_id'] is int ? json['system_service_id'] : -1,
      description: json['description'] is String ? json['description'] : "",
      clinicCharges: json['charges'] is int ? json['charges'] : -1,
      categoryId: json['category_id'] is int ? json['category_id'] : -1,
      subcategoryId: json['subcategory_id'],
      vendorId: json['vendor_id'] is int ? json['vendor_id'] : -1,
      durationMin: json['duration_min'] is int ? json['duration_min'] : -1,
      timeSlot: json['time_slot'] is String ? json['time_slot'] : "",
      status: json['status'] is int ? json['status'] : -1,
      discount: json['discount'] is int ? json['discount'] : -1,
      discountValue: json['discount_value'] is int ? json['discount_value'] : -1,
      discountType: json['discount_type'] is String ? json['discount_type'] : "",
      createdBy: json['created_by'] is int ? json['created_by'] : -1,
      updatedBy: json['updated_by'] is int ? json['updated_by'] : -1,
      deletedBy: json['deleted_by'],
      createdAt: json['created_at'] is String ? json['created_at'] : "",
      updatedAt: json['updated_at'] is String ? json['updated_at'] : "",
      deletedAt: json['deleted_at'],
      fileUrl: json['file_url'] is String ? json['file_url'] : "",
      clinicServiceMapping: json['clinic_service_mapping'] is List ? List<ClinicServiceMapping>.from(json['clinic_service_mapping'].map((x) => ClinicServiceMapping.fromJson(x))) : [],
      appointmentService: json['appointment_service'] is List ? json['appointment_service'] : [],
      systemservice: json['systemservice'] is Map ? Systemservice.fromJson(json['systemservice']) : Systemservice(),
      media: json['media'] is List ? json['media'] : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'system_service_id': systemServiceId,
      'description': description,
      'charges': clinicCharges,
      'category_id': categoryId,
      'subcategory_id': subcategoryId,
      'vendor_id': vendorId,
      'duration_min': durationMin,
      'time_slot': timeSlot,
      'status': status,
      'discount': discount,
      'discount_value': discountValue,
      'discount_type': discountType,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'deleted_by': deletedBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'file_url': fileUrl,
      'clinic_service_mapping': clinicServiceMapping.map((e) => e.toJson()).toList(),
      'appointment_service': [],
      'systemservice': systemservice.toJson(),
      'media': [],
    };
  }
}

class ClinicServiceMapping {
  int id;
  int serviceId;
  int clinicId;
  int createdBy;
  int updatedBy;
  dynamic deletedBy;
  String createdAt;
  String updatedAt;
  dynamic deletedAt;
  Center center;

  ClinicServiceMapping({
    this.id = -1,
    this.serviceId = -1,
    this.clinicId = -1,
    this.createdBy = -1,
    this.updatedBy = -1,
    this.deletedBy,
    this.createdAt = "",
    this.updatedAt = "",
    this.deletedAt,
    required this.center,
  });

  factory ClinicServiceMapping.fromJson(Map<String, dynamic> json) {
    return ClinicServiceMapping(
      id: json['id'] is int ? json['id'] : -1,
      serviceId: json['service_id'] is int ? json['service_id'] : -1,
      clinicId: json['clinic_id'] is int ? json['clinic_id'] : -1,
      createdBy: json['created_by'] is int ? json['created_by'] : -1,
      updatedBy: json['updated_by'] is int ? json['updated_by'] : -1,
      deletedBy: json['deleted_by'],
      createdAt: json['created_at'] is String ? json['created_at'] : "",
      updatedAt: json['updated_at'] is String ? json['updated_at'] : "",
      deletedAt: json['deleted_at'],
      center: json['center'] is Map ? Center.fromJson(json['center']) : Center(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'service_id': serviceId,
      'clinic_id': clinicId,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'deleted_by': deletedBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'center': center.toJson(),
    };
  }
}

class Center {
  int id;
  String name;
  String email;
  String slug;
  int systemServiceCategory;
  String description;
  String contactNumber;
  String address;
  int city;
  int state;
  int country;
  String pincode;
  dynamic latitude;
  dynamic longitude;
  int status;
  int timeSlot;
  int vendorId;
  int createdBy;
  int updatedBy;
  dynamic deletedBy;
  String createdAt;
  String updatedAt;
  dynamic deletedAt;
  String fileUrl;
  List<dynamic> media;

  Center({
    this.id = -1,
    this.name = "",
    this.email = "",
    this.slug = "",
    this.systemServiceCategory = -1,
    this.description = "",
    this.contactNumber = "",
    this.address = "",
    this.city = -1,
    this.state = -1,
    this.country = -1,
    this.pincode = "",
    this.latitude,
    this.longitude,
    this.status = -1,
    this.timeSlot = -1,
    this.vendorId = -1,
    this.createdBy = -1,
    this.updatedBy = -1,
    this.deletedBy,
    this.createdAt = "",
    this.updatedAt = "",
    this.deletedAt,
    this.fileUrl = "",
    this.media = const [],
  });

  factory Center.fromJson(Map<String, dynamic> json) {
    return Center(
      id: json['id'] is int ? json['id'] : -1,
      name: json['name'] is String ? json['name'] : "",
      email: json['email'] is String ? json['email'] : "",
      slug: json['slug'] is String ? json['slug'] : "",
      systemServiceCategory: json['system_service_category'] is int ? json['system_service_category'] : -1,
      description: json['description'] is String ? json['description'] : "",
      contactNumber: json['contact_number'] is String ? json['contact_number'] : "",
      address: json['address'] is String ? json['address'] : "",
      city: json['city'] is int ? json['city'] : -1,
      state: json['state'] is int ? json['state'] : -1,
      country: json['country'] is int ? json['country'] : -1,
      pincode: json['pincode'] is String ? json['pincode'] : "",
      latitude: json['latitude'],
      longitude: json['longitude'],
      status: json['status'] is int ? json['status'] : -1,
      timeSlot: json['time_slot'] is int ? json['time_slot'] : -1,
      vendorId: json['vendor_id'] is int ? json['vendor_id'] : -1,
      createdBy: json['created_by'] is int ? json['created_by'] : -1,
      updatedBy: json['updated_by'] is int ? json['updated_by'] : -1,
      deletedBy: json['deleted_by'],
      createdAt: json['created_at'] is String ? json['created_at'] : "",
      updatedAt: json['updated_at'] is String ? json['updated_at'] : "",
      deletedAt: json['deleted_at'],
      fileUrl: json['file_url'] is String ? json['file_url'] : "",
      media: json['media'] is List ? json['media'] : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'slug': slug,
      'system_service_category': systemServiceCategory,
      'description': description,
      'contact_number': contactNumber,
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'pincode': pincode,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
      'time_slot': timeSlot,
      'vendor_id': vendorId,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'deleted_by': deletedBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'file_url': fileUrl,
      'media': [],
    };
  }
}

class Systemservice {
  int id;
  String slug;
  String name;
  int categoryId;
  dynamic subcategoryId;
  String description;
  String type;
  int isVideoConslutcy;
  int featured;
  int status;
  dynamic createdBy;
  dynamic updatedBy;
  dynamic deletedBy;
  String createdAt;
  String updatedAt;
  dynamic deletedAt;
  String fileUrl;
  List<Media> media;

  Systemservice({
    this.id = -1,
    this.slug = "",
    this.name = "",
    this.categoryId = -1,
    this.subcategoryId,
    this.description = "",
    this.type = "",
    this.isVideoConslutcy = -1,
    this.featured = -1,
    this.status = -1,
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
    this.createdAt = "",
    this.updatedAt = "",
    this.deletedAt,
    this.fileUrl = "",
    this.media = const <Media>[],
  });

  factory Systemservice.fromJson(Map<String, dynamic> json) {
    return Systemservice(
      id: json['id'] is int ? json['id'] : -1,
      slug: json['slug'] is String ? json['slug'] : "",
      name: json['name'] is String ? json['name'] : "",
      categoryId: json['category_id'] is int ? json['category_id'] : -1,
      subcategoryId: json['subcategory_id'],
      description: json['description'] is String ? json['description'] : "",
      type: json['type'] is String ? json['type'] : "",
      isVideoConslutcy: json['is_video_consultancy'] is int ? json['is_video_consultancy'] : -1,
      featured: json['featured'] is int ? json['featured'] : -1,
      status: json['status'] is int ? json['status'] : -1,
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      deletedBy: json['deleted_by'],
      createdAt: json['created_at'] is String ? json['created_at'] : "",
      updatedAt: json['updated_at'] is String ? json['updated_at'] : "",
      deletedAt: json['deleted_at'],
      fileUrl: json['file_url'] is String ? json['file_url'] : "",
      media: json['media'] is List ? List<Media>.from(json['media'].map((x) => Media.fromJson(x))) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slug': slug,
      'name': name,
      'category_id': categoryId,
      'subcategory_id': subcategoryId,
      'description': description,
      'type': type,
      'is_video_consultancy': isVideoConslutcy,
      'featured': featured,
      'status': status,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'deleted_by': deletedBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'file_url': fileUrl,
      'media': media.map((e) => e.toJson()).toList(),
    };
  }
}

class Media {
  int id;
  String modelType;
  int modelId;
  String uuid;
  String collectionName;
  String name;
  String fileName;
  String mimeType;
  String disk;
  String conversionsDisk;
  int size;
  List<dynamic> manipulations;
  List<dynamic> customProperties;
  GeneratedConversions generatedConversions;
  List<dynamic> responsiveImages;
  int orderColumn;
  String createdAt;
  String updatedAt;
  String originalUrl;
  String previewUrl;

  Media({
    this.id = -1,
    this.modelType = "",
    this.modelId = -1,
    this.uuid = "",
    this.collectionName = "",
    this.name = "",
    this.fileName = "",
    this.mimeType = "",
    this.disk = "",
    this.conversionsDisk = "",
    this.size = -1,
    this.manipulations = const [],
    this.customProperties = const [],
    required this.generatedConversions,
    this.responsiveImages = const [],
    this.orderColumn = -1,
    this.createdAt = "",
    this.updatedAt = "",
    this.originalUrl = "",
    this.previewUrl = "",
  });

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      id: json['id'] is int ? json['id'] : -1,
      modelType: json['model_type'] is String ? json['model_type'] : "",
      modelId: json['model_id'] is int ? json['model_id'] : -1,
      uuid: json['uuid'] is String ? json['uuid'] : "",
      collectionName: json['collection_name'] is String ? json['collection_name'] : "",
      name: json['name'] is String ? json['name'] : "",
      fileName: json['file_name'] is String ? json['file_name'] : "",
      mimeType: json['mime_type'] is String ? json['mime_type'] : "",
      disk: json['disk'] is String ? json['disk'] : "",
      conversionsDisk: json['conversions_disk'] is String ? json['conversions_disk'] : "",
      size: json['size'] is int ? json['size'] : -1,
      manipulations: json['manipulations'] is List ? json['manipulations'] : [],
      customProperties: json['custom_properties'] is List ? json['custom_properties'] : [],
      generatedConversions: json['generated_conversions'] is Map ? GeneratedConversions.fromJson(json['generated_conversions']) : GeneratedConversions(),
      responsiveImages: json['responsive_images'] is List ? json['responsive_images'] : [],
      orderColumn: json['order_column'] is int ? json['order_column'] : -1,
      createdAt: json['created_at'] is String ? json['created_at'] : "",
      updatedAt: json['updated_at'] is String ? json['updated_at'] : "",
      originalUrl: json['original_url'] is String ? json['original_url'] : "",
      previewUrl: json['preview_url'] is String ? json['preview_url'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'model_type': modelType,
      'model_id': modelId,
      'uuid': uuid,
      'collection_name': collectionName,
      'name': name,
      'file_name': fileName,
      'mime_type': mimeType,
      'disk': disk,
      'conversions_disk': conversionsDisk,
      'size': size,
      'manipulations': [],
      'custom_properties': [],
      'generated_conversions': generatedConversions.toJson(),
      'responsive_images': [],
      'order_column': orderColumn,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'original_url': originalUrl,
      'preview_url': previewUrl,
    };
  }
}

class GeneratedConversions {
  bool thumb;
  bool thumb300;

  GeneratedConversions({
    this.thumb = false,
    this.thumb300 = false,
  });

  factory GeneratedConversions.fromJson(Map<String, dynamic> json) {
    return GeneratedConversions(
      thumb: json['thumb'] is bool ? json['thumb'] : false,
      thumb300: json['thumb300'] is bool ? json['thumb300'] : false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'thumb': thumb,
      'thumb300': thumb300,
    };
  }
}

class Clinics {
  int id;
  int doctorId;
  int clinicId;
  String name;
  dynamic createdBy;
  dynamic updatedBy;
  dynamic deletedBy;
  String createdAt;
  String updatedAt;
  dynamic deletedAt;

  Clinics({
    this.id = -1,
    this.doctorId = -1,
    this.clinicId = -1,
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
    this.name = "",
    this.createdAt = "",
    this.updatedAt = "",
    this.deletedAt,
  });

  factory Clinics.fromJson(Map<String, dynamic> json) {
    return Clinics(
      id: json['id'] is int ? json['id'] : -1,
      doctorId: json['doctor_id'] is int ? json['doctor_id'] : -1,
      clinicId: json['clinic_id'] is int ? json['clinic_id'] : -1,
      name: json['name'] is String ? json['name'] : "",
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
      'doctor_id': doctorId,
      'clinic_id': clinicId,
      'name': name,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'deleted_by': deletedBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}

// "title": "Doctor Commission",
//                   "commission_type": "percentage",
//                   "commission_value": 2,

class Commissions {
  int id;
  int employeeId;
  int commissionId;
  String title;
  String commissionType;
  int commissionValue;
  dynamic createdBy;
  dynamic updatedBy;
  dynamic deletedBy;
  String createdAt;
  String updatedAt;
  dynamic deletedAt;

  Commissions({
    this.id = -1,
    this.employeeId = -1,
    this.commissionId = -1,
    this.title = "",
    this.commissionType = "",
    this.commissionValue = -1,
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
    this.createdAt = "",
    this.updatedAt = "",
    this.deletedAt,
  });

  factory Commissions.fromJson(Map<String, dynamic> json) {
    return Commissions(
      id: json['id'] is int ? json['id'] : -1,
      employeeId: json['employee_id'] is int ? json['employee_id'] : -1,
      commissionId: json['commission_id'] is int ? json['commission_id'] : -1,
      commissionValue: json['commission_value'] is int ? json['commission_value'] : -1,
      commissionType: json['commission_type'] is String ? json['commission_type'] : "",
      title: json['title'] is String ? json['title'] : "",
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
      'employee_id': employeeId,
      'commission_id': commissionId,
      'created_by': createdBy,
      'title': title,
      'commission_type': commissionType,
      'commission_value': commissionValue,
      'updated_by': updatedBy,
      'deleted_by': deletedBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}

class DoctorDetailRes {
  bool status;
  Doctor data;
  String message;
  DoctorDetailRes({
    this.status = false,
    required this.data,
    this.message = "",
  });
  factory DoctorDetailRes.fromJson(Map<String, dynamic> json) {
    return DoctorDetailRes(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is Map ? Doctor.fromJson(json['data']) : Doctor(),
      message: json['message'] is String ? json['message'] : "",
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.toJson(),
      'message': message,
    };
  }
}

class EncounterDetailResp {
  bool status;
  EncounterDetailModel data;
  String message;

  EncounterDetailResp({
    this.status = false,
    required this.data,
    this.message = "",
  });

  factory EncounterDetailResp.fromJson(Map<String, dynamic> json) {
    return EncounterDetailResp(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is Map ? EncounterDetailModel.fromJson(json['data']) : EncounterDetailModel(serviceDetails: ServiceDetails(servicePriceData: ServicePriceData())),
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

class EncounterDetailModel {
  int id;
  int encounterId;
  int appointmentId;
  int clinicId;
  int serviceId;
  int doctorId;
  int userId;
  String date;
  int paymentStatus;
  ServiceDetails serviceDetails;

  EncounterDetailModel({
    this.id = -1,
    this.encounterId = -1,
    this.appointmentId = -1,
    this.clinicId = -1,
    this.serviceId = -1,
    this.doctorId = -1,
    this.userId = -1,
    this.date = "",
    this.paymentStatus = -1,
    required this.serviceDetails,
  });

  factory EncounterDetailModel.fromJson(Map<String, dynamic> json) {
    return EncounterDetailModel(
      id: json['id'] is int ? json['id'] : -1,
      encounterId: json['encounter_id'] is int ? json['encounter_id'] : -1,
      appointmentId: json['appointment_id'] is int ? json['appointment_id'] : -1,
      clinicId: json['clinic_id'] is int ? json['clinic_id'] : -1,
      serviceId: json['service_id'] is int ? json['service_id'] : -1,
      doctorId: json['doctor_id'] is int ? json['doctor_id'] : -1,
      userId: json['user_id'] is int ? json['user_id'] : -1,
      date: json['date'] is String ? json['date'] : "",
      paymentStatus: json['payment_status'] is int ? json['payment_status'] : -1,
      serviceDetails: json['service_details'] is Map ? ServiceDetails.fromJson(json['service_details']) : ServiceDetails(servicePriceData: ServicePriceData()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'encounter_id': encounterId,
      'appointment_id': appointmentId,
      'clinic_id': clinicId,
      'service_id': serviceId,
      'doctor_id': doctorId,
      'user_id': userId,
      'date': date,
      'payment_status': paymentStatus,
      'service_details': serviceDetails.toJson(),
    };
  }
}

class ServiceDetails {
  int id;
  int systemServiceId;
  String name;
  String description;
  String type;
  int isVideoConsultancy;
  int charges;
  int categoryId;
  dynamic subcategoryId;
  int vendorId;
  int durationMin;
  String timeSlot;
  int status;
  int discount;
  dynamic discountValue;
  dynamic discountType;
  dynamic createdBy;
  dynamic updatedBy;
  dynamic deletedBy;
  String createdAt;
  String updatedAt;
  dynamic deletedAt;
  ServicePriceData servicePriceData;
  List<TaxData> taxData;
  String fileUrl;
  List<DoctorService> doctorService;
  List<Media> media;

  ServiceDetails({
    this.id = -1,
    this.systemServiceId = -1,
    this.name = "",
    this.description = "",
    this.type = "",
    this.isVideoConsultancy = -1,
    this.charges = -1,
    this.categoryId = -1,
    this.subcategoryId,
    this.vendorId = -1,
    this.durationMin = -1,
    this.timeSlot = "",
    this.status = -1,
    this.discount = -1,
    this.discountValue,
    this.discountType,
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
    this.createdAt = "",
    this.updatedAt = "",
    this.deletedAt,
    required this.servicePriceData,
    this.taxData = const <TaxData>[],
    this.fileUrl = "",
    this.doctorService = const <DoctorService>[],
    this.media = const <Media>[],
  });

  factory ServiceDetails.fromJson(Map<String, dynamic> json) {
    return ServiceDetails(
      id: json['id'] is int ? json['id'] : -1,
      systemServiceId: json['system_service_id'] is int ? json['system_service_id'] : -1,
      name: json['name'] is String ? json['name'] : "",
      description: json['description'] is String ? json['description'] : "",
      type: json['type'] is String ? json['type'] : "",
      isVideoConsultancy: json['is_video_consultancy'] is int ? json['is_video_consultancy'] : -1,
      charges: json['charges'] is int ? json['charges'] : -1,
      categoryId: json['category_id'] is int ? json['category_id'] : -1,
      subcategoryId: json['subcategory_id'],
      vendorId: json['vendor_id'] is int ? json['vendor_id'] : -1,
      durationMin: json['duration_min'] is int ? json['duration_min'] : -1,
      timeSlot: json['time_slot'] is String ? json['time_slot'] : "",
      status: json['status'] is int ? json['status'] : -1,
      discount: json['discount'] is int ? json['discount'] : -1,
      discountValue: json['discount_value'],
      discountType: json['discount_type'],
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      deletedBy: json['deleted_by'],
      createdAt: json['created_at'] is String ? json['created_at'] : "",
      updatedAt: json['updated_at'] is String ? json['updated_at'] : "",
      deletedAt: json['deleted_at'],
      servicePriceData: json['service_price_data'] is Map ? ServicePriceData.fromJson(json['service_price_data']) : ServicePriceData(),
      taxData: json['tax_data'] is List ? List<TaxData>.from(json['tax_data'].map((x) => TaxData.fromJson(x))) : [],
      fileUrl: json['file_url'] is String ? json['file_url'] : "",
      doctorService: json['doctor_service'] is List ? List<DoctorService>.from(json['doctor_service'].map((x) => DoctorService.fromJson(x))) : [],
      media: json['media'] is List ? List<Media>.from(json['media'].map((x) => Media.fromJson(x))) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'system_service_id': systemServiceId,
      'name': name,
      'description': description,
      'type': type,
      'is_video_consultancy': isVideoConsultancy,
      'charges': charges,
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
      'service_price_data': servicePriceData.toJson(),
      'tax_data': taxData.map((e) => e.toJson()).toList(),
      'file_url': fileUrl,
      'doctor_service': doctorService.map((e) => e.toJson()).toList(),
      'media': media.map((e) => e.toJson()).toList(),
    };
  }
}

class ServicePriceData {
  num servicePrice;
  num serviceAmount;
  num totalAmount;
  int duration;
  String discountType;
  num discountValue;
  num discountAmount;

  ServicePriceData({
    this.servicePrice = 0,
    this.serviceAmount = 0,
    this.totalAmount = 0,
    this.duration = 0,
    this.discountType = "",
    this.discountValue = 0,
    this.discountAmount = 0,
  });

  factory ServicePriceData.fromJson(Map<String, dynamic> json) {
    return ServicePriceData(
      servicePrice: json['service_price'] is num ? json['service_price'] : 0,
      serviceAmount: json['service_amount'] is num ? json['service_amount'] : 0,
      totalAmount: json['total_amount'] is num ? json['total_amount'] : 0,
      duration: json['duration'] is int ? json['duration'] : 0,
      discountType: json['discount_type'] is String ? json['discount_type'] : "",
      discountValue: json['discount_value'] is num ? json['discount_value'] : 0,
      discountAmount: json['discount_amount'] is num ? json['discount_amount'] : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'service_price': servicePrice,
      'service_amount': serviceAmount,
      'total_amount': totalAmount,
      'duration': duration,
      'discount_type': discountType,
      'discount_value': discountValue,
      'discount_amount': discountAmount,
    };
  }
}

class TaxData {
  String title;
  num value;
  String type;
  num amount;

  TaxData({
    this.title = "",
    this.value = 0,
    this.type = "",
    this.amount = 0,
  });

  factory TaxData.fromJson(Map<String, dynamic> json) {
    return TaxData(
      title: json['title'] is String ? json['title'] : "",
      value: json['value'] is num ? json['value'] : 0,
      type: json['type'] is String ? json['type'] : "",
      amount: json['amount'] is num ? json['amount'] : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'value': value,
      'type': type,
      'amount': amount,
    };
  }
}

class DoctorService {
  int id;
  int serviceId;
  int clinicId;
  int doctorId;
  int charges;
  int status;
  dynamic createdBy;
  dynamic updatedBy;
  dynamic deletedBy;
  String createdAt;
  String updatedAt;
  dynamic deletedAt;

  DoctorService({
    this.id = -1,
    this.serviceId = -1,
    this.clinicId = -1,
    this.doctorId = -1,
    this.charges = -1,
    this.status = -1,
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
    this.createdAt = "",
    this.updatedAt = "",
    this.deletedAt,
  });

  factory DoctorService.fromJson(Map<String, dynamic> json) {
    return DoctorService(
      id: json['id'] is int ? json['id'] : -1,
      serviceId: json['service_id'] is int ? json['service_id'] : -1,
      clinicId: json['clinic_id'] is int ? json['clinic_id'] : -1,
      doctorId: json['doctor_id'] is int ? json['doctor_id'] : -1,
      charges: json['charges'] is int ? json['charges'] : -1,
      status: json['status'] is int ? json['status'] : -1,
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
      'service_id': serviceId,
      'clinic_id': clinicId,
      'doctor_id': doctorId,
      'charges': charges,
      'status': status,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'deleted_by': deletedBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
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

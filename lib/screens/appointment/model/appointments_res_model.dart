import 'package:nb_utils/nb_utils.dart';

import '../../../utils/constants.dart';
import '../../Encounter/generate_invoice/model/billing_item_model.dart';
import '../../home/model/dashboard_res_model.dart';
import 'appointment_details_resp.dart';
import 'encounter_detail_model.dart';

class AppointmentListRes {
  bool status;
  List<AppointmentData> data;
  String message;

  AppointmentListRes({
    this.status = false,
    this.data = const <AppointmentData>[],
    this.message = "",
  });

  factory AppointmentListRes.fromJson(Map<String, dynamic> json) {
    return AppointmentListRes(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is List ? List<AppointmentData>.from(json['data'].map((x) => AppointmentData.fromJson(x))) : [],
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

class AppointmentData {
  int id;
  String status;
  String startDateTime;
  int userId;
  String userName;
  String userImage;
  String userEmail;
  String userPhone;
  String userDob;
  String userGender;
  int clinicId;
  String clinicName;
  int doctorId;
  String description;
  String doctorName;
  String doctorImage;
  String doctorPhone;
  String appointmentDate;
  String appointmentTime;
  String endTime;
  int duration;
  int encounterId;
  String encounterDescription;
  int serviceId;
  bool encounterStatus;
  String serviceName;
  String serviceType;
  bool isVideoConsultancy;
  String serviceImage;
  String categoryName;
  String appointmentExtraInfo;
  String address;
  num totalAmount;
  num serviceAmount;
  String discountType;
  num discountValue;
  num discountAmount;
  String paymentStatus;
  bool isEnableAdvancePayment;
  num advancePaymentAmount;
  int advancePaymentStatus;
  num advancePaidAmount;
  num remainingPayableAmount;
  String zoomLink;
  String googleLink;
  String bookForName;
  String booForImage;
  int createdBy;
  int updatedBy;
  int deletedBy;
  String createdAt;
  String updatedAt;
  String deletedAt;

  int countryId;
  int stateId;
  int cityId;
  String countryName;
  String stateName;
  String cityName;
  String pincode;
  String clinicImage;
  String clinicAddress;
  String clinicPhone;
  String doctorEmail;
  num servicePrice;

  num serviceTotal;
  num subtotal;
  String billingFinalDiscountType;
  bool enableFinalBillingDiscount;
  num billingFinalDiscountValue;
  num billingFinalDiscountAmount;
  List<AppointmentMedicalReport> medicalReport;

  num totalInclusiveTax;
  num totalExclusiveTax;
  List<TaxPercentage> exclusiveTaxList;
  List<BillingItem> billingItems;

  //For notification read
  String notificationId;

  int? cancellationChargeAmount;
  num? cancellationCharges;
  String? cancellationType;
  String? reason;
  num? refundAmount;
  String? refundStatus;
  num? paidAmount;

  List<BedAllocation> bedAllocation;

  String? bedTypeName;
  String? bed;

  bool get isAdvancePaymentDone => paidAmount.validate() != 0;

  bool get isServiceDiscountAvailable => discountAmount > 0;

  ///Tax

  bool get isInclusiveTaxesAvailable => totalInclusiveTax > 0;

  bool get isExclusiveTaxesAvailable => exclusiveTaxList.isNotEmpty;

  AppointmentData({
    this.id = -1,
    this.status = "",
    this.startDateTime = "",
    this.userId = -1,
    this.userName = "",
    this.userImage = "",
    this.userEmail = "",
    this.userPhone = "",
    this.userDob = "",
    this.userGender = "",
    this.clinicId = -1,
    this.clinicName = "",
    this.doctorId = -1,
    this.address = "",
    this.doctorName = "",
    this.doctorImage = "",
    this.doctorPhone = "",
    this.appointmentDate = "",
    this.description = "",
    this.appointmentTime = "",
    this.endTime = "",
    this.duration = -1,
    this.serviceId = -1,
    this.serviceName = "",
    this.serviceType = "",
    this.isVideoConsultancy = false,
    this.serviceImage = "",
    this.categoryName = "",
    this.appointmentExtraInfo = "",
    this.totalAmount = 0,
    this.serviceAmount = 0,
    this.discountType = "",
    this.discountValue = 0,
    this.encounterId = -1,
    this.encounterDescription = "",
    this.encounterStatus = false,
    this.discountAmount = 0,
    this.paymentStatus = PaymentStatus.pending,
    this.isEnableAdvancePayment = false,
    this.advancePaymentAmount = 0,
    this.advancePaymentStatus = 0,
    this.advancePaidAmount = 0,
    this.remainingPayableAmount = 0,
    this.zoomLink = "",
    this.googleLink = "",
    this.bookForName = "",
    this.booForImage = "",
    this.countryId = -1,
    this.stateId = -1,
    this.cityId = -1,
    this.countryName = "",
    this.stateName = "",
    this.cityName = "",
    this.pincode = "",
    this.clinicImage = "",
    this.clinicAddress = "",
    this.clinicPhone = "",
    this.doctorEmail = "",
    this.servicePrice = 0,
    this.serviceTotal = 0,
    this.subtotal = 0,
    this.billingFinalDiscountType = "",
    this.enableFinalBillingDiscount = false,
    this.billingFinalDiscountValue = 0,
    this.billingFinalDiscountAmount = 0,
    this.medicalReport = const <AppointmentMedicalReport>[],
    this.totalExclusiveTax = 0,
    this.totalInclusiveTax = 0,
    this.exclusiveTaxList = const <TaxPercentage>[],
    this.billingItems = const <BillingItem>[],
    this.createdBy = -1,
    this.updatedBy = -1,
    this.deletedBy = -1,
    this.createdAt = "",
    this.updatedAt = "",
    this.deletedAt = "",
    this.notificationId = "",
    this.cancellationChargeAmount = 0,
    this.cancellationCharges = 0,
    this.cancellationType = "",
    this.reason = "",
    this.refundAmount = 0.0,
    this.refundStatus = "",
    this.bedAllocation = const [],
    this.bedTypeName,
    this.bed,
  });

  factory AppointmentData.fromJson(Map<String, dynamic> json) {
    return AppointmentData(
      id: json['id'] is int ? json['id'] : -1,
      status: json['status'] is String ? json['status'] : "",
      startDateTime: json['start_date_time'] is String ? json['start_date_time'] : "",
      userId: json['user_id'] is int ? json['user_id'] : -1,
      userName: json['user_name'] is String ? json['user_name'] : "",
      userImage: json['user_image'] is String ? json['user_image'] : "",
      userEmail: json['user_email'] is String ? json['user_email'] : "",
      userPhone: json['user_phone'] is String ? json['user_phone'] : "",
      userDob: json['user_dob'] is String ? json['user_dob'] : "",
      userGender: json['user_gender'] is String ? json['user_gender'] : "",
      clinicId: json['clinic_id'] is int ? json['clinic_id'] : -1,
      clinicName: json['clinic_name'] is String ? json['clinic_name'] : "",
      doctorId: json['doctor_id'] is int ? json['doctor_id'] : -1,
      address: json['address'] is String ? json['address'] : "",
      doctorName: json['doctor_name'] is String ? json['doctor_name'] : "",
      doctorImage: json['doctor_image'] is String ? json['doctor_image'] : "",
      doctorPhone: json['doctor_phone'] is String ? json['doctor_phone'] : "",
      appointmentDate: json['appointment_date'] is String ? json['appointment_date'] : "",
      description: json['description'] is String ? json['description'] : "",
      appointmentTime: json['appointment_time'] is String ? json['appointment_time'] : "",
      endTime: json['end_time'] is String ? json['end_time'] : "",
      duration: json['duration'] is int ? json['duration'] : -1,
      serviceId: json['service_id'] is int ? json['service_id'] : -1,
      serviceName: json['service_name'] is String ? json['service_name'] : "",
      serviceType: json['service_type'] is String ? json['service_type'] : "",
      isVideoConsultancy: json['is_video_consultancy'] == 1,
      serviceImage: json['service_image'] is String ? json['service_image'] : "",
      categoryName: json['category_name'] is String ? json['category_name'] : "",
      appointmentExtraInfo: json['appointment_extra_info'] is String ? json['appointment_extra_info'] : "",
      totalAmount: json['total_amount'] is num ? json['total_amount'] : 0,
      serviceAmount: json['service_amount'] is num ? json['service_amount'] : 0,
      discountType: json['discount_type'] is String ? json['discount_type'] : "",
      discountValue: json['discount_value'] is num ? json['discount_value'] : 0,
      encounterId: json['encounter_id'] is int ? json['encounter_id'] : -1,
      encounterDescription: json['encounter_description'] is String ? json['encounter_description'] : "",
      encounterStatus: json['encounter_status'] == 1,
      discountAmount: json['discount_amount'] is num ? json['discount_amount'] : 0,
      //paymentStatus: json['payment_status'] is String ? json['payment_status'] : PaymentStatus.pending,
      paymentStatus: json['payment_status']?.toString() ?? "0",

      isEnableAdvancePayment: json['is_enable_advance_payment'] == 1,
      advancePaymentAmount: json['advance_payment_amount'] is num ? json['advance_payment_amount'] : 0,
      advancePaymentStatus: json['advance_payment_status'] is int ? json['advance_payment_status'] : 0,
      advancePaidAmount: json['advance_paid_amount'] is num ? json['advance_paid_amount'] : 0,
      remainingPayableAmount: json['remaining_payable_amount'] is num ? json['remaining_payable_amount'] : 0,
      zoomLink: json['zoom_link'] is String ? json['zoom_link'] : "",
      googleLink: json['google_link'] is String ? json['google_link'] : "",
      bookForName: json['book_for_name'] is String ? json['book_for_name'] : "",
      booForImage: json['book_for_image'] is String ? json['book_for_image'] : "",
      countryId: json['country_id'] is int ? json['country_id'] : -1,
      stateId: json['state_id'] is int ? json['state_id'] : -1,
      cityId: json['city_id'] is int ? json['city_id'] : -1,
      countryName: json['country_name'] is String ? json['country_name'] : "",
      stateName: json['state_name'] is String ? json['state_name'] : "",
      cityName: json['city_name'] is String ? json['city_name'] : "",
      pincode: json['pincode'] is String ? json['pincode'] : "",
      clinicImage: json['clinic_image'] is String ? json['clinic_image'] : "",
      clinicAddress: json['clinic_address'] is String ? json['clinic_address'] : "",
      clinicPhone: json['clinic_phone'] is String ? json['clinic_phone'] : "",
      doctorEmail: json['doctor_email'] is String ? json['doctor_email'] : "",
      servicePrice: json['service_price'] is num ? json['service_price'] : 0,
      serviceTotal: json['service_total'] is num ? json['service_total'] : 0,
      subtotal: json['subtotal'] is num ? json['subtotal'] : 0,
      billingFinalDiscountType: json['billing_final_discount_type'] is String ? json['billing_final_discount_type'] : "",
      enableFinalBillingDiscount: json['enable_final_billing_discount'] == 1,
      billingFinalDiscountValue: json['billing_final_discount_value'] is num ? json['billing_final_discount_value'] : 0,
      billingFinalDiscountAmount: json['billing_final_discount_amount'] is num ? json['billing_final_discount_amount'] : 0,
      medicalReport: json['medical_report'] is List ? List<AppointmentMedicalReport>.from(json['medical_report'].map((x) => AppointmentMedicalReport.fromJson(x))) : [],
      totalExclusiveTax: json['total_tax'] is num ? json['total_tax'] : 0,
      totalInclusiveTax: json['total_inclusive_tax'] is num ? json['total_inclusive_tax'] : 0,
      exclusiveTaxList: json['tax_data'] is List ? List<TaxPercentage>.from(json['tax_data'].map((x) => TaxPercentage.fromJson(x))) : [],
      billingItems: json['billing_items'] is List ? List<BillingItem>.from(json['billing_items'].map((x) => BillingItem.fromJson(x))) : [],
      createdBy: json['created_by'] is int ? json['created_by'] : -1,
      updatedBy: json['updated_by'] is int ? json['updated_by'] : -1,
      deletedBy: json['deleted_by'] is int ? json['deleted_by'] : -1,
      createdAt: json['created_at'] is String ? json['created_at'] : "",
      updatedAt: json['updated_at'] is String ? json['updated_at'] : "",
      deletedAt: json['deleted_at'] is String ? json['deleted_at'] : "",
      notificationId: json['notification_id'] is String ? json['notification_id'] : "",
      cancellationChargeAmount: json['cancellation_charge_amount'] is int ? json['cancellation_charge_amount'] : 0,
      cancellationCharges: json['cancellation_charge'] is num ? json['cancellation_charge'] : 0,
      cancellationType: json['cancellation_type'] is String ? json['cancellation_type'] : "",
      reason: json['reason'] is String ? json['reason'] : "",
      refundAmount: json['refund_amount'] is num ? json['refund_amount'] : 0.0,
      refundStatus: json['refund_status'] is String ? json['refund_status'] : "",
      bedAllocation: json['bed_details'] is List ? List<BedAllocation>.from(json['bed_details'].map((x) => BedAllocation.fromJson(x))) : [],
      bedTypeName: json['bed_type_name'] is String ? json['bed_type_name'] : "",
      bed: json['bed'] is String ? json['bed'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'start_date_time': startDateTime,
      'user_id': userId,
      'user_name': userName,
      'user_image': userImage,
      'user_email': userEmail,
      'user_phone': userPhone,
      'user_dob': userDob,
      'user_gender': userGender,
      'clinic_id': clinicId,
      'clinic_name': clinicName,
      'clinic_image': clinicImage,
      'clinic_address': clinicAddress,
      'clinic_phone': clinicPhone,
      'doctor_id': doctorId,
      'doctor_name': doctorName,
      'doctor_image': doctorImage,
      'doctor_phone': doctorPhone,
      'appointment_date': appointmentDate,
      'appointment_time': appointmentTime,
      'end_time': endTime,
      'duration': duration,
      'address': address,
      'description': description,
      'encounter_id': encounterId,
      'encounter_description': encounterDescription,
      'encounter_status': encounterStatus ? 1 : 0,
      'service_id': serviceId,
      'service_name': serviceName,
      'service_type': serviceType,
      'is_video_consultancy': isVideoConsultancy ? 1 : 0,
      'service_image': serviceImage,
      'category_name': categoryName,
      'appointment_extra_info': appointmentExtraInfo,
      'total_amount': totalAmount,
      'service_amount': serviceAmount,
      'discount_type': discountType,
      'discount_value': discountValue,
      'discount_amount': discountAmount,
      'payment_status': paymentStatus,
      'is_enable_advance_payment': isEnableAdvancePayment ? 1 : 0,
      'advance_payment_amount': advancePaymentAmount,
      'advance_payment_status': advancePaymentStatus,
      'advance_paid_amount': advancePaidAmount,
      'remaining_payable_amount': remainingPayableAmount,
      'zoom_link': zoomLink,
      'google_link': googleLink,
      'book_for_name': bookForName,
      'book_for_Image': booForImage,
      'country_id': countryId,
      'state_id': stateId,
      'city_id': cityId,
      'country_name': countryName,
      'state_name': stateName,
      'city_name': cityName,
      'doctor_email': doctorEmail,
      'service_price': servicePrice,
      'service_total': serviceTotal,
      'subtotal': subtotal,
      'billing_final_discount_type': billingFinalDiscountType,
      'enable_final_billing_discount': enableFinalBillingDiscount ? 1 : 0,
      'billing_final_discount_value': billingFinalDiscountValue,
      'billing_final_discount_amount': billingFinalDiscountAmount,
      'medical_report': medicalReport.map((e) => e.toJson()).toList(),
      'total_tax': totalExclusiveTax,
      'total_inclusive_tax': totalInclusiveTax,
      'tax_data': exclusiveTaxList.map((e) => e.toJson()).toList(),
      'billing_items': billingItems.map((e) => e.toJson()).toList(),
      'created_by': createdBy,
      'updated_by': updatedBy,
      'deleted_by': deletedBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'cancellation_charge_amount': cancellationChargeAmount,
      'cancellation_charge': cancellationCharges,
      'cancellation_type': cancellationType,
      'reason': reason,
      'refund_amount': refundAmount,
      'refund_status': refundStatus,
      'bed_type_name': bedTypeName,
      'bed': bed,
    };
  }
}

import 'encounter_details_resp.dart';

class SaveBillingResp {
  int encounterId;
  int clinicId;
  int serviceId;
  int doctorId;
  int userId;
  String date;
  int paymentStatus;
  bool finalDiscountEnabled;
  num finalDiscountValue;
  String finalDiscountType;
  ServiceDetails? serviceDetails;
  int pharmaId = -1;
  bool bedPaymentStatus;

  SaveBillingResp({
    this.encounterId = -1,
    this.clinicId = -1,
    this.serviceId = -1,
    this.doctorId = -1,
    this.userId = -1,
    this.date = "",
    this.paymentStatus = -1,
    this.finalDiscountEnabled = false,
    this.finalDiscountValue = 0,
    this.finalDiscountType = "",
    this.serviceDetails,
    this.bedPaymentStatus = false,
  });

  factory SaveBillingResp.fromJson(Map<String, dynamic> json) {
    return SaveBillingResp(
      encounterId: json['encounter_id'] is int ? json['encounter_id'] : -1,
      clinicId: json['clinic_id'] is int ? json['clinic_id'] : -1,
      serviceId: json['service_id'] is int ? json['service_id'] : -1,
      doctorId: json['doctor_id'] is int ? json['doctor_id'] : -1,
      userId: json['user_id'] is int ? json['user_id'] : -1,
      date: json['date'] is String ? json['date'] : "",
      paymentStatus: json['payment_status'] is int ? json['payment_status'] : -1,
      finalDiscountEnabled: json['final_discount_enabled'] is bool ? json['final_discount_enabled'] : json['final_discount_enabled'] == 1,
      finalDiscountValue: json['final_discount_value'] is num ? json['final_discount_value'] : 0,
      finalDiscountType: json['final_discount_type'] is String ? json['final_discount_type'] : "",
      serviceDetails: json['service_details'] is Map ? ServiceDetails.fromJson(json['service_details']) : ServiceDetails(servicePriceData: ServicePriceData()),
      bedPaymentStatus: json['bed_payment_status'] is bool ? json['bed_payment_status'] : (json['bed_payment_status'] == 1 ? true : false),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'encounter_id': encounterId,
      'clinic_id': clinicId,
      'service_id': serviceId.isNegative ? null : serviceId,
      'doctor_id': doctorId,
      'user_id': userId,
      'date': date,
      'payment_status': paymentStatus,
      if (serviceDetails != null) 'service_details': serviceDetails?.toJson(),
      'encounter_status': paymentStatus == 1 ? 0 : 1,
      'final_discount_enabled': finalDiscountEnabled ? 1 : 0,
      'final_discount_value': finalDiscountValue,
      'final_discount_type': finalDiscountType,
      'bed_payment_status': bedPaymentStatus ? 1 : 0,
    };
  }
}

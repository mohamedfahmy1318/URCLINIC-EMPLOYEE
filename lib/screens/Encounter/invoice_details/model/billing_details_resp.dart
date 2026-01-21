import '../../../home/model/dashboard_res_model.dart';
import '../../generate_invoice/model/billing_item_model.dart';

class BillingDetailsResp {
  bool status;
  BillingDetailModel data;
  String message;

  BillingDetailsResp({
    this.status = false,
    required this.data,
    this.message = "",
  });

  factory BillingDetailsResp.fromJson(Map<String, dynamic> json) {
    return BillingDetailsResp(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is Map ? BillingDetailModel.fromJson(json['data']) : BillingDetailModel.fromJson({}),
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

class BillingDetailModel {
  int id;
  int encounterId;
  int userId;
  String userName;
  String userAddress;
  String userGender;
  String userDob;
  int clinicId;
  String clinicName;
  String clinicAddress;
  String clinicEmail;
  int doctorId;
  String doctorName;
  int serviceId;
  String serviceName;
  num servicePrice;
  num serviceAmount;
  num totalAmount;
  num subTotal;
  num finalTotalAmount;
  num discountAmount;
  String discountType;
  num discountValue;
  bool isEnableAdvancePayment;
  num advancePaymentAmount;
  int advancePaymentStatus;
  num advancePaidAmount;
  num remainingPayableAmount;
  String billingFinalDiscountType;
  bool enableFinalBillingDiscount;
  num billingFinalDiscountValue;
  num billingFinalDiscountAmount;
  List<BillingItem> billingItems;

  String date;
  int paymentStatus;


  num totalExclusiveTax;
  num totalInclusiveTax;

  List<TaxPercentage> exclusiveTaxList;

  bool get isInclusiveTaxesAvailable => totalInclusiveTax > 0;

  bool get isExclusiveTaxesAvailable => exclusiveTaxList.isNotEmpty;

  BedDetails bedDetails;

  BillingDetailModel({
    this.id = -1,
    this.encounterId = -1,
    this.userId = -1,
    this.userName = "",
    this.userAddress = "",
    this.userGender = "",
    this.userDob = "",
    this.clinicId = -1,
    this.clinicName = "",
    this.clinicAddress = "",
    this.clinicEmail = "",
    this.doctorId = -1,
    this.doctorName = "",
    this.serviceId = -1,
    this.serviceName = "",
    this.serviceAmount = 0,
    this.servicePrice = 0,
    this.totalAmount = 0,
    this.subTotal = 0,
    this.finalTotalAmount = 0,
    this.discountAmount = 0,
    this.discountType = "",
    this.discountValue = 0,
    this.isEnableAdvancePayment = false,
    this.advancePaymentAmount = 0,
    this.advancePaymentStatus = 0,
    this.advancePaidAmount = 0,
    this.remainingPayableAmount = 0,
    this.billingFinalDiscountType = "",
    this.enableFinalBillingDiscount = false,
    this.billingFinalDiscountValue = 0,
    this.billingFinalDiscountAmount = 0,
    this.billingItems = const <BillingItem>[],
    this.date = "",
    this.paymentStatus = -1,
    this.totalInclusiveTax = 0,
    this.totalExclusiveTax = 0,
    this.exclusiveTaxList = const <TaxPercentage>[],
    required this.bedDetails,

  });

  factory BillingDetailModel.fromJson(Map<String, dynamic> json) {
    return BillingDetailModel(
      id: json['id'] is int ? json['id'] : -1,
      encounterId: json['encounter_id'] is int ? json['encounter_id'] : -1,
      userId: json['user_id'] is int ? json['user_id'] : -1,
      userName: json['user_name'] is String ? json['user_name'] : "",
      userAddress: json['user_address'] is String ? json['user_address'] : "",
      userGender: json['user_gender'] is String ? json['user_gender'] : "",
      userDob: json['user_dob'] is String ? json['user_dob'] : "",
      clinicId: json['clinic_id'] is int ? json['clinic_id'] : -1,
      clinicName: json['clinic_name'] is String ? json['clinic_name'] : "",
      clinicEmail: json['clinic_email'] is String ? json['clinic_email'] : "",
      clinicAddress: json['clinic_address'] is String ? json['clinic_address'] : "",
      doctorId: json['doctor_id'] is int ? json['doctor_id'] : -1,
      doctorName: json['doctor_name'] is String ? json['doctor_name'] : "",
      serviceId: json['service_id'] is int ? json['service_id'] : -1,
      serviceName: json['service_name'] is String ? json['service_name'] : "",
      servicePrice: json['service_price'] is num ? json['service_price'] : 0,
      serviceAmount: json['service_amount'] is num ? json['service_amount'] : 0,
      totalAmount: json['total_amount'] is num ? json['total_amount'] : 0,
      subTotal: json['sub_total'] is num ? json['sub_total'] : 0,
      finalTotalAmount: json['final_total'] is num ? json['final_total'] : 0,
      discountAmount: json['discount_amount'] is num ? json['discount_amount'] : 0,
      discountType: json['discount_type'] is String ? json['discount_type'] : "",
      discountValue: json['discount_value'] is num ? json['discount_value'] : 0,
      isEnableAdvancePayment: json['is_enable_advance_payment'] is bool ? json['is_enable_advance_payment'] : json['is_enable_advance_payment'] == 1,
      advancePaymentAmount: json['advance_payment_amount'] is num ? json['advance_payment_amount'] : 0,
      advancePaymentStatus: json['advance_payment_status'] is int ? json['advance_payment_status'] : 0,
      advancePaidAmount: json['advance_paid_amount'] is num ? json['advance_paid_amount'] : 0,
      remainingPayableAmount: json['remaining_payable_amount'] is num ? json['remaining_payable_amount'] : 0,
      billingFinalDiscountType: json['billing_final_discount_type'] is String ? json['billing_final_discount_type'] : "",
      enableFinalBillingDiscount: json['enable_final_billing_discount'] is bool ? json['enable_final_billing_discount'] : json['enable_final_billing_discount'] == 1,
      billingFinalDiscountValue: json['billing_final_discount_value'] is num ? json['billing_final_discount_value'] : 0,
      billingFinalDiscountAmount: json['billing_final_discount_amount'] is num ? json['billing_final_discount_amount'] : 0,
      exclusiveTaxList: json['tax'] is List ? List<TaxPercentage>.from(json['tax'].map((x) => TaxPercentage.fromJson(x))) : [],
      totalExclusiveTax: json['total_tax'] is num ? json['total_tax'] : 0,
      totalInclusiveTax: json['total_inclusive_tax'] is num ? json['total_inclusive_tax'] : 0,
      billingItems: json['billing_items'] is List ? List<BillingItem>.from(json['billing_items'].map((x) => BillingItem.fromJson(x))) : [],
      date: json['date'] is String ? json['date'] : "",
      paymentStatus: json['payment_status'] is int ? json['payment_status'] : -1,
      bedDetails: json['bed_details'] is Map ? BedDetails.fromJson(json['bed_details']) : BedDetails(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'encounter_id': encounterId,
      'user_id': userId,
      'user_name': userName,
      'user_address': userAddress,
      'user_gender': userGender,
      'user_dob': userDob,
      'clinic_id': clinicId,
      'clinic_name': clinicName,
      'clinic_address': clinicAddress,
      'clinic_email': clinicEmail,
      'doctor_id': doctorId,
      'doctor_name': doctorName,
      'service_id': serviceId,
      'service_name': serviceName,
      'service_amount': serviceAmount,
      'total_amount': totalAmount,
      'sub_total': subTotal,
      'discount_amount': discountAmount,
      'discount_type': discountType,
      'discount_value': discountValue,
      'is_enable_advance_payment': isEnableAdvancePayment ? 1 : 0,
      'advance_payment_amount': advancePaymentAmount,
      'advance_payment_status': advancePaymentStatus,
      'advance_paid_amount': advancePaidAmount,
      'remaining_payable_amount': remainingPayableAmount,
      'billing_final_discount_type': billingFinalDiscountType,
      'enable_final_billing_discount': enableFinalBillingDiscount ? 1 : 0,
      'billing_final_discount_value': billingFinalDiscountValue,
      'billing_final_discount_amount': billingFinalDiscountAmount,
      'total_tax': totalExclusiveTax,
      'total_inclusive_tax': totalInclusiveTax,
      'tax': exclusiveTaxList.map((e) => e.toJson()).toList(),
      'billing_items': billingItems.map((e) => e.toJson()).toList(),
      'date': date,
      'payment_status': paymentStatus,
    };
  }
}

class BedDetails {
  int bedAllocationId;
  int bedId;
  int bedTypeId;
  String bedName;
  String bedType;
  num charge;
  String assignDate;
  String dischargeDate;
  int perDayCharge;
  int bedPaymentStatus;



  BedDetails({
    this.bedAllocationId = -1,
    this.bedId = -1,
    this.bedTypeId = -1,
    this.bedName = "",
    this.bedType = "",
    this.charge = -1,
    this.assignDate = "",
    this.dischargeDate = "",
    this.perDayCharge = -1,
    this.bedPaymentStatus = -1,
  });

  factory BedDetails.fromJson(Map<String, dynamic> json) {
    return BedDetails(
      bedAllocationId: json['bed_allocation_id'] is int ? json['bed_allocation_id'] : -1,
      bedId: json['bed_id'] is int ? json['bed_id'] : -1,
      bedTypeId: json['bed_type_id'] is int ? json['bed_type_id'] : -1,
      bedName: json['bed_name'] is String ? json['bed_name'] : "",
      bedType: json['bed_type'] is String ? json['bed_type'] : "",
      charge: json['charge'] is num ? json['charge'] : 0,
      assignDate: json['assign_date'] is String ? json['assign_date'] : "",
      dischargeDate: json['discharge_date'] is String ? json['discharge_date'] : "",
      perDayCharge: json['per_day_charge'] is int ? json['per_day_charge'] : -1,
      bedPaymentStatus: json['bed_payment_status'] is int ? json['bed_payment_status'] : -1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bed_allocation_id': bedAllocationId,
      'bed_id': bedId,
      'bed_type_id': bedTypeId,
      'bed_name': bedName,
      'bed_type': bedType,
      'charge': charge,
      'assign_date': assignDate,
      'discharge_date': dischargeDate,
      'per_day_charge': perDayCharge,
      'bed_payment_status': bedPaymentStatus,
    };
  }
}


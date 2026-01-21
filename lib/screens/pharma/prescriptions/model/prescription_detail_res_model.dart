import 'package:kivicare_clinic_admin/screens/home/model/dashboard_res_model.dart';

import '../../medicine/model/medicine_resp_model.dart';

class PrescriptionDetailRes {
  int code;
  bool status;
  String message;
  PrescriptionDetail data;

  PrescriptionDetailRes({
    this.code = -1,
    this.status = false,
    this.message = "",
    required this.data,
  });

  factory PrescriptionDetailRes.fromJson(Map<String, dynamic> json) {
    return PrescriptionDetailRes(
      code: json['code'] is int ? json['code'] : -1,
      status: json['status'] is bool ? json['status'] : false,
      message: json['message'] is String ? json['message'] : "",
      data: json['data'] is Map ? PrescriptionDetail.fromJson(json['data']) : PrescriptionDetail.fromJson({}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'status': status,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class PrescriptionDetail {
  int id;
  String appointmentStatus;
  String appointmentPaymentStatus;
  String prescriptionStatus;
  String prescriptionPaymentStatus;
  PatientInfo patientInfo;
  DoctorInfo doctorInfo;
  BookingInfo bookingInfo;
  List<MedicineInfo> medicineInfo;
  PaymentInfo paymentInfo;

  PrescriptionDetail({
    this.id = -1,
    this.appointmentStatus = "",
    this.appointmentPaymentStatus = "",
    this.prescriptionStatus = "",
    this.prescriptionPaymentStatus = "",
    required this.patientInfo,
    required this.doctorInfo,
    required this.bookingInfo,
    this.medicineInfo = const <MedicineInfo>[],
    required this.paymentInfo,
  });

  factory PrescriptionDetail.fromJson(Map<String, dynamic> json) {
    return PrescriptionDetail(
      id: json['id'] is int ? json['id'] : -1,
      appointmentStatus: json['appointment_status'] is String ? json['appointment_status'] : "",
      appointmentPaymentStatus: json['appointment_payment_status'] is String ? json['appointment_payment_status'] : "",
      prescriptionStatus: json['prescription_status'] is String ? json['prescription_status'] : "",
      prescriptionPaymentStatus: json['prescription_payment_status'] is String ? json['prescription_payment_status'] : "",
      patientInfo: json['patient_info'] is Map ? PatientInfo.fromJson(json['patient_info']) : PatientInfo(),
      doctorInfo: json['doctor_info'] is Map ? DoctorInfo.fromJson(json['doctor_info']) : DoctorInfo(),
      bookingInfo: json['booking_info'] is Map ? BookingInfo.fromJson(json['booking_info']) : BookingInfo(),
      medicineInfo: json['medicine_info'] is List ? List<MedicineInfo>.from(json['medicine_info'].map((x) => MedicineInfo.fromJson(x))) : [],
      paymentInfo: json['payment_info'] is Map ? PaymentInfo.fromJson(json['payment_info']) : PaymentInfo(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'appointment_status': appointmentStatus,
      'appointment_payment_status': appointmentPaymentStatus,
      'prescription_status': prescriptionStatus,
      'prescription_payment_status': prescriptionPaymentStatus,
      'patient_info': patientInfo.toJson(),
      'doctor_info': doctorInfo.toJson(),
      'booking_info': bookingInfo.toJson(),
      'medicine_info': medicineInfo.map((e) => e.toJson()).toList(),
      'payment_info': paymentInfo.toJson(),
    };
  }
}

class PatientInfo {
  String name;
  String phone;
  String email;
  String image;

  PatientInfo({
    this.name = "",
    this.phone = "",
    this.email = "",
    this.image = "",
  });

  factory PatientInfo.fromJson(Map<String, dynamic> json) {
    return PatientInfo(
      name: json['name'] is String ? json['name'] : "",
      phone: json['phone'] is String ? json['phone'] : "",
      email: json['email'] is String ? json['email'] : "",
      image: json['image'] is String ? json['image'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'image': image,
    };
  }
}

class DoctorInfo {
  String name;
  String phone;
  String email;
  String image;

  DoctorInfo({
    this.name = "",
    this.phone = "",
    this.email = "",
    this.image = "",
  });

  factory DoctorInfo.fromJson(Map<String, dynamic> json) {
    return DoctorInfo(
      name: json['name'] is String ? json['name'] : "",
      phone: json['phone'] is String ? json['phone'] : "",
      email: json['email'] is String ? json['email'] : "",
      image: json['image'] is String ? json['image'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'image': image,
    };
  }
}

class BookingInfo {
  String appointmentDateTime;
  String serviceName;
  String prescriptionDate;
  String appointmentType;
  String clinicName;
  int encounterStatus;
  String paymentStatus;
  num price;
  int encounterId;

  BookingInfo({
    this.appointmentDateTime = "",
    this.serviceName = "",
    this.prescriptionDate = "",
    this.appointmentType = "",
    this.clinicName = "",
    this.encounterStatus = -1,
    this.paymentStatus = "",
    this.price = 0,
    this.encounterId = -1,
  });

  factory BookingInfo.fromJson(Map<String, dynamic> json) {
    return BookingInfo(
      appointmentDateTime: json['appointment_date_time'] is String ? json['appointment_date_time'] : "",
      serviceName: json['service_name'] is String ? json['service_name'] : "",
      prescriptionDate: json['prescription_date'] is String ? json['prescription_date'] : "",
      appointmentType: json['appointment_type'] is String ? json['appointment_type'] : "",
      clinicName: json['clinic_name'] is String ? json['clinic_name'] : "",
      encounterStatus: json['encounter_status'] is int ? json['encounter_status'] : -1,
      paymentStatus: json['payment_status'] is String ? json['payment_status'] : "",
      price: json['price'] is num ? json['price'] : 0,
      encounterId: json['encounter_id'] is int ? json['encounter_id'] : -1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appointment_date_time': appointmentDateTime,
      'service_name': serviceName,
      'prescription_date': prescriptionDate,
      'appointment_type': appointmentType,
      'clinic_name': clinicName,
      'encounter_status': encounterStatus,
      'payment_status': paymentStatus,
      'price': price,
    };
  }
}

class MedicineInfo {
  int id;
  int medicineId;
  String name;
  String form;
  String dosage;
  String frequency;
  String days;
  int quantity;
  String expiryDate;
  num medicinePrice;
  num totalAmount;
  num avilableStock;
  String instruction;
  MedicineCategory category;

  MedicineInfo({
    this.id = -1,
    this.medicineId = -1,
    this.name = "",
    this.form = "",
    this.dosage = "",
    this.frequency = "",
    this.days = "",
    this.quantity = 0,
    this.expiryDate = "",
    this.medicinePrice = 0,
    this.totalAmount = 0,
    this.avilableStock = 0,
    this.instruction = "",
    required this.category,
  });

  factory MedicineInfo.fromJson(Map<String, dynamic> json) {
    return MedicineInfo(
      id: json['id'] is int ? json['id'] : -1,
      medicineId: json['medicine_id'] is int ? json['medicine_id'] : -1,
      name: json['name'] is String ? json['name'] : "",
      form: json['form'] is String ? json['form'] : "",
      dosage: json['dosage'] is String ? json['dosage'] : "",
      frequency: json['frequency'] is String ? json['frequency'] : "",
      days: json['days'] is String ? json['days'] : "",
      quantity: json['quantity'] is int ? json['quantity'] : 0,
      expiryDate: json['expiry_date'] is String ? json['expiry_date'] : "",
      medicinePrice: json['medicine_price'] is num ? json['medicine_price'] : 0,
      totalAmount: json['total_amount'] is num ? json['total_amount'] : 0,
      avilableStock: json['avilable_stock'] is num ? json['avilable_stock'] : 0,
      instruction: json['instruction'] is String ? json['instruction'] : "",
      category: json['category'] is Map ? MedicineCategory.fromJson(json['category']) : MedicineCategory(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'form': form,
      'dosage': dosage,
      'frequency': frequency,
      'days': days,
      'quantity': quantity,
      'expiry_date': expiryDate,
      'medicine_price': medicinePrice,
      'total_amount': totalAmount,
      'avilable_stock': avilableStock,
      'instruction': instruction,
      'category': category.toJson(),
    };
  }
}


class PaymentInfo {
  num medicineTotal;
  List<TaxPercentage> inclusiveTax;
  List<TaxPercentage> exclusiveTax;
  num exclusiveTaxAmount;
  num inclusiveTaxAmount;
  num totalAmount;

  PaymentInfo({
    this.medicineTotal = -1,
    this.inclusiveTax = const <TaxPercentage>[],
    this.exclusiveTax = const <TaxPercentage>[],
    this.exclusiveTaxAmount = 0,
    this.inclusiveTaxAmount = 0,
    this.totalAmount = 0,
  });

  factory PaymentInfo.fromJson(Map<String, dynamic> json) {
    return PaymentInfo(
      medicineTotal: json['medicine_total'] is num ? json['medicine_total'] : 0,
      inclusiveTax: json['inclusive_tax'] is List ? List<TaxPercentage>.from(json['inclusive_tax'].map((x) => TaxPercentage.fromJson(x))) : [],
      exclusiveTax: json['exclusive_tax'] is List ? List<TaxPercentage>.from(json['exclusive_tax'].map((x) => TaxPercentage.fromJson(x))) : [],
      exclusiveTaxAmount: json['exclusive_tax_amount'] is num ? json['exclusive_tax_amount'] : 0,
      inclusiveTaxAmount: json['inclusive_tax_amount'] is num ? json['inclusive_tax_amount'] : 0,
      totalAmount: json['total_amount'] is num ? json['total_amount'] : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medicine_total': medicineTotal,
      'inclusive_tax': inclusiveTax.map((e) => e.toJson()).toList(),
      'exclusive_tax': exclusiveTax.map((e) => e.toJson()).toList(),
      'exclusive_tax_amount': exclusiveTaxAmount,
      'inclusive_tax_amount': inclusiveTaxAmount,
      'total_amount': totalAmount,
    };
  }
}

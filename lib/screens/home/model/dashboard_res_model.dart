
import 'package:kivicare_clinic_admin/utils/constants.dart';
import '../../appointment/model/appointments_res_model.dart';
import '../../bed_management/model/bed_master_model.dart';
import '../../clinic/model/clinics_res_model.dart';
import '../../pharma/medicine/model/medicine_resp_model.dart';
import '../../pharma/prescriptions/model/prescriptions_res_model.dart';
import '../../service/model/service_list_model.dart';

class DashboardRes {
  bool status;
  DashboardData data;
  String message;

  DashboardRes({
    this.status = false,
    required this.data,
    this.message = "",
  });

  factory DashboardRes.fromJson(Map<String, dynamic> json) {
    return DashboardRes(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is Map ? DashboardData.fromJson(json['data']) : DashboardData(),
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

class DashboardData {
  int vendorTotalClinic;
  int vendorTotalService;
  int vendorTotalAppoinment;
  num vendorTotalEarning;
  int vendorTotalDoctors;
  int vendorTotalPatient;
  List<AppointmentData> upcomingAppointment;
  List<ClinicData> clinics;

  //Doctor analytics
  int doctorTotalAppointments;
  int doctorTotalPatient;
  num doctorTotalEarning;
  int doctorTotalServiceCount;
  List<ServiceElement> doctorServices;

  //Receptionist analytics
  int receptionistTotalAppointments;
  int receptionistTotalServiceCount;
  int receptionistTotalPatient;
  num receptionistTotalEarning;
  int receptionistTotalAssignDoctor;
  List<ClinicData> receptionistClinic;

  //Pharma analytics
  int pharmaTotalMedicine;
  int pharmaTopMedicine;
  int pharmaExpiredMedicine;
  int pharmaLowStockMedicine;
  num pharmaTotalEarning;
  num pharmaTotalRevenue;
  List<Supplier> topSuppliers;
  List<PrescriptionData> todayPrescription;

  //Unread Notificaions
  int unReadCount;
  List<BedMasterModel> latestUpdatedBeds;

  DashboardData({
    this.vendorTotalClinic = 0,
    this.vendorTotalService = 0,
    this.vendorTotalAppoinment = 0,
    this.vendorTotalEarning = 0,
    this.vendorTotalDoctors = 0,
    this.vendorTotalPatient = 0,
    this.upcomingAppointment = const <AppointmentData>[],
    this.clinics = const <ClinicData>[],

    //Doctor analytics
    this.doctorTotalAppointments = 0,
    this.doctorTotalPatient = 0,
    this.doctorTotalEarning = 0,
    this.doctorTotalServiceCount = 0,
    this.doctorServices = const <ServiceElement>[],

    //Receptionist analytics
    this.receptionistTotalAppointments = 0,
    this.receptionistTotalServiceCount = 0,
    this.receptionistTotalPatient = 0,
    this.receptionistTotalEarning = 0,
    this.receptionistTotalAssignDoctor = 0,
    this.receptionistClinic = const <ClinicData>[],

    //Pharma analytics
    this.pharmaTotalMedicine = 0,
    this.pharmaTopMedicine = 0,
    this.pharmaExpiredMedicine = 0,
    this.pharmaLowStockMedicine = 0,
    this.pharmaTotalEarning = 0.0,
    this.pharmaTotalRevenue = 0.0,
    this.topSuppliers = const <Supplier>[],
    this.todayPrescription = const <PrescriptionData>[],

    //Unread Notificaions
    this.unReadCount = 0,
    this.latestUpdatedBeds = const <BedMasterModel>[],
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      vendorTotalClinic: json['vendor_total_clinic'] is int ? json['vendor_total_clinic'] : 0,
      vendorTotalService: json['vendor_total_service'] is int ? json['vendor_total_service'] : 0,
      vendorTotalAppoinment: json['vendor_total_appoinment'] is int ? json['vendor_total_appoinment'] : 0,
      vendorTotalEarning: json['vendor_total_earning'] is num ? json['vendor_total_earning'] : 0,
      vendorTotalDoctors: json['vendor_total_doctors'] is int ? json['vendor_total_doctors'] : 0,
      vendorTotalPatient: json['vendor_total_patient'] is int ? json['vendor_total_patient'] : 0,
      upcomingAppointment: json['upcoming_appointment'] is List ? List<AppointmentData>.from(json['upcoming_appointment'].map((x) => AppointmentData.fromJson(x))) : [],
      clinics: json['clinics'] is List ? List<ClinicData>.from(json['clinics'].map((x) => ClinicData.fromJson(x))) : [],

      //Doctor analytics
      doctorTotalAppointments: json['doctor_total_appointments'] is int ? json['doctor_total_appointments'] : 0,
      doctorTotalPatient: json['doctor_total_patient'] is int ? json['doctor_total_patient'] : 0,
      doctorTotalEarning: json['doctor_total_earning'] is num ? json['doctor_total_earning'] : 0,
      doctorTotalServiceCount: json['doctor_total_service_count'] is int ? json['doctor_total_service_count'] : 0,
      doctorServices: json['doctor_services'] is List ? List<ServiceElement>.from(json['doctor_services'].map((x) => ServiceElement.fromJson(x))) : [],

      //Receptionist analytics
      receptionistTotalAppointments: json['receptionist_total_appointments'] is int ? json['receptionist_total_appointments'] : 0,
      receptionistTotalServiceCount: json['receptionist_total_service_count'] is int ? json['receptionist_total_service_count'] : 0,
      receptionistTotalPatient: json['receptionist_total_patient'] is int ? json['receptionist_total_patient'] : 0,
      receptionistTotalEarning: json['receptionist_total_earning'] is num ? json['receptionist_total_earning'] : 0,
      receptionistTotalAssignDoctor: json['receptionist_total_assign_doctor'] is int ? json['receptionist_total_assign_doctor'] : 0,
      receptionistClinic: json['receptionist_clinic'] is List ? List<ClinicData>.from(json['receptionist_clinic'].map((x) => ClinicData.fromJson(x))) : [],

      //Pharma analytics
      pharmaTotalMedicine: json['pharma_total_medicine'] is int ? json['pharma_total_medicine'] : -1,
      pharmaTopMedicine: json['pharma_top_medicine'] is int ? json['pharma_top_medicine'] : -1,
      pharmaExpiredMedicine: json['pharma_expired_medicine'] is int ? json['pharma_expired_medicine'] : -1,
      pharmaLowStockMedicine: json['pharma_low_stock_medicine'] is int ? json['pharma_low_stock_medicine'] : -1,
      pharmaTotalEarning: json['pharma_total_earning'] is num ? json['pharma_total_earning'] : 0.0,
      pharmaTotalRevenue: json['pharma_total_revenue'] is num ? json['pharma_total_revenue'] : 0.0,
      topSuppliers: json['top_suppliers'] is List ? List<Supplier>.from(json['top_suppliers'].map((x) => Supplier.fromJson(x))) : [],
      todayPrescription: json['today_prescription'] is List ? List<PrescriptionData>.from(json['today_prescription'].map((x) => PrescriptionData.fromJson(x))) : [],

      //Unread Notificaions
      unReadCount: json['notification_count'] is int ? json['notification_count'] : 0,
      latestUpdatedBeds: json['latest_updated_beds'] is List ? List<BedMasterModel>.from(json['latest_updated_beds'].map((x) => BedMasterModel.fromJson(x))) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      //Vendor analytics
      'vendor_total_clinic': vendorTotalClinic,
      'vendor_total_service': vendorTotalService,
      'vendor_total_appoinment': vendorTotalAppoinment,
      'vendor_total_earning': vendorTotalEarning,
      'vendor_total_doctors': vendorTotalDoctors,
      'vendor_total_customers': vendorTotalPatient,
      'upcoming_appointment': upcomingAppointment.map((e) => e.toJson()).toList(),
      'clinics': clinics.map((e) => e.toJson()).toList(),

      //Doctor analytics
      'doctor_total_appointments': doctorTotalAppointments,
      'doctor_total_patient': doctorTotalPatient,
      'doctor_total_earning': doctorTotalEarning,
      'doctor_total_service_count': doctorTotalServiceCount,
      'doctor_services': doctorServices.map((e) => e.toJson()).toList(),

      //Receptionist analytics
      'receptionist_total_appointments': receptionistTotalAppointments,
      'receptionist_total_service_count': receptionistTotalServiceCount,
      'receptionist_total_patient': receptionistTotalPatient,
      'receptionist_total_earning': receptionistTotalEarning,
      'receptionist_total_assign_doctor': receptionistTotalAssignDoctor,
      'receptionist_clinic': receptionistClinic.map((e) => e.toJson()).toList(),

      //Pharma analytics
      'pharma_total_medicine': pharmaTotalMedicine,
      'pharma_top_medicine': pharmaTopMedicine,
      'pharma_expired_medicine': pharmaExpiredMedicine,
      'pharma_low_stock_medicine': pharmaLowStockMedicine,
      'pharma_total_earning': pharmaTotalEarning,
      'pharma_total_revenue': pharmaTotalRevenue,
      'top_suppliers': topSuppliers.map((e) => e.toJson()).toList(),
      'today_prescription': todayPrescription.map((e) => e.toJson()).toList(),

      //Unread Notificaions
      'notification_count': unReadCount,
      'latest_updated_beds': latestUpdatedBeds.map((e) => e.toJson()).toList(),
    };
  }
}

class TaxPercentage {
  int id;
  String title;
  String type;
  String taxScope;
  String bookingType;
  num value;
  num amount;
  num? totalCalculatedValue;

  TaxPercentage({
    this.id = -1,
    this.title = "",
    this.type = "",
    this.taxScope = TaxType.exclusiveTax,
    this.bookingType = "",
    this.value = 0,
    this.amount = 0,
    this.totalCalculatedValue,
  });

  factory TaxPercentage.fromJson(Map<String, dynamic> json) {
    return TaxPercentage(
      id: json['id'] is int ? json['id'] : -1,
      title: json['title'] is String ? json['title'] : "",
      type: json['type'] is String ? json['type'] : "",
      taxScope: json['tax_scope'] is String ? json['tax_scope'] : TaxType.exclusiveTax,
      bookingType: json['booking_type'] is String ? json['booking_type'] : "",
      value: json['value'] is num ? json['value'] : 0,
      amount: json['amount'] is num ? json['amount'] : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'tax_scope': taxScope,
      'booking_type': bookingType,
      'value': value,
      'amount': amount,
    };
  }
}

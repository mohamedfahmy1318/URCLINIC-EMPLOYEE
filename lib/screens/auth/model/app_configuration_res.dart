import '../../../utils/constants.dart';
import '../../home/model/dashboard_res_model.dart';

class ConfigurationResponse {
  RazorPay razorPay;
  StripePay stripePay;
  PaystackPay paystackPay;
  PaypalPay paypalPay;
  FlutterwavePay flutterwavePay;
  PatientAppUrl patientAppUrl;
  ClinicadminAppUrl clinicadminAppUrl;
  bool isForceUpdateforAndroid;
  int patientAndroidMinForceUpdateCode;
  int patientAndroidLatestVersionUpdateCode;
  int clinicadminAndroidMinForceUpdateCode;
  int clinicadminAndroidLatestVersionUpdateCode;
  bool isForceUpdateforIos;
  int patientIosMinForceUpdateCode;
  int patientIosLatestVersionUpdateCode;
  int clinicadminIosMinForceUpdateCode;
  int clinicadminIosLatestVersionUpdateCode;
  Currency currency;
  String siteDescription;
  int isUserPushNotification;
  int enableChatGpt;
  int testWithoutKey;
  String chatgptKey;
  String notification;
  String firebaseKey;
  int inAppPurchase;
  String applicationLanguage;
  bool status;
  bool viewPatientSoap;
  bool isBodyChart;
  bool isTelemedSetting;
  bool isMultiVendor;
  bool isEncounterProblem;
  bool isEncounterObservation;
  bool isEncounterNote;
  bool isEncounterPrescription;
  String cancellationType;
  int cancellationCharge;
  int cancellationChargeHours;
  bool isCancellationChargeEnabled;
  int isPharma;

  List<TaxPercentage> taxData;

  bool get isTaxDetailsAvailable => taxData.isNotEmpty;

  List<TaxPercentage> get exclusiveTaxList => taxData.where((element) => element.taxScope == TaxType.exclusiveTax).toList();

  List<TaxPercentage> get inclusiveTaxList => taxData.where((element) => element.taxScope == TaxType.inclusiveTax).toList();

  bool get isInclusiveTaxesAvailable => inclusiveTaxList.isNotEmpty;

  bool get isExclusiveTaxesAvailable => exclusiveTaxList.isNotEmpty;

  int isDummyCredential;

  ConfigurationResponse({
    required this.razorPay,
    required this.stripePay,
    required this.paystackPay,
    required this.paypalPay,
    required this.flutterwavePay,
    required this.patientAppUrl,
    required this.clinicadminAppUrl,
    this.isForceUpdateforAndroid = false,
    this.patientAndroidMinForceUpdateCode = 0,
    this.patientAndroidLatestVersionUpdateCode = 0,
    this.clinicadminAndroidMinForceUpdateCode = 0,
    this.clinicadminAndroidLatestVersionUpdateCode = 0,
    this.isForceUpdateforIos = false,
    this.patientIosMinForceUpdateCode = 0,
    this.patientIosLatestVersionUpdateCode = 0,
    this.clinicadminIosMinForceUpdateCode = 0,
    this.clinicadminIosLatestVersionUpdateCode = 0,
    required this.currency,
    this.siteDescription = "",
    this.isUserPushNotification = -1,
    this.enableChatGpt = -1,
    this.testWithoutKey = -1,
    this.chatgptKey = "",
    this.notification = "",
    this.firebaseKey = "",
    this.inAppPurchase = -1,
    this.applicationLanguage = "",
    this.status = false,
    this.viewPatientSoap = false,
    this.isBodyChart = false,
    this.isTelemedSetting = false,
    this.isMultiVendor = false,
    this.isEncounterProblem = false,
    this.isEncounterObservation = false,
    this.isEncounterNote = false,
    this.isEncounterPrescription = false,
    this.taxData = const <TaxPercentage>[],
    this.cancellationType = "",
    this.cancellationCharge = 0,
    this.cancellationChargeHours = 0,
    this.isCancellationChargeEnabled = false,
    this.isDummyCredential = 0,
    this.isPharma = 0,
  });

  factory ConfigurationResponse.fromJson(Map<String, dynamic> json) {
    return ConfigurationResponse(
      razorPay: json['razor_pay'] is Map ? RazorPay.fromJson(json['razor_pay']) : RazorPay(),
      stripePay: json['stripe_pay'] is Map ? StripePay.fromJson(json['stripe_pay']) : StripePay(),
      paystackPay: json['paystack_pay'] is Map ? PaystackPay.fromJson(json['paystack_pay']) : PaystackPay(),
      paypalPay: json['paypal_pay'] is Map ? PaypalPay.fromJson(json['paypal_pay']) : PaypalPay(),
      flutterwavePay: json['flutterwave_pay'] is Map ? FlutterwavePay.fromJson(json['flutterwave_pay']) : FlutterwavePay(),
      patientAppUrl: json['patient_app_url'] is Map ? PatientAppUrl.fromJson(json['patient_app_url']) : PatientAppUrl(),
      clinicadminAppUrl: json['clinicadmin_app_url'] is Map ? ClinicadminAppUrl.fromJson(json['clinicadmin_app_url']) : ClinicadminAppUrl(),
      isForceUpdateforAndroid: json['isForceUpdateforAndroid'] is bool ? json['isForceUpdateforAndroid'] : json['isForceUpdateforAndroid'] == 1,
      patientAndroidMinForceUpdateCode: json['patient_android_min_force_update_code'] is int ? json['patient_android_min_force_update_code'] : 0,
      patientAndroidLatestVersionUpdateCode: json['patient_android_latest_version_update_code'] is int ? json['patient_android_latest_version_update_code'] : 0,
      clinicadminAndroidMinForceUpdateCode: json['clinicadmin_android_min_force_update_code'] is int ? json['clinicadmin_android_min_force_update_code'] : 0,
      clinicadminAndroidLatestVersionUpdateCode: json['clinicadmin_android_latest_version_update_code'] is int ? json['clinicadmin_android_latest_version_update_code'] : 0,
      isForceUpdateforIos: json['isForceUpdateforIos'] is bool ? json['isForceUpdateforIos'] : json['isForceUpdateforIos'] == 1,
      patientIosMinForceUpdateCode: json['patient_ios_min_force_update_code'] is int ? json['patient_ios_min_force_update_code'] : 0,
      patientIosLatestVersionUpdateCode: json['patient_ios_latest_version_update_code'] is int ? json['patient_ios_latest_version_update_code'] : 0,
      clinicadminIosMinForceUpdateCode: json['clinicadmin_ios_min_force_update_code'] is int ? json['clinicadmin_ios_min_force_update_code'] : 0,
      clinicadminIosLatestVersionUpdateCode: json['clinicadmin_ios_latest_version_update_code'] is int ? json['clinicadmin_ios_latest_version_update_code'] : 0,
      currency: json['currency'] is Map ? Currency.fromJson(json['currency']) : Currency(),
      siteDescription: json['site_description'] is String ? json['site_description'] : "",
      isUserPushNotification: json['is_user_push_notification'] is int ? json['is_user_push_notification'] : -1,
      enableChatGpt: json['enable_chat_gpt'] is int ? json['enable_chat_gpt'] : -1,
      testWithoutKey: json['test_without_key'] is int ? json['test_without_key'] : -1,
      chatgptKey: json['chatgpt_key'] is String ? json['chatgpt_key'] : "",
      notification: json['notification'] is String ? json['notification'] : "",
      firebaseKey: json['firebase_key'] is String ? json['firebase_key'] : "",
      inAppPurchase: json['in_app_purchase'] is int ? json['in_app_purchase'] : -1,
      applicationLanguage: json['application_language'] is String ? json['application_language'] : "",
      status: json['status'] is bool ? json['status'] : false,
      viewPatientSoap: json['view_patient_soap'] is bool ? json['view_patient_soap'] : json['view_patient_soap'] == 1,
      isBodyChart: json['is_body_chart'] is bool ? json['is_body_chart'] : json['is_body_chart'] == 1,
      isTelemedSetting: json['is_telemed_setting'] is bool ? json['is_telemed_setting'] : json['is_telemed_setting'] == 1,
      isMultiVendor: json['is_multi_vendor'] is bool ? json['is_multi_vendor'] : json['is_multi_vendor'] == 1,
      isEncounterProblem: json['is_encounter_problem'] is bool ? json['is_encounter_problem'] : json['is_encounter_problem'] == 1,
      isEncounterObservation: json['is_encounter_observation'] is bool ? json['is_encounter_observation'] : json['is_encounter_observation'] == 1,
      isEncounterNote: json['is_encounter_note'] is bool ? json['is_encounter_note'] : json['is_encounter_note'] == 1,
      isEncounterPrescription: json['is_encounter_prescription'] is bool ? json['is_encounter_prescription'] : json['is_encounter_prescription'] == 1,
      taxData: json['tax'] is List ? List<TaxPercentage>.from(json['tax'].map((x) => TaxPercentage.fromJson(x))) : [],
      cancellationType: json['cancellation_type'] is String ? json['cancellation_type'] : "",
      cancellationCharge: json['cancellation_charge'] is int ? json['cancellation_charge'] : 0,
      cancellationChargeHours: json['cancellation_charge_hours'] is int ? json['cancellation_charge_hours'] : 0,
      isCancellationChargeEnabled: json['is_cancellation_charge'] is bool ? json['is_cancellation_charge'] : json['is_cancellation_charge'] == 1,
      isDummyCredential: json['is_dummy_credentials'] is int ? json['is_dummy_credentials'] : 0,
      isPharma: json['is_pharma'] is int ? json['is_pharma'] : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'razor_pay': razorPay.toJson(),
      'stripe_pay': stripePay.toJson(),
      'paystack_pay': paystackPay.toJson(),
      'paypal_pay': paypalPay.toJson(),
      'flutterwave_pay': flutterwavePay.toJson(),
      'patient_app_url': patientAppUrl.toJson(),
      'clinicadmin_app_url': clinicadminAppUrl.toJson(),
      'isForceUpdateforAndroid': isForceUpdateforAndroid,
      'patient_android_min_force_update_code': patientAndroidMinForceUpdateCode,
      'patient_android_latest_version_update_code': patientAndroidLatestVersionUpdateCode,
      'clinicadmin_android_min_force_update_code': clinicadminAndroidMinForceUpdateCode,
      'clinicadmin_android_latest_version_update_code': clinicadminAndroidLatestVersionUpdateCode,
      'isForceUpdateforIos': isForceUpdateforIos,
      'patient_ios_min_force_update_code': patientIosMinForceUpdateCode,
      'patient_ios_latest_version_update_code': patientIosLatestVersionUpdateCode,
      'clinicadmin_ios_min_force_update_code': clinicadminIosMinForceUpdateCode,
      'clinicadmin_ios_latest_version_update_code': clinicadminIosLatestVersionUpdateCode,
      'currency': currency.toJson(),
      'site_description': siteDescription,
      'is_user_push_notification': isUserPushNotification,
      'enable_chat_gpt': enableChatGpt,
      'test_without_key': testWithoutKey,
      'chatgpt_key': chatgptKey,
      'notification': notification,
      'firebase_key': firebaseKey,
      'in_app_purchase': inAppPurchase,
      'application_language': applicationLanguage,
      'view_patient_soap': viewPatientSoap,
      'is_body_chart': isBodyChart,
      'is_telemed_setting': isTelemedSetting,
      'is_multi_vendor': isMultiVendor,
      'is_encounter_problem': isEncounterProblem,
      'is_encounter_observation': isEncounterObservation,
      'is_encounter_note': isEncounterNote,
      'is_encounter_prescription': isEncounterPrescription,
      'status': status,
      'tax': taxData.map((e) => e.toJson()).toList(),
      'cancellation_type': cancellationType,
      'cancellation_charge': cancellationCharge,
      'cancellation_charge_hours': cancellationChargeHours,
      'is_cancellation_charge': isCancellationChargeEnabled,
      'is_dummy_credentials': isDummyCredential,
      'is_pharma': isPharma,
    };
  }
}

class VendorAppUrl {
  String vendorAppPlayStore;
  String vendorAppAppStore;

  VendorAppUrl({
    this.vendorAppPlayStore = "",
    this.vendorAppAppStore = "",
  });

  factory VendorAppUrl.fromJson(Map<String, dynamic> json) {
    return VendorAppUrl(
      vendorAppPlayStore: json['vendor_app_play_store'] is String ? json['vendor_app_play_store'] : "",
      vendorAppAppStore: json['vendor_app_app_store'] is String ? json['vendor_app_app_store'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vendor_app_play_store': vendorAppPlayStore,
      'vendor_app_app_store': vendorAppAppStore,
    };
  }
}

class RazorPay {
  String razorpaySecretkey;
  String razorpayPublickey;

  RazorPay({
    this.razorpaySecretkey = "",
    this.razorpayPublickey = "",
  });

  factory RazorPay.fromJson(Map<String, dynamic> json) {
    return RazorPay(
      razorpaySecretkey: json['razorpay_secretkey'] is String ? json['razorpay_secretkey'] : "",
      razorpayPublickey: json['razorpay_publickey'] is String ? json['razorpay_publickey'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'razorpay_secretkey': razorpaySecretkey,
      'razorpay_publickey': razorpayPublickey,
    };
  }
}

class StripePay {
  String stripeSecretkey;
  String stripePublickey;

  StripePay({
    this.stripeSecretkey = "",
    this.stripePublickey = "",
  });

  factory StripePay.fromJson(Map<String, dynamic> json) {
    return StripePay(
      stripeSecretkey: json['stripe_secretkey'] is String ? json['stripe_secretkey'] : "",
      stripePublickey: json['stripe_publickey'] is String ? json['stripe_publickey'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stripe_secretkey': stripeSecretkey,
      'stripe_publickey': stripePublickey,
    };
  }
}

class PaystackPay {
  String paystackSecretkey;
  String paystackPublickey;

  PaystackPay({
    this.paystackSecretkey = "",
    this.paystackPublickey = "",
  });

  factory PaystackPay.fromJson(Map<String, dynamic> json) {
    return PaystackPay(
      paystackSecretkey: json['paystack_secretkey'] is String ? json['paystack_secretkey'] : "",
      paystackPublickey: json['paystack_publickey'] is String ? json['paystack_publickey'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paystack_secretkey': paystackSecretkey,
      'paystack_publickey': paystackPublickey,
    };
  }
}

class PaypalPay {
  String paypalSecretkey;
  String paypalClientid;

  PaypalPay({
    this.paypalSecretkey = "",
    this.paypalClientid = "",
  });

  factory PaypalPay.fromJson(Map<String, dynamic> json) {
    return PaypalPay(
      paypalSecretkey: json['paypal_secretkey'] is String ? json['paypal_secretkey'] : "",
      paypalClientid: json['paypal_clientid'] is String ? json['paypal_clientid'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paypal_secretkey': paypalSecretkey,
      'paypal_clientid': paypalClientid,
    };
  }
}

class FlutterwavePay {
  String flutterwaveSecretkey;
  String flutterwavePublickey;

  FlutterwavePay({
    this.flutterwaveSecretkey = "",
    this.flutterwavePublickey = "",
  });

  factory FlutterwavePay.fromJson(Map<String, dynamic> json) {
    return FlutterwavePay(
      flutterwaveSecretkey: json['flutterwave_secretkey'] is String ? json['flutterwave_secretkey'] : "",
      flutterwavePublickey: json['flutterwave_publickey'] is String ? json['flutterwave_publickey'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'flutterwave_secretkey': flutterwaveSecretkey,
      'flutterwave_publickey': flutterwavePublickey,
    };
  }
}

class Currency {
  String currencyName;
  String currencySymbol;
  String currencyCode;
  String currencyPosition;
  int noOfDecimal;
  String thousandSeparator;
  String decimalSeparator;

  Currency({
    this.currencyName = "Doller",
    this.currencySymbol = "\$",
    this.currencyCode = "USD",
    this.currencyPosition = CurrencyPosition.CURRENCY_POSITION_LEFT,
    this.noOfDecimal = 2,
    this.thousandSeparator = ",",
    this.decimalSeparator = ".",
  });

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      currencyName: json['currency_name'] is String ? json['currency_name'] : "Doller",
      currencySymbol: json['currency_symbol'] is String ? json['currency_symbol'] : "\$",
      currencyCode: json['currency_code'] is String ? json['currency_code'] : "USD",
      currencyPosition: json['currency_position'] is String ? json['currency_position'] : "left",
      noOfDecimal: json['no_of_decimal'] is int ? json['no_of_decimal'] : 2,
      thousandSeparator: json['thousand_separator'] is String ? json['thousand_separator'] : ",",
      decimalSeparator: json['decimal_separator'] is String ? json['decimal_separator'] : ".",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currency_name': currencyName,
      'currency_symbol': currencySymbol,
      'currency_code': currencyCode,
      'currency_position': currencyPosition,
      'no_of_decimal': noOfDecimal,
      'thousand_separator': thousandSeparator,
      'decimal_separator': decimalSeparator,
    };
  }
}

class PatientAppUrl {
  String patientAppPlayStore;
  String patientAppAppStore;

  PatientAppUrl({
    this.patientAppPlayStore = "",
    this.patientAppAppStore = "",
  });

  factory PatientAppUrl.fromJson(Map<String, dynamic> json) {
    return PatientAppUrl(
      patientAppPlayStore: json['patient_app_play_store'] is String ? json['patient_app_play_store'] : "",
      patientAppAppStore: json['patient_app_app_store'] is String ? json['patient_app_app_store'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'patient_app_play_store': patientAppPlayStore,
      'patient_app_app_store': patientAppAppStore,
    };
  }
}

class ClinicadminAppUrl {
  String clinicadminAppPlayStore;
  String clinicadminAppAppStore;

  ClinicadminAppUrl({
    this.clinicadminAppPlayStore = "",
    this.clinicadminAppAppStore = "",
  });

  factory ClinicadminAppUrl.fromJson(Map<String, dynamic> json) {
    return ClinicadminAppUrl(
      clinicadminAppPlayStore: json['clinicadmin_app_play_store'] is String ? json['clinicadmin_app_play_store'] : "",
      clinicadminAppAppStore: json['clinicadmin_app_app_store'] is String ? json['clinicadmin_app_app_store'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clinicadmin_app_play_store': clinicadminAppPlayStore,
      'clinicadmin_app_app_store': clinicadminAppAppStore,
    };
  }
}

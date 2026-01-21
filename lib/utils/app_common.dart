import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/api/core_apis.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/clinic/model/clinics_res_model.dart';
import '../configs.dart';
import '../main.dart';
import '../screens/appointment/model/save_booking_res.dart';
import '../screens/auth/model/about_page_res.dart';
import '../screens/auth/model/app_configuration_res.dart';
import '../screens/auth/model/login_response.dart';
import 'colors.dart';
import 'package:kivicare_clinic_admin/utils/constants.dart';
import '../locale/app_localizations.dart';
import '../locale/languages.dart';
import 'local_storage.dart';

bool isIqonicProduct = DOMAIN_URL.contains("apps.iqonic.design") || DOMAIN_URL.contains("iqonic.design") || DOMAIN_URL.contains("innoquad.in");

//Firebase App Name Topic
String get appNameTopic => APP_NAME
    .toLowerCase()
    .replaceAll(RegExp('[^a-z0-9]+'), '-') // replace non-alphanumerics with '-'
    .replaceAll(RegExp('-+'), '-') // collapse multiple dashes into one
    .replaceAll(RegExp(r'^-+|-+$'), ''); // trim leading/trailing dashes
//endregion
RxString selectedLanguageCode = DEFAULT_LANGUAGE.obs;
RxBool isLoggedIn = false.obs;
Rx<UserData> loginUserData = UserData().obs;
RxBool isDarkMode = false.obs;
RxInt unreadNotificationCount = 0.obs;

Rx<Currency> appCurrency = Currency().obs;
Rx<ConfigurationResponse> appConfigs = ConfigurationResponse(
  patientAppUrl: PatientAppUrl(),
  clinicadminAppUrl: ClinicadminAppUrl(),
  razorPay: RazorPay(),
  stripePay: StripePay(),
  paystackPay: PaystackPay(),
  paypalPay: PaypalPay(),
  flutterwavePay: FlutterwavePay(),
  currency: Currency(),
).obs;

//
Rx<PackageInfoData> currentPackageinfo = PackageInfoData().obs;
Rx<ClinicData> selectedAppClinic = ClinicData().obs;
RxList<CommissionModel> selectedAppCommission = <CommissionModel>[].obs;

// Currency position common
bool get isCurrencyPositionLeft => appCurrency.value.currencyPosition == CurrencyPosition.CURRENCY_POSITION_LEFT;

bool get isCurrencyPositionRight => appCurrency.value.currencyPosition == CurrencyPosition.CURRENCY_POSITION_RIGHT;

bool get isCurrencyPositionLeftWithSpace => appCurrency.value.currencyPosition == CurrencyPosition.CURRENCY_POSITION_LEFT_WITH_SPACE;

bool get isCurrencyPositionRightWithSpace => appCurrency.value.currencyPosition == CurrencyPosition.CURRENCY_POSITION_RIGHT_WITH_SPACE;
//endregion

RxList<AboutDataModel> aboutPages = RxList();

Rx<SaveBookingRes> saveBookingRes = SaveBookingRes(saveBookingResData: SaveBookingResData()).obs;
//Booking Success
RxString bookingSuccessDate = "".obs;
// Rx<SaveBookingRes> saveBookingRes = SaveBookingRes().obs;
//

bool canLaunchVideoCall({required String status}) => status.toLowerCase().contains(StatusConst.confirmed) || status.toLowerCase().contains(StatusConst.check_in);

String getBookingStatus({required String status}) {
  if (status.toLowerCase().contains(StatusConst.pending)) {
    return locale.value.pending;
  } else if (status.toLowerCase().contains(StatusConst.completed)) {
    return locale.value.completed;
  } else if (status.toLowerCase().contains(StatusConst.confirmed)) {
    return locale.value.confirmed;
  } else if (status.toLowerCase().contains(StatusConst.cancel)) {
    return locale.value.cancelled;
  } else if (status.toLowerCase().contains(StatusConst.inprogress)) {
    return locale.value.inProgress;
  } else if (status.toLowerCase().contains(StatusConst.reject)) {
    return locale.value.rejected;
  } else if (status.toLowerCase().contains(StatusConst.check_in)) {
    return locale.value.checkIn;
  } else if (status.toLowerCase().contains(StatusConst.checkout)) {
    return locale.value.completed;
  } else {
    return "";
  }
}

Color getBookingStatusColor({required String status}) {
  if (status.toLowerCase().contains(StatusConst.pending)) {
    return pendingStatusColor;
  } else if (status.toLowerCase().contains(StatusConst.upcoming)) {
    return upcomingStatusColor;
  } else if (status.toLowerCase().contains(StatusConst.confirmed)) {
    return confirmedStatusColor;
  } else if (status.toLowerCase().contains(StatusConst.check_in)) {
    return inprogressStatusColor;
  } else if (status.toLowerCase().contains(StatusConst.completed)) {
    return confirmedStatusColor;
  } else if (status.toLowerCase().contains(StatusConst.cancel)) {
    return cancelStatusColor;
  } else if (status.toLowerCase().contains(StatusConst.reject)) {
    return cancelStatusColor;
  } else if (status.toLowerCase().contains(StatusConst.checkout)) {
    return confirmedStatusColor;
  } else {
    return defaultStatusColor;
  }
}
String getBookingPaymentStatus({required String status}) {
  // Convert numeric values to correct status name
  switch (status) {
    case "1":
      return locale.value.paid;
    case "2":
      return locale.value.failed;
    case "0":
    default:
      return locale.value.pending;
  }
}

/*String getBookingPaymentStatus({required String status}) {
  if (status.toLowerCase().contains(PaymentStatus.pending)) {
    return locale.value.pending;
  } else if (status.toLowerCase().contains(PaymentStatus.ADVANCE_PAID)) {
    return locale.value.advancePaid;
  } else if (status.toLowerCase().contains(PaymentStatus.PAID)) {
    return locale.value.paid;
  } else if (status.toLowerCase().contains(PaymentStatus.ADVANCE_REFUNDED)) {
    return locale.value.advanceRefunded;
  } else if (status.toLowerCase().contains(PaymentStatus.REFUNDED)) {
    return locale.value.refunded;
  } else if (status.toLowerCase().contains(PaymentStatus.failed)) {
    return locale.value.failed;
  } else {
    return status;
  }
}*/

String getPrescriptionStatus({required String status}) {
  if (status.toLowerCase().contains(StatusConst.pending)) {
    return locale.value.pending;
  } else if (status.toLowerCase().contains(StatusConst.completed) || status.toLowerCase().contains(PaymentStatus.PAID)) {
    return locale.value.completed;
  } else {
    return status;
  }
}

Color getPrescriptionStatusColor({required String status}) {
  if (status.toLowerCase().contains(StatusConst.pending)) {
    return pendingStatusColor;
  } else if (status.toLowerCase().contains(StatusConst.completed)) {
    return completedStatusColor;
  } else {
    return confirmedStatusColor;
  }
}

String getPrescriptionPaymentStatus({required String status}) {
  if (status.toLowerCase().contains(PaymentStatus.pending) || status.toLowerCase().contains(PaymentStatus.UNPAID)) {
    return locale.value.unpaid;
  } else if (status.toLowerCase().contains(StatusConst.completed) || status.toLowerCase().contains(PaymentStatus.PAID)) {
    return locale.value.paid;
  } else {
    return status;
  }
}

Color getPrescriptionPaymentStatusColor({required String paymentStatus}) {
  if (paymentStatus.toLowerCase().contains(PaymentStatus.pending) || paymentStatus.toLowerCase().contains(PaymentStatus.UNPAID)) {
    return pendingStatusColor;
  } else if (paymentStatus.toLowerCase().contains(StatusConst.completed) || paymentStatus.toLowerCase().contains(PaymentStatus.PAID)) {
    return completedStatusColor;
  } else {
    return confirmedStatusColor;
  }
}

Color getPriceStatusColor({required String paymentStatus}) {
  if (paymentStatus.toLowerCase().contains(PaymentStatus.pending)) {
    return pendingStatusColor;
  } else if (paymentStatus.toLowerCase().contains(PaymentStatus.ADVANCE_PAID)) {
    return completedStatusColor;
  } else if (paymentStatus.toLowerCase().contains(PaymentStatus.PAID)) {
    return completedStatusColor;
  } else if (paymentStatus.toLowerCase().contains(PaymentStatus.ADVANCE_REFUNDED)) {
    return confirmedStatusColor;
  } else if (paymentStatus.toLowerCase().contains(PaymentStatus.REFUNDED)) {
    return confirmedStatusColor;
  } else {
    return defaultStatusColor;
  }
}
Color getNewPriceStatusColor({required String paymentStatus}) {
  switch (paymentStatus) {
    case "1":
      return completedStatusColor;
    case "2":
      return  defaultStatusColor;
    case "0":
    default:
      return pendingStatusColor;
  }
}

String getRequestStatus({required String status}) {
  if (status.toLowerCase().contains(RequestStatus.pending)) {
    return locale.value.pending;
  } else if (status.toLowerCase().contains(RequestStatus.approved) || status.toLowerCase().contains(RequestStatus.accept)) {
    return locale.value.approved;
  } else if (status.toLowerCase().contains(RequestStatus.rejected)) {
    return locale.value.rejected;
  } else {
    return "";
  }
}

Color getRequestStatusColor({required String requestStatus}) {
  if (requestStatus.toLowerCase().contains(RequestStatus.pending)) {
    return pendingStatusColor;
  } else if (requestStatus.toLowerCase().contains(RequestStatus.approved) || requestStatus.toLowerCase().contains(RequestStatus.accept)) {
    return completedStatusColor;
  } else if (requestStatus.toLowerCase().contains(RequestStatus.rejected)) {
    return cancelStatusColor;
  } else {
    return defaultStatusColor;
  }
}

String getOrderStatus({required String status}) {
  if (status.toLowerCase().contains(StatusConst.pending)) {
    return locale.value.pending;
  } else if (status.toLowerCase().contains(StatusConst.delivered) ) {
    return locale.value.delivered;
  } else {
    return status;
  }
}
Color getOrderStatusColor({required String orderStatus}) {
  if (orderStatus.toLowerCase().contains(PaymentStatus.pending) ) {
    return pendingStatusColor;
  } else if (orderStatus.toLowerCase().contains(StatusConst.delivered) ) {
    return completedStatusColor;
  } else {
    return cancelStatusColor;
  }
}

String getUserRoleTopic(String userRole) {
  return userRole.toLowerCase().replaceAll(' ', '_');
}

// Normalize codes like en-US / en_US to en
String _normalizeLanguageCode(String code) {
  if (code.isEmpty) return DEFAULT_LANGUAGE;
  final parts = code.split(RegExp(r'[-_]'));
  return parts.isNotEmpty ? parts.first : code;
}

// Apply admin default language live if it differs from current
Future<void> applyLanguageFromConfigIfChanged(String languageCode) async {
  try {
    final String newCode = _normalizeLanguageCode(languageCode.validate(value: DEFAULT_LANGUAGE));
    if (newCode.isEmpty || newCode == selectedLanguageCode.value) return;

    await setValue(SELECTED_LANGUAGE_CODE, newCode);
    setValueToLocal(SELECTED_LANGUAGE_CODE, newCode);
    selectedLanguageCode(newCode);

    BaseLanguage temp = await const AppLocalizations().load(Locale(newCode));
    locale.value = temp;
    Get.updateLocale(Locale(newCode));
  } catch (e) {
    // Ignore localization errors silently
  }
}

bool checkTimeDifference({required DateTime inputDateTime}) {
  final DateTime currentTime = DateTime.now();

  if (currentTime.isBefore(inputDateTime) && inputDateTime.difference(currentTime).inHours <= appConfigs.value.cancellationChargeHours) {
    return true;
  }

  // Check if the current time is after the booking date and time
  if (currentTime.isAfter(inputDateTime)) {
    return false;
  }

  // Otherwise, it's more than 12 hours before the booking time
  return false;
}

/// Convert bed name to bed ID
/// This utility function helps convert bed names to IDs when needed for backend API calls
Future<int?> getBedIdFromName(String bedName) async {
  try {
    // First try to get from bed masters
    int? bedId = await CoreServiceApis.getBedIdByName(bedName);

    // If not found, try from bed list
    bedId ??= await CoreServiceApis.getBedIdByNameFromBedList(bedName);

    return bedId;
  } catch (e) {
    return null;
  }
}

/// Convert bed name to bed ID with caching
/// This version caches the result to avoid repeated API calls
Map<String, int> _bedNameToIdCache = {};

Future<int?> getBedIdFromNameCached(String bedName) async {
  // Check cache first
  if (_bedNameToIdCache.containsKey(bedName)) {
    return _bedNameToIdCache[bedName];
  }

  try {
    // Get bed ID
    int? bedId = await getBedIdFromName(bedName);

    // Cache the result
    if (bedId != null) {
      _bedNameToIdCache[bedName] = bedId;
    }

    return bedId;
  } catch (e) {
    return null;
  }
}

/// Clear bed name to ID cache
/// Call this when bed data might have changed
void clearBedNameToIdCache() {
  _bedNameToIdCache.clear();
}


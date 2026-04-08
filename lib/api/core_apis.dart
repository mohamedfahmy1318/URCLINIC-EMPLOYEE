import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kivicare_clinic_admin/screens/bed_management/bed_type/model/bed_type_model.dart';
import 'package:kivicare_clinic_admin/screens/doctor/doctor_session/model/doctor_session_model.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/Encounter/add_encounter/model/encounter_resp_model.dart';
import 'package:kivicare_clinic_admin/screens/service/model/service_list_model.dart';

import '../models/base_response_model.dart';
import '../network/network_utils.dart';
import '../screens/Encounter/add_encounter/model/patient_model.dart';
import '../screens/Encounter/body_chart/model/body_chart_resp.dart';
import '../screens/Encounter/generate_invoice/model/encounter_details_resp.dart';
import '../screens/Encounter/generate_invoice/model/service_details_resp.dart';
import '../screens/Encounter/invoice_details/model/billing_details_resp.dart';
import '../screens/Encounter/model/enc_dashboard_detail_res.dart';
import '../screens/Encounter/model/encounter_invoice_resp.dart';
import '../screens/Encounter/model/encounters_list_model.dart';
import '../screens/Encounter/model/get_soap_res.dart';
import '../screens/Encounter/model/medical_reports_res_model.dart';
import '../screens/Encounter/model/problems_observations_model.dart';
import '../screens/appointment/add_appointment/appointment_slot_model.dart';
import '../screens/appointment/model/appointment_details_resp.dart';
import '../screens/appointment/model/appointment_invoice_res.dart';
import '../screens/appointment/model/appointments_res_model.dart';
import '../screens/appointment/model/encounter_detail_model.dart';
import '../screens/appointment/model/other_patient_list_res.dart';
import '../screens/appointment/model/review_res_model.dart';
import '../screens/appointment/model/save_booking_res.dart';
import '../screens/auth/model/login_response.dart';
import '../screens/category/model/all_category_model.dart';
import '../screens/bed_management/bed_type/model/bed_type_model.dart'
    show BedTypeElement, BedTypeListRes;
import '../screens/payout/model/payout_model.dart';
import '../screens/clinic/add_clinic_form/model/specialization_resp.dart';
import '../screens/clinic/model/clinics_res_model.dart';
import '../screens/doctor/doctor_session/add_session/model/doctor_session_model.dart'
    hide DoctorSessionModel;
import '../screens/doctor/model/doctor_list_res.dart';
import '../screens/doctor/model/review_model.dart';
import '../screens/pharma/medicine/model/medicine_resp_model.dart';
import '../screens/receptionist/model/receptionist_res_model.dart';
import '../screens/requests/model/service_request_model.dart';
import '../utils/api_end_points.dart';
import '../utils/app_common.dart';
import '../utils/constants.dart';
import 'package:kivicare_clinic_admin/screens/bed_management/model/bed_master_model.dart';
import 'package:kivicare_clinic_admin/screens/bed_management/model/bed_list_model.dart';

class CoreServiceApis {
  // Keep this false until backend fully supports bed-management endpoints.
  static bool isBedFeatureEnabled = false;
  static bool _isBedFeatureUnavailableFromBackend = false;

  static bool get isBedFeatureAvailable =>
      isBedFeatureEnabled && !_isBedFeatureUnavailableFromBackend;

  static bool isBedFeatureUnavailableError(Object error) {
    final message = error.toString().toLowerCase();
    return message.contains('404') ||
        message.contains('page not found') ||
        message.contains('not found');
  }

  static void _markBedFeatureUnavailable({
    String? endpoint,
    int? statusCode,
    Object? error,
  }) {
    if (_isBedFeatureUnavailableFromBackend) return;

    _isBedFeatureUnavailableFromBackend = true;
    final source = endpoint ?? 'bed endpoint';
    final details = error != null ? error.toString() : 'HTTP $statusCode';
    log('Bed feature disabled because $source is unavailable ($details).');
  }

  static Future<dynamic> _executeBedRequest(
    String endPoint, {
    HttpMethodType method = HttpMethodType.GET,
    Map? request,
    Map? extraKeys,
  }) async {
    if (!isBedFeatureAvailable) return null;

    try {
      final response = await buildHttpResponse(
        endPoint,
        method: method,
        request: request,
        extraKeys: extraKeys,
      );

      if (response.statusCode == 404) {
        _markBedFeatureUnavailable(
          endpoint: endPoint,
          statusCode: response.statusCode,
        );
        return null;
      }

      return await handleResponse(response);
    } catch (e) {
      if (isBedFeatureUnavailableError(e)) {
        _markBedFeatureUnavailable(endpoint: endPoint, error: e);
        return null;
      }
      rethrow;
    }
  }

  static BaseResponseModel _bedFeatureDisabledResponse() {
    return BaseResponseModel(status: false, message: '');
  }

  static Future<RxList<CategoryElement>> getCategoryList({
    String search = '',
    int page = 1,
    int perPage = 50,
    required List<CategoryElement> categories,
    Function(bool)? lastPageCallBack,
  }) async {
    final String searchCat = search.isNotEmpty ? '&search=$search' : '';
    final categoryListRes = CategoryListRes.fromJson(await handleResponse(
        await buildHttpResponse(
            "${APIEndPoints.getCategoryList}?per_page=$perPage&page=$page$searchCat")));
    if (page == 1) categories.clear();
    categories.addAll(categoryListRes.data);
    lastPageCallBack?.call(categoryListRes.data.length != perPage);
    return categories.obs;
  }

  static Future<RxList<ServiceElement>> getServiceList({
    int isAllSer = 0,
    int page = 1,
    int perPage = 10,
    required List<ServiceElement> serviceList,
    Function(bool)? lastPageCallBack,
    int? categoryId,
    int? clinicId,
    int? doctorId,
    String search = '',
    String params = '',
    String serviceId = '',
  }) async {
    final String isAllService = isAllSer > 0 ? '&services=$isAllSer' : '';
    final String catId = categoryId != null && !categoryId.isNegative
        ? '&category_id=$categoryId'
        : '';
    final String clinicid =
        clinicId != null && !clinicId.isNegative ? '&clinic_id=$clinicId' : '';
    final String doctorid =
        doctorId != null && !doctorId.isNegative ? '&doctor_id=$doctorId' : '';
    final String searchService = search.isNotEmpty ? '&search=$search' : '';
    final String serviceID =
        serviceId.isNotEmpty ? '&system_service_id=$serviceId' : '';
    final String newParams = params.isNotEmpty ? '&$params' : '';
    final serviceListRes = ServiceListRes.fromJson(await handleResponse(
        await buildHttpResponse(
            "${APIEndPoints.getServices}?per_page=$perPage&page=$page$searchService$catId$clinicid$doctorid$newParams$serviceID$isAllService")));
    if (page == 1 || search.isNotEmpty) serviceList.clear();
    serviceList.addAll(serviceListRes.data);
    lastPageCallBack?.call(serviceListRes.data.length != perPage);
    return serviceList.obs;
  }

  static Future<RxList<EncounterElement>> getEncounterList({
    int page = 1,
    int perPage = 10,
    int? clinicId,
    required List<EncounterElement> encounterList,
    Function(bool)? lastPageCallBack,
  }) async {
    String clinicid =
        clinicId != null && !clinicId.isNegative ? '&clinic_id=$clinicId' : '';
    final encounterListRes = EncounterListRes.fromJson(await handleResponse(
        await buildHttpResponse(
            "${APIEndPoints.getEncounterList}?per_page=$perPage&page=$page$clinicid",
            method: HttpMethodType.GET)));
    if (page == 1) encounterList.clear();
    encounterList.addAll(encounterListRes.data);
    lastPageCallBack?.call(encounterListRes.data.length != perPage);
    return encounterList.obs;
  }

  //Get Body Chart List
  static Future<RxList<BodyChartModel>> getBodyChartLists({
    //To-do Change Models
    int page = 1,
    int perPage = 10,
    int? encounterId,
    required List<BodyChartModel> bodyChartList, //To-do Change Models
    Function(bool)? lastPageCallBack,
  }) async {
    String encounter = encounterId != null && !encounterId.isNegative
        ? '&encounter_id=$encounterId'
        : '';
    final bodyChartDetails = BodyChartResp.fromJson(await handleResponse(
        await buildHttpResponse(
            "${APIEndPoints.bodyChartDetails}?per_page=$perPage&page=$page$encounter",
            method: HttpMethodType.GET)));
    if (page == 1) bodyChartList.clear();
    bodyChartList.addAll(bodyChartDetails.data);
    lastPageCallBack?.call(bodyChartDetails.data.length != perPage);
    return bodyChartList.obs;
  }

  static Future<BaseResponseModel> deleteBodyChart(
      {required int chartId}) async {
    return BaseResponseModel.fromJson(await handleResponse(
        await buildHttpResponse('${APIEndPoints.deleteBodychart}/$chartId',
            method: HttpMethodType.POST)));
  }

  static Future<RxList<Doctor>> getDoctors({
    int page = 1,
    String search = '',
    dynamic perPage = 10,
    required List<Doctor> doctors,
    Function(bool)? lastPageCallBack,
    int? clinicId,
  }) async {
    final String clncId =
        clinicId != null && !clinicId.isNegative ? '&clinic_id=$clinicId' : '';
    final String searchDoc = search.isNotEmpty ? '&search=$search' : '';
    final doctorListRes = DoctorListRes.fromJson(await handleResponse(
        await buildHttpResponse(
            "${APIEndPoints.getDoctors}?per_page=$perPage&page=$page$clncId$searchDoc")));
    if (page == 1) doctors.clear();
    doctors.addAll(doctorListRes.data);
    lastPageCallBack?.call(doctorListRes.data.length != perPage);
    return doctors.obs;
  }

  static Future<AppointmentEncounterDetailModel> getEncounterDetail(
      {required int encounterId}) async {
    return AppointmentEncounterDetailModel.fromJson(await handleResponse(
        await buildHttpResponse(
            "${APIEndPoints.encounterDashboardDetail}?encounter_id=$encounterId")));
  }

  static Future<RxList<RequestElement>> getRequestList({
    int page = 1,
    int perPage = 50,
    required List<RequestElement> requests,
    Function(bool)? lastPageCallBack,
  }) async {
    final requestListRes = RequestListRes.fromJson(await handleResponse(
        await buildHttpResponse(
            "${APIEndPoints.getRequestList}?per_page=$perPage&page=$page")));
    if (page == 1) requests.clear();
    requests.addAll(requestListRes.data);
    lastPageCallBack?.call(requestListRes.data.length != perPage);
    return requests.obs;
  }

  static Future<void> saveRequestService({
    bool isEdit = false,
    required Map<String, dynamic> request,
    List<File>? files,
    VoidCallback? onSuccess,
  }) async {
    final multiPartRequest =
        await getMultiPartRequest(APIEndPoints.saveRequestService);
    multiPartRequest.fields.addAll(await getMultipartFields(val: request));

    if (files.validate().isNotEmpty) {
      multiPartRequest.files.add(await http.MultipartFile.fromPath(
          'file_url', files.validate().first.path.validate()));
    }

    /*  if (files.validate().isNotEmpty) {
      multiPartRequest.files.addAll(await getMultipartImages(files: files.validate(), name: 'medical_report'));
      multiPartRequest.fields['attachment_count'] = files.validate().length.toString();
    } */
    multiPartRequest.headers.addAll(buildHeaderTokens());

    await sendMultiPartRequest(
      multiPartRequest,
      onSuccess: (temp) async {
        log("Response: ${jsonDecode(temp)}");
        final baseResponseModel = BaseResponseModel.fromJson(jsonDecode(temp));
        toast(baseResponseModel.message, print: true);
        onSuccess?.call();
      },
      onError: (error) {
        toast(error.toString(), print: true);
      },
    );
  }

  static Future<RxList<ReceptionistData>> getReceptionistList({
    int page = 1,
    int perPage = 50,
    required List<ReceptionistData> receptionists,
    Function(bool)? lastPageCallBack,
  }) async {
    final requestListRes = ReceptionistListRes.fromJson(await handleResponse(
        await buildHttpResponse(
            "${APIEndPoints.getReceptionistList}?per_page=$perPage&page=$page")));
    if (page == 1) receptionists.clear();
    receptionists.addAll(requestListRes.data);
    lastPageCallBack?.call(requestListRes.data.length != perPage);
    return receptionists.obs;
  }

  static Future<BaseResponseModel> deleteReceptionist(
      {required int receptionistId}) async {
    return BaseResponseModel.fromJson(await handleResponse(
        await buildHttpResponse(
            '${APIEndPoints.deleteReceptionist}/$receptionistId',
            method: HttpMethodType.POST)));
  }

  static Future<void> saveReceptionist({
    bool isEdit = false,
    int? id,
    required Map<String, dynamic> request,
    List<File>? files,
    VoidCallback? onSuccess,
  }) async {
    final multiPartRequest = await getMultiPartRequest(isEdit
        ? "${APIEndPoints.updateReceptionist}/$id"
        : APIEndPoints.saveReceptionist);
    multiPartRequest.fields.addAll(await getMultipartFields(val: request));

    if (files.validate().isNotEmpty) {
      multiPartRequest.files.add(await http.MultipartFile.fromPath(
          'file_url', files.validate().first.path.validate()));
    }

    /*  if (files.validate().isNotEmpty) {
      multiPartRequest.files.addAll(await getMultipartImages(files: files.validate(), name: 'medical_report'));
      // multiPartRequest.fields['attachment_count'] = files.validate().length.toString();
    } */

    multiPartRequest.headers.addAll(buildHeaderTokens());

    await sendMultiPartRequest(
      multiPartRequest,
      onSuccess: (temp) async {
        log("Response: ${jsonDecode(temp)}");
        final baseResponseModel = BaseResponseModel.fromJson(jsonDecode(temp));
        toast(baseResponseModel.message, print: true);
        onSuccess?.call();
      },
      onError: (error) {
        toast(error.toString(), print: true);
      },
    );
  }

  // Save Body Chart Request
  static Future<void> saveBodyChart({
    bool isEdit = false,
    int? id,
    required Map<String, dynamic> request,
    List<File>? files,
    VoidCallback? onSuccess,
  }) async {
    final multiPartRequest = await getMultiPartRequest(isEdit
        ? "${APIEndPoints.updateBodychart}/$id"
        : APIEndPoints.saveBodychart);
    multiPartRequest.fields.addAll(await getMultipartFields(val: request));
    if (files.validate().isNotEmpty) {
      multiPartRequest.files.add(await http.MultipartFile.fromPath(
          'file_url', files.validate().first.path.validate()));
    }

    multiPartRequest.headers.addAll(buildHeaderTokens());

    await sendMultiPartRequest(
      multiPartRequest,
      onSuccess: (temp) async {
        log("Response: ${jsonDecode(temp)}");
        final baseResponseModel = BaseResponseModel.fromJson(jsonDecode(temp));
        toast(baseResponseModel.message, print: true);
        onSuccess?.call();
      },
      onError: (error) {
        toast(error.toString(), print: true);
      },
    );
  }

  static Future<RxList<AppointmentData>> getAppointmentList({
    String firstDate = '',
    String lastDate = '',
    int page = 1,
    String search = '',
    int? patientId,
    int? serviceId,
    int? doctorId,
    int? clinicId,
    int? categoryId,
    String? filterByStatus,
    String paymentStatus = '',
    int perPage = Constants.perPageItem,
    required List<AppointmentData> appointments,
    Function(bool)? lastPageCallBack,
  }) async {
    final String fDate = firstDate.isNotEmpty ? '&first_date=$firstDate' : '';
    final String lDate = lastDate.isNotEmpty ? '&last_date=$lastDate' : '';
    final String pId =
        patientId != null && !patientId.isNegative ? '&user_id=$patientId' : '';
    final String sId = serviceId != null && !serviceId.isNegative
        ? '&service_id=$serviceId'
        : '';
    final String dId =
        doctorId != null && !doctorId.isNegative ? '&doctor_id=$doctorId' : '';
    final String cId =
        clinicId != null && clinicId > 0 ? '&clinic_id=$clinicId' : '';
    final String catId =
        categoryId != null && categoryId > 0 ? '&category_id=$categoryId' : '';
    final String searchBooking = search.isNotEmpty ? '&search=$search' : '';
    final String statusFilter =
        filterByStatus != null && filterByStatus.isNotEmpty
            ? '&status=$filterByStatus'
            : '';
    final String paymentStatusFilter =
        paymentStatus.isNotEmpty ? '&payment_status=$paymentStatus' : '';
    final bookingRes = AppointmentListRes.fromJson(
      await handleResponse(
        await buildHttpResponse(
          "${APIEndPoints.getAppointments}?page=$page&per_page=$perPage$pId$sId$dId$cId$statusFilter$searchBooking$paymentStatusFilter$catId$fDate$lDate",
        ),
      ),
    );
    if (page == 1) appointments.clear();
    appointments.addAll(bookingRes.data.validate());

    lastPageCallBack?.call(bookingRes.data.validate().length != perPage);

    return appointments.obs;
  }

  // static Future<AppointmentData> getAppointmentDetail({required int appointmentId}) async {
  //   return AppointmentData.fromJson(await handleResponse(await buildHttpResponse("${APIEndPoints.getAppointmentDetail}?appointment_id=$appointmentId" )));
  // }
  static Future<AppointmentData> getAppointmentDetail({
    int? appointmentId,
    String notifyId = "",
    required AppointmentData appointMentDet,
  }) async {
    final String appointment =
        appointmentId != null ? 'appointment_id=$appointmentId' : '';
    final String notificationId =
        appointMentDet.notificationId.trim().isNotEmpty
            ? '&notification_id=${appointMentDet.notificationId}'
            : '';
    final res = AppointmentDetailsResp.fromJson(await handleResponse(
        await buildHttpResponse(
            "${APIEndPoints.getAppointmentDetail}?$appointment$notificationId")));
    appointMentDet = res.data;
    return appointMentDet;
    // return AppointmentData.fromJson(await handleResponse(await buildHttpResponse("${APIEndPoints.getAppointmentDetail}?appointment_id=$appointmentId" )));
  }

  static Future<BaseResponseModel> updateBooking({required Map request}) async {
    return BaseResponseModel.fromJson(await handleResponse(
        await buildHttpResponse(APIEndPoints.bookingUpdate,
            request: request, method: HttpMethodType.POST)));
  }

  static Future<BaseResponseModel> updateStatus(
      {required Map request, required int appointmentId}) async {
    return BaseResponseModel.fromJson(await handleResponse(
        await buildHttpResponse('${APIEndPoints.updateStatus}/$appointmentId',
            request: request, method: HttpMethodType.POST)));
  }

  static Future<BaseResponseModel> saveSession(
      {required Map request, required int doctorId}) async {
    return BaseResponseModel.fromJson(await handleResponse(
        await buildHttpResponse("${APIEndPoints.saveSession}/$doctorId",
            request: request, method: HttpMethodType.POST)));
  }

  static Future<BaseResponseModel> assignDoctor({required Map request}) async {
    return BaseResponseModel.fromJson(await handleResponse(
        await buildHttpResponse(APIEndPoints.assignDoctor,
            request: request, method: HttpMethodType.POST)));
  }

  static Future<BaseResponseModel> assignDoctorService(
      {required Map request}) async {
    return BaseResponseModel.fromJson(await handleResponse(
        await buildHttpResponse(APIEndPoints.assignDoctorService,
            request: request, method: HttpMethodType.POST)));
  }

  static Future<BaseResponseModel> updateReview({required Map request}) async {
    return BaseResponseModel.fromJson(await handleResponse(
        await buildHttpResponse(APIEndPoints.saveRating,
            request: request, method: HttpMethodType.POST)));
  }

  static Future<BaseResponseModel> deleteReview({required int id}) async {
    return BaseResponseModel.fromJson(await handleResponse(
        await buildHttpResponse(APIEndPoints.deleteRating,
            request: {"id": id}, method: HttpMethodType.POST)));
  }

  static Future<BaseResponseModel> changeAppointmentStatus(
      {required int id, required Map request}) async {
    return BaseResponseModel.fromJson(await handleResponse(
        await buildHttpResponse("${APIEndPoints.updateStatus}/$id",
            request: request, method: HttpMethodType.POST)));
  }

  static Future<EmployeeReviewRes> getEmployeeReviews({
    int? empId,
    int page = 1,
    int perPage = Constants.perPageItem,
    Function(bool)? lastPageCallBack,
  }) async {
    if (isLoggedIn.value) {
      final String employeeId = empId != null ? '&employee_id=$empId' : '';
      final reviewRes = EmployeeReviewRes.fromJson(await handleResponse(
          await buildHttpResponse(
              "${APIEndPoints.getRating}?per_page=$perPage&page=$page$employeeId")));
      lastPageCallBack?.call(reviewRes.reviewData.length != perPage);
      return reviewRes;
    } else {
      return EmployeeReviewRes();
    }
  }

  static Future<BillingDetailModel> getBillingDetails({
    int? encounterId,
    required BillingDetailModel billingDetails,
  }) async {
    final String encounter = encounterId != null && !encounterId.isNegative
        ? '&encounter_id=$encounterId'
        : '';
    final reviewRes = BillingDetailsResp.fromJson(await handleResponse(
        await buildHttpResponse(
            "${APIEndPoints.billingRecordDetail}?$encounter")));
    billingDetails = reviewRes.data;
    return billingDetails;
  }

  //get Encounter Details
  static Future<EncounterDetailModel> getEncounterDet({
    int? encounterId,
    required EncounterDetailModel encounterDetModel,
  }) async {
    final String encounter = encounterId != null && !encounterId.isNegative
        ? 'encounter_id=$encounterId'
        : '';
    final reviewRes = EncounterDetailResp.fromJson(await handleResponse(
        await buildHttpResponse("${APIEndPoints.encounterDetail}?$encounter")));
    encounterDetModel = reviewRes.data;
    return encounterDetModel;
  }

  //Save Encounter Details
  static Future<BaseResponseModel> saveInvoice({
    required Map<String, dynamic> request,
  }) async {
    final res = BaseResponseModel.fromJson(await handleResponse(
        await buildHttpResponse(APIEndPoints.saveBillingDetails,
            request: request, method: HttpMethodType.POST)));
    return res;
  }

//Save Billing Items
  static Future<BaseResponseModel> saveBillingItems({
    required Map<String, dynamic> request,
  }) async {
    final res = BaseResponseModel.fromJson(await handleResponse(
        await buildHttpResponse(APIEndPoints.saveBillingItems,
            request: request, method: HttpMethodType.POST)));
    return res;
  }

  //delete Billing Items
  static Future<BaseResponseModel> deleteBillingItems({
    required int id,
  }) async {
    final res = BaseResponseModel.fromJson(await handleResponse(
        await buildHttpResponse("${APIEndPoints.deleteBillingItems}/$id",
            method: HttpMethodType.POST)));
    return res;
  }

  //get Service Details
  static Future<ServiceDetails> getServiceDetails({
    int? encounterId,
    int? serviceId,
    required ServiceDetails serviceDetails,
  }) async {
    final String encounter = encounterId != null && !encounterId.isNegative
        ? 'encounter_id=$encounterId'
        : '';
    final String service = serviceId != null && !serviceId.isNegative
        ? '&service_id=$serviceId'
        : '';
    final reviewRes = ServiceDetailResp.fromJson(await handleResponse(
        await buildHttpResponse(
            "${APIEndPoints.serviceDetail}?$encounter$service")));
    serviceDetails = reviewRes.data;
    return serviceDetails;
  }

  static Future<RxList<DoctorSessionModel>> getDoctorSessionList({
    int page = 1,
    String search = '',
    int? clinicId,
    int perPage = Constants.perPageItem,
    required List<DoctorSessionModel> doctorSession,
    Function(bool)? lastPageCallBack,
  }) async {
    final String cId =
        clinicId != null && !clinicId.isNegative ? '&clinic_id=$clinicId' : '';
    final doctorSes = DoctorSessionResp.fromJson(await handleResponse(
        await buildHttpResponse(
            "${APIEndPoints.getDoctorSession}?page=$page&per_page=$perPage$cId")));
    if (page == 1) doctorSession.clear();
    doctorSession
        .addAll(doctorSes.data.validate() as Iterable<DoctorSessionModel>);
    lastPageCallBack?.call(doctorSes.data.validate().length != perPage);
    return doctorSession.obs;
  }

  //Get Specialization List
  static Future<RxList<SpecializationModel>> getSpecializationList({
    int page = 1,
    var perPage = Constants.perPageItem,
    String search = '',
    required List<SpecializationModel> specializationList,
    Function(bool)? lastPageCallBack,
  }) async {
    final String searchSpec = search.trim().isNotEmpty ? '&search=$search' : '';
    final res = SpecializationResp.fromJson(await handleResponse(
        await buildHttpResponse(
            "${APIEndPoints.getSpecializationList}?per_page=$perPage&page=$page$searchSpec")));
    if (page == 1) specializationList.clear();
    specializationList.addAll(res.data.validate());
    lastPageCallBack?.call(res.data.validate().length != perPage);
    return specializationList.obs;
  }

  //Get Clinic List
  static Future<RxList<ClinicData>> getClinicList({
    int page = 1,
    String search = '',
    int? serviceId,
    var perPage = Constants.perPageItem,
    required List<ClinicData> clinicList,
    Function(bool)? lastPageCallBack,
  }) async {
    final String searchClinic = search.isNotEmpty ? '&search=$search' : '';
    final String service = serviceId != null ? '&service_id=$serviceId' : '';
    final res = ClinicListRes.fromJson(await handleResponse(await buildHttpResponse(
        "${APIEndPoints.getClinics}?per_page=$perPage&page=$page$searchClinic$service")));
    if (page == 1) clinicList.clear();
    clinicList.addAll(res.data);
    lastPageCallBack?.call(res.data.length != perPage);
    return clinicList.obs;
  }

  //Get Patient List
  static Future<RxList<PatientModel>> getPatientsList({
    int page = 1,
    String search = '',
    String filter = '',
    int? doctorId,
    int? clinicId,
    var perPage = Constants.perPageItem,
    required List<PatientModel> patientsList,
    Function(bool)? lastPageCallBack,
  }) async {
    final String searchPatient = search.isNotEmpty ? '&search=$search' : '';
    final String filterPatient = filter.isNotEmpty ? '&filter=$filter' : '';
    final String dId =
        doctorId != null && !doctorId.isNegative ? '&doctor_id=$doctorId' : '';
    final String cId =
        clinicId != null && !clinicId.isNegative ? '&clinic_id=$clinicId' : '';
    final res = PatientListModel.fromJson(await handleResponse(
        await buildHttpResponse(
            "${APIEndPoints.getPatientsList}?per_page=$perPage&page=$page$searchPatient$filterPatient$dId$cId")));
    if (page == 1) patientsList.clear();
    patientsList.addAll(res.data.validate());
    lastPageCallBack?.call(res.data.validate().length != perPage);
    return patientsList.obs;
  }

  //Get Payout List
  static Future<RxList<PayoutModel>> getPayoutList({
    int page = 1,
    var perPage = Constants.perPageItem,
    required List<PayoutModel> payoutList,
    Function(bool)? lastPageCallBack,
  }) async {
    final res = PayoutListModel.fromJson(await handleResponse(
        await buildHttpResponse(
            "${APIEndPoints.getDoctorPayoutHistory}?per_page=$perPage&page=$page")));
    if (page == 1) payoutList.clear();
    payoutList.addAll(res.data.validate());
    lastPageCallBack?.call(res.data.validate().length != perPage);
    return payoutList.obs;
  }

  //Get Doctor Details
  static Future<Rx<Doctor>> getDoctorDetail({required int doctorId}) async {
    final clinicId = selectedAppClinic.value.id > 0
        ? '&clinic_id=${selectedAppClinic.value.id}'
        : '';
    final res = DoctorDetailRes.fromJson(await handleResponse(
        await buildHttpResponse(
            "${APIEndPoints.doctorDetails}?doctor_id=$doctorId$clinicId")));
    return res.data.obs;
  }

  static Future<Rx<ReceptionistData>> getReceptionistDetail(
      {required int receptionistId}) async {
    final response = await handleResponse(await buildHttpResponse(
        "${APIEndPoints.receptionistDetails}?receptionist_id=$receptionistId"));

    // Check if response contains data field
    if (response is Map<String, dynamic> && response.containsKey("data")) {
      final receptionistData = ReceptionistData.fromJson(response["data"]);
      return receptionistData.obs;
    } else {
      return ReceptionistData()
          .obs; // Return default object if response is invalid
    }
  }

  //Get Review List
  static Future<RxList<ReviewModel>> getReviewList({
    int? doctorId,
    int page = 1,
    var perPage = Constants.perPageItem,
    required List<ReviewModel> reviewList,
    Function(bool)? lastPageCallBack,
  }) async {
    final res = ReviewListModel.fromJson(await handleResponse(
        await buildHttpResponse(
            "${APIEndPoints.getRating}?per_page=$perPage&page=$page&doctor_id=$doctorId")));
    if (page == 1) reviewList.clear();
    reviewList.addAll(res.data.validate());
    lastPageCallBack?.call(res.data.validate().length != perPage);
    return reviewList.obs;
  }

  //Save Encounter
  static Future<Rx<EncounterResp>> saveEncounter(
      {required Map request, required EncounterResp encounterResp}) async {
    final res = AddEncounterResp.fromJson(await handleResponse(
        await buildHttpResponse(APIEndPoints.saveEncounter,
            request: request, method: HttpMethodType.POST)));
    encounterResp = res.data;
    return encounterResp.obs;
  }

  //Edit Encounter
  static Future<Rx<EncounterResp>> editEncounter(
      {required Map request,
      required int id,
      required EncounterResp encounterResp}) async {
    final res = AddEncounterResp.fromJson(await handleResponse(
        await buildHttpResponse("${APIEndPoints.editEncounter}/$id",
            request: request, method: HttpMethodType.POST)));
    encounterResp = res.data;
    return encounterResp.obs;
  }

  //Delete Encounter
  static Future<Rx<BaseResponseModel>> deleteEncounter(
      {required int id}) async {
    final res = BaseResponseModel.fromJson(await handleResponse(
        await buildHttpResponse("${APIEndPoints.deleteEncounter}/$id",
            method: HttpMethodType.POST)));
    return res.obs;
  }

  //Get Clinic List
  static Future<RxList<CMNElement>> getEncProblems({String search = ''}) async {
    final String searchProblems = search.isNotEmpty ? '&search=$search' : '';
    final res = ProblemsListRes.fromJson(await handleResponse(
        await buildHttpResponse(
            "${APIEndPoints.getEncProblemObservations}?type=${EncounterDropdownTypes.encounterProblem}$searchProblems")));
    return res.data.obs;
  }

  //Get Clinic List
  static Future<RxList<CMNElement>> getEncObservations(
      {String search = ''}) async {
    final String searchObservations =
        search.isNotEmpty ? '&search=$search' : '';
    final res = ProblemsListRes.fromJson(await handleResponse(
        await buildHttpResponse(
            "${APIEndPoints.getEncProblemObservations}?type=${EncounterDropdownTypes.encounterObservations}$searchObservations")));
    return res.data.obs;
  }

  //Get Clinic List
  static Future<RxList<MedicalReport>> getMedicalReports({
    int page = 1,
    required int encounterId,
    var perPage = Constants.perPageItem,
    required List<MedicalReport> medicalReports,
    Function(bool)? lastPageCallBack,
  }) async {
    final res = MedicalReportsRes.fromJson(await handleResponse(
        await buildHttpResponse(
            "${APIEndPoints.getMedicalReport}?per_page=$perPage&page=$page&encounter_id=$encounterId")));
    if (page == 1) medicalReports.clear();
    medicalReports.addAll(res.data);
    lastPageCallBack?.call(res.data.length != perPage);
    return medicalReports.obs;
  }

  static Future<BaseResponseModel> deleteMedicalReports(
      {required int reportId}) async {
    return BaseResponseModel.fromJson(await handleResponse(
        await buildHttpResponse(
            '${APIEndPoints.deleteMedicalReport}/$reportId')));
  }

  static Future<void> saveMedicalReport({
    int? reportId,
    bool isEdit = false,
    required Map<String, dynamic> request,
    List<File>? files,
    VoidCallback? onSuccess,
  }) async {
    final multiPartRequest = await getMultiPartRequest(isEdit
        ? "${APIEndPoints.updateMedicalReport}/$reportId"
        : APIEndPoints.saveMedicalReport);
    multiPartRequest.fields.addAll(await getMultipartFields(val: request));

    if (files.validate().isNotEmpty) {
      multiPartRequest.files.add(await http.MultipartFile.fromPath(
          'file_url', files.validate().first.path.validate()));
    }

    /*  if (files.validate().isNotEmpty) {
      multiPartRequest.files.addAll(await getMultipartImages(files: files.validate(), name: 'medical_report'));
      multiPartRequest.fields['attachment_count'] = files.validate().length.toString();
    } */

    multiPartRequest.headers.addAll(buildHeaderTokens());

    await sendMultiPartRequest(
      multiPartRequest,
      onSuccess: (temp) async {
        log("Response: ${jsonDecode(temp)}");
        final baseResponseModel = BaseResponseModel.fromJson(jsonDecode(temp));
        toast(baseResponseModel.message, print: true);
        onSuccess?.call();
      },
      onError: (error) {
        toast(error.toString(), print: true);
      },
    );
  }

  //
  static Future<RxList<MedicalReport>> getPrescription({
    int page = 1,
    required int encounterId,
    var perPage = Constants.perPageItem,
    required List<MedicalReport> medicalReports,
    Function(bool)? lastPageCallBack,
  }) async {
    final res = MedicalReportsRes.fromJson(await handleResponse(
        await buildHttpResponse(
            "${APIEndPoints.getPrescription}?per_page=$perPage&page=$page&encounter_id=$encounterId")));
    if (page == 1) medicalReports.clear();
    medicalReports.addAll(res.data);
    lastPageCallBack?.call(res.data.length != perPage);
    return medicalReports.obs;
  }

  static Future<BaseResponseModel> deletePrescription(
      {required int reportId}) async {
    return BaseResponseModel.fromJson(await handleResponse(
        await buildHttpResponse(
            '${APIEndPoints.deletePrescription}/$reportId')));
  }

  static Future<void> savePrescription({
    int? reportId,
    bool isEdit = false,
    required Map<String, dynamic> request,
    List<File>? files,
    VoidCallback? onSuccess,
  }) async {
    final multiPartRequest = await getMultiPartRequest(isEdit
        ? "${APIEndPoints.updatePrescription}/$reportId"
        : APIEndPoints.savePrescription);
    multiPartRequest.fields.addAll(await getMultipartFields(val: request));

    if (files.validate().isNotEmpty) {
      multiPartRequest.files.add(await http.MultipartFile.fromPath(
          'file_url', files.validate().first.path.validate()));
    }

    /*  if (files.validate().isNotEmpty) {
      multiPartRequest.files.addAll(await getMultipartImages(files: files.validate(), name: 'medical_report'));
      multiPartRequest.fields['attachment_count'] = files.validate().length.toString();
    } */

    multiPartRequest.headers.addAll(buildHeaderTokens());

    await sendMultiPartRequest(
      multiPartRequest,
      onSuccess: (temp) async {
        log("Response: ${jsonDecode(temp)}");
        final baseResponseModel = BaseResponseModel.fromJson(jsonDecode(temp));
        toast(baseResponseModel.message, print: true);
        onSuccess?.call();
      },
      onError: (error) {
        toast(error.toString(), print: true);
      },
    );
  }

  static Future<BaseResponseModel> saveEncounterDashboard(
      {required Map request}) async {
    return BaseResponseModel.fromJson(await handleResponse(
        await buildHttpResponse(APIEndPoints.saveEncounterDashboard,
            request: request, method: HttpMethodType.POST)));
  }

  static Future<BaseResponseModel> saveSOAP(
      {required Map request, required int encounterId}) async {
    return BaseResponseModel.fromJson(await handleResponse(
        await buildHttpResponse("${APIEndPoints.saveSOAP}/$encounterId",
            request: request, method: HttpMethodType.POST)));
  }

  static Future<Rx<GetSOAPRes>> getSOAP(int encounterId) async {
    final res = GetSOAPRes.fromJson(await handleResponse(
        await buildHttpResponse("${APIEndPoints.getSOAP}/$encounterId")));
    return res.obs;
  }

  static Future<Rx<EncounterDashboardDetail>> encounterDashboardDetail(
      int encounterId) async {
    final res = EncounterDashboardRes.fromJson(await handleResponse(
        await buildHttpResponse(
            "${APIEndPoints.encounterDashboardDetail}?encounter_id=$encounterId")));
    return res.data.obs;
  }

  //Get Patient List
  static Future<RxList<Medicine>> getMedicineList({
    int page = 1,
    String search = '',
    var perPage = Constants.perPageItem,
    required List<Medicine> medicineList,
    Function(bool)? lastPageCallBack,
  }) async {
    final searchMedicine = search.isNotEmpty ? '&name=$search' : '';
    final res = MedicineListRes.fromJson(await handleResponse(
        await buildHttpResponse(
            "${APIEndPoints.getMedicineList}?per_page=$perPage&page=$page$searchMedicine")));
    if (page == 1) medicineList.clear();
    medicineList.addAll(res.data.validate());
    lastPageCallBack?.call(res.data.validate().length != perPage);
    return medicineList.obs;
  }

  static Future<Rx<EncounterInvoiceResp>> downloadEncounter(
      int encounterId) async {
    final res = EncounterInvoiceResp.fromJson(await handleResponse(
        await buildHttpResponse(
            "${APIEndPoints.encounterInvoice}?id=$encounterId")));
    return res.obs;
  }

  static Future<Rx<AppointmentInvoiceResp>> appointmentInvoice(
      int appointmentId) async {
    final res = AppointmentInvoiceResp.fromJson(await handleResponse(
        await buildHttpResponse(
            "${APIEndPoints.downloadInvoice}?id=$appointmentId")));
    return res.obs;
  }

  static Future<Rx<EncounterInvoiceResp>> downloadPrescription(
      int encounterId) async {
    final res = EncounterInvoiceResp.fromJson(await handleResponse(
        await buildHttpResponse(
            "${APIEndPoints.downloadPrescription}?id=$encounterId")));
    return res.obs;
  }

  static Future<RxList<String>> getTimeSlots({
    required RxList<String> slots,
    required String date,
    required int clinicId,
    required int doctorId,
    required int serviceId,
  }) async {
    final timeSlotsRes = TimeSlotsRes.fromJson(await handleResponse(
        await buildHttpResponse(
            "${APIEndPoints.getTimeSlots}?appointment_date=$date&doctor_id=$doctorId&clinic_id=$clinicId&service_id=$serviceId")));
    slots(timeSlotsRes.slots);
    return slots;
  }

  static Future<void> saveBookApi({
    required Map<String, dynamic> request,
    List<PlatformFile>? files,
    required VoidCallback onSuccess,
    required VoidCallback loaderOff,
  }) async {
    var multiPartRequest = await getMultiPartRequest(APIEndPoints.saveBooking);
    multiPartRequest.fields.addAll(await getMultipartFields(val: request));

    if (files.validate().isNotEmpty) {
      multiPartRequest.files.addAll(
        await getMultipartImages(
          files: files.validate(),
          name: 'file_url',
        ),
      );
    }

    // Add headers
    multiPartRequest.headers.addAll(buildHeaderTokens());

    // Send request
    await sendMultiPartRequest(
      multiPartRequest,
      onSuccess: (temp) async {
        log("Response: ${jsonDecode(temp)}");
        try {
          saveBookingRes(SaveBookingRes.fromJson(jsonDecode(temp)));
        } catch (e) {
          log('SaveBookingRes.fromJson E: $e');
        }
        onSuccess.call();
      },
      onError: (error) {
        toast(error.toString(), print: true);
        loaderOff.call();
      },
    );
  }

//Payment
  static Future<BaseResponseModel> savePayment({required Map request}) async {
    return BaseResponseModel.fromJson(await handleResponse(
        await buildHttpResponse(APIEndPoints.savePayment,
            request: request, method: HttpMethodType.POST)));
  }

  /// Fetch Other Patient List
  static Future<RxList<UserData>> otherMemberPatientList({
    int page = 1,
    int perPage = 10,
    required String patientId,
    required List<UserData> memberList,
    Function(bool)? lastPageCallBack,
  }) async {
    final memberListRes = OtherPatientListRes.fromJson(
      await handleResponse(
        await buildHttpResponse(
          "${APIEndPoints.otherMemberPatientList}?patient_id=$patientId&per_page=$perPage&page=$page",
        ),
      ),
    );
    if (page == 1) memberList.clear();
    memberList.addAll(memberListRes.data);
    lastPageCallBack?.call(memberListRes.data.length != perPage);
    return memberList.obs;
  }

  // Bed Management APIs
  static Future<List<BedTypeElement>> getBedTypes() async {
    final response = await _executeBedRequest(
      APIEndPoints.bedTypeList,
      method: HttpMethodType.GET,
    );
    if (response == null) return <BedTypeElement>[];

    final bedTypeListRes = BedTypeListRes.fromJson(response);
    return bedTypeListRes.data.validate();
  }

  static Future<RxList<BedMasterModel>> getBedList({
    int page = 1,
    int perPage = 50,
    required List<BedMasterModel> bedList,
    Function(bool)? lastPageCallBack,
    int? bedTypeId,
    String? status,
    int? clinicId,
  }) async {
    if (!isBedFeatureAvailable) {
      if (page == 1) bedList.clear();
      lastPageCallBack?.call(true);
      return bedList.obs;
    }

    String bedType = bedTypeId != null ? '&bed_type_id=$bedTypeId' : '';
    String bedStatus =
        status != null && status.isNotEmpty ? '&status=$status' : '';
    String clinic = clinicId != null ? '&clinic_id=$clinicId' : '';

    final response = await _executeBedRequest(
      "${APIEndPoints.bedMasterList}?per_page=$perPage&page=$page$bedType$bedStatus$clinic",
      method: HttpMethodType.GET,
    );
    if (response == null) {
      if (page == 1) bedList.clear();
      lastPageCallBack?.call(true);
      return bedList.obs;
    }

    final bedListRes = BedListRes.fromJson(response);
    if (page == 1) bedList.clear();
    bedList.addAll(bedListRes.data);
    lastPageCallBack?.call(bedListRes.data.length != perPage);

    return bedList.obs;
  }

  static Future<BaseResponseModel> deleteBed({required int bedId}) async {
    final response = await _executeBedRequest(
      "${APIEndPoints.bedMaster}/$bedId",
      method: HttpMethodType.DELETE,
    );
    if (response == null) return _bedFeatureDisabledResponse();

    return BaseResponseModel.fromJson(response);
  }

  static Future<BaseResponseModel> updateBedStatus({
    required int bedId,
    required Map<String, dynamic> request,
  }) async {
    final response = await _executeBedRequest(
      "${APIEndPoints.bedStatus}/bed/$bedId/toggle-maintenance",
      request: request,
      method: HttpMethodType.POST,
    );
    if (response == null) return _bedFeatureDisabledResponse();

    return BaseResponseModel.fromJson(response);
  }

  static Future<BaseResponseModel> addBed({
    required Map<String, dynamic> request,
  }) async {
    final response = await _executeBedRequest(
      APIEndPoints.bedMaster,
      request: request,
      method: HttpMethodType.POST,
    );
    if (response == null) return _bedFeatureDisabledResponse();

    return BaseResponseModel.fromJson(response);
  }

  static Future<BaseResponseModel> updateBed({
    required int bedId,
    required Map<String, dynamic> request,
  }) async {
    final response = await _executeBedRequest(
      "${APIEndPoints.bedMaster}/$bedId",
      request: request,
      method: HttpMethodType.PUT,
    );
    if (response == null) return _bedFeatureDisabledResponse();

    return BaseResponseModel.fromJson(response);
  }

  static Future<RxList<BedMasterModel>> getBedMasters({
    int page = 1,
    int perPage = 10,
    String searchBed = '',
    int? clinicId,
    required List<BedMasterModel> bedMasterList,
    Function(bool)? lastPageCallBack,
  }) async {
    if (!isBedFeatureAvailable) {
      if (page == 1) bedMasterList.clear();
      lastPageCallBack?.call(true);
      return bedMasterList.obs;
    }

    final search = searchBed.isNotEmpty ? '&search=$searchBed' : '';
    final clinic = clinicId != null ? '&clinic_id=$clinicId' : '';
    final response = await _executeBedRequest(
      "${APIEndPoints.bedMasterList}?per_page=$perPage&page=$page$search$clinic",
      method: HttpMethodType.GET,
    );
    if (response == null) {
      if (page == 1) bedMasterList.clear();
      lastPageCallBack?.call(true);
      return bedMasterList.obs;
    }

    if (page == 1) bedMasterList.clear();
    if (response is List) {
      bedMasterList
          .addAll(response.map((e) => BedMasterModel.fromJson(e)).toList());
      lastPageCallBack?.call((response).length != perPage);
    } else if (response is Map && response['data'] is List) {
      bedMasterList.addAll((response['data'] as List)
          .map((e) => BedMasterModel.fromJson(e))
          .toList());
      lastPageCallBack?.call((response['data'] as List).length != perPage);
    }
    return bedMasterList.obs;
  }

  static Future<BedMasterModel> getBedMasterById(int id) async {
    final response = await _executeBedRequest(
      "${APIEndPoints.bedMaster}/$id",
      method: HttpMethodType.GET,
    );
    if (response == null) return BedMasterModel();

    return BedMasterModel.fromJson(response);
  }

  static Future<BaseResponseModel> deleteBedMaster(int id) async {
    final response = await _executeBedRequest(
      "${APIEndPoints.bedMaster}/$id",
      method: HttpMethodType.DELETE,
    );
    if (response == null) return _bedFeatureDisabledResponse();

    return BaseResponseModel.fromJson(response);
  }

  static Future<BaseResponseModel> addBedType({
    required Map<String, dynamic> request,
  }) async {
    final response = await _executeBedRequest(
      APIEndPoints.bedType,
      request: request,
      method: HttpMethodType.POST,
    );
    if (response == null) return _bedFeatureDisabledResponse();

    return BaseResponseModel.fromJson(response);
  }

  static Future<BaseResponseModel> updateBedType({
    required int id,
    required Map<String, dynamic> request,
  }) async {
    final response = await _executeBedRequest(
      "${APIEndPoints.bedType}/$id",
      request: request,
      method: HttpMethodType.PUT,
    );
    if (response == null) return _bedFeatureDisabledResponse();

    return BaseResponseModel.fromJson(response);
  }

  static Future<BedMasterModel> bedAllocationApi({
    required Map<String, dynamic> request,
  }) async {
    final response = await _executeBedRequest(
      APIEndPoints.bedAllocation,
      request: request,
      method: HttpMethodType.POST,
    );
    if (response == null) return BedMasterModel();

    return BedMasterModel.fromJson(response);
  }

  static Future<Map<String, dynamic>> getBedStatusSummary(
      {int clinicId = 0}) async {
    if (!isBedFeatureAvailable) {
      return {
        'status': false,
        'data': {
          'statistics': <String, dynamic>{},
        }
      };
    }

    final String clinic = clinicId > 0 ? '?clinic_id=$clinicId' : '';
    final response = await _executeBedRequest(
      '${APIEndPoints.bedStatus}$clinic',
      method: HttpMethodType.GET,
    );
    if (response == null) {
      return {
        'status': false,
        'data': {
          'statistics': <String, dynamic>{},
        }
      };
    }

    return response;
  }

  static Future<List<BedMasterModel>> getLatestUpdatedBeds() async {
    // final String clinicId = loginUserData.value.userRole.contains(EmployeeKeyConst.doctor) || loginUserData.value.userRole.contains(EmployeeKeyConst.receptionist) ? 'clinic_id=${selectedAppClinic.value.id}' : '';
    final response = await _executeBedRequest(
      APIEndPoints.bedsAvailable,
      method: HttpMethodType.GET,
    );
    if (response == null) return <BedMasterModel>[];

    final bedListRes = BedListRes.fromJson(response);
    return bedListRes.data.validate();
  }

  static Future<int?> getBedIdByName(String bedName) async {
    if (!isBedFeatureAvailable) return null;

    try {
      List<BedMasterModel> bedMasterList = [];
      final bedsRx = await getBedMasters(
        page: 1,
        perPage: 10,
        bedMasterList: bedMasterList,
        lastPageCallBack: null,
      );
      final beds = bedsRx.toList();

      final bed = beds.firstWhereOrNull((bed) => bed.bed == bedName);

      return bed?.id;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  static Future<int?> getBedIdByNameFromBedList(String bedName) async {
    if (!isBedFeatureAvailable) return null;

    try {
      final beds = await getBedList(
        bedList: <BedMasterModel>[],
        page: 1,
        perPage: 10, // Get all beds
      );
      final bed = beds.firstWhereOrNull((bed) => bed.bed == bedName);

      return bed?.id;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}

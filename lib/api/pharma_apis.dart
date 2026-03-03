import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart' hide MultipartFile;
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:kivicare_clinic_admin/models/base_response_model.dart';
import 'package:kivicare_clinic_admin/screens/Encounter/add_encounter/model/patient_model.dart';
import 'package:kivicare_clinic_admin/screens/doctor/model/doctor_list_res.dart';
import 'package:kivicare_clinic_admin/screens/pharma/inventory/model/categories_res_model.dart';
import 'package:kivicare_clinic_admin/screens/pharma/medicine/controller/medicine_list_controller.dart';
import 'package:kivicare_clinic_admin/screens/pharma/orders/models/order_model.dart';
import 'package:kivicare_clinic_admin/screens/pharma/prescriptions/model/prescription_detail_res_model.dart';
import 'package:kivicare_clinic_admin/utils/app_common.dart';
import 'package:nb_utils/nb_utils.dart';
import '../network/network_utils.dart';
import '../screens/doctor/model/commission_list_model.dart';
import '../screens/pharma/medicine/model/stock_history_resp_model.dart';
import '../screens/pharma/suppliers/model/supplier_types_res_model.dart';
import '../screens/pharma/manufacturer/model/manufacturers_res_model.dart';
import '../screens/pharma/medicine/model/medicine_resp_model.dart';
import '../screens/pharma/inventory/model/medicine_forms_res_model.dart';
import '../screens/pharma/prescriptions/model/prescriptions_res_model.dart';
import '../screens/pharma/suppliers/model/suppliers_res_model.dart';

import '../utils/api_end_points.dart';
import '../utils/constants.dart';

class PharmaApis {
  //Get Medicine List
  static Future<RxList<Medicine>> getMedicineList({
    bool isExpiredMedicine = false,
    int encounterId = -1,
    int pharmaId = -1,
    int page = 1,
    String search = '',
    var perPage = Constants.perPageItem,
    List<String> searchMedicineName = const [],
    List<String> searchMedicineForm = const [],
    List<String> searchMedicineCategory = const [],
    List<String> searchMedicineSupplier = const [],
    required List<Medicine> medicineList,
    Function(bool)? lastPageCallBack,
    int clinicId = 0,
    MedicineScreenType screenType = MedicineScreenType.all,
  }) async {
    String expiredMed = isExpiredMedicine ? 'expired_medicine=1' : '';
    String searchMedicine = search.isNotEmpty ? '&search=$search' : '';

    // Determine the type of medicine screen to filter the results
    String type = '';
    switch (screenType) {
      case MedicineScreenType.top:
        type = 'top-medicine';
        break;
      case MedicineScreenType.expired:
        type = 'upcoming-expiry';
        break;
      case MedicineScreenType.lowStock:
        type = 'low-stock';
        break;
      default:
        type = '';
    }
    clinicId = selectedAppClinic.value.id;
    String clinicIdStr = clinicId > 0 ? "&clinic_id=$clinicId" : "";
    String pharmaIdStr = pharmaId > 0 ? "&pharma_id=$pharmaId" : "";
    String typeStr = type.trim().isNotEmpty ? '&type=$type' : '';
    String formStr = searchMedicineForm.isNotEmpty
        ? '&form=${searchMedicineForm.join(",")}'
        : '';
    String categoryStr = searchMedicineCategory.isNotEmpty
        ? '&category=${searchMedicineCategory.join(",")}'
        : '';
    String supplierStr = searchMedicineSupplier.isNotEmpty
        ? '&supplier=${searchMedicineSupplier.join(",")}'
        : '';
    String encounterStr = pharmaId > 0
        ? ''
        : encounterId > 0
            ? '&encounter_id=$encounterId'
            : '';

    final response = await buildHttpResponse(
      "${APIEndPoints.getMedicineList}?per_page=$perPage&page=$page$searchMedicine$typeStr$clinicIdStr$formStr$categoryStr$supplierStr$encounterStr$pharmaIdStr$expiredMed",
      method: HttpMethodType.GET,
    );

    final res = MedicineListRes.fromJson(await handleResponse(response));

    if (page == 1) medicineList.clear();
    medicineList.addAll(res.data.validate());

    lastPageCallBack?.call(res.data.validate().length != perPage);

    return medicineList.obs;
  }

  //Get Prescription List
  static Future<RxList<PrescriptionData>> getPrescriptionList({
    int page = 1,
    String search = '',
    var perPage = Constants.perPageItem,
    required List<PrescriptionData> prescriptionList,
    List<String> bookingStatus = const [],
    List<String> paymentStatus = const [],
    List<int> doctorName = const [],
    List<int> patientName = const [],
    Function(bool)? lastPageCallBack,
  }) async {
    String searchPrescription = search.isNotEmpty ? '&search=$search' : '';
    String bookingStatusStr =
        bookingStatus.isNotEmpty ? '&status=${bookingStatus.join(",")}' : '';
    String paymentStatusStr = paymentStatus.isNotEmpty
        ? '&payment_status=${paymentStatus.join(",")}'
        : '';
    String doctorStr =
        doctorName.isNotEmpty ? '&doctor_name=${doctorName.join(",")}' : '';
    String patientStr =
        patientName.isNotEmpty ? '&patient_name=${patientName.join(",")}' : '';
    final res = PrescriptionListRes.fromJson(await handleResponse(
        await buildHttpResponse(
            "${APIEndPoints.getPrescriptionList}?per_page=$perPage&page=$page$searchPrescription$bookingStatusStr$paymentStatusStr$doctorStr$patientStr",
            method: HttpMethodType.GET)));
    if (page == 1) prescriptionList.clear();
    prescriptionList.addAll(res.data);
    lastPageCallBack?.call(res.data.length != perPage);
    return prescriptionList.obs;
  }

  //Get Medicine Category
  static Future<RxList<MedicineCategory>> getMedicineCategory({
    int page = 1,
    String search = '',
    var perPage = Constants.perPageItem,
    required List<MedicineCategory> medCategoryList,
    Function(bool)? lastPageCallBack,
  }) async {
    String searchPrescription = search.isNotEmpty ? '&search=$search' : '';
    final res = MedicineCategoryListRes.fromJson(await handleResponse(
        await buildHttpResponse(
            "${APIEndPoints.getMedicineCategoryList}?per_page=$perPage&page=$page$searchPrescription",
            method: HttpMethodType.GET)));
    if (page == 1) medCategoryList.clear();
    medCategoryList.addAll(res.data);
    lastPageCallBack?.call(res.data.length != perPage);
    return medCategoryList.obs;
  }

  //Get Medicine History
  static Future<RxList<MedicineHistoryElement>> getMedicineHistory({
    int page = 1,
    String search = '',
    required int medId,
    var perPage = Constants.perPageItem,
    required List<MedicineHistoryElement> medHistoryList,
    Function(bool)? lastPageCallBack,
  }) async {
    final res = StockHistoryResp.fromJson(await handleResponse(
        await buildHttpResponse(
            "${APIEndPoints.getMedicineHistory}?per_page=$perPage&page=$page&medicine_id=$medId",
            method: HttpMethodType.GET)));
    if (page == 1) medHistoryList.clear();
    medHistoryList.addAll(res.data);
    lastPageCallBack?.call(res.data.length != perPage);
    return medHistoryList.obs;
  }

  //Get Medicine Forms
  static Future<RxList<MedicineForm>> getMedicineForms({
    int page = 1,
    String search = '',
    var perPage = Constants.perPageItem,
    required List<MedicineForm> medicineForms,
    Function(bool)? lastPageCallBack,
  }) async {
    String searchPrescription = search.isNotEmpty ? '&search=$search' : '';
    final res = MedicineFormListRes.fromJson(await handleResponse(
        await buildHttpResponse(
            "${APIEndPoints.getMedicineFormList}?per_page=$perPage&page=$page$searchPrescription",
            method: HttpMethodType.GET)));
    if (page == 1) medicineForms.clear();
    medicineForms.addAll(res.data);
    lastPageCallBack?.call(res.data.length != perPage);
    return medicineForms.obs;
  }

  //Get Manufacturers
  static Future<RxList<Manufacturer>> getManufacturerList({
    int page = 1,
    String search = '',
    var perPage = Constants.perPageItem,
    required List<Manufacturer> manufacturerList,
    Function(bool)? lastPageCallBack,
  }) async {
    String searchPrescription = search.isNotEmpty ? '&search=$search' : '';
    final res = ManufacturerListRes.fromJson(await handleResponse(
        await buildHttpResponse(
            "${APIEndPoints.getManufacturerList}?per_page=$perPage&page=$page$searchPrescription",
            method: HttpMethodType.GET)));
    if (page == 1) manufacturerList.clear();
    manufacturerList.addAll(res.data);
    lastPageCallBack?.call(res.data.length != perPage);
    return manufacturerList.obs;
  }

  //Get Suppliers
  static Future<RxList<Supplier>> getSupplierList({
    int page = 1,
    String search = '',
    String status = "",
    var perPage = Constants.perPageItem,
    required List<Supplier> supplierList,
    Function(bool)? lastPageCallBack,
  }) async {
    String searchPrescription = search.isNotEmpty ? "&search=$search" : '';
    String statusStr = status.isNotEmpty ? "&status=$status" : '';
    final res = SupplierListRes.fromJson(await handleResponse(
        await buildHttpResponse(
            "${APIEndPoints.getSupplierList}?per_page=$perPage&page=$page$searchPrescription$statusStr",
            method: HttpMethodType.GET)));
    if (page == 1) supplierList.clear();
    supplierList.addAll(res.data as Iterable<Supplier>);
    lastPageCallBack?.call(res.data.length != perPage);
    return supplierList.obs;
  }

  // Order list
  static Future<RxList<OrderModel>> getOrderList({
    int id = -1,
    int page = 1,
    String search = '',
    var perPage = Constants.perPageItem,
    required List<OrderModel> orderList,
    Function(bool)? lastPageCallBack,
  }) async {
    String searchOrder = search.isNotEmpty ? "&search=$search" : '';
    String pharma = id == -1 ? "" : '&pharma_id=$id';
    final res = OrderListRes.fromJson(await handleResponse(
      await buildHttpResponse(
        "${APIEndPoints.getOrderList}?per_page=$perPage&page=$page$searchOrder$pharma",
        method: HttpMethodType.GET,
      ),
    ));

    if (page == 1) orderList.clear();
    orderList.addAll(res.data);
    lastPageCallBack?.call(res.data.length != perPage);

    return orderList.obs;
  }

  static Future<Rx<PrescriptionDetail>> getPrescriptionDetail(int id) async {
    final res = PrescriptionDetailRes.fromJson(await handleResponse(
        await buildHttpResponse("${APIEndPoints.getPrescriptionDetail}?id=$id",
            method: HttpMethodType.GET)));
    return res.data.obs;
  }

  static Future<BaseResponseModel> saveMedicineToPrescription(
      {required Map request, required int id}) async {
    return BaseResponseModel.fromJson(await handleResponse(
        await buildHttpResponse("${APIEndPoints.addExtraMedicineToPresc}/$id",
            request: request, method: HttpMethodType.POST)));
  }

  static Future<BaseResponseModel> prescriptionEditMedicine(
      {required Map request, required int id}) async {
    return BaseResponseModel.fromJson(await handleResponse(
        await buildHttpResponse("${APIEndPoints.prescriptionEditMedicine}/$id",
            request: request, method: HttpMethodType.POST)));
  }

  static Future<BaseResponseModel> prescriptionMedicineDelete(
      {required int id}) async {
    return BaseResponseModel.fromJson(await handleResponse(
        await buildHttpResponse(
            "${APIEndPoints.prescriptionMedicineDelete}/$id",
            method: HttpMethodType.DELETE)));
  }

  static Future<BaseResponseModel> prescriptionUpdate(
      {required Map request}) async {
    return BaseResponseModel.fromJson(await handleResponse(
        await buildHttpResponse(APIEndPoints.prescriptionUpdate,
            request: request, method: HttpMethodType.POST)));
  }

  //Save Medicine to Stock
  static Future<BaseResponseModel> saveMedicineToStock(
      {required Map request, int? id}) async {
    String endpoint = APIEndPoints.storeMedicineToStock;
    if (id != null) {
      endpoint = "${APIEndPoints.medicineUpdate}/$id";
    }
    var res = BaseResponseModel.fromJson(await handleResponse(
        await buildHttpResponse(endpoint,
            request: request, method: HttpMethodType.POST)));
    return res;
  }

  //Add Medicine to Stock
  static Future<BaseResponseModel> addMedicineStock(
      {required Map request, int? id}) async {
    var res = BaseResponseModel.fromJson(await handleResponse(
        await buildHttpResponse("${APIEndPoints.addMedicineStock}/$id",
            request: request, method: HttpMethodType.POST)));
    return res;
  }

  //Save Manufacturer Detail
  static Future<BaseResponseModel> saveManufacturer(
      {required Map request}) async {
    return BaseResponseModel.fromJson(await handleResponse(
        await buildHttpResponse(APIEndPoints.saveManufacturer,
            request: request, method: HttpMethodType.POST)));
  }

  //Add Edit Supplier
  static Future<dynamic> addEditSupplier({
    bool isEdit = false,
    int? supplierId,
    required Map<String, dynamic> request,
    File? imageFile,
    Function(dynamic)? onSuccess,
  }) async {
    if (isLoggedIn.value) {
      MultipartRequest multiPartRequest =
          await getMultiPartRequest(APIEndPoints.addSupplier);

      if (isEdit && supplierId != null) {
        request['id'] = supplierId;
      }

      multiPartRequest.fields.addAll(await getMultipartFields(val: request));

      if (imageFile != null) {
        multiPartRequest.files
            .add(await MultipartFile.fromPath('image', imageFile.path));
      }

      multiPartRequest.headers.addAll(buildHeaderTokens());

      log("Supplier Fields ➤ ${jsonEncode(multiPartRequest.fields)}");
      log("Supplier Files ➤ ${multiPartRequest.files.map((e) => e.filename)}");

      // Await response from multipart sender
      final result = await sendMultiPartRequest(
        multiPartRequest,
        onSuccess: (data) async {
          log("Response: ${jsonDecode(data)}");
          final baseResponseModel =
              BaseResponseModel.fromJson(jsonDecode(data));
          if (baseResponseModel.message.isNotEmpty)
            toast(baseResponseModel.message, print: true);
          onSuccess?.call(data);
        },
        onError: (error) {
          throw error;
        },
      ).catchError((error) {
        throw error;
      });

      return result;
    }

    // throw errorSomethingWentWrong;
  }

  //Get Supplier Types
  static Future<RxList<SupplierType>> getSupplierTypes({
    int page = 1,
    String search = '',
    var perPage = Constants.perPageItem,
    required List<SupplierType> supplierTypes,
    Function(bool)? lastPageCallBack,
  }) async {
    String searchSupplierType = search.isNotEmpty ? '&search=$search' : '';
    final res = SupplierTypeListRes.fromJson(await handleResponse(
        await buildHttpResponse(
            "${APIEndPoints.getSupplierTypes}?per_page=$perPage&page=$page$searchSupplierType",
            method: HttpMethodType.GET)));
    if (page == 1) supplierTypes.clear();
    supplierTypes.addAll(res.data);
    lastPageCallBack?.call(res.data.length != perPage);
    return supplierTypes.obs;
  }

  //Purchase Order
  static Future<BaseResponseModel> purchaseOrder({required Map request}) async {
    return BaseResponseModel.fromJson(await handleResponse(
        await buildHttpResponse(APIEndPoints.purchaseOrder,
            request: request, method: HttpMethodType.POST)));
  }

  static Future<BaseResponseModel> editPurchaseOrder(
      {required Map request, required int id}) async {
    return BaseResponseModel.fromJson(await handleResponse(
        await buildHttpResponse("${APIEndPoints.editPurchaseOrder}/$id",
            request: request, method: HttpMethodType.POST)));
  }

//Delete Medicine
  static Future<BaseResponseModel> deleteMedicine({required int id}) async {
    return BaseResponseModel.fromJson(await handleResponse(
        await buildHttpResponse("${APIEndPoints.deleteMedicine}$id",
            method: HttpMethodType.POST)));
  }

  //Delete purchase order
  static Future<BaseResponseModel> deletePurchaseOrder(
      {required int id}) async {
    return BaseResponseModel.fromJson(await handleResponse(
        await buildHttpResponse("${APIEndPoints.deletePurchaseOrder}/$id",
            method: HttpMethodType.DELETE)));
  }

  //delete supplier
  static Future<BaseResponseModel> deleteSupplier({required int id}) async {
    return BaseResponseModel.fromJson(await handleResponse(
        await buildHttpResponse("${APIEndPoints.deleteSupplier}$id",
            method: HttpMethodType.DELETE)));
  }

  ///doctor list for search
  static Future<RxList<Doctor>> getDoctorListForSearch({
    int page = 1,
    List<Doctor> doctorsList = const [],
    var perPage = Constants.perPageItem,
    Function(bool)? lastPageCallBack,
  }) async {
    final res = DoctorListRes.fromJson(await handleResponse(
        await buildHttpResponse(APIEndPoints.getDoctorList,
            method: HttpMethodType.GET)));
    if (page == 1) doctorsList.clear();
    doctorsList.addAll(res.data);
    lastPageCallBack?.call(res.data.length != perPage);
    return doctorsList.obs;
  }

  ///doctor list for search
  static Future<RxList<PatientModel>> getPatientListForSearch({
    int page = 1,
    List<PatientModel> patientList = const [],
    var perPage = Constants.perPageItem,
    Function(bool)? lastPageCallBack,
  }) async {
    final res = PatientListModel.fromJson(await handleResponse(
        await buildHttpResponse(APIEndPoints.getPatientList,
            method: HttpMethodType.GET)));
    if (page == 1) patientList.clear();
    patientList.addAll(res.data);
    lastPageCallBack?.call(res.data.length != perPage);
    return patientList.obs;
  }

  static Future<BaseResponseModel> changeOrderStatus(
      {required int id, Map<String, dynamic>? request}) async {
    return BaseResponseModel.fromJson(await handleResponse(
        await buildHttpResponse("${APIEndPoints.changeOrderStatus}$id",
            request: request, method: HttpMethodType.POST)));
  }

  static Future<BaseResponseModel> changePrescriptionStatus(
      {Map<String, dynamic>? request}) async {
    return BaseResponseModel.fromJson(await handleResponse(
        await buildHttpResponse(APIEndPoints.updatePrescriptionStatus,
            request: request, method: HttpMethodType.POST)));
  }

  static Future<BaseResponseModel> changePrescriptionPaymentStatus(
      {Map<String, dynamic>? request}) async {
    return BaseResponseModel.fromJson(await handleResponse(
        await buildHttpResponse(APIEndPoints.updatePrescriptionPaymentStatus,
            request: request, method: HttpMethodType.POST)));
  }

  static Future<RxList<Pharma>> getPharmaList({
    int page = 1,
    String search = '',
    String status = "",
    var perPage = Constants.perPageItem,
    required List<Pharma> pharmaList,
    int clinicId = -1,
  }) async {
    String searchParma = search.isNotEmpty ? "&search=$search" : '';
    String clinicIdStr = clinicId != -1 ? "&clinic_id=$clinicId" : '';

    final response = await handleResponse(
      await buildHttpResponse(
        "${APIEndPoints.getPharmaList}?per_page=$perPage&page=$page$searchParma$clinicIdStr",
        method: HttpMethodType.GET,
      ),
    );

    // 🛠 Extract the "data" list from the paginated response
    List<Pharma> res = (response['data'] as List)
        .map((json) => Pharma.fromJson(json))
        .toList();

    if (page == 1) pharmaList.clear();
    pharmaList.addAll(res);

    return pharmaList.obs;
  }

  static Future<CommissionListRes> getPharmaCommission() async {
    return CommissionListRes.fromJson(await handleResponse(
        await buildHttpResponse(APIEndPoints.pharmaCommissionList,
            method: HttpMethodType.GET)));
  }

  Future<dynamic> addEditPharma({
    bool isEdit = false,
    int pharmaId = -1,
    required Map<String, dynamic> request,
    List<File>? files,
    Function(dynamic)? onSuccess,
  }) async {
    if (isEdit) {
      request.remove("password");
      request.remove("confirm_password");
    }

    log("Request is ${request.toString()}");

    final endpoint = isEdit
        ? "${APIEndPoints.updatePharma}/$pharmaId"
        : APIEndPoints.addPharma;
    var multiPartRequest = await getMultiPartRequest(endpoint);

    multiPartRequest.fields.addAll(await getMultipartFields(val: request));
    if (files != null && files.isNotEmpty) {
      final file = files.first;
      if (file.path.isNotEmpty) {
        log("Uploading file: ${file.path}");
        multiPartRequest.files.add(
          await http.MultipartFile.fromPath('profile_image', file.path),
        );
      } else {
        log("⚠️ File path is empty — skipping upload");
      }
    } else {
      log("⚠️ No files selected — skipping file upload");
    }

    log("Multipart Fields ➤ ${jsonEncode(multiPartRequest.fields)}");
    log("Multipart Files ➤ ${multiPartRequest.files.map((e) => e.filename)}");
    log("Multipart Extension ➤ ${multiPartRequest.files.map((e) => e.filename?.split('.').last)}");

    multiPartRequest.headers.addAll(buildHeaderTokens());

    await sendMultiPartRequest(
      multiPartRequest,
      onSuccess: (data) async {
        final baseResponseModel = BaseResponseModel.fromJson(jsonDecode(data));
        log("✅ API Success: ${baseResponseModel.message}");
        toast(baseResponseModel.message, print: true);
        onSuccess?.call(baseResponseModel);
      },
      onError: (error) {
        log("on Error: $error");
      },
    ).catchError((error) {
      log("catch error-----$error");
    });
  }
}

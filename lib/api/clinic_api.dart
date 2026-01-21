import 'dart:io';

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:http/http.dart';
import 'package:kivicare_clinic_admin/screens/clinic/model/clinics_res_model.dart';
import 'package:nb_utils/nb_utils.dart';

import '../models/base_response_model.dart';
import '../network/network_utils.dart';
import '../screens/clinic/add_clinic_form/model/clinic_session_response.dart';
import '../screens/clinic/model/clinic_detail_model.dart';
import '../screens/clinic/model/clinic_gallery_model.dart';
import '../utils/api_end_points.dart';
import '../utils/app_common.dart';
import '../utils/constants.dart';

class ClinicApis {
  static Future<RxList<ClinicData>> getClinicList({
    String search = '',
    int page = 1,
    var perPage = Constants.perPageItem,
    required List<ClinicData> clinicList,
    Function(bool)? lastPageCallBack,
    bool isReceptionistRegister = false,
    bool isDoctorRegister = false,
    bool isPharmaRegister = false,
    int? doctorId,
  }) async {
    final String searchService = search.isNotEmpty ? '&search=$search' : '';

    String endpoint =  APIEndPoints.getClinics;
    String extraParams = '';
    if(isPharmaRegister){
      extraParams = '&pharma_login=1';
    }
    if (isReceptionistRegister) {
      endpoint = APIEndPoints.getClinicListToRegister;
      final int vendorId = loginUserData.value.id;
      final String vendorParam = vendorId > 0 ? '&vendor_id=$vendorId' : '';
      extraParams = '&receptionist_login=1$vendorParam';
    } else if (isDoctorRegister) {
      endpoint = APIEndPoints.getClinicListToRegister;
    }

    final res = ClinicListRes.fromJson(
      await handleResponse(
        await buildHttpResponse("$endpoint?per_page=$perPage&page=$page$searchService$extraParams"),
      ),
    );

    if (page == 1) clinicList.clear();
    clinicList.addAll(res.data.validate());

    lastPageCallBack?.call(res.data.validate().length != perPage);

    return clinicList.obs;
  }

  static Future<ClinicDetailModel> getClinicDetails({required int clinicId}) async {
    return ClinicDetailModel.fromJson(await handleResponse(await buildHttpResponse('${APIEndPoints.getClinicDetails}?clinic_id=$clinicId')));
  }

  static Future<RxList<ClinicData>> getClinicListWithDoctor({
    int? doctorId,
    String search = '',
    int page = 1,
    var perPage = Constants.perPageItem,
    required List<ClinicData> clinicList,
    Function(bool)? lastPageCallBack,
  }) async {
    final String searchService = search.isNotEmpty ? '&search=$search' : '';
    final String doctor = doctorId.toString().isNotEmpty ? '&doctor_id=$doctorId' : '';
    final res = ClinicListRes.fromJson(await handleResponse(await buildHttpResponse("${APIEndPoints.getClinics}?per_page=$perPage&page=$page$doctor$searchService")));

    if (page == 1) clinicList.clear();
    clinicList.addAll(res.data.validate());

    lastPageCallBack?.call(res.data.validate().length != perPage);

    return clinicList.obs;
  }

  static Future<dynamic> addEditClinc({
    bool isEdit = false,
    int? clinicId,
    ClinicData? clinicData,
    required Map<String, dynamic> request,
    // List<XFile>? files,
    File? imageFile,
    Function(dynamic)? onSuccess,
  }) async {
    if (isLoggedIn.value) {
      final MultipartRequest multiPartRequest = await getMultiPartRequest(isEdit ? "${APIEndPoints.updateClinic}/$clinicId" : APIEndPoints.saveClinic);
      multiPartRequest.fields.addAll(await getMultipartFields(val: request));
      if (imageFile != null) {
        // multiPartRequest.files.addAll(await getMultipartImages2(files: files.validate(), name: 'feature_image'));
        multiPartRequest.files.add(await MultipartFile.fromPath('file_url', imageFile.path));
      }

      multiPartRequest.headers.addAll(buildHeaderTokens());

      await sendMultiPartRequest(
        multiPartRequest,
        onSuccess: (data) async {
          onSuccess?.call(data);
        },
        onError: (error) {
          throw error;
        },
      ).catchError((error) {
        throw error;
      });
    }
  }

  static Future<BaseResponseModel> deleteClinic({required int clinicId}) async {
    return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('${APIEndPoints.deleteClinic}/$clinicId', method: HttpMethodType.POST)));
  }

  static Future<RxList<GalleryData>> getClinicGalleryList({
    int page = 1,
    int perPage = 10,
    required List<GalleryData> galleryList,
    Function(bool)? lastPageCallBack,
    int clinicId = -1,
  }) async {
    final String clncId = clinicId != -1 ? '&clinic_id=$clinicId' : '';
    final galleryListRes = ClinicGalleryModel.fromJson(await handleResponse(await buildHttpResponse("${APIEndPoints.getClinicGallery}?per_page=$perPage&page=$page$clncId")));
    if (page == 1) galleryList.clear();
    galleryList.addAll(galleryListRes.data);
    lastPageCallBack?.call(galleryListRes.data.length != perPage);
    return galleryList.obs;
  }

  //Save Gallery Images
  static Future<dynamic> saveClinicGallery({
    required Map<String, dynamic> request,
    List<File>? imageFile,
    Function(dynamic)? onSuccess,
  }) async {
    if (isLoggedIn.value) {
      final MultipartRequest multiPartRequest = await getMultiPartRequest(APIEndPoints.saveClinicGallery);
      multiPartRequest.fields.addAll(await getMultipartFields(val: request));
      if (imageFile != null || imageFile!.isNotEmpty) {
        for (var i = 0; i < imageFile.length; i++) {
          multiPartRequest.files.add(await MultipartFile.fromPath('gallery_images[$i]', imageFile[i].path));
        }
      }
      multiPartRequest.headers.addAll(buildHeaderTokens());
      await sendMultiPartRequest(
        multiPartRequest,
        onSuccess: (data) async {
          onSuccess?.call(data);
        },
        onError: (error) {
          throw error;
        },
      ).catchError((error) {
        throw error;
      });
    }
  }

  //Delete Gallery List
  // static Future<BaseResponseModel> deleteClinicGallery({required Map request}) async {
  //   return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse(APIEndPoints.saveClinicGallery, request: request, method: HttpMethodType.POST)));
  // }

  static Future<dynamic> deleteClinicGallery({
    required Map<String, dynamic> request,
    Function(dynamic)? onSuccess,
  }) async {
    if (isLoggedIn.value) {
      final MultipartRequest multiPartRequest = await getMultiPartRequest(APIEndPoints.saveClinicGallery);
      multiPartRequest.fields.addAll(await getMultipartFields(val: request));
      multiPartRequest.headers.addAll(buildHeaderTokens());
      await sendMultiPartRequest(
        multiPartRequest,
        onSuccess: (data) async {
          onSuccess?.call(data);
        },
        onError: (error) {
          throw error;
        },
      ).catchError((error) {
        throw error;
      });
    }
  }

  //Clinic Session List
  static Future<RxList<ClinicSessionModel>> getClinicSessionList({required int clinicId, required List<ClinicSessionModel> clinicSessionResp}) async {
    final resp = ClinicSessionResp.fromJson(await handleResponse(await buildHttpResponse("${APIEndPoints.clinicSessionList}?clinic_id=$clinicId")));
    clinicSessionResp.addAll(resp.data);
    return clinicSessionResp.obs;
  }

  //Save Clinic Session
  static Future<RxList<ClinicSessionModel>> saveClinicSession({required Map request, required List<ClinicSessionModel> clinicSessionResp}) async {
    final resp = ClinicSessionResp.fromJson(await handleResponse(await buildHttpResponse(APIEndPoints.saveClinicSession, request: request, method: HttpMethodType.POST)));
    toast(resp.message);
    clinicSessionResp.addAll(resp.data);
    return clinicSessionResp.obs;
  }
}

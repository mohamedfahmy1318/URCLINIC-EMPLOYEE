import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/screens/doctor/model/commission_list_model.dart';
import 'package:http/http.dart' as http;
import '../models/base_response_model.dart';
import '../network/network_utils.dart';
import '../screens/clinic/add_clinic_form/model/clinic_session_response.dart';
import '../utils/api_end_points.dart';

class DoctorApis {
  static Future<CommissionListRes> getCommission() async {
    return CommissionListRes.fromJson(await handleResponse(
        await buildHttpResponse(APIEndPoints.doctorCommissionList)));
  }

  static Future<dynamic> addDoctor(
      {bool isEdit = false,
      int? doctorId,
      required Map<String, dynamic> request,
      List<File>? files,
      Function(dynamic)? onSuccess}) async {
    if (isEdit) {
      request.remove("password");
      request.remove("confirm_password");
    }
    final multiPartRequest = await getMultiPartRequest(isEdit
        ? "${APIEndPoints.updateDoctor}/$doctorId"
        : APIEndPoints.saveDoctor);
    final Map<String, dynamic> fields = Map<String, dynamic>.from(request);
    final String? qualificationsJson = fields.remove('qualifications');

    List<int> clinicIds = fields.remove('clinic_id') ?? [];
    List<int> serviceIds = fields.remove('service_id') ?? [];
    List<int> commissionIds = fields.remove('commission_id') ?? [];

    multiPartRequest.fields.addAll(await getMultipartFields(val: fields));

    for (int i = 0; i < clinicIds.length; i++) {
      multiPartRequest.fields['clinic_id[$i]'] = clinicIds[i].toString();
    }
    for (int i = 0; i < serviceIds.length; i++) {
      multiPartRequest.fields['service_id[$i]'] = serviceIds[i].toString();
    }
    for (int i = 0; i < commissionIds.length; i++) {
      multiPartRequest.fields['commission_id[$i]'] =
          commissionIds[i].toString();
    }

    multiPartRequest.fields.addAll(await getMultipartFields(val: fields));
    if (qualificationsJson != null && qualificationsJson.isNotEmpty) {
      try {
        final List<dynamic> qualifications = jsonDecode(qualificationsJson);
        for (int i = 0; i < qualifications.length; i++) {
          final q = qualifications[i];
          if (q is Map) {
            if ((q['degree'] ?? '').toString().trim().isNotEmpty) {
              multiPartRequest.fields['qualifications[$i][degree]'] =
                  q['degree'].toString();
            }
            if ((q['university'] ?? '').toString().trim().isNotEmpty) {
              multiPartRequest.fields['qualifications[$i][university]'] =
                  q['university'].toString();
            }
            if ((q['year'] ?? '').toString().trim().isNotEmpty) {
              multiPartRequest.fields['qualifications[$i][year]'] =
                  q['year'].toString();
            }
          }
        }
      } catch (e) {
        // If parsing fails, skip qualifications instead of breaking the request
      }
    }

    if (files.validate().isNotEmpty) {
      multiPartRequest.files.add(await http.MultipartFile.fromPath(
          'profile_image', files.validate().first.path.validate()));
    }

    /*  if (files.validate().isNotEmpty) {
      multiPartRequest.files.addAll(await getMultipartImages(files: files.validate(), name: 'medical_report'));
      // multiPartRequest.fields['attachment_count'] = files.validate().length.toString();
    } */
    multiPartRequest.headers.addAll(buildHeaderTokens());
    await sendMultiPartRequest(
      multiPartRequest,
      onSuccess: (data) async {
        log("Response: ${jsonDecode(data)}");
        final baseResponseModel = BaseResponseModel.fromJson(jsonDecode(data));
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
  }

  //Doctor Session List
  static Future<RxList<ClinicSessionModel>> getDoctorSessionList(
      {required int clinicId,
      required int doctorId,
      required List<ClinicSessionModel> doctorSessionResp}) async {
    final resp = ClinicSessionResp.fromJson(await handleResponse(
        await buildHttpResponse(
            "${APIEndPoints.doctorSessionList}?clinic_id=$clinicId&doctor_id=$doctorId")));
    doctorSessionResp.addAll(resp.data);
    return doctorSessionResp.obs;
  }

  static Future<BaseResponseModel> deleteDoctor({required int doctorId}) async {
    return BaseResponseModel.fromJson(await handleResponse(
        await buildHttpResponse('${APIEndPoints.deleteDoctor}/$doctorId',
            method: HttpMethodType.POST)));
  }
}

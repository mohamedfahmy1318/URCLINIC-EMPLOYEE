import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/utils/app_common.dart';
import '../../api/core_apis.dart';
import 'model/request_type_model.dart';
import 'model/service_request_model.dart';

class RequestListController extends GetxController {
  Rx<Future<RxList<RequestElement>>> getRequestList = Future(() => RxList<RequestElement>()).obs;
  RxList<RequestElement> requestList = RxList();
  RxInt page = 1.obs;
  RxBool isLoading = false.obs;
  RxBool isLastPage = false.obs;

  //TextFiled Controller
  final GlobalKey<FormState> addReqFormKey = GlobalKey();
  TextEditingController nameCont = TextEditingController();
  TextEditingController descCont = TextEditingController();

  // List typeList = ['category', 'service', 'specialization'];

  Rx<RequestType> selectedType = RequestType().obs;

  @override
  void onReady() {
    if (selectedType.value.id.isNegative && requestTypeList.isNotEmpty) {
      selectedType(requestTypeList.first);
    }
    getRequests();
    super.onReady();
  }

  Future<void> getRequests({bool showloader = true, String search = ""}) async {
    if (showloader) {
      isLoading(true);
    }
    await getRequestList(
      CoreServiceApis.getRequestList(
        requests: requestList,
        page: page.value,
        lastPageCallBack: (p0) {
          isLastPage(p0);
        },
      ),
    ).then((value) {}).catchError((e) {
      log('getRequests E: $e');
    }).whenComplete(() => isLoading(false));
  }

  Future<void> addRequest() async {
    isLoading(true);

    final Map<String, dynamic> req = {
      "name": nameCont.text.trim(),
      "description": descCont.text.trim(),
      "type": selectedType.value.type,
      "vendor_id": loginUserData.value.id,
      "status": 1,
    };

    CoreServiceApis.saveRequestService(request: req).then((value) async {
      getRequests();
      nameCont.clear();
      descCont.clear();
      Get.back();
    }).catchError((e) {
      toast(e.toString(), print: true);
    }).whenComplete(() => isLoading(false));
  }
}

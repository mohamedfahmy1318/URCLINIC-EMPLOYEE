import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stream_transform/stream_transform.dart';
import 'model/clinics_res_model.dart';
import '../../api/clinic_api.dart';

class ClinicListController extends GetxController {
  Rx<Future<RxList<ClinicData>>> getClinics = Future(() => RxList<ClinicData>()).obs;
  RxList<ClinicData> clinicList = RxList();
  RxInt page = 1.obs;
  RxBool isLoading = false.obs;
  RxBool isLastPage = false.obs;

  Rx<ClinicData> selectClinic = ClinicData().obs;

  RxBool isSearchClincText = false.obs;
  TextEditingController searchClinicCont = TextEditingController();

  StreamController<String> searchClincStream = StreamController<String>();
  final _scrollController = ScrollController();

  @override
  void onReady() {
    _scrollController.addListener(() => Get.context != null ? hideKeyboard(Get.context) : null);
    searchClincStream.stream.debounce(const Duration(seconds: 1)).listen((s) {
      getClinicList();
    });
    getClinicList();
    super.onReady();
  }

  Future<void> getClinicList({bool showloader = true}) async {
    if (showloader) {
      isLoading(true);
    }
    await getClinics(
      ClinicApis.getClinicList(
        clinicList: clinicList,
        page: page.value,
        search: searchClinicCont.text.trim(),
        lastPageCallBack: (p0) {
          isLastPage(p0);
        },
      ),
    ).then((value) {}).catchError((e) {
      log("getClinicList err: $e");
    }).whenComplete(() => isLoading(false));
  }

  @override
  void onClose() {
    searchClincStream.close();
    if (Get.context != null) {
      _scrollController.removeListener(() => hideKeyboard(Get.context));
    }
    super.onClose();
  }
}

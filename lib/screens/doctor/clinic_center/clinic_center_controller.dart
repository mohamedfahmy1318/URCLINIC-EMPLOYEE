import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../api/clinic_api.dart';
import '../../auth/model/clinic_center_argument_model.dart';
import '../../clinic/model/clinics_res_model.dart';

class ClinicCenterController extends GetxController {
  Rx<Future<RxList<ClinicData>>> getClinics = Future(() => RxList<ClinicData>()).obs;
  RxList<ClinicData> clinicList = RxList();
  RxInt page = 1.obs;
  RxBool isLoading = false.obs;
  RxBool isLastPage = false.obs;

  RxBool isSearchClincText = false.obs;
  TextEditingController searchClinicCont = TextEditingController();

  StreamController<String> searchClincStream = StreamController<String>();
  final _scrollController = ScrollController();

  RxList<ClinicData> selectedClinics = RxList();

  RxBool isSingleSelect = false.obs;
  Rx<ClinicData> singleClinicSelect = ClinicData().obs;

  RxBool isReceptionistRegister = false.obs;
  RxBool isDoctorRegister = false.obs;
  RxBool isPharmaRegister = false.obs;

  @override
  void onReady() {
    _scrollController.addListener(() => Get.context != null ? hideKeyboard(Get.context) : null);
    searchClincStream.stream.debounce(const Duration(seconds: 1)).listen((s) {
      getClinicList();
    });

    getSelClinicList();
    super.onReady();
  }

  Future<void> getSelClinicList() async {
    if (Get.arguments is List<ClinicData>) {
      selectedClinics.addAll(Get.arguments as List<ClinicData>);
    }

    if (Get.arguments is ClinicData) {
      isSingleSelect(true);
      singleClinicSelect(Get.arguments as ClinicData);
    }

    if (Get.arguments is ClinicCenterArgumentModel) {
      final res = Get.arguments as ClinicCenterArgumentModel;
      isSingleSelect(true);
      singleClinicSelect(res.selectedClinc);
      if (res.isReceptionistRegister) {
        isReceptionistRegister(true);
      } else if (res.isDoctorRegister) {
        isDoctorRegister(true);
      }
    }
    getClinicList();
  }

  bool checkSelClinicList({required ClinicData clinic}) {
    for (final element in selectedClinics) {
      if (element.id == clinic.id) {
        return true;
      }
    }
    return false;
  }

  Future<void> getClinicList({bool showloader = true}) async {
    if (showloader) {
      isLoading(true);
    }
    await getClinics(
      ClinicApis.getClinicList(
        isReceptionistRegister: isReceptionistRegister.value,
        isDoctorRegister: isDoctorRegister.value,
        isPharmaRegister: isPharmaRegister.value,
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

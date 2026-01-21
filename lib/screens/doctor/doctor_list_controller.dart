import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:kivicare_clinic_admin/api/core_apis.dart';
import '../clinic/model/clinics_res_model.dart';
import 'model/doctor_list_res.dart';

class DoctorListController extends GetxController {
  Rx<Future<RxList<Doctor>>> doctorsFuture = Future(() => RxList<Doctor>()).obs;
  RxBool isLoading = false.obs;
  RxList<Doctor> doctors = RxList();
  RxBool isLastPage = false.obs;
  RxInt page = 1.obs;
  Rx<ClinicData> clinic = ClinicData().obs;
  Rx<Doctor> selectedDoctor = Doctor().obs;

  ///Search
  TextEditingController searchCont = TextEditingController();
  RxBool isSearchText = false.obs;
  StreamController<String> searchStream = StreamController<String>();
  final _scrollController = ScrollController();

  @override
  void onInit() {
    _scrollController.addListener(() => Get.context != null ? hideKeyboard(Get.context) : null);
    searchStream.stream.debounce(const Duration(seconds: 1)).listen((s) {
      getDoctors();
    });
    if (Get.arguments is ClinicData) {
      clinic(Get.arguments);
    }
    getDoctors();
    super.onInit();
  }

  Future<void> getDoctors({bool showloader = true}) async {
    if (showloader) {
      isLoading(true);
    }
    await doctorsFuture(
      CoreServiceApis.getDoctors(
        page: page.value,
        doctors: doctors,
        clinicId: clinic.value.id,
        search: searchCont.text.trim(),
        lastPageCallBack: (p0) {
          isLastPage(p0);
        },
      ),
    ).then((value) {
      log('value.length ==> ${value.length}');
      if (value.isNotEmpty) {
        selectedDoctor(value.first);
      }
    }).catchError((e) {
      log("getDoctors error $e");
    }).whenComplete(() => isLoading(false));
  }
}

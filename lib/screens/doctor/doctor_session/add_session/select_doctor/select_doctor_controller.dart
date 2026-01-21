import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stream_transform/stream_transform.dart';
import '../../../../../api/clinic_api.dart';
import '../../../../../api/core_apis.dart';
import '../../../../clinic/model/clinics_res_model.dart';
import '../../../model/doctor_list_res.dart';

class SelectDoctorController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<Doctor> selectDoctorData = Doctor().obs;
  Rx<ClinicData> selectClinicData = ClinicData().obs;

  //Doctor List
  Rx<Future<RxList<Doctor>>> doctorsFuture = Future(() => RxList<Doctor>()).obs;
  RxList<Doctor> doctors = RxList();
  RxBool isDoctorsLastPage = false.obs;
  RxInt doctorsPage = 1.obs;
  TextEditingController searchCont = TextEditingController();
  RxBool isSearchText = false.obs;
  StreamController<String> searchStream = StreamController<String>();
  final _scrollController = ScrollController();

  //Clinic List
  Rx<Future<RxList<ClinicData>>> clinicFuture = Future(() => RxList<ClinicData>()).obs;
  RxBool isClinicLoading = false.obs;
  RxList<ClinicData> clinicList = RxList();
  RxBool isClinicLastPage = false.obs;
  RxInt clinicPage = 1.obs;
  TextEditingController searchClinicCont = TextEditingController();
  RxBool isSearchClinicText = false.obs;
  StreamController<String> searchClinicStream = StreamController<String>();
  final _scrollClinicController = ScrollController();

  void getDoctorList() {
    _scrollController.addListener(() => Get.context != null ? hideKeyboard(Get.context) : null);
    searchStream.stream.debounce(const Duration(seconds: 1)).listen((s) {
      getDoctors();
    });
    getDoctors();
  }

  void getClinics({required int doctorId}) {
    _scrollClinicController.addListener(() => Get.context != null ? hideKeyboard(Get.context) : null);
    searchClinicStream.stream.debounce(const Duration(seconds: 1)).listen((s) {
      getClinicsData(doctorId);
    });
    getClinicsData(doctorId);
  }

  Future<void> getClinicsData(int doctorId, {bool showLoader = true}) async {
    if (showLoader) {
      isClinicLoading(true);
    }
    await clinicFuture(
      ClinicApis.getClinicListWithDoctor(
        doctorId: doctorId,
        page: clinicPage.value,
        clinicList: clinicList,
        search: searchClinicCont.text.trim(),
        lastPageCallBack: (p0) {
          isClinicLastPage(p0);
        },
      ),
    ).then((value) {
      log('value.length ==> ${value.length}');
    }).catchError((e) {
      log("getClinic error $e");
    }).whenComplete(() => isClinicLoading(false));
  }

  Future<void> getDoctors({bool showLoader = true}) async {
    if (showLoader) {
      isLoading(true);
    }
    await doctorsFuture(
      CoreServiceApis.getDoctors(
        page: doctorsPage.value,
        doctors: doctors,
        search: searchCont.text.trim(),
        lastPageCallBack: (p0) {
          isDoctorsLastPage(p0);
        },
      ),
    ).then((value) {
      log('value.length ==> ${value.length}');
    }).catchError((e) {
      log("getDoctors error $e");
    }).whenComplete(() => isLoading(false));
  }
}

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/api/pharma_apis.dart';
import 'package:kivicare_clinic_admin/screens/Encounter/add_encounter/model/patient_model.dart';
import 'package:kivicare_clinic_admin/screens/doctor/model/doctor_list_res.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stream_transform/stream_transform.dart';
import '../model/prescriptions_res_model.dart';

class AllPrescriptionsController extends GetxController {
  Rx<Future<RxList<PrescriptionData>>> prescriptionListFuture = Future(() => RxList<PrescriptionData>()).obs;
  Rx<Future<RxList<Doctor>>> doctorListFuture = Future(() => RxList<Doctor>()).obs;

  Rx<Future<RxList<PatientModel>>> patientListFuture = Future(() => RxList<PatientModel>()).obs;
  RxBool isLoading = false.obs;
  RxList<PrescriptionData> prescriptionList = RxList();
  RxList<Doctor> doctorList = RxList();
  RxList<PatientModel> patientList = RxList();
  RxBool isLastPage = false.obs;
  RxInt page = 1.obs;

  //Search
  RxBool isSearchPrescriptionText = false.obs;
  TextEditingController searchPrescriptionCont = TextEditingController();
  StreamController<String> searchPrescriptionStream = StreamController<String>();
  final _scrollController = ScrollController();
  List<String> prescriptionStatusTypeList = [
    "Pending",
    "Completed",
  ];
  List<String> prescriptionPaymentStatusTypeList = [
    "Paid",
    "Unpaid",
  ];
  RxList<String> bookingStatusList = <String>[].obs;
  RxList<String> paymentStatusList = <String>[].obs;
  RxList<String> newPaymentStatusList = <String>[].obs;
  RxList<int> doctorListName = <int>[].obs;
  RxList<int> patientListName = <int>[].obs;
  RxInt selectedTabIndex = 0.obs;
  RxInt count = 0.obs;
  RxBool isFilterLoading = false.obs;

  @override
  void onReady() {
    _scrollController.addListener(() => Get.context != null ? hideKeyboard(Get.context) : null);
    searchPrescriptionStream.stream.debounce(const Duration(seconds: 1)).listen((s) {
      getPrescriptions();
    });
    getPrescriptions();
    super.onReady();
  }

  Future<void> getPrescriptions({
    bool showLoader = true,
    List<String> bookingStatusList = const [],
    List<String> paymentStatusList = const [],
    List<int> doctorListName = const [],
    List<int> patientListName = const [],
  }) async {

    if (showLoader) {
      isLoading(true);
    }

    await prescriptionListFuture(
      PharmaApis.getPrescriptionList(
        prescriptionList: prescriptionList,
        page: page.value,
        search: searchPrescriptionCont.text.trim(),
        bookingStatus: bookingStatusList,
        paymentStatus: paymentStatusList,
        doctorName: doctorListName,
        patientName: patientListName,
        lastPageCallBack: (p0) {
          isLastPage(p0);
        },
      ),
    ).then((value) {
      log("${value.first.id}");
      newPaymentStatusList.clear();
      log('value.length ==> ${value.length}');
    }).catchError((e) {
      log("getPrescriptions Err : $e");
    }).whenComplete(() => isLoading(false));
  }

  Future<void> getDoctorList({bool showLoader = true}) async {
    if (showLoader) {
      isLoading(true);
    }
    await doctorListFuture(
      PharmaApis.getDoctorListForSearch(
          doctorsList: doctorList,
          page: 1,
          lastPageCallBack: (p0) {
            isLastPage(p0);
          }),
    ).then((value) {
      isLoading(false);
      log("Doctor List Length : ${value.length}");
    }).catchError((e) {
      isLoading(false);
      log("getDoctorList Err : $e");
    }).whenComplete(() => isLoading(false));
  }

  Future<void> getPatientList({bool showLoader = true}) async {
    if (showLoader) {
      isLoading(true);
    }
    await patientListFuture(
      PharmaApis.getPatientListForSearch(
          patientList: patientList,
          page: 1,
          lastPageCallBack: (p0) {
            isLastPage(p0);
          }),
    ).then((value) {
      isLoading(false);
      log("Patient List Length : ${value.length}");
    }).catchError((e) {
      isLoading(false);
      log("getPatientList Err : $e");
    });
  }

  @override
  void onClose() {
    searchPrescriptionStream.close();
    if (Get.context != null) {
      _scrollController.removeListener(() => hideKeyboard(Get.context));
    }
    super.onClose();
  }
}

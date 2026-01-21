// ignore_for_file: depend_on_referenced_packages
import 'dart:developer';

import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/api/core_apis.dart';
import 'model/doctor_list_res.dart';

class DoctorDetailController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<Future<Rx<Doctor>>> doctorDetailFuture = Future(() => Doctor().obs).obs;
  Rx<Doctor> doctorDetails = Doctor().obs;

  @override
  void onInit() {
    if (Get.arguments is Doctor) {
      doctorDetails(Get.arguments);
    }
    getDoctorDetail();
    super.onInit();
  }

  Future<void> getDoctorDetail({bool showloader = false}) async {
    if (!showloader) {
      isLoading(true);
    }
    await doctorDetailFuture(
      CoreServiceApis.getDoctorDetail(doctorId: doctorDetails.value.doctorId),
    ).then((value) {
      doctorDetails(value.value);
    }).catchError((e) {
      log("getDoctorDetails error $e");
    }).whenComplete(() => isLoading(false));
  }
}

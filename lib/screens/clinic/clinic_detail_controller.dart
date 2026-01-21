// ignore_for_file: depend_on_referenced_packages
import 'dart:async';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../api/clinic_api.dart';
import '../../api/core_apis.dart';
import '../doctor/model/doctor_list_res.dart';
import '../service/model/service_list_model.dart';
import 'model/clinic_detail_model.dart';
import 'model/clinics_res_model.dart';

class ClinicDetailController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<Future<ClinicDetailModel>> getClinicDetailFuture = Future(() => ClinicDetailModel(data: ClinicData())).obs;
  //Services
  Rx<Future<RxList<ServiceElement>>> serviceListFuture = Future(() => RxList<ServiceElement>()).obs;
  RxBool isServicesLoading = false.obs;
  RxList<ServiceElement> serviceList = RxList();
  RxBool isServicesLastPage = false.obs;
  RxInt servicesPage = 1.obs;

  //Doctors
  Rx<Future<RxList<Doctor>>> doctorsFuture = Future(() => RxList<Doctor>()).obs;
  RxBool isDoctorsLoading = false.obs;
  RxList<Doctor> doctors = RxList();
  RxBool isDoctorsLastPage = false.obs;
  RxInt doctorsPage = 1.obs;

  Rx<ClinicData> clinicData = ClinicData().obs;

  @override
  void onInit() {
    if (Get.arguments is ClinicData) {
      clinicData(Get.arguments);
      getClinicDetail();
      getServiceList();
      getDoctors();
    }

    super.onInit();
  }

  ///Get Clinic Detail
  Future<void> getClinicDetail({bool showLoader = true}) async {
    if (showLoader) {
      isLoading(true);
    }
    await getClinicDetailFuture(ClinicApis.getClinicDetails(clinicId: clinicData.value.id)).then((value) {
      clinicData(value.data);
    }).catchError((e) {
      log('ClinicDetail getClinicDetail err ==> $e');
    }).whenComplete(() => isLoading(false));
  }

  Future<void> getServiceList({bool showLoader = true}) async {
    if (showLoader) {
      isServicesLoading(true);
    }
    await serviceListFuture(
      CoreServiceApis.getServiceList(
        page: servicesPage.value,
        serviceList: serviceList,
        clinicId: clinicData.value.id,
        lastPageCallBack: (p0) {
          isServicesLastPage(p0);
        },
      ),
    ).then((value) {
      log('value.length ==> ${value.length}');
    }).catchError((e) {
      log('Clinic detail getServiceList err ==> $e');
    }).whenComplete(() => isServicesLoading(false));
  }

  Future<void> getDoctors({bool showLoader = true}) async {
    if (showLoader) {
      isDoctorsLoading(true);
    }
    await doctorsFuture(
      CoreServiceApis.getDoctors(
        page: doctorsPage.value,
        doctors: doctors,
        clinicId: clinicData.value.id,
        lastPageCallBack: (p0) {
          isDoctorsLastPage(p0);
        },
      ),
    ).then((value) {
      log('value.length ==> ${value.length}');
    }).catchError((e) {
      log("getDoctors error $e");
    }).whenComplete(() => isDoctorsLoading(false));
  }
}

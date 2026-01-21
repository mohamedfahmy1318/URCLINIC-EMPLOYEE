import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/main.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:kivicare_clinic_admin/screens/clinic/model/clinics_res_model.dart';
import 'package:kivicare_clinic_admin/utils/app_common.dart';
import '../../api/core_apis.dart';
import '../../utils/constants.dart';
import '../doctor/model/doctor_list_res.dart';
import 'assing_doctor_screen_controller.dart';
import 'manage_service/service_apis.dart';
import 'model/service_list_model.dart';

class AllServicesController extends GetxController {
  Rx<Future<RxList<ServiceElement>>> serviceListFuture = Future(() => RxList<ServiceElement>()).obs;
  RxBool isLoading = false.obs;
  RxList<ServiceElement> serviceList = RxList<ServiceElement>();
  RxList<ServiceElement> doctorServiceList = RxList<ServiceElement>();
  RxBool isLastPage = false.obs;
  RxInt page = 1.obs;

  RxBool isSearchServiceText = false.obs;
  TextEditingController searchServiceCont = TextEditingController();

  StreamController<String> searchServiceStream = StreamController<String>();
  final _scrollController = ScrollController();

  Rx<Doctor> doctorData = Doctor().obs;
  Rx<ClinicData> clinicData = ClinicData().obs;

  RxList<ServiceElement> selectedService = RxList<ServiceElement>();

  RxList<ServiceElement> selectedServiceTemp = RxList<ServiceElement>();

  Rx<ServiceElement> singleServiceSelect = ServiceElement(status: false.obs).obs;

  RxString appBarTitle = locale.value.services.obs;

  @override
  void onInit() {
    try {
      // Arguments processed
      if (Get.arguments is Doctor) {
        doctorData(Get.arguments);
        if (doctorData.value.firstName.isNotEmpty) {
          appBarTitle("${doctorData.value.firstName}${locale.value.sServices}");
        }
      }

      if (Get.arguments is ClinicData) {
        clinicData(Get.arguments);

        if (clinicData.value.name.isNotEmpty) {
          appBarTitle("${clinicData.value.name}${locale.value.sServices}");
        }
      }

      if (Get.arguments[0] is Doctor) {
        doctorData(Get.arguments[0]);
        if (doctorData.value.firstName.isNotEmpty) {
          appBarTitle("${doctorData.value.firstName}${locale.value.sServices}");
        }
      }

      if (Get.arguments[1] is ServiceElement) {
        singleServiceSelect(Get.arguments[1]);
      }

      if (Get.arguments[2] is ClinicData) {
        clinicData(Get.arguments[2]);
      }
    } catch (e) {
      log('AllServicesCont Get.arguments onInit E: $e');
    }
    getDoctorAllServices();
    super.onInit();
  }

  @override
  void onReady() {
    _scrollController.addListener(() => Get.context != null ? hideKeyboard(Get.context) : null);
    searchServiceStream.stream.debounce(const Duration(seconds: 1)).listen((s) {
      getAllServices();
    });
    getAllServices();
    getSelServicesList();
    super.onReady();
  }

  void getSelServicesList() {
    if (Get.arguments is List<ServiceElement>) {
      selectedService.addAll(Get.arguments as List<ServiceElement>);
    }
  }

  bool checkSelServiceList({required ServiceElement service}) {
    for (final element in selectedService) {
      if (element.id == service.id) {
        return true;
      }
    }
    return false;
  }

  /// New helper: update temporary selected list based on current serviceList & selectedService
  void updateTempSelected() {
    selectedServiceTemp.clear();
    for (final svc in serviceList) {
      if (selectedService.any((sel) => sel.id == svc.id)) {
        selectedServiceTemp.add(svc);
      }
    }
  }

  Future<void> getAllServices({bool showloader = true}) async {
    if (showloader) {
      isLoading(true);
    }
    await serviceListFuture(
      CoreServiceApis.getServiceList(
        page: page.value,
        serviceList: serviceList,
        clinicId: clinicData.value.id.isNegative && loginUserData.value.userRole.contains(EmployeeKeyConst.doctor) ? selectedAppClinic.value.id : clinicData.value.id,
        doctorId: loginUserData.value.userRole.contains(EmployeeKeyConst.doctor) ? loginUserData.value.id : doctorData.value.doctorId,
        search: searchServiceCont.text.trim(),
        lastPageCallBack: (p0) {
          isLastPage(p0);
        },
      ),
    ).then((value) {
      getDoctorCharges();
      updateTempSelected();
    }).catchError((e) {
      toast(e);
    }).whenComplete(() => isLoading(false));
  }

  Future<void> getDoctorAllServices({bool showloader = true}) async {
    if (showloader) {
      isLoading(true);
    }
    await serviceListFuture(
      CoreServiceApis.getServiceList(
        page: page.value,
        perPage: 100,
        serviceList: doctorServiceList,
        clinicId: clinicData.value.id.isNegative && loginUserData.value.userRole.contains(EmployeeKeyConst.doctor) ? selectedAppClinic.value.id : clinicData.value.id,
        doctorId: loginUserData.value.userRole.contains(EmployeeKeyConst.doctor) ? loginUserData.value.id : doctorData.value.doctorId,
        search: searchServiceCont.text.trim(),
        lastPageCallBack: (p0) {
          isLastPage(p0);
        },
      ),
    ).then((value) {
      getDoctorCharges();
      log('value.length ==> ${value.length}');
      updateTempSelected();
    }).catchError((e) {
      log("getServiceList Err : $e");
    }).whenComplete(() => isLoading(false));
  }

  void getDoctorCharges() {
    if (loginUserData.value.userRole.contains(EmployeeKeyConst.doctor)) {
      try {
        for (final service in serviceList) {
          for (final assignDoctor in service.assignDoctor) {
            if (assignDoctor.doctorId == loginUserData.value.id && assignDoctor.clinicId == selectedAppClinic.value.id && assignDoctor.serviceId == service.id) {
              service.doctorCharges = assignDoctor.charges;
            }
          }
        }
      } catch (e) {
        log('getServicePrice Errr: $e');
      }
    }
  }

  Future<void> updateServicesStatus({required int id, required int status}) async {
    if (isLoading.value) return; // Returns from here if already call in progress
    isLoading(true);
    ServiceFormApis.updateServicesStatus(serviceId: id, request: {"status": status}).then((value) {
      toast(value.message.trim().isNotEmpty ? value.message.trim() : locale.value.statusUpdatedSuccessfully);
    }).catchError((e) {
      toast(e.toString());
    }).whenComplete(() => isLoading(false));
  }

  Future<void> changeServicePrice({required int serviceId, required String price}) async {
    isLoading(true);
    await CoreServiceApis.assignDoctor(
      request: {
        "service_id": serviceId,
        "clinic_id": selectedAppClinic.value.id,
        "assign_doctors": [SelectDoctor(doctorId: loginUserData.value.id, price: price.trim()).toJson()],
      },
    ).then((value) async {
      Get.back(result: true);
      toast(value.message.isNotEmpty ? value.message : locale.value.priceUpdatedSuccessfully);
      getAllServices();
    }).catchError((e) {
      toast(e.toString());
      log('changeServicePrice Errr: $e');
    }).whenComplete(() => isLoading(false));
  }

  @override
  void onClose() {
    searchServiceStream.close();
    if (Get.context != null) {
      _scrollController.removeListener(() => hideKeyboard(Get.context));
    }
    super.onClose();
  }
}

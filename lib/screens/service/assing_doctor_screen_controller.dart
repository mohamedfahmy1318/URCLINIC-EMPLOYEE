import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:kivicare_clinic_admin/screens/doctor/model/doctor_list_res.dart';
import 'package:kivicare_clinic_admin/utils/app_common.dart';
import 'package:kivicare_clinic_admin/utils/constants.dart';
import '../../api/core_apis.dart';
import '../../main.dart';
import '../clinic/model/clinics_res_model.dart';
import 'all_service_list_controller.dart';
import 'model/service_list_model.dart';

class AssingDoctorController extends GetxController {
  Rx<ServiceElement> selectServices = ServiceElement(status: false.obs).obs;
  Rx<Future<RxList<Doctor>>> doctorsFuture = Future(() => RxList<Doctor>()).obs;
  RxBool isLoading = false.obs;
  RxList<Doctor> doctors = RxList();
  RxBool isLastPage = false.obs;
  RxInt page = 1.obs;
  RxBool isSearchText = false.obs;
  Rx<Doctor> selectedDoctor = Doctor().obs;
  TextEditingController searchCont = TextEditingController();
  StreamController<String> searchStream = StreamController<String>();
  final _scrollController = ScrollController();

  //Clinic
  Rx<Future<RxList<ClinicData>>> getClinicsFuture = Future(() => RxList<ClinicData>()).obs;
  RxBool isClinicLoading = false.obs;
  RxInt clinicPage = 1.obs;
  RxList<ClinicData> clinicList = RxList();
  RxBool isClinicLastPage = false.obs;
  Rx<ClinicData> selectClinic = ClinicData().obs;
  RxString searchClinic = "".obs;

  //Error Clinic
  RxBool hasErrorFetchingClinic = false.obs;
  RxString errorMessageClinic = "".obs;

  TextEditingController clinicCont = TextEditingController();
  RxList<SelectDoctor> selectedDoctors = RxList();

  @override
  void onInit() {
    // getDoctors();
    if (Get.arguments is ServiceElement) {
      selectServices(Get.arguments);
    }
    if (!selectedAppClinic.value.id.isNegative) {
      selectClinic(selectedAppClinic.value);
      getDoctors();
    }
    _scrollController.addListener(() => Get.context != null ? hideKeyboard(Get.context) : null);
    searchStream.stream.debounce(const Duration(seconds: 1)).listen((s) {
      getDoctors();
    });
    super.onInit();
  }

  Future<void> getClinicList({bool showloader = true}) async {
    if (showloader) {
      isClinicLoading(true);
    }
    await getClinicsFuture(
      CoreServiceApis.getClinicList(
        clinicList: clinicList,
        page: clinicPage.value,
        serviceId: selectServices.value.id,
        search: searchClinic.value,
        lastPageCallBack: (p0) {
          isClinicLastPage(p0);
        },
      ),
    ).then((value) async {
      log("Value is ==> $value");
      clinicList(value);
      hasErrorFetchingClinic(false);
    }).catchError((e) {
      hasErrorFetchingClinic(true);
      errorMessageClinic(e.toString());
      toast("Error: $e");
      log("getClinicList err: $e");
    }).whenComplete(() => isClinicLoading(false));
  }

  Future<void> getDoctors({bool showloader = true}) async {
    if (showloader) {
      isLoading(true);
    }
    await doctorsFuture(
      CoreServiceApis.getDoctors(
        page: page.value,
        doctors: doctors,
        clinicId: selectClinic.value.id,
        search: searchCont.text.trim(),
        lastPageCallBack: (p0) {
          isLastPage(p0);
        },
      ),
    ).then((value) {
      log('value.length ==> ${value.length}');
      if (value.isNotEmpty) {
        selectedDoctor(value.first);
        if (loginUserData.value.userRole.contains(EmployeeKeyConst.doctor)) {
          doctors.removeWhere((e) => loginUserData.value.id != e.doctorId);
          for (final element in doctors) {
            element.isSelected(true);
            try {
              final AllServicesController allSCont = Get.find();
              for (final service in allSCont.serviceList) {
                for (final assignDoctor in service.assignDoctor) {
                  if (assignDoctor.doctorId == element.doctorId && assignDoctor.clinicId == selectClinic.value.id && assignDoctor.serviceId == selectServices.value.id) {
                    element.charges.text = assignDoctor.charges.toString();
                  }
                }
              }
            } catch (e) {
              log('allSCont = Get.find() Errr: $e');
            }
          }
        }
      }
    }).catchError((e) {
      log("getDoctors error $e");
    }).whenComplete(() => isLoading(false));
  }

  Future<void> saveDoctor() async {
    isLoading(true);
    await selectDoctorList();
    await CoreServiceApis.assignDoctor(request: {"service_id": selectServices.value.id, "clinic_id": selectClinic.value.id, "assign_doctors": selectedDoctors.toJson()}).then((value) async {
      Get.back(result: true);
      toast(value.message.isNotEmpty ? value.message : locale.value.doctorsAssignSuccessfully);
    }).catchError((e) {
      toast(e.toString(), print: true);
    }).whenComplete(() => isLoading(false));
  }

   Future<void> selectDoctorList() async {
    for (final element in doctors) {
      if (element.isSelected.isTrue) {
        selectedDoctors.add(SelectDoctor(doctorId: element.doctorId, price: element.charges.text));
      }
    }
  }
}

class SelectDoctor {
  final int doctorId;
  final String price;

  SelectDoctor({required this.doctorId, required this.price});

  factory SelectDoctor.fromJson(Map<String, dynamic> json) {
    return SelectDoctor(
      doctorId: json['doctor_id'] is int ? json['doctor_id'] : -1,
      price: json['price'] is int ? json['price'] : -1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'doctor_id': doctorId,
      'price': price,
    };
  }
}

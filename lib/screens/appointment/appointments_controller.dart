// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kivicare_clinic_admin/screens/category/model/all_category_model.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/api/core_apis.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:kivicare_clinic_admin/utils/app_common.dart';
import '../../main.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../Encounter/add_encounter/model/patient_model.dart';
import '../Encounter/model/encounters_list_model.dart';
import '../doctor/model/doctor_list_res.dart';
import '../home/home_controller.dart';
import '../patient/model/patient_argument_model.dart';
import '../service/model/service_list_model.dart';
import 'model/appointments_res_model.dart';

class AppointmentsController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLastPage = false.obs;
  Rx<Future<RxList<AppointmentData>>> getAppointments =
      Future(() => RxList<AppointmentData>()).obs;
  RxList<AppointmentData> appointments = RxList();
  RxInt page = 1.obs;
  Rx<Doctor> selectedDoctor = Doctor().obs;
  Rx<ServiceElement> selectedServiceData =
      ServiceElement(status: false.obs).obs;
  Rx<PatientModel> selectedPatient = PatientModel().obs;
  RxString status = "".obs;
  RxString paymentStatus = "".obs;
  RxString firstDate = ''.obs;
  RxString lastDate = ''.obs;
  Rx<CategoryElement> selectedCategory = CategoryElement().obs;
  RxInt categoryId = 0.obs;
  RxInt clinicId = 0.obs;

  ///Search
  TextEditingController searchCont = TextEditingController();
  RxBool isSearchText = false.obs;
  StreamController<String> searchStream = StreamController<String>();
  final _scrollController = ScrollController();

  Rx<PatientArgumentModel> patientDetailArgument =
      PatientArgumentModel(patientModel: PatientModel()).obs;

  @override
  void onInit() {
    if (Get.arguments is PatientArgumentModel) {
      patientDetailArgument(Get.arguments);
      selectedPatient(patientDetailArgument.value.patientModel);
    }
    _scrollController.addListener(
        () => Get.context != null ? hideKeyboard(Get.context) : null);
    searchStream.stream.debounce(const Duration(seconds: 1)).listen((s) {
      getAppointmentList();
    });
    getAppointmentList(showloader: false);
    super.onInit();
  }

  Future<void> getAppointmentList(
      {bool showloader = true, String search = ""}) async {
    if (showloader) {
      isLoading(true);
    }
    await getAppointments(
      CoreServiceApis.getAppointmentList(
        categoryId: categoryId.value,
        firstDate: firstDate.value,
        lastDate: lastDate.value,
        paymentStatus: paymentStatus.value,
        filterByStatus: status.value,
        serviceId: selectedServiceData.value.id,
        patientId: selectedPatient.value.id,
        doctorId: selectedDoctor.value.doctorId > 0
            ? selectedDoctor.value.doctorId
            : selectedDoctor.value.id,
        clinicId: clinicId.value > 0
            ? clinicId.value
            : loginUserData.value.userRole.contains(EmployeeKeyConst.doctor)
                ? selectedAppClinic.value.id
                : null,
        page: page.value,
        search: searchCont.text.trim(),
        appointments: appointments,
        lastPageCallBack: (p0) {
          isLastPage(p0);
        },
      ),
    ).then((value) {
      // If doctor, filter out pending appointments — only receptionist controls those
      if (loginUserData.value.userRole.contains(EmployeeKeyConst.doctor)) {
        appointments.removeWhere((e) => e.status == StatusConst.pending);
      }
    }).catchError((e) {
      log('getAppointments E: $e');
    }).whenComplete(() => isLoading(false));
  }

  void updateStatus({
    required String status,
    required int id,
    required bool isBack,
    required BuildContext context,
    required bool isCheckOut,
    EncounterElement? encountDetails,
    Function(BuildContext)? onCallBack,
  }) {
    showConfirmDialogCustom(
      context,
      primaryColor: appColorPrimary,
      title: locale.value.doYouWantToPerformThisAction,
      positiveText: locale.value.yes,
      negativeText: locale.value.cancel,
      onAccept: (ctx) async {
        if (isCheckOut) {
          onCallBack!(context);
        } else {
          isLoading(true);
          CoreServiceApis.changeAppointmentStatus(
            id: id,
            request: {'status': postStatus(status: status)},
          ).then((value) {
            toast(value.message.trim().isEmpty
                ? locale.value.statusHasBeenUpdated
                : value.message.trim());
            if (isBack) {
              Get.back();
            }
            try {
              final HomeController hcont = Get.find();
              hcont.getDashboardDetail();
            } catch (e) {
              log('Appointments updateStatus hcont = Get.find() E: $e');
            }
            getAppointmentList();
          }).catchError((e) {
            isLoading(false);
            toast(e.toString());
          });
        }
      },
    );
  }

  @override
  void onClose() {
    searchStream.close();
    if (Get.context != null) {
      _scrollController.removeListener(() => hideKeyboard(Get.context));
    }
    super.onClose();
  }
}

// ignore_for_file: unrelated_type_equality_checks

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:kivicare_clinic_admin/api/core_apis.dart';
import 'package:kivicare_clinic_admin/screens/Encounter/add_encounter/model/encounter_resp_model.dart';
import '../../../utils/app_common.dart';
import '../../../utils/common_base.dart';
import '../../../utils/constants.dart';
import '../../clinic/model/clinics_res_model.dart';
import '../../doctor/model/doctor_list_res.dart';
import '../model/encounters_list_model.dart';
import 'model/patient_model.dart';

class AddEncountersController extends GetxController {
  //TextFiled Controller
  final GlobalKey<FormState> addEncounterFormKey = GlobalKey();
  TextEditingController dateCont = TextEditingController();
  TextEditingController clinicCont = TextEditingController();
  TextEditingController doctorCont = TextEditingController();
  TextEditingController patientCont = TextEditingController();
  TextEditingController descriptionCont = TextEditingController();

  FocusNode dateFocus = FocusNode();
  FocusNode clinicFocus = FocusNode();
  FocusNode doctorFocus = FocusNode();
  FocusNode patientFocus = FocusNode();
  FocusNode descriptionFocus = FocusNode();

  //Error Clinic
  RxBool hasErrorFetchingClinic = false.obs;
  RxString errorMessageClinic = "".obs;

  //Error Doctor
  RxBool hasErrorFetchingDoctor = false.obs;
  RxString errorMessageDoctor = "".obs;

  //Error Patient
  RxBool hasErrorFetchingPatient = false.obs;
  RxString errorMessagePatient = "".obs;

  //Clinic
  Rx<Future<RxList<ClinicData>>> getClinics = Future(() => RxList<ClinicData>()).obs;
  RxBool isLoading = false.obs;
  RxInt page = 1.obs;
  RxList<ClinicData> clinicList = RxList();
  RxBool isLastPage = false.obs;
  Rx<ClinicData> selectClinic = ClinicData().obs;
  RxString searchClinic = "".obs;

  //Doctors
  Rx<Future<RxList<Doctor>>> doctorsFuture = Future(() => RxList<Doctor>()).obs;
  RxBool isDoctorsLoading = false.obs;
  RxList<Doctor> doctors = RxList();
  RxBool isDoctorsLastPage = false.obs;
  RxInt doctorsPage = 1.obs;
  Rx<Doctor> selectDoctor = Doctor().obs;
  RxString searchDoctor = "".obs;

  //Patient
  Rx<Future<RxList<PatientModel>>> patientFuture = Future(() => RxList<PatientModel>()).obs;
  RxBool isPatientLoading = false.obs;
  RxList<PatientModel> patientList = RxList();
  RxBool isPatientLastPage = false.obs;
  RxInt patientPage = 1.obs;
  Rx<PatientModel> selectPatient = PatientModel().obs;
  RxString searchPatient = "".obs;

  //Save Encounter
  Rx<Future<Rx<EncounterResp>>> saveEncounterFuture = Future(() => EncounterResp().obs).obs;
  Rx<EncounterResp> encounterResp = EncounterResp().obs;

  //Edit Counter Details
  Rx<EncounterElement> editEncounterResp = EncounterElement().obs;

  @override
  void onReady() {
    selectClinic(selectedAppClinic.value);
    getClinicList();
    getPatientList();
    getArgument();
    super.onReady();
  }

  void getArgument() {
    if (Get.arguments != null && Get.arguments.length > 0 && Get.arguments[0] != null && (Get.arguments[0] is bool) && (Get.arguments[1] is EncounterElement)) {
      editEncounterResp(Get.arguments[1]);
      dateCont.text = editEncounterResp.value.encounterDate.dateInDMMMMyyyyFormat;
      descriptionCont.text = editEncounterResp.value.description;
    }
  }

  Future<void> getClinicList({bool showloader = true}) async {
    if (showloader) {
      isLoading(true);
    }
    await getClinics(
      CoreServiceApis.getClinicList(
        clinicList: clinicList,
        page: page.value,
        search: searchClinic.value,
        lastPageCallBack: (p0) {
          isLastPage(p0);
        },
      ),
    ).then((value) async {
      log("Value is ==> $value");
      clinicList(value);
      hasErrorFetchingClinic(false);
      if (editEncounterResp.value.clinicName.isNotEmpty) {
        for (final element in clinicList) {
          if (element.id == editEncounterResp.value.clinicId) {
            selectClinic(element);
            clinicCont.text = element.name;
          }
        }
        await getDoctors();
      }
    }).catchError((e) {
      hasErrorFetchingClinic(true);
      errorMessageClinic(e.toString());
      toast("Error: $e");
      log("getClinicList err: $e");
    }).whenComplete(() => isLoading(false));
  }

  Future<void> getPatientList({bool showloader = true}) async {
    if (showloader) {
      isLoading(true);
    }
    await patientFuture(
      CoreServiceApis.getPatientsList(
        patientsList: patientList,
        page: page.value,
        clinicId: loginUserData.value.userRole.contains(EmployeeKeyConst.doctor) ? selectedAppClinic.value.id : null,
        search: searchPatient.value,
        lastPageCallBack: (p0) {},
      ),
    ).then((value) {
      hasErrorFetchingPatient(false);
      if (editEncounterResp.value.userName.isNotEmpty) {
        for (final element in patientList) {
          if (element.id == editEncounterResp.value.userId) {
            selectPatient(element);
            patientCont.text = element.fullName;
          }
        }
      }
    }).catchError((e) {
      hasErrorFetchingPatient(true);
      errorMessagePatient(e.toString());
      toast("Error: $e");
      log("getPatientsList err: $e");
    }).whenComplete(() => isLoading(false));
  }

  Future<void> getDoctors({bool showLoader = true}) async {
    if (showLoader) {
      isLoading(true);
    }
    await doctorsFuture(
      CoreServiceApis.getDoctors(
        page: doctorsPage.value,
        doctors: doctors,
        search: searchDoctor.value,
        clinicId: selectClinic.value.id,
        lastPageCallBack: (p0) {
          isDoctorsLastPage(p0);
        },
      ),
    ).then((value) {
      hasErrorFetchingDoctor(false);
      log('value.length ==> ${value.length}');
      if (editEncounterResp.value.doctorName.isNotEmpty) {
        for (final element in doctors) {
          if (element.doctorId == editEncounterResp.value.doctorId) {
            selectDoctor(element);
            doctorCont.text = element.fullName;
          }
        }
      }
    }).catchError((e) {
      hasErrorFetchingDoctor(true);
      errorMessageDoctor(e.toString());
      log("getDoctors error $e");
    }).whenComplete(() => isLoading(false));
  }

  Future<void> saveEncounter({bool showloader = true}) async {
    final Map<String, dynamic> request = {
      "encounter_date": dateCont.text.dateInyyyyMMddFormat.toString(),
      "clinic_id": selectClinic.value.id.toString(),
      "doctor_id": loginUserData.value.userRole.contains(EmployeeKeyConst.doctor) ? loginUserData.value.id : selectDoctor.value.doctorId.toString(),
      "user_id": selectPatient.value.id.toString(),
      "description": descriptionCont.text.isEmpty ? "" : descriptionCont.text,
    };
    if (showloader) {
      isLoading(true);
    }
    await saveEncounterFuture(CoreServiceApis.saveEncounter(request: request, encounterResp: encounterResp.value)).then((value) {
      encounterResp(value.value);
      Get.back(result: true);
    }).catchError((e) {
      toast("Error: $e");
      log("getEncounterResp err: $e");
    }).whenComplete(() => isLoading(false));
  }

  //Update Encounter
  Future<void> editEncounter({bool showloader = true}) async {
    final Map<String, dynamic> request = {
      "encounter_date": dateCont.text.dateInyyyyMMddFormat.toString(),
      "clinic_id": selectClinic.value.id.toString(),
      "doctor_id": loginUserData.value.userRole.contains(EmployeeKeyConst.doctor) ? loginUserData.value.id : selectDoctor.value.doctorId.toString(),
      "user_id": selectPatient.value.id.toString(),
      "description": descriptionCont.text,
    };
    if (showloader) {
      isLoading(true);
    }
    await saveEncounterFuture(CoreServiceApis.editEncounter(request: request, id: editEncounterResp.value.id, encounterResp: encounterResp.value)).then((value) {
      encounterResp(value.value);
      Get.back(result: true);
    }).catchError((e) {
      toast("Error: $e");
      log("getEncounterResp err: $e");
    }).whenComplete(() => isLoading(false));
  }
}

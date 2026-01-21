import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../api/core_apis.dart';
import '../model/encounters_list_model.dart';
import '../model/problems_observations_model.dart';

import '../model/soap_req.dart';

class SOAPController extends GetxController {
  //TextField Controller
  final GlobalKey<FormState> clinicalDetailsFormKey = GlobalKey();

  TextEditingController subjectiveCont = TextEditingController();
  TextEditingController objectiveCont = TextEditingController();
  TextEditingController assessmentCont = TextEditingController();
  TextEditingController planCont = TextEditingController();

  //Bill TextField Controller
  final GlobalKey<FormState> addPrescriptionFormKey = GlobalKey();
  TextEditingController nameCont = TextEditingController();
  TextEditingController frequencyCont = TextEditingController();
  TextEditingController durationCont = TextEditingController();
  TextEditingController instructionCont = TextEditingController();

  //FocusNode
  FocusNode nameFocus = FocusNode();
  FocusNode frequencyFocus = FocusNode();
  FocusNode durationFocus = FocusNode();
  FocusNode instructionFocus = FocusNode();

  //Clinic
  Rx<Future<RxList<CMNElement>>> getProblems = Future(() => RxList<CMNElement>()).obs;
  Rx<Future<RxList<CMNElement>>> getObservations = Future(() => RxList<CMNElement>()).obs;
  RxBool isLoading = false.obs;

  Rx<EncounterElement> encounterData = EncounterElement().obs;

  ///Search
  TextEditingController searchCont = TextEditingController();
  RxBool isSearchText = false.obs;
  StreamController<String> searchStream = StreamController<String>();
  final _scrollController = ScrollController();

  @override
  void onInit() {
    if (Get.arguments is EncounterElement) {
      encounterData(Get.arguments as EncounterElement);
    }
    getSOAPDetails();
    super.onInit();
  }

  Future<void> getSOAPDetails() async {
    isLoading(true);
    await CoreServiceApis.getSOAP(encounterData.value.id).then((res) {
      subjectiveCont.text = res.value.data.subjective.trim();
      objectiveCont.text = res.value.data.objective.trim();
      assessmentCont.text = res.value.data.assessment.trim();
      planCont.text = res.value.data.plan.trim();
    }).catchError((e) {
      log("getEncouterDetails Err : $e");
    }).whenComplete(() => isLoading(false));
  }

  Future<void> saveSOAP() async {
    isLoading(true);
    final SOAPReq soapReq = SOAPReq(
      encounterId: encounterData.value.id,
      appointmentId: encounterData.value.appointmentId,
      patientId: encounterData.value.userId,
      subjective: subjectiveCont.text.trim(),
      objective: objectiveCont.text.trim(),
      assessment: assessmentCont.text.trim(),
      plan: planCont.text.trim(),
    );

    CoreServiceApis.saveSOAP(
      request: soapReq.toJson(),
      encounterId: encounterData.value.id,
    ).then((value) {
      toast(value.message);
      Get.back();
    }).catchError((e) {
      toast(e.toString());
    }).whenComplete(() => isLoading(false));
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
